module Krikri::Harvesters
  ##
  # A harvester implementation for OAI-PMH
  class OAIHarvester
    include Krikri::Harvester
    attr_accessor :client

    ##
    # @param opts [Hash] options to pass through to client requests.
    #   Allowable options are specified in OAI::Const::Verbs. Currently :from,
    #   :until, :set, and :metadata_prefix.
    # @see OAI::Client
    # @see #expected_opts
    def initialize(opts = {})
      uri = opts.delete(:uri)
      if opts.include?(:oai)
        @opts = opts[:oai]
      else
        @opts = {}
      end
      @client = OAI::Client.new(uri)
    end

    ##
    # Sends ListIdentifier requests lazily.
    #
    # The following will only send requests to the endpoint until it
    # has 1000 record ids:
    #
    #     record_ids.take(1000)
    #
    def record_ids(opts = {})
      opts = opts.merge(@opts)
      client.list_identifiers(opts).full.lazy.flat_map(&:identifier)
    end

    # Count on record_ids will request all ids and load them into memory
    # TODO: an efficient implementation of count for OAI
    def count
      raise NotImplementedError
    end

    ##
    # Sends ListRecords requests lazily.
    #
    # The following will only send requests to the endpoint until it
    # has 1000 records:
    #
    #     records.take(1000)
    #
    def records(opts = {})
      opts = opts.merge(@opts)
      client.list_records(opts).full.lazy.flat_map do |rec|
        Krikri::OriginalRecord.build(rec.header.identifier, rec.metadata.to_s)
      end
    end

    ##
    # @see Krikri::Harvester#run
    #
    # An OAI Harvester may have one or more sets.
    # If there is no :set property in @opts then it will be run on every
    # record.  If the :set property exists, only the specified sets will be
    # harvested.
    #
    # This will run all sets serially, which is the safe approach.  If parallel
    # operation is necessary, SoftwareAgent#enqueue can be overridden in this
    # class to loop through the sets and enqueue a separate job for each.
    #
    def run
      log :info, 'harvest is running'
      if ! sets
        records.each(&:save)
      else
        sets.each do |set|
          records({set: set}).each(&:save)
        end
      end
      log :info, 'harvest is done'
      true
    end

    # TODO: normalize records; there will be differences in XML
    # for different requests
    def get_record(identifier, opts = {})
      opts[:identifier] = identifier
      opts = opts.merge(@opts)
      Krikri::OriginalRecord
        .build(identifier,
               client.get_record(opts).doc.to_s)
    end

    ##
    # @see Krikri::Harvester::expected_opts
    def self.expected_opts
      {
        key: :oai,
        opts: {
          set: {type: :string, required: false, multiple_ok: true},
          metadata_prefix: {type: :string, required: true}
        }
      }
    end

    private

    def sets
      nil if ! @opts.include?(:set) or @opts[:set].empty?
      nil if ! @opts[:set].class == Array or @opts[:set].class == String
      Array(@opts[:set])
    end

  end
end

require 'rubygems'
require 'rsolr'

module Krikri
  ##
  # Generates flattened Solr documents and manages indexing of DPLA MAP models.
  class IndexService
    @solr = RSolr.connect

    # TODO: Assure that the following metacharacters are escaped:
    # + - && || ! ( ) { } [ ] ^ " ~ * ? : \

    ##
    # Adds a single JSON document to Solr
    # @param JSON
    def self.add(doc)
      @solr.add solr_doc(doc)
    end

    ##
    # Deletes an item from Solr
    # @param String or Array
    def self.delete_by_id(id)
      @solr.delete_by_id id
    end

    ##
    # Deletes items from Solr that match query
    # @param String or Array
    def self.delete_by_query(query)
      @solr.delete_by_query query
    end

    ##
    # Commits changes to Solr, making them visible to new requests
    # Should be run after self.add and self.delete
    # Okay to add or delete multiple docs and commit them all with
    # a single self.commit
    def self.commit
      @solr.commit
    end

    ##
    # Sends a GET request to Solr with the given params
    # @param Hash
    def self.query(params = {})
      @solr.get('select', params: params)
    end

    ##
    # Returns all items with missing values for a given field
    # @param String
    # @return Array
    #  example: [{"id" => "012345" ... } ... ]
    def self.items_with_missing_field(field_name)
      params = { :qt => 'standard',
                 :q => "+id:[* TO *]-#{field_name}:[* TO *]" }
      query(params)['response']['docs']
    end

    ##
    # Returns the total number of items that are missing each given field
    # @param Array
    # @return Hash
    #  example: {"dataProvider_name" => 2 ... }
    def self.missing_field_totals(field_names)
      params = { :rows => 0, 'facet.field' => field_names,
                 'facet.mincount' => 10000000, 'facet.missing' => true }
      result = query(params)['facet_counts']['facet_fields']
      # transform each key-value pair in Hash from "field_name"=>[nil,2] to
      # "field_name"=>2
      result.each_with_object({}) { |(k, v), h| h[k] = v[1] }
    end

    ##
    # Converts JSON document into a Hash that complies with Solr
    # schema
    def self.solr_doc(doc)
      flat_hash(JSON.parse(doc))
    end

    ##
    # Flattens a nested hash
    # Joins keys with "_" and removes "@" symbols
    # Example:
    #   flat_hash( {"a"=>"1", "b"=>{"c"=>"2", "d"=>"3"} )
    #   => {"a"=>"1", "b_c"=>"2", "b_d"=>"3"}
    def self.flat_hash(hash, keys = [])
      new_hash = {}

      hash.each do |key, val|

        if val.is_a? Hash
          new_hash.merge!(flat_hash(val, keys + [key]))
        else
          new_hash[format_key(keys + [key])] = val
        end
      end

      new_hash
    end

    ##
    # Formats a key to match a field name in the Solr schema
    #
    # Removes unnecessary special character strings that would
    # require special treatment in Solr
    #
    # @param Array
    #
    # TODO: Revisit this to make it more generalizable
    def self.format_key(keys)
      keys.join('_')
        .gsub('@', '')
        .gsub('http://www.geonames.org/ontology#', '')
        .gsub('http://www.w3.org/2003/01/geo/wgs84_pos#', '')
    end

    private_class_method(:solr_doc, :flat_hash, :format_key)
  end
end

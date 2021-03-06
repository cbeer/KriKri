module Krikri::Enrichments
  ##
  # Enrichment to strip empty strings from a value
  #
  #   empty = RemoveEmptyFields.new
  #   empty.enrich_value('moomin')
  #   # => 'moomin'
  #   empty.enrich_value('')
  #   # => nil
  class RemoveEmptyFields
    include Krikri::FieldEnrichment

    def enrich_value(value)
      (value.is_a?(String) && empty?(value)) ? nil : value
    end

    private

    def empty?(value)
      return true if value.empty?
      return true if value =~ /^\s*$/
      false
    end
  end
end

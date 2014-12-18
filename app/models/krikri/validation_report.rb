module Krikri
  # Provides data for validation reports related to the QA process
  class ValidationReport

    ##
    # Returns the number of items missing each required field
    # @return Hash
    def self.all
      Krikri::IndexService.missing_field_totals(REQUIRED_FIELDS)
    end

    ##
    # Returns items that are missing a given field
    # @param String
    # @return Array
    def self.find(field_name)
      Krikri::IndexService.items_with_missing_field(field_name)
    end

  end
end

module Krikri
  module ValidationReportHelper

    REQUIRED_FIELDS = ['dataProvider_name', 'isShownAt_id', 'preview_id',
                 'sourceResource_rights', 'sourceResource_title',
                 'sourceResource_type_id']

    def report_list
      reports = missing_field_totals
      #[{:name => 'hello', :count => 2}, {:name => 'moo', :count => 1}]
    end

    ##
    # Returns the number of items missing each required field
    # @return Array
    def missing_field_totals
      solr_params = { 
        :rows => 0,
        'facet.field' => REQUIRED_FIELDS,
        'facet.mincount' => 10000000,
        'facet.missing' => true
      }

      response = Blacklight::SolrRepository.new(blacklight_config)
        .search(solr_params)

      if response['facet_counts'] && 
        fields = response['facet_counts']['facet_fields']
        # transform Hash of key-value pairs into Array of Hashes
        #   example: { "field_name"=>[nil,2] } is tranformed into
        #   [{ name: "field_name", count: 2 }]
        return fields.each_with_object([]) do |(key, value), array|
          array << { name: key, count: value[1] }
        end
      end

      return nil
    end

  end
end

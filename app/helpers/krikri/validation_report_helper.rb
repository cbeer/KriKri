module Krikri
  module ValidationReportHelper

    REQUIRED_FIELDS = ['dataProvider_name', 'isShownAt_id', 'preview_id',
                 'sourceResource_rights', 'sourceResource_title',
                 'sourceResource_type_id']

    def report_list
      construct_report(missing_field_totals)
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
      Blacklight::SolrRepository.new(blacklight_config).search(solr_params)  
    end

    # transform Hash of key-value pairs into Array of Hashes
    #   example: { "field_name"=>[nil,2] } is tranformed into
    #   [{ name: "field_name", count: 2 }]
    def construct_report(solr_response)

      if solr_response && solr_response['facet_counts'] && 
        fields = solr_response['facet_counts']['facet_fields']

        return fields.each_with_object([]) do |(key, value), array|
          array << { 
            name: key, 
            count: value[1],
          }
        end
      end

      return nil
    end

    def report_link(report)
      label = "#{report[:name]} (#{report[:count]})"

      if report[:count] > 0
        link_url = "validation_reports?q=-#{report[:name]}:[*%20TO%20*]"
        return link_to label, link_url
      end

     return label
    end

  end
end

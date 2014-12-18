module Krikri
  module ValidationReport

    REQUIRED_FIELDS = ['dataProvider_name', 'isShownAt_id', 'preview_id',
                 'sourceResource_rights', 'sourceResource_title',
                 'sourceResource_type_id']



    # def index
    #   @report_list = missing_field_totals
    #   #return @report_list
    # end

    # def show
    #   @docs = items_with_missing_field
    #   #return @docs
    # end

    # def missing_field_totals
    #   solr_params = { 
    #     :rows => 0,
    #     'facet.field' => REQUIRED_FIELDS,
    #     'facet.mincount' => 10000000,
    #     'facet.missing' => true
    #   }
    #   #response = query(params)['facet_counts']['facet_fields']

    #   response = Blacklight::SolrRepository.search(solr_params)

    #   # transform each key-value pair in Hash from "field_name"=>[nil,2] to
    #   # "field_name"=>2
    #   #response.each_with_object({}) { |(k, v), h| h[k] = v[1] }
    # end

    # def items_with_missing_field(field_name)
    #   field_name = params[:id]
    #   solr_params = {
    #     :qt => 'standard',
    #     :q => "+id:[* TO *]-#{field_name}:[* TO *]"
    #   }
    #   ##query(params)['response']['docs']

    #   response = Blacklight::SolrRepository.search(solr_params)
    #   #response['response']['docs']
    # end

  end
end
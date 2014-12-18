module Krikri::SolrHelper::MissingFieldReporter

  REQUIRED_FIELDS = ['dataProvider_name', 'isShownAt_id', 'preview_id',
                   'sourceResource_rights', 'sourceResource_title',
                   'sourceResource_type_id']

  #def self.included base
    #base.solr_search_params_logic << :items_with_missing_field
    #base.solr_search_params_logic << :missing_field_totals
  #end

  ##
  # Sends a GET request to Solr with the given params
  # @param Hash
  #def self.query(params = {})
  #  @solr.get('select', params: params)
    #Blacklight::SolrHelper.query_solr(params)
  #end

  # #
  # Returns all items with missing values for a given field
  # @param String
  # @return Array
  # example: [{"id" => "012345" ... } ... ]
  def items_with_missing_field(field_name)
    ##params = { :qt => 'standard',
    ##           :q => "+id:[* TO *]-#{field_name}:[* TO *]" }
    ##query(params)['response']['docs']
    solr_params = {}
    solr_params[:qt] = 'standard'
    solr_params[:q] = "+id:[* TO *]-#{field_name}:[* TO *]"

    Blacklight::SolrRepository.search(solr_params)

  end

  ##
  # Returns the total number of items that are missing each given field
  # @param Array
  # @return Hash
  #  example: {"dataProvider_name" => 2 ... }
  def missing_field_totals(solr_parameters, user_parameters)
    #params = { :rows => 0, 'facet.field' => field_names,
    #           'facet.mincount' => 10000000, 'facet.missing' => true }
    #result = query(params)['facet_counts']['facet_fields']
    # transform each key-value pair in Hash from "field_name"=>[nil,2] to
    # "field_name"=>2
    #result.each_with_object({}) { |(k, v), h| h[k] = v[1] }
    solr_params = {}
    solr_params[:rows] = 0
    solr_params['facet.field'] = REQUIRED_FIELDS
    solr_params['facet.mincount'] = 110000000
    solr_params['facet.missing'] = true

    response = Blacklight::SolrRepository.search(solr_params)
  end

end
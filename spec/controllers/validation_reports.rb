require 'spec_helper'

describe Krikri::ValidationReportsController, :type => :controller do

  routes { Krikri::Engine.routes }

  # describe '#index' do
  #   it 'assigns report names and totals to @report_list' do
  #     invalid_doc = { 'dataProvider_name' => 2 }
  #     Krikri::IndexService.stub(:missing_field_totals).and_return(invalid_doc)
  #     get :index
  #     expect(assigns(:report_list)).to eq invalid_doc
  #   end
  #   it 'renders the :index view' do
  #     get :index
  #     expect(response).to render_template('krikri/validation_reports/index')
  #   end
  # end

  # describe '#show' do
  #   it 'assigns docs with missing values to @docs' do
  #     docs = [{}, {}, {}]
  #     Krikri::IndexService.stub(:items_with_missing_field).and_return(docs)
  #     get :show, id: 'dataProvider_name'
  #     expect(assigns(:docs)).to eq docs
  #   end
  #   it 'renders the :show view' do
  #     get :show, id: 'dataProvider_name'
  #     expect(response).to render_template('krikri/validation_reports/show')
  #   end
  # end

end

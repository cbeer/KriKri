require 'spec_helper'

describe Krikri::SolrValidationReport do

  subject { Krikri::SolrValidationReport.new({}) }

  describe '#to_partial_path' do

    it 'should return validation_reports/document path' do
      expect(subject.to_partial_path).to eq('validation_reports/document')
    end
  end
end

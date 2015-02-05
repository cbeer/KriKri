shared_examples 'a parser with oai headers' do
  describe '#header' do
    it 'has a header' do
      expect(subject.header).to be_a Krikri::Parser::Value
    end

    it 'has children' do
      expect(subject.header.children)
        .to include('xmlns:identifier', 'xmlns:datestamp', 'xmlns:setSpec')
    end
  end
end

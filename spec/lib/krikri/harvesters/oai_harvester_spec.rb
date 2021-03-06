# -*- coding: utf-8 -*-
require 'spec_helper'

describe Krikri::Harvesters::OAIHarvester do

  let(:args) { { uri: 'http://example.org/endpoint' } }
  subject { described_class.new(args) }

  it 'has a client' do
    expect(subject.client).to be_a OAI::Client
  end

  context 'with connection' do
    before do
      # TODO: webmock ListIdentifiers, test lazy resumption
      records = (10..110).map do |id|
        element = REXML::Element.new
        element.add_element REXML::Element.new('identifier').add_text(
          'oai:oaipmh.huygens.knaw.nl:arthurianfiction:MAN' +
          id.to_s.rjust(10, '0'))
        OAI::Header.new(element)
      end

      allow(subject.client).to receive_message_chain(:list_identifiers, :full)
        .and_return(records)

      # TODO: better way of maintaining example OAI record results?
      # GetRecord -- Single record OAI Request
      stub_request(:get,
                   'http://example.org/endpoint?identifier='\
                   'oai:oaipmh.huygens.knaw.nl:arthurianfiction:MAN0000000010'\
                   '&metadataPrefix=oai_dc&verb=GetRecord')
        .with(:headers => {
                'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
              })
        .to_return(:status => 200,
                   :body => '<?xml version="1.0" encoding="UTF-8"?><?xml-stylesheet type="text/xsl" href="static/oai2.xsl"?><OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"><responseDate>2014-10-27T22:19:17Z</responseDate><request verb="GetRecord" identifier="oai:oaipmh.huygens.knaw.nl:arthurianfiction:MAN0000000010" metadataPrefix="oai_dc">http://oaipmh.huygens.knaw.nl/</request><GetRecord><record><header><identifier>oai:oaipmh.huygens.knaw.nl:arthurianfiction:MAN0000000010</identifier><datestamp>2012-07-13T14:27:31Z</datestamp><setSpec>arthurianfiction:manuscript</setSpec><setSpec>arthurianfiction</setSpec></header><metadata><oai_dc:dc xmlns:cmdi="http://www.clarin.eu/cmd/" xmlns:database="http://www.oclc.org/pears/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd http://www.clarin.eu/cmd/ http://catalog.clarin.eu/ds/ComponentRegistry/rest/registry/profiles/clarin.eu:cr1:p_1345561703673/xsd">
   <dc:title>Aberystwyth, National Library of Wales, 446-E</dc:title>
   <dc:creator>Bart Besamusca</dc:creator>
   <dc:identifier>https://service.arthurianfiction.org/manuscript/MAN0000000010</dc:identifier>
   <dc:date>2012-07-13T14:27:31Z</dc:date>
   <dc:contributor>Bart Besamusca</dc:contributor>
   <dc:type>model</dc:type>
   <dc:language>eng</dc:language>
</oai_dc:dc></metadata></record></GetRecord></OAI-PMH>',
                   :headers => {})

      # ListRecords -- Multiple record OAI Request (w/ resumption)
      stub_request(:get,
                   'http://example.org/endpoint?metadataPrefix=oai_dc&verb='\
                   'ListRecords')
        .with(:headers => {
                'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
              })
        .to_return(:status => 200,
                   :body => '<?xml version="1.0" encoding="UTF-8"?><?xml-stylesheet type="text/xsl" href="static/oai2.xsl"?><OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"><responseDate>2014-10-27T23:05:33Z</responseDate><request verb="ListRecords" metadataPrefix="oai_dc">http://oaipmh.huygens.knaw.nl/</request><ListRecords><record><header><identifier>oai:oaipmh.huygens.knaw.nl:arthurianfiction:MAN0000000010</identifier><datestamp>2012-07-13T14:27:31Z</datestamp><setSpec>arthurianfiction:manuscript</setSpec><setSpec>arthurianfiction</setSpec></header><metadata><oai_dc:dc xmlns:cmdi="http://www.clarin.eu/cmd/" xmlns:database="http://www.oclc.org/pears/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd http://www.clarin.eu/cmd/ http://catalog.clarin.eu/ds/ComponentRegistry/rest/registry/profiles/clarin.eu:cr1:p_1345561703673/xsd">
   <dc:title>Aberystwyth, National Library of Wales, 446-E</dc:title>
   <dc:creator>Bart Besamusca</dc:creator>
   <dc:identifier>https://service.arthurianfiction.org/manuscript/MAN0000000010</dc:identifier>
   <dc:date>2012-07-13T14:27:31Z</dc:date>
   <dc:contributor>Bart Besamusca</dc:contributor>
   <dc:type>model</dc:type>
   <dc:language>eng</dc:language>
</oai_dc:dc></metadata></record><record><header><identifier>oai:oaipmh.huygens.knaw.nl:arthurianfiction:MAN0000000011</identifier><datestamp>2012-07-13T14:27:31Z</datestamp><setSpec>arthurianfiction</setSpec><setSpec>arthurianfiction:manuscript</setSpec></header><metadata><oai_dc:dc xmlns:cmdi="http://www.clarin.eu/cmd/" xmlns:database="http://www.oclc.org/pears/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd http://www.clarin.eu/cmd/ http://catalog.clarin.eu/ds/ComponentRegistry/rest/registry/profiles/clarin.eu:cr1:p_1345561703673/xsd">
   <dc:title>Aberystwyth, National Library of Wales, 5018-D</dc:title>
   <dc:creator>Bart Besamusca</dc:creator>
   <dc:identifier>https://service.arthurianfiction.org/manuscript/MAN0000000011</dc:identifier>
   <dc:date>2012-07-13T14:27:31Z</dc:date>
   <dc:contributor>Bart Besamusca</dc:contributor>
   <dc:type>model</dc:type>
   <dc:language>eng</dc:language>
</oai_dc:dc></metadata></record><record><header><identifier>oai:oaipmh.huygens.knaw.nl:arthurianfiction:MAN0000000012</identifier><datestamp>2012-07-13T14:27:31Z</datestamp><setSpec>arthurianfiction</setSpec><setSpec>arthurianfiction:manuscript</setSpec></header><metadata><oai_dc:dc xmlns:cmdi="http://www.clarin.eu/cmd/" xmlns:database="http://www.oclc.org/pears/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd http://www.clarin.eu/cmd/ http://catalog.clarin.eu/ds/ComponentRegistry/rest/registry/profiles/clarin.eu:cr1:p_1345561703673/xsd">
   <dc:title>Aberystwyth, National Library of Wales, 445-D</dc:title>
   <dc:creator>Bart Besamusca</dc:creator>
   <dc:identifier>https://service.arthurianfiction.org/manuscript/MAN0000000012</dc:identifier>
   <dc:date>2012-07-13T14:27:31Z</dc:date>
   <dc:contributor>Bart Besamusca</dc:contributor>
   <dc:type>model</dc:type>
   <dc:language>eng</dc:language>
</oai_dc:dc></metadata><about>
<oaiProvenance:provenance xmlns:oaiProvenance="http://www.openarchives.org/OAI/2.0/provenance" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/provenance http://www.openarchives.org/OAI/2.0/provenance.xsd">
<oaiProvenance:originDescription harvestDate="2015-01-07" altered="true">
<oaiProvenance:baseURL>http://cdm16694.contentdm.oclc.org/oai/oai.php</oaiProvenance:baseURL>
<oaiProvenance:identifier>oai:cdm16694.contentdm.oclc.org:R6A001/1</oaiProvenance:identifier>
<oaiProvenance:datestamp>2015-01-07</oaiProvenance:datestamp>
<oaiProvenance:metadataNamespace>http://www.openarchives.org/OAI/2.0/</oaiProvenance:metadataNamespace>
</oaiProvenance:originDescription>
</oaiProvenance:provenance>
</about></record><record><header><identifier>oai:oaipmh.huygens.knaw.nl:arthurianfiction:MAN0000000013</identifier><datestamp>2012-07-13T14:27:31Z</datestamp><setSpec>arthurianfiction:manuscript</setSpec><setSpec>arthurianfiction</setSpec></header><metadata><oai_dc:dc xmlns:cmdi="http://www.clarin.eu/cmd/" xmlns:database="http://www.oclc.org/pears/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd http://www.clarin.eu/cmd/ http://catalog.clarin.eu/ds/ComponentRegistry/rest/registry/profiles/clarin.eu:cr1:p_1345561703673/xsd">
   <dc:title>Aberystwyth, National Library of Wales, 5667 E</dc:title>
   <dc:creator>Bart Besamusca</dc:creator>
   <dc:identifier>https://service.arthurianfiction.org/manuscript/MAN0000000013</dc:identifier>
   <dc:date>2012-07-13T14:27:31Z</dc:date>
   <dc:contributor>Bart Besamusca</dc:contributor>
   <dc:type>model</dc:type>
   <dc:language>eng</dc:language>
</oai_dc:dc></metadata></record><resumptionToken cursor="1">MToxMHwyOnwzOnw0Onw1Om9haV9kYw==</resumptionToken></ListRecords></OAI-PMH>',
                   :headers => {})

      # ListRecords -- Multiple record OAI Request (resumed)
      stub_request(:get,
                   'http://example.org/endpoint?resumptionToken='\
                   'MToxMHwyOnwzOnw0Onw1Om9haV9kYw==&verb=ListRecords')
        .with(:headers => {
                'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
              })
        .to_return(:status => 200,
                   :body => '<?xml version="1.0" encoding="UTF-8"?><?xml-stylesheet type="text/xsl" href="static/oai2.xsl"?><OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"><responseDate>2014-10-27T23:05:33Z</responseDate><request verb="ListRecords" metadataPrefix="oai_dc">http://oaipmh.huygens.knaw.nl/</request><ListRecords><record><header><identifier>oai:oaipmh.huygens.knaw.nl:arthurianfiction:MAN0000000010</identifier><datestamp>2012-07-13T14:27:31Z</datestamp><setSpec>arthurianfiction:manuscript</setSpec><setSpec>arthurianfiction</setSpec></header><metadata><oai_dc:dc xmlns:cmdi="http://www.clarin.eu/cmd/" xmlns:database="http://www.oclc.org/pears/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd http://www.clarin.eu/cmd/ http://catalog.clarin.eu/ds/ComponentRegistry/rest/registry/profiles/clarin.eu:cr1:p_1345561703673/xsd">
   <dc:title>Aberystwyth, National Library of Wales, 446-E</dc:title>
   <dc:creator>Bart Besamusca</dc:creator>
   <dc:identifier>https://service.arthurianfiction.org/manuscript/MAN0000000010</dc:identifier>
   <dc:date>2012-07-13T14:27:31Z</dc:date>
   <dc:contributor>Bart Besamusca</dc:contributor>
   <dc:type>model</dc:type>
   <dc:language>eng</dc:language>
</oai_dc:dc></metadata></record><record><header><identifier>oai:oaipmh.huygens.knaw.nl:arthurianfiction:MAN0000000011</identifier><datestamp>2012-07-13T14:27:31Z</datestamp><setSpec>arthurianfiction</setSpec><setSpec>arthurianfiction:manuscript</setSpec></header><metadata><oai_dc:dc xmlns:cmdi="http://www.clarin.eu/cmd/" xmlns:database="http://www.oclc.org/pears/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd http://www.clarin.eu/cmd/ http://catalog.clarin.eu/ds/ComponentRegistry/rest/registry/profiles/clarin.eu:cr1:p_1345561703673/xsd">
   <dc:title>Aberystwyth, National Library of Wales, 5018-D</dc:title>
   <dc:creator>Bart Besamusca</dc:creator>
   <dc:identifier>https://service.arthurianfiction.org/manuscript/MAN0000000011</dc:identifier>
   <dc:date>2012-07-13T14:27:31Z</dc:date>
   <dc:contributor>Bart Besamusca</dc:contributor>
   <dc:type>model</dc:type>
   <dc:language>eng</dc:language>
</oai_dc:dc></metadata></record></ListRecords></OAI-PMH>',
                   :headers => {})
    end

    it 'retries timed out requests' do
      expect_any_instance_of(Faraday::Adapter::NetHttp)
        .to receive(:perform_request).at_least(4).times
             .and_raise(Net::ReadTimeout.new)
      expect { subject.records.first }.to raise_error
    end

    describe 'resumption' do
      let(:resumed_uri) do
        'http://example.org/endpoint?resumptionToken='\
        'MToxMHwyOnwzOnw0Onw1Om9haV9kYw==&verb=ListRecords'
      end

      it 'follows resumption token' do
        subject.records.each { |r| r }
        expect(WebMock).to have_requested(:get, resumed_uri).once
      end

      it 'only follows resumption token as far as requested' do
        subject.records.take(4).each { |r| r }
        expect(WebMock).not_to have_requested(:get, resumed_uri)
      end
    end

    describe 'options' do
      let(:result) { double }
      let(:args) do
        {uri: 'http://example.org/endpoint', oai: {metadata_prefix: 'mods'}}
      end
      let(:request_opts) { {set: 'moomin'} }

      shared_context 'oai options' do
        before do
          allow(result).to receive(:full).and_return([])
        end
      end

      shared_examples 'send options' do
        it 'sends request with option' do
          expect(subject.client).to receive(request_type)
            .with(:metadata_prefix => args[:oai][:metadata_prefix])
            .and_return(result)
          subject.send(method)
        end
        it 'adds options passed into request' do
          expect(subject.client).to receive(request_type)
            .with(:metadata_prefix => args[:oai][:metadata_prefix],
                  :set => request_opts[:set])
            .and_return(result)
          subject.send(method, request_opts)
        end
      end

      describe '#records' do
        include_context 'oai options'
        include_examples 'send options'

        let(:request_type) { :list_records }
        let(:method) { :records }
      end

      describe 'record_ids' do
        include_context 'oai options'
        include_examples 'send options'

        let(:request_type) { :list_identifiers }
        let(:method) { :record_ids }
      end

      describe '#get_record' do
        before do
          allow(result).to receive(:record).and_return(oai_record)
        end

        let(:identifier) { 'comet_moominland' }
        let(:request_type) { :get_record }
        let(:oai_record) { OAI::Record.new(REXML::Element.new) }

        it 'sends request with option' do
          expect(subject.client).to receive(request_type)
            .with(:identifier => identifier,
                  :metadata_prefix => args[:oai][:metadata_prefix])
            .and_return(result)
          subject.get_record(identifier)
        end

        it 'adds options passed into request' do
          expect(subject.client).to receive(request_type)
            .with(:identifier => identifier,
                  :metadata_prefix => args[:oai][:metadata_prefix],
                  :set => request_opts[:set])
            .and_return(result)
          subject.get_record(identifier, request_opts)
        end
      end
    end

    describe '#enqueue' do
      let(:args) do
        {uri: 'http://example.org/endpoint', oai: {metadata_prefix: 'mods'}}
      end
      before do
        Resque.remove_queue('harvest')  # Not strictly necessary. Future?
        Krikri::Activity.delete_all
      end
      it 'saves harvest options correctly when creating an activity' do
        # Ascertain that options particular to this harvester type are
        # serialized and deserialized properly.
        described_class.enqueue(Krikri::HarvestJob, opts = args)
        activity = Krikri::Activity.first
        opts = JSON.parse(activity.opts, symbolize_names: true)
        expect(opts).to eq(args)
      end
    end

    it_behaves_like 'a harvester'
  end
end


describe Krikri::Harvester::Registry do
  describe '#registered?' do
    it 'knows OAIHarvester is registered' do
      # It should have been registered by the engine initializer, engine.rb.
      expect(described_class.registered?(:oai)).to be true
    end
  end
end

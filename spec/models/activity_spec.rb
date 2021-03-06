require 'spec_helper'
require 'timecop'

##
# Custom matcher that verifies whether the period represented by the start
# and end timestamps of the given model is close enough to the given duration.
RSpec::Matchers.define :have_duration_of do |duration|
  match do |actual|
    real_dur = actual.end_time - actual.start_time
    (real_dur - duration).abs < 0.1
  end
end

describe Krikri::Activity, type: :model do
  subject { create(:krikri_activity) }

  describe '#rdf_subject' do
    it 'is a URI' do
      expect(subject.rdf_subject).to be_a RDF::URI
    end

    it 'uses #id as local name ' do
      expect(subject.rdf_subject.to_s).to end_with subject.id.to_s
    end
  end

  describe '#start_time' do
    before do
      subject.set_start_time
    end

    it 'marks start time' do
      expect(subject.start_time).to be_a ActiveSupport::TimeWithZone
    end
  end

  describe '#end_time' do
    it 'raises an error if not started' do
      expect { subject.set_end_time }.to raise_error
    end
  end

  describe '#ended?' do
    context 'before completion' do
      it 'returns false' do
        expect(subject).not_to be_ended
      end
    end

    context 'while running' do
      before { subject.set_start_time }

      it 'returns false' do
        expect(subject).not_to be_ended
      end
    end

    context 'after completion' do
      before do
        subject.set_start_time
        subject.set_end_time
      end

      it 'returns true' do
        expect(subject).to be_ended
      end
    end
  end

  describe '#run' do
    it 'runs the given block' do
      expect { |b| subject.run(&b) }
        .to yield_with_args(subject.agent_instance, subject.rdf_subject)
    end

    it 'sets start and end times when running a block' do
      duration = 30     # seconds
      subject.run { Timecop.travel(duration) }
      Timecop.return    # come back to the present for future tests
      expect(subject).to have_duration_of(duration)
    end

    context 'after first run' do
      before do
        subject.run { }
      end

      it 'sets end_time to nil before running' do
        subject.run { expect(subject.end_time).to be_nil }
      end
    end

    context 'with error' do
      let(:error) { StandardError.new('my error') }

      it 'logs errors' do
        message = "Error performing Activity: #{subject.id}\nmy error"
        expect(Rails.logger).to receive(:error).with(start_with(message))
        begin
          subject.run { raise error }
        rescue
        end
      end

      it 'rethrows error' do
        expect { subject.run { raise error } }
          .to raise_error StandardError
      end

      it 'sets end time' do
        begin
          subject.run { raise error }
        rescue
        end
        expect(subject.end_time).to be_within(1.second).of(Time.now)
      end
    end
  end

  describe '#agent_instance' do
    it 'returns an instance of the agent class' do
      expect(subject.agent_instance)
        .to be_an_instance_of(subject.agent.constantize)
    end

    it 'returns the same instance for successive calls' do
      expect(subject.agent_instance).to be subject.agent_instance
    end
  end

  describe '#parsed_opts' do
    it 'is a hash of opts' do
      expect(subject.parsed_opts).to be_a Hash
    end

    it 'has symbolized keys' do
      subject.parsed_opts.keys.each do |k|
        expect(k).to be_a Symbol
      end
    end
  end
end

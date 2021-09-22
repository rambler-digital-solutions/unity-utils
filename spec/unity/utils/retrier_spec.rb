# frozen_string_literal: true

RSpec.describe Unity::Utils::Retrier do
  let(:errors) { nil }
  let(:action) { 5 + 5 }

  describe '#call' do
    subject { described_class.new(errors, 3, 0).call { action } }

    it 'does not retryes and returns correct result' do
      expect_any_instance_of(described_class).not_to receive(:sleep_on)
      is_expected.to eq(10)
    end

    context 'without block and arguments' do
      subject { described_class.new.call }

      it { is_expected.to be_nil }
    end
  end

  describe '.call' do
    subject { described_class.call { action } }

    it 'does not retryes and returns correct result' do
      expect_any_instance_of(described_class).not_to receive(:sleep_on)
      is_expected.to eq(10)
    end

    context 'without block' do
      subject { described_class.call }

      it { is_expected.to be_nil }
    end

    context 'when bad action' do
      let(:action) { 5 / 0 }

      before { allow_any_instance_of(described_class).to receive(:sleep_factor).and_return(0) }

      it 'retryes and returns error' do
        expect_any_instance_of(described_class).to receive(:sleep_on).exactly(5).times
        expect { subject }.to raise_error(ZeroDivisionError)
      end
    end
  end
end

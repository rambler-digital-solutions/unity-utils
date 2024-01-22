# frozen_string_literal: true

require 'spec_helper'
require 'faraday'

RSpec.describe Unity::Utils::FaradayWithRetries do
  let(:instance) { described_class.new }
  let(:url) { nil }

  describe 'args' do
    subject do
      instance
        .call(url).as_json['builder']['handlers']
        .find { |h| h['name'] == 'Faraday::Request::Retry' }['args']
    end

    before { stub_const('Unity::Utils::FaradayWithRetries::DEFAULT_EXCEPTIONS', ['boom!']) }

    let(:correct_args) do
      [{ backoff_factor: 1, interval: 1.0, interval_randomness: 0.1, max: 3,
        exceptions: ['boom!'] }.stringify_keys]
    end

    it { is_expected.to eq(correct_args) }

    context 'with args' do
      let(:instance) do
        described_class.new(exceptions: [ZeroDivisionError], max: 2, interval: 2.0,
                            interval_randomness: 0.2, backoff_factor: 2)
      end
      let(:correct_args) do
        [{ backoff_factor: 2, interval: 2.0, interval_randomness: 0.2, max: 2,
          exceptions: [ZeroDivisionError] }.stringify_keys]
      end

      before { stub_const('ZeroDivisionError', 'boom!') }

      it { is_expected.to eq(correct_args) }
    end
  end
end

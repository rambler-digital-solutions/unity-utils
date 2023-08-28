# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Unity::Utils::UrlValidator, type: :validator do
  subject { described_class.new(url).call }

  let(:locale_prefix) { 'unity_utils.errors' }

  before { I18n.locale = :ru }

  context 'with valid url' do
    context 'with site url' do
      let(:url) { 'https://motor.ru/reports/videoparis.htm' }

      it 'returns true and empty errors array' do
        expect(subject).to be_valid
        expect(subject.errors).to be_empty
      end
    end

    context 'with krang url' do
      let(:topic_id) { 1 }
      let(:url) { "http://localhost:8090/#/topic/#{topic_id}?_k=7mwqub" }

      it 'returns true and empty errors array' do
        expect(subject).to be_valid
        expect(subject.errors).to be_empty
      end
    end
  end

  context 'without top level domain' do
    subject { described_class.new(url).call }

    let(:url) { 'http://rambler' }

    it 'returns true and empty errors array' do
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end
  end

  context 'with invalid url' do
    context 'with blank url' do
      let(:error_message) { I18n.t!("#{locale_prefix}.blank_url") }

      context 'with nil url' do
        let(:url) { nil }

        it 'returns false and blank error' do
          expect(subject).to be_invalid
          expect(subject.errors).to eq([error_message])
        end
      end

      context 'with empty string url' do
        let(:url) { '' }

        it 'returns false and blank error' do
          expect(subject).to be_invalid
          expect(subject.errors).to eq([error_message])
        end
      end
    end

    context 'with invalid protocol' do
      let(:url) { 'ftp://motor.ru/reports/videoparis.htm' }

      it 'returns false and protocol error' do
        expect(subject).to be_invalid
        expect(subject.errors).to eq([I18n.t!("#{locale_prefix}.invalid_protocol")])
      end
    end

    context 'with blank host' do
      let(:url) { 'secretmag.ru' }

      it 'returns false and host error' do
        expect(subject).to be_invalid
        expect(subject.errors).to eq([I18n.t!("#{locale_prefix}.blank_host")])
      end
    end

    context 'with custom validation errors' do
      subject { described_class.new(url, custom_errors).call }

      let(:url) { 'http://s1.shredder.unity.rambler tech' }
      let(:locale) { 'errors.price_ru.bad_response' }
      let(:custom_errors) { { parse_uri!: locale } }
      let(:error_message) { 'Error message' }

      before { allow(I18n).to receive(:t).with(locale).and_return(error_message) }

      it 'returns false and custom format error' do
        expect(subject).to be_invalid
        expect(subject.errors).to eq([error_message])
      end
    end

    context 'with two fragments' do
      subject { described_class.new(url).call }

      let(:url) { 'http://rambler.ru#first#second' }

      it 'returns false and format error' do
        expect(subject).to be_invalid
        expect(subject.errors).to eq([I18n.t!("#{locale_prefix}.invalid_url_format")])
      end
    end
  end
end

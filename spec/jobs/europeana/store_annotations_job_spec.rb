# frozen_string_literal: true

RSpec.describe Europeana::StoreAnnotationsJob do
  include_context 'Annotations API'

  let(:exhibition) { alchemy_pages(:complex_exhibition_root) }

  before do
    # Override Annotations API shared context request stub for Hash targets
    stub_request(:get, annotations_api_search_method_url).
      to_return(status: 200,
                body: api_responses(:annotations_search, target: :hash),
                headers: { 'Content-Type' => 'application/ld+json' })
  end

  it 'should be in the "annotations" queue' do
    expect { described_class.perform_later(exhibition.urlname, exhibition.language_code) }.
      to have_enqueued_job.on_queue('annotations')
  end

  context 'with gallery annotations enabled' do
    before do
      ENV['EUROPEANA_ANNOTATIONS_API_USER_TOKEN'] = 'fake_token'
    end

    it 'should fetch existing annotations' do
      WebMock::Config.instance.query_values_notation = :flat_array
      described_class.perform_now(exhibition.urlname, exhibition.language_code)

      expected_query = [
        'pageSize=100',
        'profile=standard',
        'qf=creator_name:"Europeana.eu Exhibition"',
        'qf=link_relation:isGatheredInto',
        %(qf=link_resource_uri:"https://www.europeana.eu/portal/#{exhibition.language_code}/exhibitions/#{exhibition.urlname}"),
        'qf=motivation:linking',
        'query=*:*',
        "wskey=#{annotations_api_key}"
      ].join('&')

      expect(a_request(:get, annotations_api_search_method_url).
        with(query: expected_query)).
        to have_been_made.once

      WebMock::Config.instance.query_values_notation = nil
    end

    it 'should create non-existent annotations' do
      described_class.perform_now(exhibition.urlname, exhibition.language_code)

      expect(a_request(:post, annotations_api_create_method_url).
        with(query: hash_including(wskey: annotations_api_key, userToken: annotations_api_user_token))).
        to have_been_made.times(2)
      expect(a_request(:post, annotations_api_create_method_url).
        with(
          query: hash_including(wskey: annotations_api_key, userToken: annotations_api_user_token),
          body: gallery.images.first.annotation.send(:body_params).to_json
        )).
        to have_been_made.once
      expect(a_request(:post, annotations_api_create_method_url).
        with(
          query: hash_including(wskey: annotations_api_key, userToken: annotations_api_user_token),
          body: gallery.images.last.annotation.send(:body_params).to_json
        )).
        to have_been_made.once
    end

    it 'should delete redundant annotations' do
      described_class.perform_now(exhibition.urlname, exhibition.language_code)

      expect(a_request(:delete, annotations_api_delete_method_url).
        with(query: hash_including(wskey: annotations_api_key, userToken: annotations_api_user_token))).
        to have_been_made.times(2)
      expect(a_request(:delete, "#{annotations_api_url}/annotations/abc/123").
        with(query: hash_including(wskey: annotations_api_key, userToken: annotations_api_user_token))).
        to have_been_made.once
      expect(a_request(:delete, "#{annotations_api_url}/annotations/def/456").
        with(query: hash_including(wskey: annotations_api_key, userToken: annotations_api_user_token))).
        to have_been_made.once
    end
  end

  context 'without user token configured' do
    before do
      ENV['EUROPEANA_ANNOTATIONS_API_USER_TOKEN'] = nil
    end

    it 'fails' do
      expect { described_class.perform_now(exhibition.urlname, exhibition.language_code) }.
        to raise_exception('Annotations functionality is not configured.')
    end
  end
end

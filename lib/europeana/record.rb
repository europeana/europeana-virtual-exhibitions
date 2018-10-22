# frozen_string_literal: true

module Europeana
  # Represents (but does not store) a Europeana record as exposed over the Record
  # API.
  #
  # @see https://pro.europeana.eu/resources/apis/record
  # TODO: Does any of this belong in the API gem instead? e.g. +#rdf+, +api_json_ld_uri+
  class Record
    include Europeana::Record::Annotations

    # Regexp to match Europeana record IDs
    ID_PATTERN = %r|/[0-9]+/[a-zA-Z0-9_]+|

    # @return [String] Europeana ID of this record
    attr_accessor :id

    class << self
      # Does the argument look like a Europeana record ID?
      #
      # @param candidate [String] String to test
      # @return [Boolean]
      def id?(candidate)
        !!(candidate =~ /\A#{ID_PATTERN}\z/)
      end

      ##
      # Extracts a Europeana record ID from a variety of known portal URL formats
      #
      # @param url [String] URL to extract from
      # @return [String,nil] Europeana ID, or nil if not a portal URL
      def id_from_portal_url(url)
        uri = URI.parse(url)
        return nil unless %w(http https).include?(uri.scheme)
        return nil unless %w(www.europeana.eu europeana.eu).include?(uri.host)
        extension = /\.[a-z]+\z/i.match(uri.path)
        return nil unless extension.nil? || extension[0] == '.html'
        match = %r|\A/portal(/[a-z]{2})?/record(#{ID_PATTERN})#{extension}\z|.match(uri.path)
        match.nil? ? nil : match[2]
      end

      # Does the argument look like a Europeana record portal URL?
      #
      # @param candidate [String] String to test
      # @return [Boolean]
      def portal_url?(candidate)
        !id_from_portal_url(candidate).nil?
      end

      ##
      # Constructs a Search API query for all of the passed IDS.
      #
      # This only returns what would need to go in the `query` parameter sent to
      # the API (or Blacklight's `q` parameter), nothing else. The caller will need
      # to ensure that other parameters are set, such as ensuring that the API
      # returns enough rows to get the entire gallery back.
      #
      # @param record_ids [Array<String>]
      # @return [String]
      def search_api_query_for_record_ids(record_ids)
        'europeana_id:("' + record_ids.join('" OR "') + '")'
      end

      ##
      # Returns the language-agnostic portal URL for a Europeana record
      #
      # @param id [String] record ID
      # @return [String]
      def portal_url(id)
        "https://www.europeana.eu/portal/record#{id}.html"
      end
    end

    def initialize(id)
      self.id = id
    end

    # @see Europeana::Record.portal_url
    def portal_url
      self.class.portal_url(id)
    end
  end
end

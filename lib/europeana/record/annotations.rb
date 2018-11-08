# frozen_string_literal: true

module Europeana
  class Record
    # Annotations support for records
    module Annotations
      # @return [String]
      def annotation_target_uri
        "http://data.europeana.eu/item#{id}"
      end
    end
  end
end

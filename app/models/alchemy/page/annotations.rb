# frozen_string_literal: true

module Alchemy
  class Page
    # Annotations support for Alchemy::Pages
    module Annotations
      extend ActiveSupport::Concern

      included do
        after_destroy :destroy_annotations, if: :annotate_records?
        after_destroy :store_annotations, if: :store_annotations_after_save?

        before_save :destroy_old_annotations, if: :destroy_annotations_before_save?
        after_save :store_annotations, if: :store_annotations_after_save?
        after_save :destroy_annotations, if: :destroy_annotations_after_save?

        delegate :annotate_records?, to: :class
      end

      class_methods do
        # Should we write annotations to the Europeana Annotations API linking
        # records to the exhibitions they are included in?
        #
        # @return [Boolean]
        def annotate_records?
          !!ENV['EUROPEANA_ANNOTATIONS_API_USER_TOKEN'].present?
        end
      end

      def annotations
        @annotations ||= Europeana::Annotation.find(annotations_search_params)
      end

      def annotations_search_params
        {
          qf: [
            "creator_name:#{escape_annotation_query_value(ENV['EUROPEANA_ANNOTATIONS_API_USER_NAME'])}",
            'link_relation:isGatheredInto',
            'motivation:linking',
            %(link_resource_uri:"#{annotation_link_resource_uri}")
          ]
        }
      end

      def annotation_link_resource_uri
        @annotation_link_resource_uri ||= "https://#{annotation_link_resource_host}/portal/#{language_code}/exhibitions/#{urlname}"
      end

      def annotation_link_resource_host
        ENV['ANNOTATION_LINK_RESOURCE_HOST'] ||
          ENV['HTTP_HOST'] ||
          'www.europeana.eu'
      end

      def all_annotation_elements
        @all_annotation_elements ||= begin
          self_and_descendants.published.map do |page|
            page.credits.select(&:has_annotation_target?)
          end.flatten
        end
      end

      def needed_annotation_targets
        @needed_annotation_targets ||= all_annotation_elements.map(&:annotation_target_uri)
      end

      def needs_annotation_for_target?(target)
        needed_annotation_targets.include?(target)
      end

      def needs_annotation?(annotation)
        needs_annotation_for_target?(annotation.target)
      end

      def existing_annotation_targets
        @existing_annotation_targets ||= annotations.map(&:target)
      end

      def has_annotation_for_target?(target)
        existing_annotation_targets.include?(target)
      end

      def annotation_api_user_token
        ENV['EUROPEANA_ANNOTATIONS_API_USER_TOKEN'] || ''
      end

      def store_annotations
        Europeana::StoreAnnotationsJob.perform_later(exhibition.urlname, language_code)
      end

      def destroy_annotations
        Europeana::StoreAnnotationsJob.perform_later(exhibition.urlname, language_code, delete_all: true)
      end

      def destroy_old_annotations
        Europeana::StoreAnnotationsJob.perform_later(urlname_was, language_code, delete_all: true)
      end

      def store_annotations_after_save?
        exhibition&.public? && annotate_records?
      end

      def destroy_annotations_after_save?
        exhibition? && !public? && annotate_records?
      end

      # This check is exclusively for renaming an exhibition level page/slug.
      def destroy_annotations_before_save?
        # rails 5.1+ use will_save_change_to_urlname?
        exhibition? && annotate_records? && urlname_changed?
      end

      def escape_annotation_query_value(value)
        value.gsub(' ', '\ ')
      end
    end
  end
end

# frozen_string_literal: true

module Europeana
  ##
  # Creates and deletes annotations via the Europeana Annotations API representing the
  # inclusion of Europeana records in an Exhibition. Inclusion is determined by the urls of credit elements.
  class StoreAnnotationsJob < ActiveJob::Base
    queue_as :annotations

    attr_reader :exhibition

    # @param urlname [String] urlname of the exhibition
    # @param delete_all [TrueClass,FalseClass] if true, just delete all exhibition annotations
    def perform(urlname, language_code, delete_all: false)
      fail 'Annotations functionality is not configured.' unless Alchemy::Page.annotate_records?
      validate_args_to_perform!(urlname, language_code, delete_all: delete_all)

      @delete_all = delete_all
      @exhibition = Alchemy::Page.where(urlname: urlname, language_code: language_code).first_or_initialize
      fail 'Annotations can only be stored at exhibition level.' unless @exhibition.depth == 2 || delete_all

      delete_annotations
      create_annotations unless delete_all
    end

    protected

    def validate_args_to_perform!(urlname, language_code, delete_all:)
      unless urlname.is_a?(String)
        fail ArgumentError, "Expected String for exhibition_slug, got #{urlname.class}"
      end
      unless language_code.is_a?(String)
        fail ArgumentError, "Expected String for language_code, got #{language_code.class}"
      end
      unless [true, false].include?(delete_all)
        fail ArgumentError, "Expected true or false for delete_all, got #{delete_all.inspect}"
      end
    end

    def create_annotations
      @exhibition.all_annotation_elements.each do |element|
        next if @exhibition.has_annotation_for_target?(element.annotation_target)
        logger.info("Creating annotation linking #{element.annotation_target_uri} to #{@exhibition.annotation_link_resource_uri}".
          green.bold)
        element.annotation.tap do |annotation|
          annotation.api_user_token = @exhibition.annotation_api_user_token
          annotation.save
        end
      end
    end

    def delete_annotations
      @exhibition.annotations.each do |annotation|
        next unless delete_annotation?(annotation)
        logger.info("Deleting annotation #{annotation.id}".red.bold)
        annotation.api_user_token = @exhibition.annotation_api_user_token
        annotation.delete
      end
    end

    def delete_annotation?(annotation)
      @delete_all || !@exhibition.needs_annotation?(annotation)
    end
  end
end

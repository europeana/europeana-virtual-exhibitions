# frozen_string_literal: true

class Alchemy::EssenceCredit < ActiveRecord::Base
  acts_as_essence(ingredient_column: :title, preview_text_column: :title)

  delegate :annotation_target_uri, to: :europeana_record

  ##
  # Overriding the ActiveRecord license accessor, because Some legacy licences need
  # to be looked up via the licence key of the license which has the same URL.
  #
  def license
    db_license = super
    inverted_licenses = Europeana::Mixins::ImageCredit::LICENSES.invert

    return db_license if inverted_licenses.key?(db_license)
    'CNE' # unable to determine
  end

  # Europeana record for +europeana_record_id+
  #
  # @return [Europeana::Record]
  def europeana_record
    return @europeana_record if instance_variable_defined?(:@europeana_record)
    @europeana_record = Europeana::Record.new(europeana_record_id)
  end

  def europeana_record_id
    return @europeana_record_id if instance_variable_defined?(:@europeana_record_id)
    @europeana_record_id = Europeana::Record.id_from_portal_url(url)
  end

  def has_annotation_target?
    europeana_record_id.present?
  end

  def annotation
    @annotation ||= Europeana::Annotation.new(annotation_attributes)
  end

  def annotation_target
    {
      'type': 'SpecificResource',
      'scope': annotation_target_uri,
      'source': annotation_link_resource_uri
    }
  end

  def annotation_attributes
    {
      motivation: 'linking',
      body: {
        '@graph' => {
          '@context' => 'http://www.europeana.eu/schemas/context/edm.jsonld',
          isGatheredInto: annotation_link_resource_uri,
          id: annotation_target_uri
        }
      },
      target: annotation_target
    }
  end

  def annotation_link_resource_uri
    # TODO: maybe delegate to each model as opposed to chaining like this. Would require more extensions though.
    @annotation_link_resource_uri ||= element&.page&.exhibition&.annotation_link_resource_uri
  end
end

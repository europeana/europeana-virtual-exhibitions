class Alchemy::EssenceCredit < ActiveRecord::Base
  acts_as_essence(ingredient_column: :title, preview_text_column: :title)

  ##
  # Overriding the ActiveRecord license accessor, because Some legacy licences need
  # to be looked up via the licence key of the license which has the same URL.
  #
  def license
    db_license = super
    inverted_licenses = Europeana::Mixins::ImageCredit::LICENSES.invert

    return db_license if inverted_licenses.key?(db_license)

    license_url = Europeana::Mixins::ImageCredit::LICENSES_URL[db_license]
    Europeana::Mixins::ImageCredit::LICENSES_URL.select { |_key, url| url == license_url}.each do |key, _value|
      return key if inverted_licenses.key?(key)
    end
    'CNE' #unable to determine
  end
end

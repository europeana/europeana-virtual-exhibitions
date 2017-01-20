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
    'CNE' # unable to determine
  end
end

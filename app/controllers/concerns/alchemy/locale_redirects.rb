module Alchemy
  module LocaleRedirects
    extend ActiveSupport::Concern

    include LocalisedRoutes
  end
end

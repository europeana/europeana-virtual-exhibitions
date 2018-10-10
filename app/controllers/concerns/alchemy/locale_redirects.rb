# frozen_string_literal: true

module Alchemy
  module LocaleRedirects
    extend ActiveSupport::Concern

    include LocalisedRoutes
  end
end

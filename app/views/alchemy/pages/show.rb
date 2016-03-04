module Alchemy::Pages
  class Show < Europeana::Styleguide::View
    include MustacheHelper

    def elements
      {
        present: @page.elements.count >= 1,
        items: @page.elements.map do |element|
          Europeana::Elements::Base.build(element).to_hash
        end
      }
    end

    def elements_as_json
      JSON.pretty_generate(elements)
    end

    def json
      JSON.pretty_generate(JSON.parse @page.to_json(include: { elements: { include: :essences }}))
    end
  end
end

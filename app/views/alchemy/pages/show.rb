module Alchemy::Pages
  class Show < Europeana::Styleguide::View
    include MustacheHelper

    def elements
      {
        present: @page.elements.count >= 1,
        items: @page.elements.map do |element|
          {
            body: element.essences.first.body,
            is_text: true
          }
        end
      }
    end

    def json
      JSON.pretty_generate(JSON.parse @page.to_json(include: { elements: { include: :essences }}))
    end
  end
end

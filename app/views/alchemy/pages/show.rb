module Alchemy::Pages
  class Show < Europeana::Styleguide::View
    def title
      @page.title
    end

    def elements
      @page.elements.all
    end

    def json
      JSON.pretty_generate(JSON.parse @page.to_json(include: { elements: { include: :essences }}))
    end
  end
end

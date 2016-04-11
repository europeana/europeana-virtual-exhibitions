module PageHelper
  def page_description(page)
    Europeana::Page.new(page).description
  end
end

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @language.root_page.title
    xml.description page_description(@language.root_page)
    xml.link show_page_url(@language.language_code, @language.root_page.urlname)
    xml.language @language.language_code
    xml.pubDate @language.root_page.published_at.rfc2822
  

    xml.image do
      xml.url show_page_url(@language.language_code, @language.root_page.urlname)
      xml.title @language.root_page.title
      xml.link show_page_url(@language.language_code, @language.root_page.urlname)
      xml.description page_description(@language.root_page)
    end

    @pages.each do |page|
      xml.item do
        xml.title page.title
        xml.description page_description(page)
        xml.pubDate page.published_at.rfc2822
        xml.link show_page_url(page.language_code, page.urlname)
      end
    end
  end
end

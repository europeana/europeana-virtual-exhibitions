require 'rack-plastic'

module Europeana
  class Gsub < Rack::Plastic
    def change_html_string(html)
      html.gsub!("/pictures/", "//#{ENV.fetch('CDN_HOST')}/pictures/")
      html
    end
  end
end

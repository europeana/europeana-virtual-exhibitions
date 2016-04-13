require 'rack-plastic'

module Europeana
  class Gsub < Rack::Plastic
    def change_html_string(html)
      html = html.gsub(/("|\'|&quot;)\/portal\/exhibitions\/pictures\/|(^\/portal\/exhibitions\/pictures\/)/) do | match |
        "#{$1}//#{ENV.fetch('CDN_HOST')}/portal/exhibitions/pictures/"
      end
      html
    end
  end
end

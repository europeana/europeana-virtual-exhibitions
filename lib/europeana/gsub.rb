require 'rack-plastic'

module Europeana
  class Gsub < Rack::Plastic
    def change_html_string(html)
      html.gsub!(/("|\')\/pictures\/|(^\/pictures\/)/) do | match |
        "#{$1}//#{ENV.fetch('CDN_HOST')}/pictures/"
      end
      html
    end
  end
end

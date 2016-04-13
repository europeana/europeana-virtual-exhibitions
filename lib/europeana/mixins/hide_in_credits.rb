module Europeana
  module Mixins
    module HideInCredits
      def hide_in_credits
        return false if !@contents.include?('hide_in_credits')
        return false if get(:hide_in_credits, :value).nil?
        get(:hide_in_credits, :value)
      end
    end
  end
end

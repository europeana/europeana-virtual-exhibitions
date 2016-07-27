Alchemy::Admin::BaseController.class_eval do
  def determine_locale?
    false
  end

  def enforce_locale?
    false
  end
end

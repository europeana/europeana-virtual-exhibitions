class Alchemy::EssenceCredit < ActiveRecord::Base
  acts_as_essence(ingredient_column: :title, preview_text_column: :title)
end

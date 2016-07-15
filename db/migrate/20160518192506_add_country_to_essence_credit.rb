class AddCountryToEssenceCredit < ActiveRecord::Migration
  def change
    add_column :alchemy_essence_credits, :country_code, :string
  end
end

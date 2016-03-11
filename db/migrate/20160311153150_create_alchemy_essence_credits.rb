class CreateAlchemyEssenceCredits < ActiveRecord::Migration
  def change
    create_table :alchemy_essence_credits do |t|

      t.timestamps null: false
    end
  end
end

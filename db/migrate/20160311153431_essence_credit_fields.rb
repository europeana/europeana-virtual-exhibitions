class EssenceCreditFields < ActiveRecord::Migration
  def change
    add_column :alchemy_essence_credits, :title, :string
    add_column :alchemy_essence_credits, :author, :string
    add_column :alchemy_essence_credits, :institution, :string
    add_column :alchemy_essence_credits, :url, :string
    add_column :alchemy_essence_credits, :license, :string
  end
end

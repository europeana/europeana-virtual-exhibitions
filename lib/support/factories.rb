require 'factory_girl'

FactoryGirl.define do
  factory :alchemy_essence_richtext, class: 'Alchemy::EssenceRichtext' do
    body '<strong>This</strong> is a headline'
  end
end

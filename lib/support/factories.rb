require 'factory_girl'

FactoryGirl.define do
  factory :alchemy_essence_richtext, class: 'Alchemy::EssenceRichtext' do
    body '<strong>This</strong> is a headline'
  end

  factory :landscape_picture, class: 'Alchemy::Picture' do
    image_file File.new(File.expand_path('../../../spec/support/placeholder-700x400.png', __FILE__))
    name 'placeholder-700x400.png'
    image_file_name 'placeholder-700x400.png'
    upload_hash Time.zone.now.hash
  end
  factory :portrait_picture, class: 'Alchemy::Picture' do
    image_file File.new(File.expand_path('../../../spec/support/placeholder-400x700.png', __FILE__))
    name 'placeholder-400x700.png'
    image_file_name 'placeholder-400x700.png'
    upload_hash Time.zone.now.hash
  end
end

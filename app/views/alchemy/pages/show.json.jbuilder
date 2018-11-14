# frozen_string_literal: true

json.url @page_object&.url
json.credit_image @page_object&.credit_image
json.description @page_object&.description
json.full_image @page_object&.all_media&.first&.dig(:image, :full, :url)
json.card_image @page_object&.all_media&.first&.dig(:image, :thumbnail, :url)
json.card_text @page_object&.description&.truncate(250, separator: ' ')
json.labels @page_object&.chapter_labels
json.lang_code @page.language_code
json.title @page_object&.title
json.slug @page.urlname
json.depth @page.depth

module Europeana
  module Elements
    class Base

      TYPES = %w(text image rich_image section quote intro foyer_card embed navigation featured_exhibition credit_intro image_compare promo)

      attr_accessor :element

      def self.build(element)
        Module.const_get("Europeana::Elements::#{element.name.camelcase}").new(element) # rescue Europeana::Elements::Base.new(element)
      end

      def initialize(element)
        @element = element
        @attributes = []
        @contents = element.content_definitions.map{|c| c["name"]}
        TYPES.each do |type|
          @attributes << "is_#{type}".to_sym
        end
      end

      TYPES.each do |type|
        define_method("is_#{type}") do
          @element.name == type
        end
      end

      def type
        self.class.name.demodulize.tableize.singularize
      end

      def to_hash(include_url: false)
        data.merge(Hash[@attributes.map {|attribute| [attribute, self.send(attribute)]}]).merge({type: type, alchemy_id: @element.id, id: "#{@element.name}_#{@element.id}"}).merge(include_url ? {page_url: include_url } : {})
      end

      def get(name, attribute = :ingredient)
        if !@contents.include?(name.to_s)
          raise StandardError, "No content #{name} found for #{@element}"
        end
        detected_content = all_content.detect { |content| content.name == name.to_s }
        if detected_content&.essence&.respond_to?(attribute)
          value = detected_content.essence.send(attribute)

          if value.class == String
            return false if value.nil? || value.empty?
            return value.strip
          end
          value
        else
          false
        end
      end

      def data
        {}
      end

      def all_content
        @all_content ||= @element.contents
      end
    end
  end
end

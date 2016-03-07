module Europeana
  module Elements
    class Base

      TYPES = %w(text image rich_image)

      def self.build(element)
        Module.const_get("Europeana::Elements::#{element.name.camelcase}").new(element)
      end

      def initialize(element)
        @element = element
        @attributes = []

        TYPES.each do |type|
          @attributes << "is_#{type}"
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

      def to_hash
        data
        d = {}
        @attributes.each do |attribute|
          d[attribute.to_sym] = self.send(attribute)
        end
        d[:type] = type
        data.merge(d)
      end

      def data
        {}
      end
    end
  end
end

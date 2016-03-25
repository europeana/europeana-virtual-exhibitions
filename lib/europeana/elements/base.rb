module Europeana
  module Elements
    class Base

      TYPES = %w(text image rich_image section quote intro foyer_card embed navigation)

      attr_accessor :element

      def self.build(element)
        Module.const_get("Europeana::Elements::#{element.name.camelcase}").new(element) # rescue Europeana::Elements::Base.new(element)
      end

      def initialize(element)
        @element = element
        @attributes = []

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

      def to_hash
        data.merge(Hash[@attributes.map {|attribute| [attribute, self.send(attribute)]}]).merge({type: type, alchemy_id: @element.id, id: "#{@element.name}_#{@element.id}"})
      end

      def get(name, attribute = :ingredient)
        if @element.content_by_name(name)
          @element.content_by_name(name).essence.send(attribute)
        else
          false
        end
      end

      def data
        {}
      end
    end
  end
end

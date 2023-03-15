module Exlibris
  module Primo
    module WebService
      module Request
        module SearchElements
          def self.included(klass)
            klass.class_eval do
              extend ClassAttributes
            end
          end

          module ClassAttributes
            def search_elements
              @search_elements ||= self.superclass.respond_to?(:search_elements) ?
                self.superclass.search_elements.dup : []
            end

            def add_search_elements *elements
              elements.each do |element|
                search_elements << element unless search_elements.include? element
              end
            end
            protected :add_search_elements

            def remove_search_elements *elements
              search_elements.delete_if do |element|
                elements.include? element
              end
            end
            protected :remove_search_elements

            def default_search_elements
              @default_search_elements ||= self.superclass.respond_to?(:default_search_elements) ?
                self.superclass.default_search_elements.dup : {}
            end

            def add_default_search_elements elements
              default_search_elements.merge! elements
            end
            protected :add_default_search_elements

            def remove_default_search_elements *keys
              keys.each do |key|
                default_search_elements.delete key
              end
            end
            protected :remove_default_search_elements
          end

          def search_elements
            @search_elements ||= self.class.search_elements
          end
          protected :search_elements

          def default_search_elements
            @default_search_elements ||= self.class.default_search_elements
          end
          protected :default_search_elements

          #
          # Returns a lambda that takes a Nokogiri::XML::Builder as an argument
          # and appends search elements XML to it.
          #
          def search_elements_xml
            lambda { |xml|
              search_elements.each do |element|
                value = (send element) ? (send element) : default_search_elements[element]
                name = element.id2name.camelize

                next if soap_search_elements.exclude?(name) || value.nil?

                xml.send(name, value)
              end
            }
          end
          protected :search_elements_xml

          def soap_search_elements
            %w(StartIndex BulkSize DidUMeanEnabled HighlightingEnabled GetMore InstBoost)
          end
          private :soap_search_elements

          # Returns a string for inclusion as query parameters for the REST API
          def search_elements_string
            search_elements.map do |element|
              value = (send element) ? (send element) : default_search_elements[element]
              name = element.id2name.camelize
              name[0] = name[0].downcase

              next if rest_search_elements.exclude?(name) || value.nil?

              "#{name}=#{URI.encode(value.to_s)}"
            end.compact.join('&')
          end

          def rest_search_elements
            %w(limit offset sort getMore conVoc)
          end
          private :rest_search_elements

          #
          # Dynamically sets attr_accessors for search_elements
          #
          def method_missing(method, *args, &block)
            if search_elements.include?(attributize(method))
              self.class.send :attr_accessor, attributize(method)
              send method, *args, &block
            else
              super
            end
          end

          #
          # Tell users that we respond to search elements accessors.
          #
          def respond_to?(method, include_private = false)
            (search_elements.include?(attributize method)) ? true : super
          end
        end
      end
    end
  end
end
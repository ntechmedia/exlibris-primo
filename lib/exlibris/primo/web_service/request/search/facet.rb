module Exlibris
  module Primo
    module WebService
      module Request
        #
        #
        #
        class Facet
          include WriteAttributes
          include XmlUtil
          attr_accessor :category, :value

          def initialize(*args)
            validate_category(args[0][:category]) unless args.empty?
            super
          end

          def category=(value)
            validate_category(value)
            @category = value
          end

          # Returns a string for inclusion in the "qInclude", "qExclude" or "multiFacets" parameter for the REST API
          # @param [String] operator the operator to use when rendering the facet to a string (default: exact)
          def to_s(operator: 'exact')
              "#{category},#{operator},#{URI.encode(value.gsub(';', ''))}"
          end

          # Validates the supplied category to ensure that it is supported
          def validate_category(category)
            return unless self.class.allowed_categories.exclude? category

            raise "The supplied category '#{category}' is not supported. Please use one of the following: #{self.class.allowed_categories.join(', ')}"
          end

          def self.allowed_categories
            [
              "facet_rtype", # Resource Type
              "facet_topic", # Subject
              "facet_creator", # Author
              "facet_tlevel", # Availability
              "facet_domain", # Collection
              "facet_library", # Library name
              "facet_lang", # Language
              "facet_lcc" # LCC classification
            ]
          end
        end
      end
    end
  end
end
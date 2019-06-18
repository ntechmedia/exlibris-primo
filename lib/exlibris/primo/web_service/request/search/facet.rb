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

          def category=(value)
            @category = value
          end

          # Returns a string for inclusion in the "qInclude", "qExclude" or "multiFacets" parameter for the REST API
          # @param [String] operator the operator to use when rendering the facet to a string (default: exact)
          def to_s(operator: 'exact')
              "#{category},#{operator},#{URI.encode(value.gsub(';', ''))}"
          end
        end
      end
    end
  end
end
module Exlibris
  module Primo
    module WebService
      module Request
        module Facets
          attr_writer :boolean_operator

          # Returns a string for the "qInclude" parameter for the REST API
          def included_facets_string
            return '' if included_facets.empty?

            "qInclude=#{included_facets.map(&:to_s).join('%7C,%7C')}"
          end

          # Returns a string for the "qExclude" parameter for the REST API
          def excluded_facets_string
            return '' if excluded_facets.empty?

            "qExclude=#{excluded_facets.map(&:to_s).join('%7C,%7C')}"
          end

          def included_facets
            @included_facets ||= []
          end

          def excluded_facets
            @excluded_facets ||= []
          end

          def add_facet(value, category, included = true)
            new_facet = Facet.new(category: category, value: value)
            included ? included_facets << new_facet : excluded_facets << new_facet
          end
        end
      end
    end
  end
end
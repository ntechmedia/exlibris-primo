module Exlibris
  module Primo
    module WebService
      module Request
        module MultiFacets
          # Returns a string for the "multiFacet" parameter for the REST API
          def multi_facets_string
            return '' if included_multi_facets.empty? && excluded_multi_facets.empty?

            included_query = included_multi_facets.map { |f| f.to_s(operator: 'include') }.join('%7C,%7C')
            excluded_query = excluded_multi_facets.map { |f| f.to_s(operator: 'exclude') }.join('%7C,%7C')
            "multiFacets=#{[included_query, excluded_query].delete_if(&:empty?).join('%7C,%7C')}"
          end

          def included_multi_facets
            @included_multi_facets ||= []
          end

          def excluded_multi_facets
            @excluded_multi_facets ||= []
          end

          def add_multi_facet(value, category, included = true)
            new_facet = Facet.new(category: category, value: value)
            included ? included_multi_facets << new_facet : excluded_multi_facets << new_facet
          end
        end
      end
    end
  end
end
module Exlibris
  module Primo
    module WebService
      module Request
        module QueryTerms
          attr_writer :boolean_operator

          def boolean_operator
            @boolean_operator ||= "AND"
          end

          #
          # Returns a lambda that takes a Nokogiri::XML::Builder as an argument
          # and appends query terms XML to it.
          #
          def query_terms_xml
            bool_operator = boolean_operator
            lambda do |xml|
              xml.QueryTerms {
                xml.BoolOpeator bool_operator
                query_terms.each do |query_term|
                  xml << query_term.to_xml
                end
              }
            end
          end

          protected :query_terms_xml

          # Returns a string for inclusion in the "q" parameter for the REST API
          def to_s
            query_terms.map { |query_term| query_term.to_s }.join(",#{boolean_operator};")
          end

          def query_terms
            @query_terms ||= []
          end

          def add_query_term(value, index, precision = "contains")
            query_terms << QueryTerm.new(value: value, index: index, precision: precision)
          end
        end
      end
    end
  end
end
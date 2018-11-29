module Exlibris
  module Primo
    module WebService
      module Request
        #
        # Search Primo
        #
        class Search < Base
          self.has_client
          self.set_base_api_action({ soap: :search_brief, rest: :search })
          include DisplayFields
          include Languages
          include Locations
          include QueryTerms
          include Facets
          include MultiFacets
          include RequestParams
          include SearchElements
          include SortBys

          # SOAP API search elements
          add_default_search_elements :start_index => "1",
                                      :bulk_size => "5",
                                      :did_u_mean_enabled => "false"

          add_search_elements :start_index,
                              :bulk_size,
                              :did_u_mean_enabled,
                              :highlighting_enabled,
                              :get_more,
                              :inst_boost

          # REST API Elements
          add_default_search_elements offset: "0",
                                      limit: "5"

          add_search_elements :limit,
                              :offset,
                              :sort,
                              :get_more,
                              :con_voc
          def to_xml
            super { |xml|
              xml.PrimoSearchRequest("xmlns" => "http://www.exlibris.com/primo/xsd/search/request") {
                request_params_xml.call xml
                query_terms_xml.call xml
                search_elements_xml.call xml
                languages_xml.call xml
                sort_bys_xml.call xml
                display_fields_xml.call xml
                locations_xml.call xml
              }
            }
          end

          # Returns a query string for use with the REST API
          def to_query_string
            [
              # TODO: implement display fields & sort_bys for REST API
              request_params_string,
              query_terms_string,
              search_elements_string,
              languages_string,
              locations_string,
              included_facets_string,
              excluded_facets_string
            ].delete_if(&:empty?).join('&')
          end
        end

        #
        # Get a specific record from Primo.
        #
        class FullView < Search
          # Add doc_id to the base elements
          self.add_base_elements :doc_id
          self.set_base_api_action({ soap: :get_record })
        end
      end
    end
  end
end
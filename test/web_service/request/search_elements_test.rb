module WebService
  module Request
    require 'test_helper'
    class RequestParamsTest < Test::Unit::TestCase
      class SearchDummy
        include Exlibris::Primo::WebService::Request::SearchElements
        include Exlibris::Primo::XmlUtil
        include Exlibris::Primo::WriteAttributes

        # SOAP API Elements
        add_default_search_elements start_index: "1",
                                    bulk_size: "5",
                                    did_u_mean_enabled: "false"

        add_search_elements :start_index,
                            :bulk_size,
                            :did_u_mean_enabled,
                            :highlighting_enabled,
                            :get_more,
                            :inst_boost
        # REST API Elements
        add_default_search_elements offset: "0",
                                    limit: "20"

        add_search_elements :limit,
                            :offset,
                            :sort,
                            :get_more,
                            :con_voc

        def to_s
          search_elements_string
        end

        def to_xml
          build_xml { |xml|
            search_elements_xml.call xml
          }
        end
      end

      def test_add_search_elements
      end

      def test_remove_search_elements
      end

      def test_add_default_search_elements
      end

      def test_remove_default_search_elements
      end

      def test_search_elements
      end

      def test_default_search_elements
      end

      def test_search_elements_xml
      end

      def test_search_elements_string_with_defaults
        search = SearchDummy.new
        expected_param = 'limit=20&offset=0'

        assert_equal expected_param, search.to_s
      end

      def test_search_elements_string_with_overridden_defaults
        search = SearchDummy.new
        search.offset = "0"
        search.limit = "10"
        search.sort = "title"
        search.get_more = "1"
        search.con_voc = "false"
        expected_param = 'getMore=1&limit=10&offset=0&sort=title&conVoc=false'

        assert_equal expected_param, search.to_s
      end
    end
  end
end

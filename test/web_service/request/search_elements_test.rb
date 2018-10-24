module WebService
  module Request
    require 'test_helper'
    class RequestParamsTest < Test::Unit::TestCase
      class SearchDummy
        include Exlibris::Primo::WebService::Request::SearchElements
        include Exlibris::Primo::XmlUtil

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

      end

      def test_search_elements_string_with_custom
      end
    end
  end
end

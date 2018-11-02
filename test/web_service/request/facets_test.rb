module WebService
  module Request
    require 'test_helper'
    class FacetsTest < Test::Unit::TestCase
      class SearchDummy
        include Exlibris::Primo::WebService::Request::Facets
        include Exlibris::Primo::XmlUtil

        def to_query_string
          [
            included_facets_string,
            excluded_facets_string
          ].delete_if(&:empty?).join('&')
        end
      end

      def test_facets
        search = SearchDummy.new

        assert_equal [], search.included_facets
        assert_equal [], search.excluded_facets
      end

      def test_no_facets
        search = SearchDummy.new

        assert_equal '', search.to_query_string
      end

      def test_implicitly_included_facets
        search = SearchDummy.new
        search.add_facet 'books', 'facet_rtype'
        expected_param = "qInclude=facet_rtype,exact,books"

        assert_equal expected_param, search.to_query_string
      end

      def test_explicitly_included_facets
        search = SearchDummy.new
        search.add_facet 'books', 'facet_rtype', true
        expected_param = "qInclude=facet_rtype,exact,books"

        assert_equal expected_param, search.to_query_string
      end

      def test_excluded_facets
        search = SearchDummy.new
        search.add_facet 'books', 'facet_rtype', false
        expected_param = "qExclude=facet_rtype,exact,books"

        assert_equal expected_param, search.to_query_string
      end


      def test_multiple_included_facets
        search = SearchDummy.new
        search.add_facet 'books', 'facet_rtype'
        search.add_facet 'Jack Johnson', 'facet_creator'
        expected_param = "qInclude=facet_rtype,exact,books|,|facet_creator,exact,Jack%20Johnson"

        assert_equal expected_param, search.to_query_string
      end

      def test_multiple_excluded_facets
        search = SearchDummy.new
        search.add_facet 'books', 'facet_rtype', false
        search.add_facet 'Jack Johnson', 'facet_creator', false
        expected_param = "qExclude=facet_rtype,exact,books|,|facet_creator,exact,Jack%20Johnson"

        assert_equal expected_param, search.to_query_string
      end

      def test_included_and_excluded_facets
        search = SearchDummy.new
        search.add_facet 'books', 'facet_rtype', true
        search.add_facet 'Jack Johnson', 'facet_creator', false
        expected_param = "qInclude=facet_rtype,exact,books&qExclude=facet_creator,exact,Jack%20Johnson"

        assert_equal expected_param, search.to_query_string
      end
    end
  end
end
module WebService
  module Request
    require 'test_helper'
    class MultiFacetsTest < Test::Unit::TestCase
      class SearchDummy
        include Exlibris::Primo::WebService::Request::MultiFacets
        include Exlibris::Primo::XmlUtil

        def to_query_string
          multi_facets_string
        end
      end

      def test_facets
        search = SearchDummy.new

        assert_equal [], search.included_multi_facets
        assert_equal [], search.excluded_multi_facets
      end

      def test_no_facets
        search = SearchDummy.new

        assert_equal '', search.to_query_string
      end

      def test_implicitly_included_facets
        search = SearchDummy.new
        search.add_multi_facet 'books', 'facet_rtype'
        expected_param = "multiFacets=facet_rtype,include,books"

        assert_equal expected_param, search.to_query_string
      end

      def test_explicitly_included_facets
        search = SearchDummy.new
        search.add_multi_facet 'books', 'facet_rtype', true
        expected_param = "multiFacets=facet_rtype,include,books"

        assert_equal expected_param, search.to_query_string
      end

      def test_excluded_facets
        search = SearchDummy.new
        search.add_multi_facet 'books', 'facet_rtype', false
        expected_param = "multiFacets=facet_rtype,exclude,books"

        assert_equal expected_param, search.to_query_string
      end


      def test_multiple_included_facets
        search = SearchDummy.new
        search.add_multi_facet 'books', 'facet_rtype'
        search.add_multi_facet 'Jack Johnson', 'facet_creator'
        expected_param = "multiFacets=facet_rtype,include,books%7C,%7Cfacet_creator,include,Jack%20Johnson"

        assert_equal expected_param, search.to_query_string
      end

      def test_multiple_excluded_facets
        search = SearchDummy.new
        search.add_multi_facet 'books', 'facet_rtype', false
        search.add_multi_facet 'Jack Johnson', 'facet_creator', false
        expected_param = "multiFacets=facet_rtype,exclude,books%7C,%7Cfacet_creator,exclude,Jack%20Johnson"

        assert_equal expected_param, search.to_query_string
      end

      def test_included_and_excluded_facets
        search = SearchDummy.new
        search.add_multi_facet 'books', 'facet_rtype', true
        search.add_multi_facet 'Jack Johnson', 'facet_creator', false
        expected_param = "multiFacets=facet_rtype,include,books%7C,%7Cfacet_creator,exclude,Jack%20Johnson"

        assert_equal expected_param, search.to_query_string
      end
    end
  end
end
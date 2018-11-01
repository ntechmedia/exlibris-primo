module WebService
  module Request
    require 'test_helper'
    class FacetTest < Test::Unit::TestCase
      def setup
        @isbn = "0143039008"
        @issn = "0090-5720"
        @title = "Travels with My Aunt"
        @author = "Graham Greene"
        @genre = "Book"
      end

      def test_set_attributes_for_rest
        facet = Exlibris::Primo::WebService::Request::Facet.new
        facet.value = 'books'
        facet.category = 'facet_rtype'
        expected_param = "#{facet.category},exact,#{facet.value}"

        assert_equal expected_param, facet.to_s
      end

      def test_set_attributes_for_rest_with_unsupported_facet
        facet = Exlibris::Primo::WebService::Request::Facet.new
        expected_message =
          "The supplied category 'facet_myfacet' is not supported. "\
          "Please use one of the following: #{Exlibris::Primo::WebService::Request::Facet.allowed_categories.join(', ')}"

        assert_raise_message(expected_message) {facet.category = 'facet_myfacet'}
      end

      def test_write_attributes_for_rest
        facet = Exlibris::Primo::WebService::Request::Facet.new(value: 'books', category: 'facet_rtype')
        expected_param = "#{facet.category},exact,#{facet.value}"

        assert_equal expected_param, facet.to_s
      end

      def test_write_attributes_for_rest_with_unsupported_facet
        expected_message =
          "The supplied category 'facet_myfacet' is not supported. "\
          "Please use one of the following: #{Exlibris::Primo::WebService::Request::Facet.allowed_categories.join(', ')}"

        assert_raise_message(expected_message) do
          Exlibris::Primo::WebService::Request::Facet.new(value: 'books', category: 'facet_myfacet')
        end
      end
    end
  end
end
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

      def test_write_attributes_for_rest
        facet = Exlibris::Primo::WebService::Request::Facet.new(value: 'books', category: 'facet_rtype')
        expected_param = "#{facet.category},exact,#{facet.value}"

        assert_equal expected_param, facet.to_s
      end
    end
  end
end
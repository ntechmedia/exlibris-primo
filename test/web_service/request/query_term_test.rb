module WebService
  module Request
    require 'test_helper'
    class QueryTermTest < Test::Unit::TestCase
      def setup
        @isbn = "0143039008"
        @issn = "0090-5720"
        @title = "Travels with My Aunt"
        @author = "Graham Greene"
        @genre = "Book"
      end

      def test_set_attributes_for_xml
        query_term = Exlibris::Primo::WebService::Request::QueryTerm.new
        query_term.value = @isbn
        query_term.precision = "exact"
        query_term.index = "isbn"
        expected_xml = strip_xml(
          <<-XML
          <QueryTerm>
            <IndexField>isbn</IndexField>
            <PrecisionOperator>exact</PrecisionOperator>
            <Value>0143039008</Value>
          </QueryTerm>
        XML
        )

        assert_equal expected_xml, query_term.to_xml
      end

      def test_write_attributes_for_xml
        query_term = Exlibris::Primo::WebService::Request::QueryTerm.new(:value => @isbn, :precision => "exact", :index => "isbn")
        expected_xml = strip_xml(
          <<-XML
          <QueryTerm>
            <IndexField>isbn</IndexField>
            <PrecisionOperator>exact</PrecisionOperator>
            <Value>0143039008</Value>
          </QueryTerm>
        XML
        )

        assert_equal expected_xml, query_term.to_xml
      end

      def test_set_attributes_for_rest
        query_term = Exlibris::Primo::WebService::Request::QueryTerm.new
        query_term.value = @isbn
        query_term.precision = "exact"
        query_term.index = "isbn"
        expected_param = "#{query_term.index},#{query_term.precision},#{query_term.value}"

        assert_equal expected_param, query_term.to_s
      end

      def test_set_attributes_for_rest_with_semicolon_in_value
        query_term = Exlibris::Primo::WebService::Request::QueryTerm.new
        query_term.value = 'The road ahead; simple guidelines'
        query_term.precision = "exact"
        query_term.index = "title"
        expected_value = URI.encode('The road ahead simple guidelines')
        expected_param = "title,exact,#{expected_value}"

        assert_equal expected_param, query_term.to_s
      end

      def test_write_attributes_for_rest
        query_term = Exlibris::Primo::WebService::Request::QueryTerm.new(:value => @isbn, :precision => "exact", :index => "isbn")
        expected_param = "isbn,exact,#{@isbn}"

        assert_equal expected_param, query_term.to_s
      end
    end
  end
end
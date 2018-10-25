module WebService
  module Request
    require 'test_helper'
    class QueryTermsTest < Test::Unit::TestCase
      class SearchDummy
        include Exlibris::Primo::WebService::Request::QueryTerms
        include Exlibris::Primo::XmlUtil

        def to_s
          query_terms_string
        end

        def to_xml
          build_xml { |xml|
            query_terms_xml.call xml
          }
        end
      end

      def setup
        @query_params = [
          {
            value: '0143039008',
            precision: 'exact',
            index: 'isbn',
          },
          {
            value: 'Travels with My Aunt',
            precision: 'contains',
            index: 'title',
          },
          {
            value: 'Book',
            precision: 'exact',
            index: 'genre',
          },
        ]
      end

      def test_query_terms
        search = SearchDummy.new

        assert_equal [], search.query_terms
      end


      def test_mutliple_terms_for_add_query_term_with_and_for_xml
        search = SearchDummy.new
        @query_params.each do |query_param|
          search.add_query_term(
            query_param[:value],
            query_param[:index],
            query_param[:precision]
          )
        end

        search.boolean_operator = 'AND'
        expected_xml = strip_xml(
          <<-XML
          <QueryTerms>
            <BoolOpeator>AND</BoolOpeator>
            <QueryTerm>
              <IndexField>isbn</IndexField>
              <PrecisionOperator>exact</PrecisionOperator>
              <Value>0143039008</Value>
            </QueryTerm>
            <QueryTerm>
              <IndexField>title</IndexField>
              <PrecisionOperator>contains</PrecisionOperator>
              <Value>Travels with My Aunt</Value>
            </QueryTerm>
            <QueryTerm>
              <IndexField>genre</IndexField>
              <PrecisionOperator>exact</PrecisionOperator>
              <Value>Book</Value>
            </QueryTerm>
          </QueryTerms>
        XML
        )

        assert_equal expected_xml, search.to_xml
      end

      def test_mutliple_terms_for_add_query_term_with_or_for_xml
        search = SearchDummy.new
        @query_params.each do |query_param|
          search.add_query_term(
            query_param[:value],
            query_param[:index],
            query_param[:precision]
          )
        end

        search.boolean_operator = 'OR'
        expected_xml = strip_xml(
          <<-XML
          <QueryTerms>
            <BoolOpeator>OR</BoolOpeator>
            <QueryTerm>
              <IndexField>isbn</IndexField>
              <PrecisionOperator>exact</PrecisionOperator>
              <Value>0143039008</Value>
            </QueryTerm>
            <QueryTerm>
              <IndexField>title</IndexField>
              <PrecisionOperator>contains</PrecisionOperator>
              <Value>Travels with My Aunt</Value>
            </QueryTerm>
            <QueryTerm>
              <IndexField>genre</IndexField>
              <PrecisionOperator>exact</PrecisionOperator>
              <Value>Book</Value>
            </QueryTerm>
          </QueryTerms>
        XML
        )

        assert_equal expected_xml, search.to_xml
      end

      def test_query_terms_xml_no_params_for_xml
        search = SearchDummy.new
        expected_xml = strip_xml(
          <<-XML
          <QueryTerms>
            <BoolOpeator>AND</BoolOpeator>
          </QueryTerms>
        XML
        )

        assert_equal expected_xml, search.to_xml
      end

      def test_mutliple_terms_for_add_query_term_with_and_for_rest
        search = SearchDummy.new
        @query_params.each do |query_param|
          search.add_query_term(
            query_param[:value],
            query_param[:index],
            query_param[:precision]
          )
        end

        search.boolean_operator = 'AND'
        expected_param = URI.encode("q=isbn,exact,0143039008,AND;title,contains,Travels with My Aunt,AND;genre,exact,Book")

        assert_equal expected_param, search.to_s
      end

      def test_mutliple_terms_for_add_query_term_with_or_for_rest
        search = SearchDummy.new
        @query_params.each do |query_param|
          search.add_query_term(
            query_param[:value],
            query_param[:index],
            query_param[:precision]
          )
        end

        search.boolean_operator = 'OR'
        expected_param = URI.encode("q=isbn,exact,0143039008,OR;title,contains,Travels with My Aunt,OR;genre,exact,Book")

        assert_equal expected_param, search.to_s
      end

      def test_query_terms_xml_no_params_for_rest
        search = SearchDummy.new
        expected_param = ''

        assert_equal expected_param, search.to_s
      end
    end
  end
end
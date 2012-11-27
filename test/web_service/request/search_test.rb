module WebService
  module Request
    require 'test_helper'
    class SearchTest < Test::Unit::TestCase
      def setup
        @base_url = "http://bobcatdev.library.nyu.edu"
        @institution = "NYU"
        @isbn = "0143039008"
        @issn = "0090-5720"
        @title = "Travels with My Aunt"
        @author = "Graham Greene"
        @genre = "Book"
      end

      def test_client
        assert_equal :search, Exlibris::Primo::WebService::Request::Search.send(:client)
      end

      def test_request_search_issn
          search_request = Exlibris::Primo::WebService::Request::Search.new :base_url => @base_url
          search_request.institution = @institution
          search_request.add_query_term @issn, "isbn", "exact"
          assert_request search_request, "searchRequest",
            "<PrimoSearchRequest xmlns=\"http://www.exlibris.com/primo/xsd/search/request\">"+
            "<QueryTerms><BoolOpeator>AND</BoolOpeator><QueryTerm>"+
            "<IndexField>isbn</IndexField>"+
            "<PrecisionOperator>exact</PrecisionOperator>"+
            "<Value>0090-5720</Value>"+
            "</QueryTerm></QueryTerms>"+
            "<StartIndex>1</StartIndex>"+
            "<BulkSize>5</BulkSize>"+
            "<DidUMeanEnabled>false</DidUMeanEnabled>"+
            "</PrimoSearchRequest>", "<institution>NYU</institution>"
          VCR.use_cassette('request searchissn call') do
            search_response = search_request.call
            search_response.records
            facets = search_response.facets
          end
      end

      def test_request_search_isbn
          search_request = Exlibris::Primo::WebService::Request::Search.new :base_url => @base_url
          search_request.institution = @institution
          search_request.add_query_term @isbn, "isbn", "exact"
          assert_request search_request, "searchRequest",
            "<PrimoSearchRequest xmlns=\"http://www.exlibris.com/primo/xsd/search/request\">"+
            "<QueryTerms><BoolOpeator>AND</BoolOpeator><QueryTerm>"+
            "<IndexField>isbn</IndexField>"+
            "<PrecisionOperator>exact</PrecisionOperator>"+
            "<Value>0143039008</Value>"+
            "</QueryTerm></QueryTerms>"+
            "<StartIndex>1</StartIndex>"+
            "<BulkSize>5</BulkSize>"+
            "<DidUMeanEnabled>false</DidUMeanEnabled>"+
            "</PrimoSearchRequest>", "<institution>NYU</institution>"
          VCR.use_cassette('request searchisbn call') do
            search_request.call
          end
      end

      def test_request_search_title
          search_request = Exlibris::Primo::WebService::Request::Search.new :base_url => @base_url
          search_request.institution = @institution
          search_request.add_query_term @title, "title"
          assert_request search_request, "searchRequest",
            "<PrimoSearchRequest xmlns=\"http://www.exlibris.com/primo/xsd/search/request\">"+
            "<QueryTerms><BoolOpeator>AND</BoolOpeator><QueryTerm>"+
            "<IndexField>title</IndexField>"+
            "<PrecisionOperator>contains</PrecisionOperator>"+
            "<Value>Travels with My Aunt</Value>"+
            "</QueryTerm></QueryTerms>"+
            "<StartIndex>1</StartIndex>"+
            "<BulkSize>5</BulkSize>"+
            "<DidUMeanEnabled>false</DidUMeanEnabled>"+
            "</PrimoSearchRequest>", "<institution>NYU</institution>"
          VCR.use_cassette('request searchtitle call') do
            search_request.call
          end
      end

      def test_request_search_did_u_mean
          search_request = Exlibris::Primo::WebService::Request::Search.new :base_url => @base_url
          search_request.institution = @institution
          search_request.did_u_mean_enabled = true
          search_request.add_query_term "Digital dvide", "title"
          assert_request search_request, "searchRequest",
            "<PrimoSearchRequest xmlns=\"http://www.exlibris.com/primo/xsd/search/request\">"+
            "<QueryTerms><BoolOpeator>AND</BoolOpeator><QueryTerm>"+
            "<IndexField>title</IndexField>"+
            "<PrecisionOperator>contains</PrecisionOperator>"+
            "<Value>Digital dvide</Value>"+
            "</QueryTerm></QueryTerms>"+
            "<StartIndex>1</StartIndex>"+
            "<BulkSize>5</BulkSize>"+
            "<DidUMeanEnabled>true</DidUMeanEnabled>"+
            "</PrimoSearchRequest>", "<institution>NYU</institution>"
          VCR.use_cassette('request searchdid u mean call') do
            search_response = search_request.call
            search_response.records
            facets = search_response.facets
            assert_equal "digital d vide", search_response.did_u_mean
            assert search_response.local?
          end
      end

      def test_request_search_author
          search_request = Exlibris::Primo::WebService::Request::Search.new :base_url => @base_url
          search_request.institution = @institution
          search_request.add_query_term @author, "creator"
          assert_request search_request, "searchRequest",
            "<PrimoSearchRequest xmlns=\"http://www.exlibris.com/primo/xsd/search/request\">"+
            "<QueryTerms><BoolOpeator>AND</BoolOpeator><QueryTerm>"+
            "<IndexField>creator</IndexField>"+
            "<PrecisionOperator>contains</PrecisionOperator>"+
            "<Value>Graham Greene</Value>"+
            "</QueryTerm></QueryTerms>"+
            "<StartIndex>1</StartIndex>"+
            "<BulkSize>5</BulkSize>"+
            "<DidUMeanEnabled>false</DidUMeanEnabled>"+
            "</PrimoSearchRequest>", "<institution>NYU</institution>"
          VCR.use_cassette('request searchauthor call') do
            search_request.call
          end
      end

      def test_request_search_genre
          search_request = Exlibris::Primo::WebService::Request::Search.new :base_url => @base_url
          search_request.institution = @institution
          search_request.add_query_term @genre, "any", "exact"
          assert_request search_request, "searchRequest",
            "<PrimoSearchRequest xmlns=\"http://www.exlibris.com/primo/xsd/search/request\">"+
            "<QueryTerms><BoolOpeator>AND</BoolOpeator><QueryTerm>"+
            "<IndexField>any</IndexField>"+
            "<PrecisionOperator>exact</PrecisionOperator>"+
            "<Value>Book</Value>"+
            "</QueryTerm></QueryTerms>"+
            "<StartIndex>1</StartIndex>"+
            "<BulkSize>5</BulkSize>"+
            "<DidUMeanEnabled>false</DidUMeanEnabled>"+
            "</PrimoSearchRequest>", "<institution>NYU</institution>"
          VCR.use_cassette('request searchgenre call') do
            # search_request.call
          end
      end

      def test_request_search_title_author_genre
        search_request = Exlibris::Primo::WebService::Request::Search.new :base_url => @base_url
        search_request.institution = @institution
        search_request.add_query_term @title, "title"
        search_request.add_query_term @author, "creator"
        search_request.add_query_term @genre, "any", "exact"
        assert_request_children(search_request, "searchRequest") do |child|
          if child.children.size > 1
            assert_nil child.namespace.prefix
            assert_equal "http://www.exlibris.com/primo/xsd/search/request", child.namespace.href
            child.children.each do |grand_child|
              if grand_child.children.size > 1
                assert_equal 4, grand_child.children.size
                grand_child.children.each do |great_grand_child|
                  assert [
                    "<BoolOpeator>AND</BoolOpeator>",
                    "<QueryTerm><IndexField>title</IndexField>"+
                    "<PrecisionOperator>contains</PrecisionOperator>"+
                    "<Value>Travels with My Aunt</Value></QueryTerm>",
                    "<QueryTerm><IndexField>creator</IndexField>"+
                    "<PrecisionOperator>contains</PrecisionOperator>"+
                    "<Value>Graham Greene</Value></QueryTerm>",
                    "<QueryTerm><IndexField>any</IndexField>"+
                    "<PrecisionOperator>exact</PrecisionOperator>"+
                    "<Value>Book</Value></QueryTerm>"].include? xmlize(great_grand_child)
                end
              else
                assert ["<StartIndex>1</StartIndex>", "<BulkSize>5</BulkSize>", 
                  "<DidUMeanEnabled>false</DidUMeanEnabled>"].include? xmlize(grand_child)
              end
            end
          else
            assert_equal "<institution>NYU</institution>", xmlize(child)
          end
        end
        VCR.use_cassette('request searchtitle author genre call') do
          search_response = search_request.call
          search_response.records
          search_response.facets
        end
      end
    end
  end
end
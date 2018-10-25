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
        @doc_id = "nyu_aleph000062856"
      end

      def test_to_s_with_nothing
        request = Exlibris::Primo::WebService::Request::Search.new base_url: @base_url
        expected_message = 'You must supply at least one query term'

        assert_raise_message(expected_message) { request.to_query_string }
      end

      def test_to_s_with_typical_request
        request = Exlibris::Primo::WebService::Request::Search.new base_url: @base_url,
                                                                   limit: 20
        request.add_request_param 'pcAvailability', 'true'
        request.add_query_term @issn, 'isbn', 'exact'
        request.add_query_term @title, 'title', 'exact'
        request.add_location 'local', 'scope:(VOLCANO)'
        expected_output = 'pcAvailability=true&q=isbn,exact,0090-5720,AND;title,exact,Travels%20with%20My%20Aunt&limit=20&offset=0&scope=VOLCANO'

        assert_equal expected_output, request.to_query_string
      end
    end
  end
end
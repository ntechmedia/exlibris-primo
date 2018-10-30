module WebService
  module Request
    require 'test_helper'
    class RestSearchTest < Test::Unit::TestCase
      def setup
        @base_url = 'https://api-ap.hosted.exlibrisgroup.com/'

        @isbn = "0143039008"
        @issn = "0090-5720"
        @title = "Travels with My Aunt"
        @author = "Graham Greene"
        @genre = "Book"
      end

      def teardown
        Exlibris::Primo.config.api = :soap
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

      def test_missing_vid
        Exlibris::Primo.configure do |config|
          config.api = :rest
          config.vid = nil
          config.tab = 'quicksearch'
          config.api_key = ENV['REST_API_KEY']
        end

        request = Exlibris::Primo::WebService::Request::Search.new :base_url => @base_url
        request.add_query_term @issn, "isbn", "exact"
        request.add_location 'local', 'scope:(UB_local_PC)'
        expected_message = 'The vid (view ID) config attribute must be set. (e.g. ExlibrisPrimo.config.vid = "Auto1")'

        assert_raise_message(expected_message) { request.call }
      end

      def test_missing_tab
        Exlibris::Primo.configure do |config|
          config.api = :rest
          config.vid = 'UNI'
          config.tab = nil
          config.api_key = ENV['REST_API_KEY']
        end

        request = Exlibris::Primo::WebService::Request::Search.new :base_url => @base_url
        request.add_query_term @issn, "isbn", "exact"
        request.add_location 'local', 'scope:(UB_local_PC)'
        expected_message = 'The tab search tab (tab) config attribute must be set. (e.g. ExlibrisPrimo.config.tab = "quicksearch")'

        assert_raise_message(expected_message) { request.call }
      end

      def test_missing_api_key
        Exlibris::Primo.configure do |config|
          config.api = :rest
          config.vid = 'UNI'
          config.tab = 'quicksearch'
          config.api_key = nil
        end

        request = Exlibris::Primo::WebService::Request::Search.new :base_url => @base_url
        request.add_query_term @issn, "isbn", "exact"
        request.add_location 'local', 'scope:(UB_local_PC)'
        expected_message = 'The apikey config attribute must be set. (e.g. ExlibrisPrimo.config.apikey = "l7xxcb1e0f7b1d09876119edf593ec552f95d")'

        assert_raise_message(expected_message) { request.call }
      end

      def test_request_search_by_title
        Exlibris::Primo.configure do |config|
          config.api = :rest
          config.vid = 'UB'
          config.tab = 'quicksearch'
          config.api_key = ENV['REST_API_KEY']
        end

        request = Exlibris::Primo::WebService::Request::Search.new :base_url => @base_url
        request.institution = @institution
        request.add_query_term @title, "title", "contains"
        request.add_location 'local', 'scope:(UB_local_PC)'
        expected_query = 'q=title,contains,Travels%20with%20My%20Aunt&limit=5&offset=0&scope=UB_local_PC'

        assert_equal expected_query, request.to_query_string

        assert_response request: request,
                        vcr_cassette: 'rest/request search by title',
                        expected_class: Exlibris::Primo::WebService::Response::Search
      end
    end
  end
end
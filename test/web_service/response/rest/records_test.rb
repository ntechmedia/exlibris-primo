module WebService
  module Response
    require 'test_helper'
    class RestRecordsTest < Test::Unit::TestCase
      def setup
        Exlibris::Primo.configure do |config|
          config.api = :rest
          config.base_url = 'https://api-ap.hosted.exlibrisgroup.com/'
          config.vid = 'UB'
          config.tab = 'quicksearch'
          config.api_key = rest_api_key
        end
      end

      def teardown
        Exlibris::Primo.config.api = :soap
      end

      def test_basic_search
        VCR.use_cassette('rest/response/basic_search') {
          api_action = :search
          request = Exlibris::Primo::WebService::Request::Search.new
          request.add_query_term 'Travels with My Aunt', "title", "contains"
          request.add_location 'local', 'scope:(UB_local_PC)'
          client = Exlibris::Primo::WebService::Client::Search.new(:base_url => @base_url)
          response = Exlibris::Primo::WebService::Response::Search.new(client.send(api_action, request.query_params), api_action)

          assert_not_nil response.records
          assert((not response.records.empty?))
        }
      end
    end
  end
end

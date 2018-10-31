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
        VCR.use_cassette('rest/response/basic_search') do
          api_action = :search
          request = Exlibris::Primo::WebService::Request::Search.new
          request.add_query_term 'Travels with My Aunt', "title", "contains"
          request.add_location 'local', 'scope:(UB_local_PC)'
          client = Exlibris::Primo::WebService::Client::Search.new(:base_url => @base_url)
          response = Exlibris::Primo::WebService::Response::Search.new(client.send(api_action, request.query_params), api_action)

          assert_not_nil response.records
          assert((not response.records.empty?))
        end
      end

      def test_holdings
        VCR.use_cassette('rest/response/basic_search') do
          api_action = :search
          request = Exlibris::Primo::WebService::Request::Search.new
          request.add_query_term 'Travels with My Aunt', "title", "contains"
          request.add_location 'local', 'scope:(UB_local_PC)'
          client = Exlibris::Primo::WebService::Client::Search.new(:base_url => @base_url)
          response = Exlibris::Primo::WebService::Response::Search.new(client.send(api_action, request.query_params), api_action)

          assert_not_nil response.records

          holding = response.records.first.holdings.first

          assert_equal "UB_MILLENNIUM.b10019315", holding.record_id
          assert_equal "UB_MILLENNIUM.b10019315", holding.original_id
          assert_equal "Travels with my aunt", holding.title
          assert_equal "Greene, Graham 1904-1991.", holding.author
          assert_equal "book", holding.display_type
          assert_equal([], holding.coverage)
          assert_nil(holding.source_config)
          assert_nil(holding.source_class)
          assert_equal({}, holding.source_data)
          assert_equal(holding, holding.to_source)
          assert_equal([holding], holding.expand)
          assert((not holding.eql?(Exlibris::Primo::Holding.new)))
          assert(holding.eql?(holding))
          assert_equal(holding, holding.merge!(holding))
          assert(holding.expand.include?(holding))
        end
      end
    end
  end
end

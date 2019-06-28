module WebService
  module Response
    require 'test_helper'
    class RestJwtTest < Test::Unit::TestCase
      def setup
        Exlibris::Primo.configure do |config|
          config.api = :rest
          config.primo_version = :primo
          config.api_key = ENV["REST_ALT_API_KEY"]
          config.vid = 'LATROBE'
          config.tab = 'default_tab'
          config.base_url = 'https://api-ap.hosted.exlibrisgroup.com/'
          config.institution = '61LATROBE'
          config.jwt_authorisation = true
          config.jwt_user = 'Pebbles'
          config.jwt_user_group = 'U/Grad'
          config.jwt_user_name = 'Murgatroyd PebblePad'
          config.jwt_language = nil
          config.jwt_on_campus = true
        end
      end

      def teardown
        Exlibris::Primo.config.api = :soap
      end

      def test_results_using_jwt_authorisation
        VCR.use_cassette('rest/response/results_using_jwt_authorisation') do
          api_action = :search
          request = Exlibris::Primo::WebService::Request::Search.new
          request.add_multi_facet 'books', 'facet_rtype'
          request.add_query_term 'An introduction to research for midwives', 'title', 'contains'
          request.add_query_term '0702034908', 'isbn', 'contains'
          request.add_location 'local', 'scope:(All)'
          client = Exlibris::Primo::WebService::Client::Search.new(base_url: @base_url)
          response = Exlibris::Primo::WebService::Response::Search.new(client.send(api_action, request.query_params), api_action)
          records = response.records
          first_result = records.first
          expected_libraries = %w(BEN_LIB BUN_LIB)

          assert_not_nil records
          assert_equal 1, records.count
          assert_equal 2, first_result.holdings.count
          assert_equal 0, first_result.fulltexts.count

          first_result.holdings.each_with_index do |holding, index|
            assert_equal expected_libraries[index], holding.library_code
          end
        end
      end
    end
  end
end

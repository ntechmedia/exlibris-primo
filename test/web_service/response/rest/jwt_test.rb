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
        end
      end

      def teardown
        Exlibris::Primo.config.api = :soap
      end

      def test_results_using_jwt_authorisation
        Exlibris::Primo.config.jwt_on_campus = true
        VCR.use_cassette('rest/response/results_using_jwt_authorisation') do
          api_action = :search
          request = Exlibris::Primo::WebService::Request::Search.new
          request.add_multi_facet 'images', 'facet_rtype'
          request.add_query_term 'Wooden figure depicting a brown bear', 'title', 'contains'
          request.add_location 'local', 'scope:(All)'
          client = Exlibris::Primo::WebService::Client::Search.new(base_url: @base_url)
          response = Exlibris::Primo::WebService::Response::Search.new(client.send(api_action, request.query_params), api_action)
          records = response.records
          first_result = records.first

          assert_not_nil records
          assert_equal 1, records.count
          assert_equal 1, first_result.fulltexts.count
        end
      end

      def test_results_without_jwt_authorisation
        Exlibris::Primo.config.jwt_on_campus = false
        VCR.use_cassette('rest/response/results_without_jwt_authorisation') do
          api_action = :search
          request = Exlibris::Primo::WebService::Request::Search.new
          request.add_multi_facet 'images', 'facet_rtype'
          request.add_query_term 'Wooden figure depicting a brown bear', 'title', 'contains'
          request.add_location 'local', 'scope:(All)'
          client = Exlibris::Primo::WebService::Client::Search.new(base_url: @base_url)
          response = Exlibris::Primo::WebService::Response::Search.new(client.send(api_action, request.query_params), api_action)
          records = response.records

          assert_not_nil records
          assert_equal 0, records.count
        end
      end
    end
  end
end

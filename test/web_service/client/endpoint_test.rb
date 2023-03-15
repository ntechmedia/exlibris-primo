module WebService
  module Client
    require 'test_helper'
    class EndpointTest < Test::Unit::TestCase
      def setup
        @base_url = "http://bobcatdev.library.nyu.edu"
      end

      def test_soap_endpoint
        reset_primo_configuration
        Exlibris::Primo.configure do |config|
          config.api = :soap
        end

        search = Exlibris::Primo::WebService::Client::Search.new base_url: @base_url
        expected_uri = 'http://bobcatdev.library.nyu.edu/PrimoWebServices/services/searcher'

        assert_equal expected_uri, search.send(:endpoint)
        reset_primo_configuration
      end

      def test_rest_endpoint
        reset_primo_configuration
        Exlibris::Primo.configure do |config|
          config.api = :rest
        end

        search = Exlibris::Primo::WebService::Client::Search.new base_url: @base_url
        expected_uri = 'http://bobcatdev.library.nyu.edu/primo/v1/search'

        assert_equal expected_uri, search.send(:endpoint)
        reset_primo_configuration
      end
    end
  end
end

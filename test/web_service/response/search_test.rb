module WebService
  module Response
    require 'test_helper'
    class SearchTest < Test::Unit::TestCase
      def setup
        @base_url = "http://bobcatdev.library.nyu.edu"
        @isbn = "0143039008"
        @user_id = "N12162279"
        @institution = "NYU"
        @doc_id = "nyu_aleph000062856"
        @dedupmgr_id = "dedupmrg17343091"
        @basket_id ="210075761"
        @new_folder_name = "new folder"
      end

      def test_search
        VCR.use_cassette('response search') {
          api_action = :search_brief
          request = Exlibris::Primo::WebService::Request::Search.new(:user_id => @user_id,
            :institution => @institution)
          request.add_query_term(@isbn, "isbn", "exact")
          client = Exlibris::Primo::WebService::Client::Search.new(:base_url => @base_url)
          response = Exlibris::Primo::WebService::Response::Search.new(
            client.send(api_action, request.to_xml), api_action)
        }
      end

      def test_full_view
        VCR.use_cassette('response full view') {
          api_action = :get_record
          request = Exlibris::Primo::WebService::Request::FullView.new(:user_id => @user_id,
            :institution => @institution, :doc_id => @doc_id)
          client = Exlibris::Primo::WebService::Client::Search.new(:base_url => @base_url)
          response = Exlibris::Primo::WebService::Response::FullView.new(
            client.send(api_action, request.to_xml), api_action)
        }
      end
    end
  end
end
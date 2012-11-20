module WebService
  module Request
    require 'test_helper'
    class BaseTest < Test::Unit::TestCase
      def setup
        @base = "http://bobcatdev.library.nyu.edu"
        @institution = "University"
        @group = "Department"
      end
  
      def test_search_search_request
        assert_raise(NotImplementedError) {
          request = Exlibris::Primo::WebService::Request::Base.new @base
        }
      end

      def test_request_build_xml
          search_request = Exlibris::Primo::WebService::Request::Search.new @base
          inner_element = search_request.send :build_xml do |xml|
            xml.inner "value"
          end
          assert_kind_of String, inner_element
          assert_equal "<inner>value</inner>", inner_element
      end
    end
  end
end
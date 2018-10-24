module WebService
  module Request
    require 'test_helper'
    class LocationTest < Test::Unit::TestCase
      def setup
        @kind = "local"
        @value = "scope:(VOLCANO)"
      end

      def test_set_attributes
        location = Exlibris::Primo::WebService::Request::Location.new
        location.kind = @kind
        location.value = @value
        assert_equal "local", location.kind
        assert_equal "scope:(VOLCANO)", location.value
      end

      def test_write_attributes
        location = Exlibris::Primo::WebService::Request::Location.new(:kind => @kind, :value => @value)
        assert_equal "local", location.kind
        assert_equal "scope:(VOLCANO)", location.value
      end

      def test_to_s
        location = Exlibris::Primo::WebService::Request::Location.new(:kind => @kind, :value => @value)
        expected_output = 'scope=VOLCANO'

        assert_equal expected_output, location.to_s
      end
    end
  end
end
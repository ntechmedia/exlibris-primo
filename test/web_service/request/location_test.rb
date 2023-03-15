module WebService
  module Request
    require 'test_helper'
    class LocationTest < Test::Unit::TestCase
      def setup
        @kind_local = "local"
        @value_local = "scope:(VOLCANO)"
        @kind_adaptor = "adaptor"
        @value_adaptor = "primo_central_multiple_fe"
      end

      def test_set_attributes
        location = Exlibris::Primo::WebService::Request::Location.new
        location.kind = @kind_local
        location.value = @value_local
        assert_equal "local", location.kind
        assert_equal "scope:(VOLCANO)", location.value
      end

      def test_write_attributes
        location = Exlibris::Primo::WebService::Request::Location.new(:kind => @kind_local, :value => @value_local)
        assert_equal "local", location.kind
        assert_equal "scope:(VOLCANO)", location.value
      end

      def test_to_s_for_scopes
        location = Exlibris::Primo::WebService::Request::Location.new(:kind => @kind_local, :value => @value_local)
        expected_output = 'VOLCANO'

        assert_equal expected_output, location.to_s
      end

      def test_to_s_for_adaptors
        # TODO: Find out how to include adaptors (e.g. primo_central_multiple_fe) for the REST
        location = Exlibris::Primo::WebService::Request::Location.new(:kind => @kind_adaptor, :value => @value_adaptor)
        expected_output = nil

        assert_equal expected_output, location.to_s
      end
    end
  end
end
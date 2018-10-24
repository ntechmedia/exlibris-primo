module WebService
  module Request
    require 'test_helper'
    class RequestParamTest < Test::Unit::TestCase
      def setup
        @key = 'pc_availability_ind'
        @value = 'true'
      end

      def test_set_attributes_for_xml
        param = Exlibris::Primo::WebService::Request::RequestParam.new
        param.key = @key
        param.value = @value
        expected_xml = strip_xml(
          <<-XML
          <RequestParam key="#{@key}">#{@value}</RequestParam>
        XML
        )

        assert_equal expected_xml, param.to_xml
      end

      def test_write_attributes_for_xml
        param = Exlibris::Primo::WebService::Request::RequestParam.new(:key => 'pc_availability_ind', :value => 'true')
        expected_xml = strip_xml(
          <<-XML
          <RequestParam key="#{@key}">#{@value}</RequestParam>
        XML
        )

        assert_equal expected_xml, param.to_xml
      end

      def test_set_attributes_for_rest_with_known_key
        param = Exlibris::Primo::WebService::Request::RequestParam.new
        param.key = 'pcAvailability'
        param.value = 'false'
        expected_param = "pcAvailability=false"

        assert_equal expected_param, param.to_s
      end

      def test_set_attributes_for_rest_with_unknown_key
        param = Exlibris::Primo::WebService::Request::RequestParam.new
        param.key = 'SomeKey'
        param.value = 'true'

        assert_raise_message(
          "The provided request parameter key #{param.key} is unknown. " \
          "Please provide one of the following: #{param.accepted.keys.join(',')}"
        ) { param.to_s }
      end

      def test_set_attributes_for_rest_with_unacceptable_value
        param = Exlibris::Primo::WebService::Request::RequestParam.new
        param.key = 'pcAvailability'
        param.value = 'T'

        assert_raise_message(
          "The provided request parameter value #{param.value} is unacceptable. " \
          "Please provide one of the following: #{param.accepted[param.key].join(',')}"
        ) { param.to_s }
      end
    end
  end
end
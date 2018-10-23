module WebService
  module Request
    require 'test_helper'
    class RequestParamTest < Test::Unit::TestCase
      def setup
        @key = 'pc_availability_ind'
        @value = 'true'
      end

      def test_set_attributes
        param = Exlibris::Primo::WebService::Request::RequestParam.new()
        param.key = @key
        param.value = @value
        expected_xml = strip_xml(
          <<-XML
          <RequestParam key="#{@key}">#{@value}</RequestParam>
        XML
        )

        assert_equal expected_xml, param.to_xml
      end

      def test_write_attributes
        param = Exlibris::Primo::WebService::Request::RequestParam.new(:key => 'pc_availability_ind', :value => 'true')
        expected_xml = strip_xml(
          <<-XML
          <RequestParam key="#{@key}">#{@value}</RequestParam>
        XML
        )

        assert_equal expected_xml, param.to_xml
      end
    end
  end
end
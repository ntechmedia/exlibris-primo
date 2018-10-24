module WebService
  module Request
    require 'test_helper'
    class LocationsTest < Test::Unit::TestCase
      class SearchDummy < ::Exlibris::Primo::WebService::Request::Base
        include Exlibris::Primo::WebService::Request::Locations
        include Exlibris::Primo::XmlUtil
        include Exlibris::Primo::WriteAttributes

        def to_xml
          super { |xml|
            xml.PrimoSearchRequest("xmlns" => "http://www.exlibris.com/primo/xsd/search/request") {
              locations_xml.call xml
            }
          }
        end
      end

      def setup
        @kind_local = "local"
        @value_local = "scope:(VOLCANO)"
        @kind_adaptor = "adaptor"
        @value_adaptor = "primo_central_multiple_fe"
      end

      def test_locations
        search = SearchDummy.new

        assert_equal [], search.locations
      end

      def test_locations_xml_with_no_locations_for_xml
        search = SearchDummy.new
        expected_xml = strip_xml(
          <<-XML
          <request>
          <![CDATA[
          <searchDummyRequest xmlns="http://www.exlibris.com/primo/xsd/wsRequest" xmlns:uic="http://www.exlibris.com/primo/xsd/primoview/uicomponents">
            <PrimoSearchRequest xmlns="http://www.exlibris.com/primo/xsd/search/request"/>
            <institution/>
          </searchDummyRequest>
          ]]>
          </request>
        XML
        )

        assert_equal expected_xml, search.to_xml
      end

      def test_locations_xml_with_locations_for_xml
        search = SearchDummy.new
        search.add_location(@kind_local, @value_local)
        search.add_location(@kind_adaptor, @value_adaptor)

        expected_xml = strip_xml(
          <<-XML
          <request>
          <![CDATA[
          <searchDummyRequest xmlns="http://www.exlibris.com/primo/xsd/wsRequest" xmlns:uic="http://www.exlibris.com/primo/xsd/primoview/uicomponents">
            <PrimoSearchRequest xmlns="http://www.exlibris.com/primo/xsd/search/request">
              <Locations>
                <uic:Location type="#{@kind_local}" value="#{@value_local}"/>
                <uic:Location type="#{@kind_adaptor}" value="#{@value_adaptor}"/>
              </Locations>
            </PrimoSearchRequest>
            <institution/>
          </searchDummyRequest>
          ]]>
          </request>
        XML
        )

        assert_equal expected_xml, search.to_xml
      end

      def test_locations_string_with_no_locations_for_rest
        search = SearchDummy.new
        expected_output = ''

        assert_equal expected_output, search.locations_string
      end

      def test_locations_string_with_locations_for_rest
        search = SearchDummy.new
        search.add_location(@kind_local, @value_local)
        search.add_location(@kind_adaptor, @value_adaptor)

        expected_output = 'scope=VOLCANO'

        assert_equal expected_output, search.locations_string
      end

      def test_locations_string_with_adaptor_only_for_rest
        search = SearchDummy.new
        search.add_location(@kind_adaptor, @value_adaptor)

        expected_output = ''

        assert_equal expected_output, search.locations_string
      end
    end
  end
end
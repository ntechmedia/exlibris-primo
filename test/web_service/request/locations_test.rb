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
        @kind_1 = "local"
        @value_1 = "scope:(VOLCANO)"
        @kind_2 = "adaptor"
        @value_2 = "primo_central_multiple_fe"
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
        search.add_location(@kind_1, @value_1)
        search.add_location(@kind_2, @value_2)

        expected_xml = strip_xml(
          <<-XML
          <request>
          <![CDATA[
          <searchDummyRequest xmlns="http://www.exlibris.com/primo/xsd/wsRequest" xmlns:uic="http://www.exlibris.com/primo/xsd/primoview/uicomponents">
            <PrimoSearchRequest xmlns="http://www.exlibris.com/primo/xsd/search/request">
              <Locations>
                <uic:Location type="#{@kind_1}" value="#{@value_1}"/>
                <uic:Location type="#{@kind_2}" value="#{@value_2}"/>
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
    end
  end
end
module WebService
  module Request
    require 'test_helper'
    class LanguagesTest < Test::Unit::TestCase
      class SearchDummy
        include Exlibris::Primo::WebService::Request::Languages
        include Exlibris::Primo::XmlUtil

        def to_xml
          build_xml { |xml|
            languages_xml.call xml
          }
        end
      end

      def test_languages_xml_with_no_language_for_xml
        search = SearchDummy.new
        expected_xml = ""

        assert_equal expected_xml, search.to_xml
      end

      def test_languages_xml_with_a_language_for_xml
        search = SearchDummy.new
        search.add_language('eng')
        expected_xml = strip_xml(
          <<-XML
          <Languages>
            <Language>eng</Language>
          </Languages>
        XML
        )

        assert_equal expected_xml, search.to_xml
      end
    end
  end
end

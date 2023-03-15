module WebService
  module Request
    require 'test_helper'
    class LanguagesTest < Test::Unit::TestCase
      class SearchDummy
        include Exlibris::Primo::WebService::Request::Languages
        include Exlibris::Primo::XmlUtil

        def to_query_string
          languages_string
        end

        def to_xml
          build_xml { |xml|
            languages_xml.call xml
          }
        end
      end

      def test_languages_xml_with_no_language
        search = SearchDummy.new
        expected_xml = ""

        assert_equal expected_xml, search.to_xml
      end

      def test_languages_xml_with_multiple_languages
        search = SearchDummy.new
        search.add_language('eng')
        search.add_language('fre')
        expected_xml = strip_xml(
          <<-XML
          <Languages>
            <Language>eng</Language>
            <Language>fre</Language>
          </Languages>
        XML
        )

        assert_equal expected_xml, search.to_xml
      end

      def test_languages_string_with_no_language
        search = SearchDummy.new
        expected_output = ""

        assert_equal expected_output, search.to_query_string
      end

      def test_languages_string_with_multiple_languages
        search = SearchDummy.new
        search.add_language('eng')
        search.add_language('fre')
        expected_output = 'lang=eng'

        assert_equal expected_output, search.to_query_string
      end
    end
  end
end

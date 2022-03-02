module Pnx
  require 'test_helper'
  class OpenurlTest < Test::Unit::TestCase
    def test_openurl
      record = Exlibris::Primo::Record.new(:raw_xml => record_xml)
      assert_not_nil record.openurl
      assert((not record.openurl.blank?))
    end

    def test_openurl_encoding
      record = Exlibris::Primo::Record.new(:raw_xml => record_with_ampersand_xml)
      journal_title = record.send(:xml).root.xpath("addata/jtitle").text
      assert_not_nil record.openurl
      assert(record.openurl.include? CGI.escape(journal_title))
    end
  end
end
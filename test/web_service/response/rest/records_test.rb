module WebService
  module Response
    require 'test_helper'
    class RestRecordsTest < Test::Unit::TestCase
      def setup
        Exlibris::Primo.configure do |config|
          config.api = :rest
          config.base_url = 'https://api-ap.hosted.exlibrisgroup.com/'
          config.vid = 'UB'
          config.tab = 'quicksearch'
          config.api_key = rest_api_key
        end
      end

      def teardown
        Exlibris::Primo.config.api = :soap
      end

      def test_basic_search
        VCR.use_cassette('rest/response/basic_search') do
          api_action = :search
          request = Exlibris::Primo::WebService::Request::Search.new
          request.add_query_term 'Travels with My Aunt', "title", "contains"
          request.add_location 'local', 'scope:(UB_local_PC)'
          client = Exlibris::Primo::WebService::Client::Search.new(:base_url => @base_url)
          response = Exlibris::Primo::WebService::Response::Search.new(client.send(api_action, request.query_params), api_action)

          assert_not_nil response.records
          assert((not response.records.empty?))
        end
      end

      def test_holdings
        VCR.use_cassette('rest/response/holdings') do
          api_action = :search
          request = Exlibris::Primo::WebService::Request::Search.new
          request.add_query_term 'Travels with My Aunt', "title", "contains"
          request.add_location 'local', 'scope:(UB_local_PC)'
          client = Exlibris::Primo::WebService::Client::Search.new(:base_url => @base_url)
          response = Exlibris::Primo::WebService::Response::Search.new(client.send(api_action, request.query_params), api_action)

          assert_not_nil response.records

          holding = response.records.first.holdings.first
          assert_not_nil holding
          assert_equal "UB_MILLENNIUM.b10019315", holding.record_id
          assert_equal "UB_MILLENNIUM.b10019315", holding.original_id
          assert_equal "Travels with my aunt", holding.title
          assert_equal "Greene, Graham 1904-1991.", holding.author
          assert_equal "book", holding.display_type
          assert_equal([], holding.coverage)
          assert_nil(holding.source_config)
          assert_nil(holding.source_class)
          assert_equal(holding, holding.to_source)
          assert_equal([holding], holding.expand)
          assert((not holding.eql?(Exlibris::Primo::Holding.new)))
          assert(holding.eql?(holding))
          assert_equal(holding, holding.merge!(holding))
          assert(holding.expand.include?(holding))
        end
      end

      def test_result_with_multiple_holdings
        VCR.use_cassette('rest/response/result_with_multiple_holdings') do
          api_action = :search
          request = Exlibris::Primo::WebService::Request::Search.new
          request.add_multi_facet 'books', 'facet_rtype'
          request.add_query_term 'Introduction to education studies', 'title', 'contains'
          request.add_query_term '0857029126', 'isbn', 'contains'
          request.add_location 'local', 'scope:(UB_local_PC)'
          client = Exlibris::Primo::WebService::Client::Search.new(:base_url => @base_url)
          response = Exlibris::Primo::WebService::Response::Search.new(client.send(api_action, request.query_params), api_action)
          records = response.records
          first_result = records.first
          expected_libraries = %w(ball gall mall)

          assert_not_nil records
          assert_equal 1, records.count
          assert_equal 3, first_result.holdings.count
          first_result.holdings.each_with_index do |holding, index|
            assert_equal expected_libraries[index], holding.library_code
          end
        end
      end

      def test_fulltexts
        VCR.use_cassette('rest/response/fulltexts') do
          api_action = :search
          request = Exlibris::Primo::WebService::Request::Search.new
          request.add_query_term 'Misbehavior online in higher education', "title", "contains"
          request.add_location 'local', 'scope:(UB_local_PC)'
          client = Exlibris::Primo::WebService::Client::Search.new(:base_url => @base_url)
          response = Exlibris::Primo::WebService::Response::Search.new(client.send(api_action, request.query_params), api_action)

          assert_not_nil response.records

          link = response.records.first.fulltexts.first
          assert_not_nil link
          assert_nil link.institution
          assert_equal "UB_MILLENNIUM.b26773934", link.record_id
          assert_equal "UB_MILLENNIUM.b26773934", link.original_id
          assert_equal "http://ebookcentral.proquest.com/lib/ballarat/detail.action?docID=862260", link.url
          assert_equal "Click here to view book", link.display
        end
      end

      def test_result_with_multiple_fulltexts
        VCR.use_cassette('rest/response/result_with_multiple_fulltexts') do
          api_action = :search
          request = Exlibris::Primo::WebService::Request::Search.new
          request.add_multi_facet 'books', 'facet_rtype'
          request.add_query_term 'Applied and Environmental Geophysics', "title", "contains"
          request.add_location 'local', 'scope:(UB_local_PC)'
          client = Exlibris::Primo::WebService::Client::Search.new(:base_url => @base_url)
          response = Exlibris::Primo::WebService::Response::Search.new(client.send(api_action, request.query_params), api_action)
          records = response.records
          first_result = records.first
          expected_urls = %w(https://ebookcentral.proquest.com/lib/ballarat/detail.action?docID=699895 https://ebookcentral.proquest.com/lib/ballarat/detail.action?docID=877401)

          assert_not_nil response.records
          assert_not_nil records
          assert_equal 1, records.count
          assert_equal 0, first_result.holdings.count
          assert_equal 2, first_result.fulltexts.count

          first_result.fulltexts.each_with_index do |fulltext, index|
            assert_equal expected_urls[index], fulltext.url
          end
        end
      end

      def test_result_with_mixed_locations
        VCR.use_cassette('rest/response/result_with_mixed_locations') do
          api_action = :search
          request = Exlibris::Primo::WebService::Request::Search.new
          request.add_multi_facet 'books', 'facet_rtype'
          request.add_query_term 'An introduction to research for midwives', 'title', 'contains'
          request.add_query_term '0702034908', 'isbn', 'contains'
          request.add_location 'local', 'scope:(UB_local_PC)'
          client = Exlibris::Primo::WebService::Client::Search.new(:base_url => @base_url)
          response = Exlibris::Primo::WebService::Response::Search.new(client.send(api_action, request.query_params), api_action)
          records = response.records
          first_result = records.first
          expected_libraries = %w(gall mall)

          assert_not_nil records
          assert_equal 2, records.count
          assert_equal 2, first_result.holdings.count
          assert_equal 1, first_result.fulltexts.count

          first_result.holdings.each_with_index do |holding, index|
            assert_equal expected_libraries[index], holding.library_code
          end

          fulltext = first_result.fulltexts.first
          assert_equal 'https://ebookcentral.proquest.com/lib/ballarat/detail.action?docID=1722038', fulltext.url
        end
      end
    end
  end
end

module Exlibris
  module Primo
    module WebService
      module Response
        class Base
          include Abstract
          include Error
          include Namespaces
          include Util
          include XmlUtil
          include Api

          self.abstract = true

          attr_reader :client_response, :api_action, :code, :body
          protected :client_response, :api_action

          def initialize(response, api_action)
            super
            @client_response = response
            @api_action = api_action

            soap_response || rest_response
          end

          private

          def soap_response
            return unless current_api == :soap

            @code = client_response.http.code
            @body = client_response.http.body
            @raw_xml = client_response.body[response_key][return_key]
          end

          def rest_response
            return unless current_api == :rest

            @code = client_response.status
            @body = client_response.body
            @raw_xml = convert_to_xml
          end

          def convert_to_xml
            Nokogiri::XML::Builder.new do |xml|
              xml.PrimoNMBib(xmlns: "http://www.exlibrisgroup.com/xsd/primo/primo_nm_bib") do
                xml.records do
                  records_to_process.each do |record|
                    process_record('record', record, xml)
                  end
                end
              end
            end.to_xml
          end

          def process_record(label, data, xml)
            if data.is_a?(Array)
              data.each { |array_value| xml.send(label, array_value) }
            elsif data.is_a?(Hash)
              xml.send("#{label}_") do
                data.each { |k, v| process_record(k, v, xml) }
              end
            end
          end

          def records_to_process
            @records_to_process ||= JSON.parse(body)['docs'].map { |r| r['pnx'] }
          end
        end
      end
    end
  end
end

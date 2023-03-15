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
                  docs_to_process.each do |doc|
                    merge_links(doc)
                    merge_delivery(doc)
                    doc['pnx']['context'] = [doc['context']] unless doc['context'].nil?
                    process('record', doc['pnx'], xml)
                  end
                end
              end
            end.to_xml
          end

          def process(label, data, xml)
            if data.is_a?(Array)
              data.each do |array_value|
                array_value.delete_if { |k, _v| k.to_s.include? '@' } if array_value.is_a?(Hash)
                xml.send("#{label}_", array_value)
              end
            elsif data.is_a?(Hash)
              xml.send("#{label}_") do
                data.each do |k, v|
                  next if k.to_s.include? '@'

                  process(k, v, xml)
                end
              end
            else
              xml.send("#{label}_", data)
            end
          end

          def merge_delivery(doc)
            if doc['pnx']['delivery'].nil?
              doc['pnx']['delivery'] = doc['delivery']
            else
              doc['pnx']['delivery'].merge!(doc['delivery'])
            end
          end

          def merge_links(doc)
            doc['pnx']['links'] = flatten_links(doc['pnx']['links'], doc['delivery']['link'].try(:dup) || [])
            doc['delivery']['link'] = nil
          end

          def flatten_links(existing_links, new_links)
            hash = existing_links.nil? ? Hash.new : existing_links
            new_links.each do |link|
              type = link['linkType'].split('/').last
              hash[type] ||= []

              next if hash[type].any? { |l| l[link['linkURL']] }

              hash[type] << "$$U#{link['linkURL']}$$D#{link['displayLabel']}"
            end
            hash
          end

          def docs_to_process
            @docs_to_process ||= JSON.parse(body)['docs']
          end
        end
      end
    end
  end
end

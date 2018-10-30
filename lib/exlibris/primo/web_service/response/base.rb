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

          attr_reader :savon_response, :api_action, :code, :body
          protected :savon_response, :api_action

          def initialize response, api_action
            super
            soap_response(response, api_action) || rest_response(response, api_action)
          end

          private

          def soap_response(response, api_action)
            return unless current_api == :soap

            @savon_response = response
            @code = savon_response.http.code
            @body = savon_response.http.body
            @api_action = api_action

            @raw_xml = savon_response.body[response_key][return_key]
          end

          def rest_response(response, api_action)
            return unless current_api == :rest

            # TODO: Processing of REST API response
          end
        end
      end
    end
  end
end

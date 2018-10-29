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

          def initialize savon_response, api_action
            super
            @savon_response = savon_response
            @code = savon_response.http.code
            @body = savon_response.http.body
            @api_action = api_action

            @raw_xml = savon_response.body[response_key][return_key]
          end
        end
      end
    end
  end
end

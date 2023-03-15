module Exlibris
  module Primo
    module WebService
      module Client
        class Base
          include Abstract
          include Config::Attributes
          include Endpoint
          include ApiClient
          include ApiActions
          include Wsdl
          include Api
          include Authorisation

          self.abstract = true

          attr_writer :base_url, :institution


          # Returns a new Exlibris::Primo::WebService::Base from the given arguments,
          # base_url and service.
          #   base_url: base URL for Primo Web Service
          def initialize *args
            super
            @base_url = args.last.delete(:base_url)
          end
        end
      end
    end
  end
end
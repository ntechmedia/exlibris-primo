module Exlibris
  module Primo
    module WebService
      module Client
        module ApiClient
          require 'savon'

          def client
            rest_client || soap_client
          end
          protected :client

          def rest_client
            return unless api == :rest

            # TODO: Choose a REST Client - Faraday is looking to be best atm
            @client
          end
          private :rest_client

          def soap_client
            return unless api == :soap

            #
            # We're not using WSDL at the moment, since
            # we don't want to make an extra HTTP call.
            #
            # @client ||= Savon.client(wsdl: wsdl)
            @client ||= Savon.client(client_options)
          end
          private :soap_client

          def client_options
            {
              proxy: proxy_url,
              endpoint: endpoint,
              namespace: endpoint,
              log: false,
              log_level: :warn
            }.delete_if { |k, v| v.blank? }
          end
          private :client_options
        end
      end
    end
  end
end
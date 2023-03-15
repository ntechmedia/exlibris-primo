module Exlibris
  module Primo
    module WebService
      module Client
        module ApiClient
          require 'savon'
          require 'faraday'

          def client
            rest_client || soap_client
          end
          protected :client

          def rest_client
            return unless current_api == :rest

            @client = ::Faraday.new(url: endpoint) do |faraday|
              faraday.request  :url_encoded
              faraday.response :logger do | logger |
                logger.filter(/(apikey=)(\w+)/,'\1[REMOVED]')
              end
              faraday.adapter  Faraday.default_adapter
            end
          end
          private :rest_client

          def soap_client
            return unless current_api == :soap

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
module Exlibris
  module Primo
    module WebService
      module Request
        module Call
          #
          # Returns an response Exlibris::Primo::WebService::Response that corresponds
          # to the request.
          #
          def call
            soap_call || rest_call
          end

          def soap_call
            return unless (Exlibris::Primo.config.api || api) == :soap

            # Get the Response class that matches the Request class.
            response_klass = "Exlibris::Primo::WebService::Response::#{self.class.name.demodulize}".constantize
            response_klass.new(client.send(soap_action, to_xml), soap_action)
          end

          private :soap_call

          def rest_call
            return unless (Exlibris::Primo.config.api || api) == :rest

          end
        end
      end
    end
  end
end
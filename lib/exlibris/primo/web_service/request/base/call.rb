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
            return unless current_api == :soap

            # Get the Response class that matches the Request class.
            response_klass = "Exlibris::Primo::WebService::Response::#{self.class.name.demodulize}".constantize
            response_klass.new(client.send(api_action, to_xml), api_action)
          end

          private :soap_call

          def rest_call
            return unless current_api == :rest

            check_class_support
            check_required_params

            response_klass = "Exlibris::Primo::WebService::Response::#{self.class.name.demodulize}".constantize
            response_klass.new(client.send(api_action, query_params), api_action)
          end

          private :rest_call

          def query_params
            Hash[URI::decode_www_form(to_query_string)].merge(required_params)
          end

          private :query_params

          # Checks that all of the required parameters have been supplied either in the config or set on the request
          def check_required_params
            errors = required_params.map { |param, value| raise param_errors[param] if value.nil? }.compact
            raise errors.joins('; ') unless errors.empty?
          end

          private :check_required_params

          def required_params
            {
              vid: Exlibris::Primo.config.vid || vid,
              tab: Exlibris::Primo.config.tab || tab,
              apikey: Exlibris::Primo.config.api_key || api_key
            }
          end

          private :required_params

          def param_errors
            {
              vid: 'The vid (view ID) config attribute must be set. (e.g. ExlibrisPrimo.config.vid = "Auto1")',
              tab: 'The tab search tab (tab) config attribute must be set. (e.g. ExlibrisPrimo.config.tab = "quicksearch")',
              apikey: 'The apikey config attribute must be set. (e.g. ExlibrisPrimo.config.apikey = "l7xxcb1e0f7b1d09876119edf593ec552f95d")',
            }
          end

          private :param_errors

          # Check that the class that this module is included in is supported by the REST API
          def check_class_support
            klass = self.class.name.demodulize

            if classes_supported_by_rest_api.exclude? klass
              raise "The #{klass} is unsupported for the REST API. " \
                    "Only the following are supported: #{classes_supported_by_rest_api.join(',')}"
            end
          end

          private :check_class_support

          # Request / Response Classes supported by the REST API
          def classes_supported_by_rest_api
            [
              'Search'
            ]
          end

          private :classes_supported_by_rest_api
        end
      end
    end
  end
end
module Exlibris
  module Primo
    module WebService
      module Client
        module ApiActions
          def self.included(klass)
            klass.class_eval do
              extend ClassAttributes
            end
          end

          module ClassAttributes
            def actions(api)
              @actions ||= {}
              @actions[api] ||= []
            end

            def add_api_actions api, *actions
              @actions[api] = actions(api) + actions
              @actions[api].uniq!
            end

            protected :add_api_actions
          end

          def actions(api)
            self.class.actions(api)
          end

          protected :actions

          #
          # Define methods for SOAP actions. SOAP actions take a single String argument, request_xml,
          # which is set as the body of the SOAP request
          #
          def method_missing(method, *args, &block)
            if actions(current_api).include? method
              self.class.send(:define_method, method) do |request_xml|
                client.call(method, message: request_xml)
              end
              send method, *args, &block
            else
              super
            end
          end

          #
          # Tell users that we respond to SOAP actions.
          #
          def respond_to?(method, include_private = false)
            (actions(current_api).include? method) ? true : super
          end

          def current_api
            Exlibris::Primo.config.api || api
          end
        end
      end
    end
  end
end
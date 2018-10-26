module Exlibris
  module Primo
    module WebService
      module Request
        module ApiAction
          def self.included(klass)
            klass.class_eval do
              extend ClassAttributes
            end
          end

          module ClassAttributes
            def api_action
              @api_action ||= name.demodulize.underscore.to_sym
            end

            attr_writer :api_action
            protected :api_action=
          end

          def api_action
            @api_action ||= self.class.api_action
          end
          protected :api_action

          def current_api
            Exlibris::Primo.config.api || api
          end
        end
      end
    end
  end
end
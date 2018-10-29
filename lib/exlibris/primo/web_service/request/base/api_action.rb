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
            def base_api_action
              @api_action ||= { soap: name.demodulize.underscore.to_sym }
            end

            def set_base_api_action(action_hash)
              @api_action = action_hash
            end
          end

          def api_action
            @api_action ||= self.class.base_api_action[current_api]
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
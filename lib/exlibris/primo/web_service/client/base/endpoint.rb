module Exlibris
  module Primo
    module WebService
      module Client
        module Endpoint
          def self.included(klass)
            klass.class_eval do
              extend ClassAttributes
            end
          end

          module ClassAttributes
            def endpoint
              @endpoint ||= name.demodulize.downcase
            end

            attr_writer :endpoint
            protected :endpoint=
          end

          def endpoint
            @endpoint ||= URI.join(
              URI(base_url),
              endpoint_path[Exlibris::Primo.config.api || api],
              (rest_method_mapping[self.class.endpoint] || self.class.endpoint).to_s
            ).to_s
          end

          protected :endpoint

          def endpoint_path
            {
              soap: '/PrimoWebServices/services/',
              rest: '/primo/v1/',
            }
          end

          private :endpoint_path

          def rest_method_mapping
            return {} unless Exlibris::Primo.config.api == :rest

            {
              searcher: :search
            }
          end

          private :rest_method_mapping

        end
      end
    end
  end
end
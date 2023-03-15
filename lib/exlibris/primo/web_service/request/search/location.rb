module Exlibris
  module Primo
    module WebService
      module Request
        #
        #
        #
        class Location
          include WriteAttributes
          attr_accessor :kind, :value

          # Returns a string for inclusion as a query parameter for the REST API
          def to_s
            # TODO: Find out how to include adaptors & remotes (e.g. primo_central_multiple_fe) for the REST
            return unless kind == 'local'

            value.gsub(/scope:|\(|\)/, '')
          end
        end
      end
    end
  end
end
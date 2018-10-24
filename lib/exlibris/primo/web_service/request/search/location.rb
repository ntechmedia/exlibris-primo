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
            return '' unless kind == 'local'

            "scope=#{value.gsub(/scope:|\(|\)/, '')}"
          end
        end
      end
    end
  end
end
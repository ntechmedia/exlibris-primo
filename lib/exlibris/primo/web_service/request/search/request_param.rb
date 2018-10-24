module Exlibris
  module Primo
    module WebService
      module Request
        #
        #
        #
        class RequestParam
          include WriteAttributes
          include XmlUtil
          attr_accessor :key, :value

          def to_xml
            build_xml do |xml|
              xml.RequestParam(:key => key) {
                xml << value
              }
            end
          end

          # Returns a string for inclusion in the as a query parameter for the REST API
          def to_s
            if accepted.keys.exclude? key
              raise "The provided request parameter key #{key} is unknown. " \
                    "Please provide one of the following: #{accepted.keys.join(',')}"
            end
            if accepted[key].exclude? value
              raise "The provided request parameter value #{value} is unacceptable. " \
                    "Please provide one of the following: #{accepted[key].join(',')}"
            end

            "#{key}=#{value}"
          end

          def accepted
            {
              'pcAvailability' => %w(true false)
            }
          end
        end
      end
    end
  end
end
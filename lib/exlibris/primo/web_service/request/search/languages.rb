module Exlibris
  module Primo
    module WebService
      module Request
        module Languages
          #
          # Returns a lambda that takes a Nokogiri::XML::Builder as an argument
          # and appends languages XML to it.
          #
          def languages_xml
            lambda { |xml|
              xml.Languages {
                languages.each do |language|
                  xml.Language language
                end
              } unless languages.empty?
            }
          end
          protected :languages_xml

          # Returns a string for inclusion in the as a query parameter for the REST API
          def languages_string
            return '' if languages.empty?

            # TODO: Need to find out how to do multiple languages for the REST API.  For now we'll just use the first language
            "lang=#{languages.first}"
          end

          def languages
            @languages ||= []
          end

          def add_language(language)
            languages << language
          end
        end
      end
    end
  end
end
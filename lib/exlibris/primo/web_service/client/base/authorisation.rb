module Exlibris
  module Primo
    module WebService
      module Client
        module Authorisation
          def jwt_bearer
            return '' unless current_api == :rest &&
              Exlibris::Primo.config.jwt_authorisation &&
              [:primo, :primo_ve].include?(Exlibris::Primo.config.primo_version)

            response = jwt_client.post do |request|
              request.headers['accept'] = 'application/json'
              request.headers['Content-Type'] = 'application/json'
              request.params['apikey'] = Exlibris::Primo.config.api_key
              request.body = jwt_body
            end
            "Bearer #{response.body}"
          end

          def jwt_client
            @jwt_client ||= ::Faraday.new(url: jwt_endpoint) do |faraday|
              faraday.request :url_encoded
              faraday.response :logger do |logger|
                logger.filter(/(apikey=)(\w+)/, '\1[REMOVED]')
              end
              faraday.adapter Faraday.default_adapter
            end
          end

          private :jwt_client

          def jwt_body
            primo_jwt_body || primo_ve_jwt_body
          end

          private :jwt_body

          def primo_jwt_body
            return unless Exlibris::Primo.config.primo_version == :primo

            {
              viewId: Exlibris::Primo.config.vid,
              institution: Exlibris::Primo.config.institution,
              language: Exlibris::Primo.config.jwt_language,
              user: Exlibris::Primo.config.jwt_user,
              userName: Exlibris::Primo.config.jwt_user_name,
              userGroup: Exlibris::Primo.config.jwt_user_group,
              onCampus: Exlibris::Primo.config.jwt_authorisation.to_s,
            }.delete_if { |_k, v| v.nil? }.to_json
          end

          private :primo_jwt_body

          def primo_ve_jwt_body
            return unless Exlibris::Primo.config.primo_version == :primo_ve

            {
              viewId: Exlibris::Primo.config.vid,
              institution: Exlibris::Primo.config.institution,
              language: Exlibris::Primo.config.jwt_language,
              userName: Exlibris::Primo.config.jwt_user,
              displayName: Exlibris::Primo.config.jwt_user_name,
              userGroup: Exlibris::Primo.config.jwt_user_group,
              onCampus: Exlibris::Primo.config.jwt_authorisation,
            }.delete_if { |_k, v| v.nil? }.to_json
          end

          private :primo_ve_jwt_body
        end
      end
    end
  end
end

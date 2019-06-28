require 'erb'
module Exlibris
  module Primo
    #
    # Specify global configuration settings for
    #
    module Config
      class << self
        include WriteAttributes
        attr_accessor :api,
                      :primo_version,
                      :vid,
                      :tab,
                      :api_key,
                      :base_url,
                      :proxy_url,
                      :institution,
                      :institutions,
                      :libraries,
                      :availability_statuses,
                      :sources,
                      :facet_labels,
                      :facet_top_level,
                      :facet_collections,
                      :facet_resource_types,
                      :load_time,
                      :jwt_authorisation,
                      :jwt_user,
                      :jwt_user_name,
                      :jwt_user_group,
                      :jwt_language,
                      :jwt_on_campus

        def load_yaml file
          write_attributes YAML.load(ERB.new(File.read(file)).result)
          self.load_time = Time.now
        end
      end

      #
      # These attributes default to the global config settings if not
      # specified locally.
      #
      module Attributes
        def config
          @config ||= Config
        end

        def api
          @api ||= Exlibris::Primo.config.api || :soap
        end

        def api_key
          @api_key
        end

        def vid
          @vid
        end

        def tab
          @tab
        end

        def base_url
          @base_url ||= String.new config.base_url.to_s
        end

        def proxy_url
          @proxy_url ||= config.proxy_url
        end

        def primo_version
          @primo_version ||= config.primo_version || :primo
        end

        def institution
          @institution ||= String.new config.institution.to_s
        end

        def jwt_authorisation
          @jwt_authorisation ||= config.jwt_authorisation || false
        end

        def institutions
          @institutions ||= (config.institutions) ? config.institutions.dup : {}
        end

        def jwt_user
          @jwt_user ||= config.jwt_user.to_s
        end

        def jwt_user_name
          @jwt_user_name ||= config.jwt_user_name.to_s
        end

        def jwt_user_group
          @jwt_user_group ||= config.jwt_user_group.to_s
        end

        def jwt_language
          @jwt_language ||= config.jwt_language.to_s
        end

        def jwt_on_campus
          @jwt_on_campus ||= config.jwt_on_campus.to_s
        end

        def libraries
          @libraries ||= (config.libraries) ? config.libraries.dup : {}
        end

        def availability_statuses
          @availability_statuses ||= (config.availability_statuses) ? config.availability_statuses.dup : {}
        end

        def sources
          @sources ||= (config.sources) ? config.sources.dup : {}
        end

        def facet_labels
          @facet_labels ||= (config.facet_labels) ? config.facet_labels.dup : {}
        end

        def facet_top_level
          @facet_top_level ||= (config.facet_top_level) ? config.facet_top_level.dup : {}
        end

        def facet_collections
          @facet_collections ||= (config.facet_collections) ? config.facet_collections.dup : {}
        end

        def facet_resource_types
          @facet_resource_types ||= (config.facet_resource_types) ? config.facet_resource_types.dup : {}
        end
      end
    end
  end
end

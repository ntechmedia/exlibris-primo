module Exlibris
  module Primo
    module Api
      def current_api
        methods.include?(:api) ? (api || Exlibris::Primo.config.api) : Exlibris::Primo.config.api
      end
    end
  end
end
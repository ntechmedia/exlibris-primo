module Exlibris
  module Primo
    module Api
      def current_api
        api || Exlibris::Primo.config.api
      end
    end
  end
end
module Exlibris
  module Primo
    module WebService
      module Client
        #
        #
        #
        class Search < Base
          self.endpoint = :searcher
          self.add_api_actions :soap, :search_brief, :get_record
        end
      end
    end
  end
end
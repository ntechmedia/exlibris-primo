module Exlibris
  module Primo
    module WebService
      module Client
        #
        #
        #
        class Tags < Base
          self.add_api_actions :soap, :get_tags, :get_all_my_tags, :get_tags_for_record, :add_tag, :remove_tag, :remove_user_tags
        end
      end
    end
  end
end
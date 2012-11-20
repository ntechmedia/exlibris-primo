module Exlibris
  module Primo
    module WebService
      module Request
        class Base
          include Abstract
          include Action
          include BaseElements
          include Client
          include Call
          include Namespaces
          include SetAttributes
          include Util
          include XmlUtil
          self.abstract = true
          self.add_base_elements :institution, :ip, :group, 
            :on_campus, :is_logged_in, :pds_handle

          DEFAULT_WRAPPER = :request
          attr_reader :root, :namespaces, :wrapper, :base_url
          protected :root, :namespaces, :wrapper, :base_url

          def initialize base_url, attributes={}
            super
            @base_url = base_url
            @root = "#{self.class.name.demodulize}Request".camelize(:lower).to_sym
            @namespaces = request_namespaces
            @wrapper = DEFAULT_WRAPPER.id2name.camelize(:lower).to_sym
            set_attributes attributes
          end

          def to_xml &block
            build_xml { |xml|
              xml.send(wrapper) {
                xml.cdata build_xml { |xml|
                  xml.send(root, namespaces) {
                    yield xml if block
                    xml << base_elements
                  }
                }
              }
            }
          end
        end

        class User < Base
          # Add user_id to the base elements
          self.add_base_elements :user_id
          self.abstract = true
        end

        class Record < Base
          # Add doc_id to the base elements
          self.add_base_elements :doc_id
          self.abstract = true
        end

        class UserRecord < Record
          # Add user_id to the base elements
          self.add_base_elements :user_id
          self.abstract = true
        end
      end
    end
  end
end
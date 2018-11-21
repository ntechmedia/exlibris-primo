module Exlibris
  module Primo
    module Pnx
      #
      # Handle holdings in availlibrary tags.
      #
      module Holdings
        #
        # Gather Holdings for this record.
        #
        def holdings
          holdings_for_rest || holdings_for_soap || []
        end

        def holdings_for_rest
          return unless current_api == :rest

          @holdings ||= xml.root.xpath("delivery/holding").collect do |holding|
            Exlibris::Primo::Holding.new(
              record_id: recordid,
              original_id: recordid,
              title: (self.display_title if self.respond_to? :display_title),
              author: (self.display_creator if self.respond_to? :display_creator),
              display_type: display_type,
              original_source_id: originalsourceids[recordid],
              source_id: sourceids[recordid],
              source_record_id: sourcerecordids[recordid],
              ils_api_id: holding['ilsApiId'],
              institution_code: holding['organization'],
              library_code: holding['libraryCode'],
              collection: holding['subLocation'],
              call_number: holding['callNumber'],
              availability_status_code: holding['availabilityStatus'],
              url: holding['holdingURL']
            )
          end
        end

        def holdings_for_soap
          return unless current_api == :soap

          @holdings ||= xml.root.xpath("display/availlibrary").collect do |availlibrary|
            subfields = parse_subfields availlibrary.inner_text
            # Get original id for dealing w/ dedup merger records
            original_id = (subfields["O"]) ? subfields["O"] : recordid
            # Get some info that may or may not be in the PNX metadata
            title = self.display_title if self.respond_to? :display_title
            author = self.display_creator if self.respond_to? :display_creator
            display_type = self.display_type if self.respond_to? :display_type
            # Add a new holding to the record's holdings.
            Exlibris::Primo::Holding.new(
              :availlibrary => availlibrary.inner_text,
              :record_id => recordid,
              :original_id => original_id,
              :title => title,
              :author => author,
              :display_type => display_type,
              :original_source_id => originalsourceids[original_id],
              :source_id => sourceids[original_id],
              :source_record_id => sourcerecordids[original_id],
              :ils_api_id => ilsapiids[original_id],
              :institution_code => subfields["I"],
              :library_code => subfields["L"],
              :collection => subfields["1"],
              :call_number => subfields["2"],
              :subfields => subfields,
              :availability_status_code => subfields["S"]
            )
          end
        end
      end
    end
  end
end
module Exlibris
  module Primo
    module Pnx
      module Tocs
        #
        #
        #
        def tocs
          @tocs ||= []
          if @tocs.empty?
            xml.xpath("links/linktotoc").each do |linktotoc|
              linktotoc, url, display = process_linktotoc linktotoc
              next if url.nil?
              @tocs << Exlibris::Primo::Toc.new(
                :recordid => recordid,
                :linktotoc => linktotoc,
                :url => url,
                :display => display,
                :notes => "")
            end
          end
          @tocs
        end

        def process_linktotoc(input)
          linktotoc, url, display, = nil, nil, nil
          return linktotoc, url, display if input.nil? or input.inner_text.nil?
          linktotoc = input.inner_text
          linktotoc.split(/\$(?=\$)/).each do |s|
            url = s.sub!(/^\$U/, "")  unless s.match(/^\$U/).nil?
            display = s.sub!(/^\$D/, "")  unless s.match(/^\$D/).nil?
          end
          return linktotoc, url, display
        end
        private :process_linktotoc
      end
    end
  end
end
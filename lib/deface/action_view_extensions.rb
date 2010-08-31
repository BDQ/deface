ActionView::Template.class_eval do
  alias_method :rails_initialize, :initialize

  def initialize(source, identifier, handler, details)
    overrides = Deface::Override.find(details)

    unless overrides.empty?
      doc = Deface::Parser.convert_fragment(source)

      overrides.each do |override|
        doc.css(override.selector).each do |match|

          match.replace case override.action
            when :remove
              ""
            when :replace
              Deface::Parser.convert_fragment(override.source.clone)
            when :insert_before
              Deface::Parser.convert_fragment(override.source.clone << match.to_s)
            when :insert_after
              Deface::Parser.convert_fragment(match.to_s << override.source.clone)
          end

        end
      end

      source = doc.to_s

      Deface::Parser.undo_erb_markup!(source)
    end

    rails_initialize(source, identifier, handler, details)
  end
end

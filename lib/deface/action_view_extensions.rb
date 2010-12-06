ActionView::Template.class_eval do
  alias_method :rails_initialize, :initialize

  def initialize(source, identifier, handler, details)
    source = Deface::Override.apply(source, details)

    rails_initialize(source, identifier, handler, details)
  end
end

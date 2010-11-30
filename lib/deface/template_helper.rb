module Deface
  module TemplateHelper

    # used to find source for a partial or template using virutal_path
    def load_template_source(virtual_path, partial)
      parts = virtual_path.split("/")

      if parts.size == 2
        prefix = ""
        name = virtual_path
      else
        prefix = parts.shift
        name = parts.join("/")
      end

      @lookup_context ||= ActionView::LookupContext.new(ActionController::Base.view_paths, {:formats => [:html]})

      @lookup_context.find(name, prefix, partial).source
    end
  end
end

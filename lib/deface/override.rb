module Deface
  class Override
    cattr_accessor :virtual, :file, :actions
    attr_accessor :args

    @@virtual ||= {}
    @@file ||= {}
    @@actions = [:remove, :replace, :insert_after, :insert_before]

    # Initializes new override, you must supply only one Target, Action & Source
    # parameter for each override (and any number of Optional parameters).
    #
    # ==== Target
    #
    # * <tt>:file_path</tt> - The relative file path of the template / partial where
    #   the override should take effect eg: "shared/_person", "admin/posts/new"
    #   this will apply to all controller actions that use the specified template
    # * <tt>:virtual_path</tt> - The controller and action name where
    #   the override should take effect eg: "controller/action" or "posts/index"
    #   will apply to all layouts, templates and partials that are used in the
    #   rendering of the specified action.
    #
    # ==== Action
    #
    # * <tt>:remove</tt> - Removes all elements that match the supplied selector
    # * <tt>:replace</tt> - Replaces all elements that match the supplied selector
    # * <tt>:insert_after</tt> - Inserts after all elements that match the supplied selector
    # * <tt>:insert_before</tt> - Inserts before all elements that match the supplied selector
    #
    # ==== Source
    #
    # * <tt>:text</tt> - String containing markup
    # * <tt>:partial</tt> - Relative path to partial
    # * <tt>:template</tt> - Relative path to template
    #
    # ==== Optional
    #
    # * <tt>:name</tt> - Unique name for override so it can be identified and modified later.
    #   This needs to be unique within the same :virtual_path or :file_path

    def initialize(args)
      @args = args

      if args.key?(:virtual_path)
        key = args[:virtual_path].to_sym

        @@virtual[key] ||= {}
        @@virtual[key][args[:name].to_s.parameterize] = self
      elsif args.key?(:file_path)
        key = args[:file_path]

        @@file[key] ||= {}
        @@file[key][args[:name].to_s.parameterize] = self
      end
    end

    def selector
      @args[self.action]
    end

    def action
      (@@actions & @args.keys).first
    end

    def source
      erb = if @args.key? :partial
        load_template_source(@args[:partial], true)
      elsif @args.key? :template
        load_template_source(@args[:template], false)
      elsif @args.key? :text
        @args[:text]
      end

      Deface::Parser::ERB.compile(erb)
    end

    def self.find(details)
      return [] unless self.virtual || self.file

      result = []

      virtual_path = details[:virtual_path]
      result << @@virtual[virtual_path.to_sym].try(:values) if virtual_path

      file_path = details[:file_path]
      result << @@file.map { |key,overrides| overrides.try(:values) if file_path =~ /#{key}/ } if file_path

      result.flatten.compact
    end

    private
      def load_template_source(virtual_path, partial)
        parts = virtual_path.split("/")

        @lookup_context ||= ActionView::LookupContext.new(ActionController::Base.view_paths, {:formats => [:html]})

        if parts.size == 2
          return @lookup_context.find(parts[1], parts[0], partial).source
        else
          return ""
        end
      end

  end

end

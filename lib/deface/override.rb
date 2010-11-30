module Deface
  class Override
    include Deface::TemplateHelper

    cattr_accessor :all, :actions
    attr_accessor :args

    @@all ||= {}
    @@actions = [:remove, :replace, :insert_after, :insert_before]

    # Initializes new override, you must supply only one Target, Action & Source
    # parameter for each override (and any number of Optional parameters).
    #
    # ==== Target
    #
    # * <tt>:virtual_path</tt> - The path of the template / partial where
    #   the override should take effect eg: "shared/_person", "admin/posts/new"
    #   this will apply to all controller actions that use the specified template
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
    #   This needs to be unique within the same :virtual_path
    # * <tt>:disabled</tt> - When set to true the override will not be applied.


    def initialize(args)
      @args = args

      key = args[:virtual_path].to_sym

      @@all[key] ||= {}
      @@all[key][args[:name].to_s.parameterize] = self
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

      Deface::Parser.erb_markup!(erb)
    end

    def disabled?
      @args.key?(:disabled) ? @args[:disabled] : false
    end

    def self.find(details)
      return [] if @@all.empty? || details.empty?

      result = []

      virtual_path = details[:virtual_path]
      result << @@all[virtual_path.to_sym].try(:values)

      result.flatten.compact
    end

  end

end

Deface
======

Deface is a library that allows you to customize ERB views in a Rails application without editing the underlying view.

It allows you to easily target html & erb elements as the hooks for customization using both CSS and XPath selectors as supported by Nokogiri.

Deface temporarily converts ERB files into a pseudo HTML markup that can be parsed and queired by Nokogiri, using the following approach:

    <%= some ruby code %>

 becomes 

    <erb-loud> some ruby code </erb-loud>

and 
  
    <% other ruby code %>

  becomes

    <erb-silent> other ruby code </erb-silent>

Deface overrides have full access to all variables accessible to the view being customized.

Deface::Override
=======

A new instance of the Deface::Override class is initialized for each customization you wish to define. When initializing a new override you must supply only one Target, Action & Source parameter and any number of Optional parameters. Note, the source parameter is not required when the "remove" action is specified.

Target
------
* <tt>:file_path</tt> - The relative file path of the template / partial where the override should take effect eg: *"shared/_person"*, *"admin/posts/new"* this will apply to all controller actions that use the specified template.

* <tt>:virtual_path</tt> - The controller and action name where the override should take effect eg: *"controller/action"* or *"posts/index"* will apply to all layouts, templates and partials that are used in the rendering of the specified action.

Action
------
* <tt>:remove</tt> - Removes all elements that match the supplied selector

* <tt>:replace</tt> - Replaces all elements that match the supplied selector

* <tt>:insert_after</tt> - Inserts after all elements that match the supplied selector

* <tt>:insert_before</tt> - Inserts before all elements that match the supplied selector

Source
------
* <tt>:text</tt> - String containing markup

* <tt>:partial</tt> - Relative path to a partial

* <tt>:template</tt> - Relative path to a template

Optional
--------
* <tt>:name</tt> - Unique name for override so it can be identified and modified later. This needs to be unique within the same `:virtual_path` or `:file_path`

Examples
========

Replaces all instances of _h1_ in the `posts/_form.html.erb` partial with `<h1>New Post</h1>`

    Deface::Override.new(:file_path => "posts/_form", :name => "example-1", :replace => "h1", :text => "<h1>New Post</h1>")

Inserts `<%= link_to "List Comments", comments_url(post) %>` before all instances of `p` with css class `comment` in any layout / template / partial used when rendering _PostsController#index_ action:

    Deface::Override.new(:virtual_path => "posts/index", :name => "example-2", :insert_before => "p.comment", :text => "<%= link_to "List Comments", comments_url(post) %>")

Inserts the contents of `shared/_comment.html.erb` after all instances of `div` with an id of `comment_21` in any layout / template / partial used when rendering _PostsController#show_ action:

    Deface::Override.new(:virtual_path => "posts/show", :name => "example-3", :insert_after => "div#comment_21", :partial => "shared/comment")

Removes any instance of `<%= helper_method %>` in the `posts/new.html.erb" template:

    Deface::Override.new(:file_path => "posts/new", :name => "example-4", :remove => "erb-loud:contains('helper_method')" )





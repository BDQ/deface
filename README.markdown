Deface
======

Deface is a library that allows you to customize ERB views in a Rails application without editing the underlying view.

It allows you to easily target html & erb elements as the hooks for customization using both CSS and XPath selectors as supported by Nokogiri.

Deface temporarily converts ERB files into a pseudo HTML markup that can be parsed and queired by Nokogiri, using the following approach:

    <%= some ruby code %>

 becomes 

    <code erb-loud> some ruby code </code>

and 
  
    <% other ruby code %>

  becomes

    <code erb-silent> other ruby code </code>

Deface overrides have full access to all variables accessible to the view being customized.

Deface::Override
=======

A new instance of the Deface::Override class is initialized for each customization you wish to define. When initializing a new override you must supply only one Target, Action & Source parameter and any number of Optional parameters. Note, the source parameter is not required when the "remove" action is specified.

Target
------
* <tt>:virtual_path</tt> - The template / partial / layout where the override should take effect eg: *"shared/_person"*, *"admin/posts/new"* this will apply to all controller actions that use the specified template.

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
* <tt>:name</tt> - Unique name for override so it can be identified and modified later. This needs to be unique within the same `:virtual_path`

Examples
========

Replaces all instances of _h1_ in the `posts/_form.html.erb` partial with `<h1>New Post</h1>`

     Deface::Override.new(:virtual_path => "posts/_form", 
                          :name => "example-1", 
                          :replace => "h1", 
                          :text => "<h1>New Post</h1>")

Inserts `<%= link_to "List Comments", comments_url(post) %>` before all instances of `p` with css class `comment` in `posts/index.html.erb`

     Deface::Override.new(:virtual_path => "posts/index", 
                          :name => "example-2", 
                          :insert_before => "p.comment",
                          :text => "<%= link_to "List Comments", comments_url(post) %>")

Inserts the contents of `shared/_comment.html.erb` after all instances of `div` with an id of `comment_21` in `posts/show.html.erb`

     Deface::Override.new(:virtual_path => "posts/show", 
                          :name => "example-3",
                          :insert_after => "div#comment_21", 
                          :partial => "shared/comment")

Removes any instance of `<%= helper_method %>` in the `posts/new.html.erb" template:

     Deface::Override.new(:virtual_path => "posts/new", 
                          :name => "example-4", 
                          :remove => "code[erb-loud]:contains('helper_method')" )

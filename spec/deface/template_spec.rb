require 'spec_helper'

module ActionView
  describe Template do
    describe "#initialize" do

      describe "with no overrides defined" do
        before(:all) do
           @template = ActionView::Template.new("<p>test</p>", "/some/path/to/file.erb", ActionView::Template::Handlers::ERB, {:virtual_path=>"posts/index", :format=>:html})
        end

        it "should initialize new template object" do
          @template.is_a?(ActionView::Template).should == true
        end

        it "should return unmodified source" do
          @template.source.should == "<p>test</p>"
        end
      end

      describe "with a single remove override defined" do
        before(:all) do
          Deface::Override.new(:virtual_path => "posts/index", :name => "Posts#index", :remove => "p", :text => "<h1>Argh!</h1>")
          @template = ActionView::Template.new("<p>test</p><%= raw(text) %>", "/some/path/to/file.erb", ActionView::Template::Handlers::ERB, {:virtual_path=>"posts/index", :format=>:html})
        end

        it "should return modified source" do
          @template.source.should == "<%= raw(text) %>"
        end
      end

      describe "with a single replace override defined" do
        before(:all) do
          Deface::Override.new(:virtual_path => "posts/index", :name => "Posts#index", :replace => "p", :text => "<h1>Argh!</h1>")
          @template = ActionView::Template.new("<p>test</p>", "/some/path/to/file.erb", ActionView::Template::Handlers::ERB, {:virtual_path=>"posts/index", :format=>:html})
        end

        it "should return modified source" do
          @template.source.should == "<h1>Argh!</h1>"
        end
      end

      describe "with a single insert_after override defined" do
        before(:all) do
          Deface::Override.new(:virtual_path => "posts/index", :name => "Posts#index", :insert_after => "img.button", :text => "<% help %>")

          @template = ActionView::Template.new("<div><img class=\"button\" src=\"path/to/button.png\"></div>",
                                               "/path/to/file.erb",
                                               ActionView::Template::Handlers::ERB,
                                               {:virtual_path=>"posts/index", :format=>:html})
        end

        it "should return modified source" do
          @template.source.gsub("\n", "").should == "<div><img class=\"button\" src=\"path/to/button.png\"><% help %></div>"
        end
      end

      describe "with a single insert_before override defined" do
        before(:all) do
          Deface::Override.new(:virtual_path => "posts/index", :name => "Posts#index", :insert_after => "ul li:last", :text => "<%= help %>")

          @template = ActionView::Template.new("<ul><li>first</li><li>second</li><li>third</li></ul>",
                                               "/path/to/file.erb",
                                               ActionView::Template::Handlers::ERB,
                                               {:virtual_path=>"posts/index", :format=>:html})
        end

        it "should return modified source" do
          @template.source.gsub("\n", "").should == "<ul><li>first</li><li>second</li><li>third</li><%= help %></ul>"
        end
      end

      describe "with a single disabled override defined" do
        before(:all) do
          Deface::Override.new(:virtual_path => "posts/index", :name => "Posts#index", :remove => "p", :text => "<h1>Argh!</h1>", :disabled => true)
          @template = ActionView::Template.new("<p>test</p><%= raw(text) %>", "/some/path/to/file.erb", ActionView::Template::Handlers::ERB, {:virtual_path=>"posts/index", :format=>:html})
        end

        it "should return unmodified source" do
          @template.source.should == "<p>test</p><%= raw(text) %>"
        end
      end

    end
  end
end

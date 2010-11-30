require 'spec_helper'

module Deface
  describe TemplateHelper do
    include Deface::TemplateHelper

    describe "load_template_source" do
      before do
        #stub view paths to be local spec/assets directory
        ActionController::Base.stub(:view_paths).and_return([File.join(File.dirname(__FILE__), '..', "assets")])
      end

      it "should return source for partial" do
        load_template_source("shared/_post", false).should == "<p>I'm from shared/post partial</p>\n"
      end

      it "should return source for template" do
        load_template_source("shared/person", false).should == "<p>I'm from shared/person template</p>\n"
      end

      it "should return source for namespaced template" do
        load_template_source("admin/posts/index", false).should == "<h1>Manage Posts</h1>\n"
      end

      it "should raise exception for non-existing file" do
        lambda { load_template_source("tester/_post", false) }.should raise_error(ActionView::MissingTemplate)
      end

    end
  end
end

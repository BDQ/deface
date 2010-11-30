require 'spec_helper'

module Deface
  describe Override do
    before(:each) do
      @override = Deface::Override.new(:virtual_path => "posts/index", :name => "Posts#index", :replace => "h1", :text => "<h1>Argh!</h1>")
    end

    it "should return correct action" do
      Deface::Override.actions.each do |action|
        @override = Deface::Override.new(:virtual_path => "posts/index", :name => "Posts#index", action => "h1", :text => "<h1>Argh!</h1>")
        @override.action.should == action
      end
    end

    it "should return correct selector" do
      @override.selector.should == "h1"
    end

    describe "#find" do
      it "should find by virtual_path" do
        Deface::Override.find({:virtual_path => "posts/index"}).size.should == 1
      end

      it "should return empty array when no details hash passed" do
        Deface::Override.find({}).should == []
      end
    end

    describe "#new" do

      it "should increase all#size by 1" do
        expect {
          Deface::Override.new(:virtual_path => "posts/new", :name => "Posts#new", :replace => "h1", :text => "<h1>argh!</h1>")
        }.to change{Deface::Override.all.size}.by(1)
      end
    end

    describe "with :text" do

      before(:each) do
        @override = Deface::Override.new(:virtual_path => "posts/index", :name => "Posts#index", :replace => "h1", :text => "<h1>Argh!</h1>")
      end

      it "should return text as source" do
        @override.source.should == "<h1>Argh!</h1>"
      end
    end

    describe "with :partial" do

      before(:each) do
        #stub view paths to be local spec/assets directory
        ActionController::Base.stub(:view_paths).and_return([File.join(File.dirname(__FILE__), '..', "assets")])

        @override = Deface::Override.new(:virtual_path => "posts/index", :name => "Posts#index", :replace => "h1", :partial => "shared/post")
      end

      it "should return partial contents as source" do
        @override.source.should == "<p>I'm from shared/post partial</p>\n"
      end

    end

    describe "with :template" do

      before(:each) do
        #stub view paths to be local spec/assets directory
        ActionController::Base.stub(:view_paths).and_return([File.join(File.dirname(__FILE__), '..', "assets")])

        @override = Deface::Override.new(:virtual_path => "posts/index", :name => "Posts#index", :replace => "h1", :template => "shared/person")
      end

      it "should return template contents as source" do
        @override.source.should == "<p>I'm from shared/person template</p>\n"
      end

    end

    describe "when redefining an existing virutal_path and name" do
      before(:each) do
        @replacement = Deface::Override.new(:virtual_path => "posts/index", :name => "Posts#index", :replace => "h1", :text => "<h1>Arrrr!</h1>")
      end

      it "should not increase all#size by 1" do
        expect {
          Deface::Override.new(:virtual_path => "posts/index", :name => "Posts#index", :replace => "h1", :text => "<h1>Arrrr!</h1>")
        }.to change{Deface::Override.all.size}.by(0)

      end

      it "should return new source" do
        @replacement.source.should_not == @override.source
        @replacement.source.should == "<h1>Arrrr!</h1>"
      end

    end

  end

end

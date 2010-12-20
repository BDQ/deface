require 'spec_helper'

module Deface
  describe Parser do

    describe "#convert" do
      it "should parse html fragment" do
        Deface::Parser.convert("<h1>Hello</h1>").should be_an_instance_of(Nokogiri::HTML::DocumentFragment)
        Deface::Parser.convert("<h1>Hello</h1>").to_s.should == "<h1>Hello</h1>"
        Deface::Parser.convert("<title>Hello</title>").should be_an_instance_of(Nokogiri::HTML::DocumentFragment)
        Deface::Parser.convert("<title>Hello</title>").to_s.should == "<title>Hello</title>"
      end

      it "should parse html document" do
        parsed = Deface::Parser.convert("<html><head><title>Hello</title></head><body>test</body>")
        parsed.should be_an_instance_of(Nokogiri::HTML::Document)
        parsed = parsed.to_s.split("\n")[1..-1]
        parsed.should == "<html>\n<head><title>Hello</title></head>\n<body>test</body>\n</html>".split("\n") #ignore doctype added by noko

        parsed = Deface::Parser.convert("<html><title>test</title></html>")
        parsed.should be_an_instance_of(Nokogiri::HTML::Document)
        parsed = parsed.to_s.split("\n")[1..-1]
        parsed.should == "<html><head><title>test</title></head></html>".split("\n") #ignore doctype added by noko


        parsed = Deface::Parser.convert("<html><p>test</p></html>")
        parsed.should be_an_instance_of(Nokogiri::HTML::Document)
        parsed = parsed.to_s.split("\n")[1..-1]
        parsed.should == "<html><body><p>test</p></body></html>".split("\n") #ignore doctype added by noko
      end

      it "should convert <% ... %>" do
        Deface::Parser.convert("<% method_name %>").to_s.should == "<code erb-silent> method_name </code>"
      end

      it "should convert <%= ... %>" do
        Deface::Parser.convert("<%= method_name %>").to_s.should == "<code erb-loud> method_name </code>"
      end

      it "should convert nested <% ... %>" do
        Deface::Parser.convert("<p id=\"<% method_name %>\"></p>").to_s.should == "<p id=\"&lt;code erb-silent&gt; method_name &lt;/code&gt;\"></p>"
      end

      it "should convert nested <%= ... %> including href attribute" do
        Deface::Parser.convert(%(<a href="<%= x 'y' + "z" %>">A Link</a>)).to_s.should == "<a href=\"&lt;code%20erb-loud&gt;%20x%20'y'%20+%20%22z%22%20&lt;/code&gt;\">A Link</a>"
      end

      it "should escape contents code tags" do
        Deface::Parser.convert("<% method_name(:key => 'value') %>").to_s.should == "<code erb-silent> method_name(:key =&gt; 'value') </code>"
      end
    end

    describe "#undo_erb_markup" do
      it "should revert <code erb-silent>" do
        Deface::Parser.undo_erb_markup!("<code erb-silent> method_name </code>").should == "<% method_name %>"
      end

      it "should revert <code erb-loud>" do
        Deface::Parser.undo_erb_markup!("<code erb-loud> method_name </code>").should == "<%= method_name %>"
      end

      it "should revert nested <code erb-silent>" do
        Deface::Parser.undo_erb_markup!("<p id=\"&lt;code erb-silent&gt; method_name > 1 &lt;/code&gt;\"></p>").should == "<p id=\"<% method_name > 1 %>\"></p>"
      end

      it "should revert nested <code erb-silent> including href attribute" do
        Deface::Parser.undo_erb_markup!("<a href=\"&lt;code%20erb-silent&gt;%20method_name%20&lt;/code&gt;\">A Link</a>").should == "<a href=\"<% method_name %>\">A Link</a>"
      end

      it "should revert nested <code erb-loud>" do
        Deface::Parser.undo_erb_markup!("<p id=\"&lt;code erb-loud&gt; method_name < 2 &lt;/code&gt;\"></p>").should == "<p id=\"<%= method_name < 2 %>\"></p>"
      end

      it "should revert nested <code erb-loud> including href attribute" do
        Deface::Parser.undo_erb_markup!("<a href=\"&lt;code%20erb-loud&gt;%20x%20'y'%20+%20'z'%20&lt;/code&gt;\">A Link</a>").should == %(<a href="<%= x 'y' + 'z' %>">A Link</a>)
        Deface::Parser.undo_erb_markup!("<a href=\"&lt;code%20erb-loud&gt;%20x%20'y'%20+%20%22z%22%20&lt;/code&gt;\">A Link</a>").should == %(<a href="<%= x 'y' + "z" %>">A Link</a>)
      end

      it "should unescape contents of code tags" do
        Deface::Parser.undo_erb_markup!("<% method(:key =&gt; 'value' %>").should == "<% method(:key => 'value' %>"
        Deface::Parser.undo_erb_markup!("<% method(:key =&gt; 'value'\n %>").should == "<% method(:key => 'value'\n %>"
      end

    end

  end

end

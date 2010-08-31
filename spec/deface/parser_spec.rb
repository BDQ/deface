require 'spec_helper'

module Deface
  describe Parser do

    describe "#convert_fragment" do
      it "should parse html" do
        Deface::Parser.convert_fragment("<h1>Hello</h1>").to_s.should == "<h1>Hello</h1>"
      end

      it "should convert <% ... %>" do
        Deface::Parser.convert_fragment("<% method_name %>").to_s.should == "<code erb-silent> method_name </code>"
      end

      it "should convert <%= ... %>" do
        Deface::Parser.convert_fragment("<%= method_name %>").to_s.should == "<code erb-loud> method_name </code>"
      end

      it "should convert nested <% ... %>" do
        Deface::Parser.convert_fragment("<p id=\"<% method_name %>\"></p>").to_s.should == "<p id=\"&lt;code erb-silent&gt; method_name &lt;/code&gt;\"></p>"
      end

      it "should convert nested <%= ... %>" do
        Deface::Parser.convert_fragment("<p id=\"<%= method_name %>\"></p>").to_s.should == "<p id=\"&lt;code erb-loud&gt; method_name &lt;/code&gt;\"></p>"
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

      it "should revert nested <code erb-loud>" do
        Deface::Parser.undo_erb_markup!("<p id=\"&lt;code erb-loud&gt; method_name < 2 &lt;/code&gt;\"></p>").should == "<p id=\"<%= method_name < 2 %>\"></p>"
      end

    end

  end

end

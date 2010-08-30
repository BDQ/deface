require 'spec_helper'

module Deface
  describe Parser do

    describe "#convert_fragment" do
      it "should parse html" do
        Deface::Parser.convert_fragment("<h1>Hello</h1>").to_s.should == "<h1>Hello</h1>"
      end

      it "should convert <% ... %>" do
        Deface::Parser.convert_fragment("<% method_name %>").to_s.should == "<erb-silent>method_name</erb-silent>"
      end

      it "should convert <%= ... %>" do
        Deface::Parser.convert_fragment("<%= method_name %>").to_s.should == "<erb-loud>method_name</erb-loud>"
      end

      it "should convert nested <% ... %>" do
        Deface::Parser.convert_fragment("<p id=\"<% method_name %>\"></p>").to_s.should == "<p id=\"&lt;erb-silent&gt;method_name&lt;/erb-silent&gt;\"></p>"
      end

      it "should convert nested <%= ... %>" do
        Deface::Parser.convert_fragment("<p id=\"<%= method_name %>\"></p>").to_s.should == "<p id=\"&lt;erb-loud&gt;method_name&lt;/erb-loud&gt;\"></p>"
      end
    end

    describe "#undo_erb_markup" do
      it "should revert <erb-silent>" do
        Deface::Parser.undo_erb_markup("<erb-silent>method_name</erb-silent>").should == "<% method_name %>"
      end

      it "should revert <erb-loud>" do
        Deface::Parser.undo_erb_markup("<erb-loud>method_name</erb-loud>").should == "<%= method_name %>"
      end

      it "should revert nested <erb-silent>" do
        Deface::Parser.undo_erb_markup("<tr id=\"&lt;erb-silent&gt;method_name&lt;/erb-silent&gt;\"></tr>").should == "<tr id=\"<% method_name %>\"></tr>"
      end

      it "should revert nested <erb-loud>" do
        Deface::Parser.undo_erb_markup("<tr id=\"&lt;erb-loud&gt;method_name&lt;/erb-loud&gt;\"></tr>").should == "<tr id=\"<%= method_name %>\"></tr>"
      end

    end

  end

end

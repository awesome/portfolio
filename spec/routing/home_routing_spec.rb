require "spec_helper"

describe HomeController do
  describe "routing" do
    it "recognizes and generates actions" do
      { :get => "/contacts" }.should route_to(:controller => "home", :action => "contacts")
      { :get => "/rss" }.should route_to(:controller => "home", :action => "index", :format => 'rss')
    end
  end
end

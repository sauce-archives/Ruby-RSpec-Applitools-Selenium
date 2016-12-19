require_relative "../util/spec_helper"

describe "Sauce Labs Homepage" do
  it "Verify homepage" do
  	@base_url = "http://www.google.com"
    @browser.get(@base_url)

    expect(@browser.title).to be == 'Cross Browser Testing, Selenium Testing, and Mobile Testing | Sauce Labs'

    @eyes.test(app_name: 'Applitools', test_name: 'Sauce Labs Home Page',
          viewport_size: {width: 1008, height: 615}, driver: @browser) do |driver|
          # Visual validation point #1
          @eyes.check_window('Main Page')
    end
  end
end

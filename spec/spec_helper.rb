require "selenium-webdriver"
require 'eyes_selenium'
require "rspec"
require "sauce_whisk"

RSpec.configure do | config |
  config.before(:each) do | test |
    build_name = ENV['JENKINS_BUILD_NUMBER'] ||
        ENV['SAUCE_BAMBOO_BUILDNUMBER'] ||
        ENV['SAUCE_TC_BUILDNUMBER'] ||
        ENV['SAUCE_BUILD_NAME'] ||
        'LOCAL'

    capabilities = {
        version: ENV['version'],
        browserName: ENV['browserName'],
        platform: ENV['platform'],
        name: test.full_description,
        build: build_name
    }

    url = "https://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.saucelabs.com:443/wd/hub".strip

    @browser = Watir::Browser.new(:remote, url: url, desired_capabilities: capabilities)

    @eyes = Applitools::Eyes.new
    @eyes.api_key = ENV['APPLITOOLS_ACCESS_KEY']
  end

  config.after(:each) do | example |
    session_id = @browser.wd.session_id
    SauceWhisk::Jobs.change_status(session_id, example.exception.nil?)
  end
end

require "headless"
require "watir-webdriver"

RSpec.configure do |c|
  # Xvfb needs to be started regardless of what browser we use, we use `before(:suite)` hooks
  # Browser instantiation happens in `before(:all)` rather than `before(:suite)`
  c.before(:suite) do
    if ENV["HEADLESS"]
      # This gem takes care of starting Xvfb
      @headless = Headless.new
      @headless.start
    end
  end

  c.after(:suite) do
    @headless.destroy if @headless
  end
end

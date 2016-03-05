describe "chrome" do
  before(:all) do
    # Fix for chrome blowing up inside of the container http://stackoverflow.com/a/28949227
    @browser = Watir::Browser.new(:chrome, switches: %w(--no-sandbox))
  end

  after(:all) do
    @browser.quit if @browser
  end

  context "example.com" do
    it "is navigable" do
      @browser.goto "example.com"
      expect(@browser.title).to eq "Example Domain"
    end
  end

  context "a javascript-heavy site" do
    it "loads asynchronously" do
      @browser.goto "google.com/adwords"

      start = Time.now
      @browser.div(class: 'overview-ad').wait_until_present
      wait_time = (Time.now - start).to_f

      expect(wait_time).to be > 0.0
    end
  end
end

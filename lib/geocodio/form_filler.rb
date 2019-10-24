require 'watir-get-image-content'

module PlaneNoisePanynj
  class FormFiller
    include FormFillerBase

    attr_accessor :complaint, :browser

    CONFIRMATION_TEXT = "thank you for filing your aircraft noise complaint"

    def self.file_complaint(complaint, test_mode = false)
      @error = nil
      success = false

      begin
        scraper = self.new(complaint, test_mode)

        scraper.create_browser
        scraper.fill_form

        success = scraper.verify_success
      rescue Exception => @error
        Rails.logger.warn("[#{complaint.airnoise_complaint_id}] Error filing PANYNJ complaint: #{@error.message}")
        false
      ensure
        scraper.verification_callback(success, @error) if scraper
        scraper.close_browser if scraper
      end
    end

    def create_browser
      @captcha_client = TextCaptcha::Dbc.new

      @browser = Watir::Browser.new :chrome, options: browser_options
      @browser.goto @complaint_form_url
    end

    def browser_options
      tor_proxy = '127.0.0.1:9050'
      Selenium::WebDriver::Chrome::Options.new(
        args: [
          # "--proxy-server=socks5://#{tor_proxy}"
        ]
      )
    end

    def fill_form
      log_progress("filling PlaneNoise PANYNJ form")

      @browser.text_field(id: 'fname').set(@complaint.first_name)
      @browser.text_field(id: 'lname').set(@complaint.last_name)
      @browser.text_field(id: 'phone1').set(@complaint.area_code)
      @browser.text_field(id: 'phone2').set(@complaint.prefix)
      @browser.text_field(id: 'phone3').set(@complaint.number)
      @browser.text_field(id: 'email').set(@complaint.email)

      @browser.text_field(id: 'address1').set(@complaint.address)
      @browser.text_field(id: 'city').set(@complaint.city)
      # @browser.select_list(id: 'state').select(@complaint.state)

      @browser.text_field(id: 'zip').set(@complaint.zip)

      log_progress("Setting date")
      @browser.send_keys :tab

      @browser.text_field(id: 'date').click
      script = "$('#date').val('#{@complaint.event_date}');"
      @browser.execute_script(script)
      @browser.send_keys :enter

      log_progress("Setting time")
      @browser.select_list(name: 'time_hour').select(@complaint.event_hr)
      @browser.select_list(name: 'time_minutes').select(@complaint.event_min)
      @browser.select_list(name: 'time_ampm').select(@complaint.event_ampm)

      log_progress("Setting airport, a/c and operation")
      @browser.send_keys :tab
      @browser.select_list(id: 'airport').select(@complaint.airport)
      @browser.send_keys :tab

      @browser.label(text: 'Too Loud & Low').click
      @browser.select_list(id: 'aircraftType').select(@complaint.aircraft_type)
      @browser.select_list(id: 'heading').select(@complaint.operation_type)

      @browser.send_keys :tab
      @browser.textarea(id: 'comments').set(@complaint.comments)

      @browser.send_keys :tab

      multi_try_captcha_and_submit do
        if should_submit_complaint?
          log_progress("Clicking submit for PANYNJ")
          @browser.form(action: 'submit.php').submit
          sleep(2)
        else
          log_progress("Not submitting complaint to PANYNJ")
        end
      end

      sleep(1)
    end

    def verify_success
      return false if @test_mode

      if /#{CONFIRMATION_TEXT}/ =~ @browser.text.downcase
        log_progress("Successfully filed complaint with PlaneNoise PANYNJ web form")
        true
      else
        log_progress("Did not get confirmation of complaint being filed via PlaneNoise PANYNJ")
        false
      end
    end

  end
end

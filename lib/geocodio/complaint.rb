module PlaneNoisePanynj
  class Complaint
    include ComplaintBase

    attr_accessor :airnoise_complaint_id, :airport_ident, :time_zone, :first_name, :last_name,
      :address, :city, :state, :zip, :area_code, :prefix, :number, :email,
      :event_date, :event_hr, :event_min, :event_ampm, :concern, :aircraft_type,
      :operation_type, :comments, :callback_url

    DATE_FORMAT = "%b %-d, %Y"

    def initialize(attrs)
      complaint_attrs = ActiveSupport::HashWithIndifferentAccess.new(attrs)
      parse_complaint(complaint_attrs)
    end

    def parse_complaint(complaint_attrs)
      @airnoise_complaint_id = complaint_attrs['id']
      @airport_ident = complaint_attrs['airport_ident']
      @time_zone = complaint_attrs['time_zone']

      @first_name = complaint_attrs['first_name']
      @last_name = complaint_attrs['last_name']

      @address = complaint_attrs['street']
      @city = complaint_attrs['city']
      @state = complaint_attrs['state']
      @zip = complaint_attrs['zip']

      @email = complaint_attrs['email']

      @area_code = parse_phone_digits(complaint_attrs, 0..2)
      @prefix = parse_phone_digits(complaint_attrs, 3..5)
      @number = parse_phone_digits(complaint_attrs, 6..9)

      @event_date = parse_complaint_date(complaint_attrs['event_time'])
      @event_hr, @event_min, @event_ampm = parse_complaint_time(complaint_attrs['event_time'])

      @airport = parse_airport(complaint_attrs['airport_ident'])
      @aircraft_type = parse_ac_type(complaint_attrs['airnoise_category'])
      @operation_type = parse_operation_type(complaint_attrs['operation_type'])

      @comments = build_description(complaint_attrs)
      @callback_url = complaint_attrs['callback_url']

      clone_submission_config(complaint_attrs)
    end

    def parse_complaint_date(complaint_time)
      event_time = Time.parse(complaint_time)
      event_date = event_time.strftime(DATE_FORMAT)

      event_date
    end

    def parse_complaint_time(complaint_time)
      hr = parse_date_time(complaint_time, '%l').strip  # hr with leading pad is invalid
      min = parse_date_time(complaint_time, '%M')
      ampm = parse_date_time(complaint_time, '%P')

      return hr, min, ampm
    end

    def parse_airport(airport_ident)
      case airport_ident
      when 'KJFK'
        'John F. Kennedy International'
      when 'KLGA'
        'LaGuardia'
      when 'KEWR'
        'Newark Liberty International'
      when 'KTEB'
        'Teterboro'
      else
        "Don't Know/Not Sure"
      end
    end

    def parse_ac_type(airnoise_category)
      case airnoise_category
      when 'general_aviation'
        "Propeller"
      when 'commercial', 'business_aviation'
        "Jet"
      when 'helicopter'
        "Helicopter"
      else
        "Unknown"
      end
    end

    # NOTE the extra space after Arrival - the form has this space
    def parse_operation_type(operation_type)
      if operation_type == 'departure'
        'Departure'
      elsif operation_type == 'arrival'
        'Arrival'
      else
        'Overflight'
      end
    end

    def self.test_complaint_attrs
      complaint_handler = ComplaintConfiguration.handler_for('KJFK', 'commercial')

      complaint_attrs = {
        "airnoise_complaint_id" => 0,
        "airport_ident" => "KJFK",
        "time_zone" => "Eastern Time (US & Canada)",
        "title" => "Mrs.",
        "first_name" => "Jana",
        "last_name" => "Golden",
        "email" => "jana@example.com",
        "phone" => "212-555-1212",
        "street" => "123 Main St",
        "city" => "Long Island",
        "state" => "NY",
        "zip" => "02123",
        "event_time" => "2018-09-11T08:51:41.640-04:00",
        "airnoise_category" => "commercial",
        "remarks" => nil,
        "registration" => "N1234UA",
        "aircraft_type" => "B737",
        "aircraft_model" => "Boeing 737-300",
        "operator" => "United Airlines",
        "callsign" => "UAL424",
        "operation_type" => "departure",
        "altitude" => "2000",
        "request_reply_to_complaint" => true,
        "callback_url" => UrlGenerator.new.api_v1_verify_complaint_submission_url,
        "submission_config" => complaint_handler.serialize_to_json
      }
    end
  end
end

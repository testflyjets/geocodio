module Geocodio
  class AcsDataPoint
    attr_reader :value
    attr_reader :margin_of_error
    attr_reader :percentage

    def initialize(payload = {})
      @value            = payload['value']
      @margin_of_error  = payload['margin_of_error']
      @percentage       = payload['percentage']
    end
  end
end

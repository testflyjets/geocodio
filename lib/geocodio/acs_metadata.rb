module Geocodio
  class AcsMetadata
    attr_reader :source
    attr_reader :survey_years
    attr_reader :survey_duration_years

    def initialize(payload = {})
      @source                = payload['meta']['source']
      @survey_years          = payload['meta']['survey_years']
      @survey_duration_years = payload['meta']['survey_duration_years']
    end
  end
end

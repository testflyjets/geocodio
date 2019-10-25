require 'geocodio/acs_statistic'

module Geocodio
  class AcsDemographics
    attr_reader :demographics

    def initialize(payload = {})
      @demographics = []
      if payload['demographics']
        parse_demographic_statistics(payload['demographics'])
      end
    end

    def parse_demographic_statistics(payload)
      payload.each do |statistic, data|
        @demographics << AcsStatistic.new(statistic, data)
      end
    end
  end
end

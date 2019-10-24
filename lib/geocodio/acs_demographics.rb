module Geocodio
  class AcsDemographics
    attr_reader :metadata
    attr_reader :demographics
  end

  def initialize(payload = {})
    @metadata = AcsMetadata.new(payload)
    # @demographics = parse_demographics(payload)
  end

  def parse_demographics(payload)
    @demographics = []
    if payload['demographics']
      parse_demographic_statistics(payload['demographics'])
    end
  end

  def parse_demographic_statistics(payload)

  end
end

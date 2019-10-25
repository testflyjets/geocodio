require 'geocodio/acs_statistic_metadata'
require 'geocodio/acs_datapoint'

module Geocodio
  class AcsStatistic
    attr_reader :name
    attr_reader :metadata
    attr_reader :datapoints

    def initialize(name, data)
      @name = name
      @metadata = AcsStatisticMetadata.new(data)
      @datapoints = parse_data_points(data)
    end

    def parse_data_points(data)
      datapoints = []

      data.delete("meta")

      data.each do |name, values|
        datapoints << AcsDatapoint.new(name, values)
      end
      
      datapoints
    end
  end
end

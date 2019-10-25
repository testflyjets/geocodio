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
      @datapoints = parse_datapoints(data)
      @datapoint_map = generate_datapoint_map(@datapoints)
    end

    def parse_datapoints(data)
      datapoints = []

      data.delete("meta")

      data.each do |name, values|
        datapoints << AcsDatapoint.new(name, values)
      end

      datapoints
    end

    def generate_datapoint_map(datapoints)
      datapoint_map = {}
      datapoints.each do |datapoint|
        datapoint_map[datapoint.name] = datapoint
      end
      datapoint_map
    end

    def find_datapoint(name)
      @datapoint_map[name]
    end
  end
end

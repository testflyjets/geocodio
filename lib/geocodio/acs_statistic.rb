module Geocodio
  class AcsStatistic
    attr_reader :name
    attr_reader :metadata
    attr_reader :data_points

    def initialize(name, data)
      @name = name
      @metadata = AcsStatisticMetadata.new(data)
      @data_points = parse_data_points(data)
    end

    def parse_data_points(data)
      @data_points = []

      data.delete("meta")
      data.each do |name, values|
        @data_points << AcsDataPoint.new(values)
      end
    end
  end
end

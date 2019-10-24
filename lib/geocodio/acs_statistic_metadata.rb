module Geocodio
  class AcsStatisticMetadata
    attr_reader :table_id
    attr_reader :universe

    def initialize(payload = {})
      if payload['meta']
        @table_id = payload['meta']['table_id']
        @universe = payload['meta']['universe']
      end
    end
  end
end

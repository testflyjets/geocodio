module Geocodio
  class Census
    attr_reader :census_year
    attr_reader :state_fips
    attr_reader :county_fips
    attr_reader :tract_code
    attr_reader :block_code
    attr_reader :block_group
    attr_reader :full_fips
    attr_reader :place_name
    attr_reader :place_fips
    attr_reader :msa_name
    attr_reader :msa_area_code
    attr_reader :msa_type
    attr_reader :csa_name
    attr_reader :csa_area_code
    attr_reader :metdiv_name
    attr_reader :metdiv_area_code
    attr_reader :source

    def initialize(payload = {})
      @census_year  = payload['census_year']
      @source       = payload['source']
      @state_fips   = payload['state_fips']
      @county_fips  = payload['county_fips']
      @tract_code   = payload['tract_code']
      @block_code   = payload['block_code']
      @block_group  = payload['block_group']
      @full_fips    = payload['full_fips']

      if payload['place']
        @place_name = payload['place']['name']
        @place_fips = payload['place']['fips']
      end

      if payload['metro_micro_statistical_area']
        @msa_name       = payload['metro_micro_statistical_area']['name']
        @msa_area_code  = payload['metro_micro_statistical_area']['area_code']
        @msa_type       = payload['metro_micro_statistical_area']['type']
      end

      if payload['combined_statistical_area']
        @csa_name       = payload['combined_statistical_area']['name']
        @csa_area_code  = payload['combined_statistical_area']['area_code']
      end

      if payload['metropolitan_division']
        @metdiv_name      = payload['metropolitan_division']['name']
        @metdiv_area_code = payload['metropolitan_division']['area_code']
      end
    end

  end
end

require 'spec_helper'

describe Geocodio::Census do
  let(:geocodio) { Geocodio::Client.new }

  subject(:census) do
    VCR.use_cassette('geocode_with_census') do
      geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[census2019]).
        best.
        census.
        first
    end
  end

  it 'has a census year' do
    expect(census.census_year).to eq(2019)
  end

  it "has a state FIPS" do
    expect(census.state_fips).to eq("06")
  end

  it "has a county FIPS" do
    expect(census.county_fips).to eq("06037")
  end

  it "has a tract code" do
    expect(census.tract_code).to eq("463700")
  end

  it "has a block group" do
    expect(census.block_group).to eq("2")
  end

  it "has a full FIPS" do
    expect(census.full_fips).to eq("060374637002001")
  end

  it "has a place name" do
    expect(census.place_name).to eq("Pasadena")
  end

  it "has a place FIPS" do
    expect(census.place_fips).to eq("0656000")
  end

  it "has an MSA name" do
    expect(census.msa_name).to eq("Los Angeles-Long Beach-Anaheim, CA")
  end

  it "has an MSA area code" do
    expect(census.msa_area_code).to eq("31080")
  end

  it "has an MSA type" do
    expect(census.msa_type).to eq("metropolitan")
  end

  it "has an CSA name" do
    expect(census.csa_name).to eq("Los Angeles-Long Beach, CA")
  end

  it "has an CSA area code" do
    expect(census.csa_area_code).to eq("348")
  end

  it "has an metropolitan division name" do
    expect(census.metdiv_name).to eq("Los Angeles-Long Beach-Glendale, CA")
  end

  it "has an metropolitan division area code" do
    expect(census.metdiv_area_code).to eq("31084")
  end

  it 'has a source' do
    expect(census.source).to eq("US Census Bureau")
  end

end

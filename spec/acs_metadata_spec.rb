require 'spec_helper'

describe Geocodio::AcsMetadata do
  let(:geocodio) { Geocodio::Client.new }

  subject(:acs_metadata) do
    VCR.use_cassette('geocode_with_acs_metadata') do
      geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[acs-demographics]).
        best.
        acs_metadata
    end
  end

  it 'has ACS metadata source' do
    expect(acs_metadata.source).to eq("American Community Survey from the US Census Bureau")
  end

  it 'has ACS metadata survey years' do
    expect(acs_metadata.survey_years).to eq("2013-2017")
  end

  it 'has ACS metadata survey duration years' do
    expect(acs_metadata.survey_duration_years).to eq("5")
  end
end

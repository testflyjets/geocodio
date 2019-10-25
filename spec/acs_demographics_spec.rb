require 'spec_helper'

describe Geocodio::AcsDemographics do
  let(:geocodio) { Geocodio::Client.new }

  subject(:acs_demographics) do
    VCR.use_cassette('geocode_with_acs_demographics') do
      geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[acs-demographics]).
        best.
        acs_demographics
    end
  end

  it "should have a collection of demographics" do
    expect(acs_demographics.demographics.size).to eq(4)
  end

  context(:statistics) do
    let(:statistic) { acs_demographics.demographics.first }

    it "should have a name" do
      expect(statistic.name).to eq("Median age")
    end

    context(:metadata) do
      let(:metadata) { statistic.metadata }

      it "should have a Table ID" do
        expect(metadata.table_id).to eq("B01002")
      end

      it "should have a universe" do
        expect(metadata.universe).to eq("Total population")
      end
    end

    context(:datapoints) do
      let(:datapoints) { statistic.datapoints }

      it "should have datapoints" do
        expect(datapoints.size).to eq(3)
      end

      context(:datapoint) do
        let(:datapoint) { datapoints.first }

        it "should have a name" do
          expect(datapoint.name).to eq("Total")
        end

        it "should have a value" do
          expect(datapoint.value).to eq(44.5)
        end

        it "shold have a margin of error" do
          expect(datapoint.margin_of_error).to eq(3.2)
        end
      end
    end
  end
end

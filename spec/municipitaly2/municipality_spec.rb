# frozen_string_literal: true

require 'municipitaly2/municipality'

RSpec.describe Municipitaly2::Municipality do
  let(:subject) do
    described_class.new(province_istat: '034', name: 'Parma', name_alt: nil,
                        partial_istat: '027', cadastrial_code: 'G337',
                        postal_codes: '43121 43122 43123 43124 43125 43126',
                        population: '195436', area: '260.5978',
                        latitude: '44.8010694', longitude: '10.3283497')
  end
  context 'has following attributes' do
    it 'province_istat as String' do
      expect(subject.province_istat).to be_kind_of(String)
      expect(subject.province_istat).to eq('034')
    end
    it 'name as String' do
      expect(subject.name).to be_kind_of(String)
      expect(subject.name).to eq('Parma')
    end
    it 'partial_istat as String' do
      expect(subject.partial_istat).to be_kind_of(String)
      expect(subject.partial_istat).to eq('027')
    end
    it 'cadastrial_code as String' do
      expect(subject.cadastrial_code).to be_kind_of(String)
      expect(subject.cadastrial_code).to eq('G337')
    end
    it 'postal_codes as Array' do
      expect(subject.postal_codes).to be_kind_of(Array)
      expect(subject.postal_codes)
        .to eq(%w[43121 43122 43123 43124 43125 43126])
    end
    it 'population as Integer' do
      expect(subject.population).to be_kind_of(Integer)
      expect(subject.population).to eq(195_436)
    end
    it 'area as Float' do
      expect(subject.area).to be_kind_of(Float)
      expect(subject.area).to eq(260.5978)
    end
    it 'latitude as Float' do
      expect(subject.latitude).to be_kind_of(Float)
      expect(subject.latitude).to eq(44.8010694)
    end
    it 'longitude as Float' do
      expect(subject.longitude).to be_kind_of(Float)
      expect(subject.longitude).to eq(10.3283497)
    end
  end
  context 'istat' do
    it 'is composed by province_istat + partial_istat' do
      expect(subject.istat)
        .to eq(subject.province_istat + subject.partial_istat)
    end
  end
  context '.all' do
    it 'returns array of all municipalities' do
      expect(described_class.all).to be_kind_of(Array)
      expect(described_class.all.first)
        .to be_kind_of(Municipitaly2::Municipality)
      expect(described_class.all.size).to eq(7894) # 2026-11-05
    end
  end
  context 'name_full' do
    it 'returns only the name when there is no alternative name' do
      expect(Municipitaly2::Search.municipality_from_istat('001001').name_full)
        .to eq('Agliè')
    end
    it 'joins name and alternative name' do
      municipality = described_class.all.find(&:name_alt)
      expect(municipality.name_full)
        .to eq("#{municipality.name}/#{municipality.name_alt}")
    end
  end
  context 'province' do
    it 'return the belongs province' do
      expect(subject.province)
        .to be_kind_of(Municipitaly2::Province)
      expect(subject.province.name)
        .to eq('Parma')
    end
  end
  context 'province_acronym' do
    it 'delegate to province#acronym' do
      expect(subject.province_acronym)
        .to eq('PR')
    end
  end
  context 'region' do
    it 'return the belongs region' do
      expect(subject.region)
        .to be_kind_of(Municipitaly2::Region)
      expect(subject.region.name)
        .to eq('Emilia-Romagna')
    end
  end
  context 'region_name' do
    it 'delegate to region#name' do
      expect(subject.region_name)
        .to eq('Emilia-Romagna')
    end
  end
  context 'region_istat' do
    it 'delegate to region#name' do
      expect(subject.region_istat)
        .to eq('08')
    end
  end
  context 'zone' do
    it 'return the belongs zone' do
      expect(subject.zone)
        .to be_kind_of(Municipitaly2::Zone)
      expect(subject.zone.name)
        .to eq('Nord-est')
    end
  end
  context 'zone_code' do
    it 'delegate to region#zone_code' do
      expect(subject.zone_code)
        .to eq(subject.region.zone_code)
    end
  end
  context 'zone_name' do
    it 'delegate to zone#name' do
      expect(subject.zone_name)
        .to eq('Nord-est')
    end
  end
end

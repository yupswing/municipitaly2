# frozen_string_literal: true

require 'municipitaly2/province'

RSpec.describe Municipitaly2::Province do
  let(:subject) do
    described_class.new(region_istat: '01', name: 'Torino',
                        istat: '001', acronym: 'TO',
                        area: 6826.9298, kind: 'Citta metropolitana', supcode: '201')
  end
  context 'has following attributes' do
    it 'region_istat as String' do
      expect(subject.region_istat).to be_kind_of(String)
      expect(subject.region_istat).to eq('01')
    end
    it 'name as String' do
      expect(subject.name).to be_kind_of(String)
      expect(subject.name).to eq('Torino')
    end
    it 'istat as String' do
      expect(subject.istat).to be_kind_of(String)
      expect(subject.istat).to eq('001')
    end
    it 'supcode as String' do
      expect(subject.supcode).to be_kind_of(String)
      expect(subject.supcode).to eq('201')
    end
    it 'acronym as String' do
      expect(subject.acronym).to be_kind_of(String)
      expect(subject.acronym).to eq('TO')
    end
    it 'iso3166_2' do
      expect(subject.iso3166_2).to be_kind_of(String)
      expect(subject.iso3166_2).to eq('IT-TO')
    end
    it 'alias iso3166 to iso3166_2' do
      expect(subject.iso3166).to be_kind_of(String)
      expect(subject.iso3166).to eq('IT-TO')
    end
    it 'kind as String' do
      expect(subject.kind).to be_kind_of(String)
      expect(subject.kind).to eq('Citta metropolitana')
    end
    it 'area as Float' do
      expect(subject.area).to be_kind_of(Float)
      expect(subject.area).to eq(6826.9298)
    end
  end
  context '.all' do
    it 'returns array of all provinces' do
      expect(described_class.all).to be_kind_of(Array)
      expect(described_class.all.first).to be_kind_of(Municipitaly2::Province)
      expect(described_class.all.size).to eq(107)
    end
  end
  context 'municipalities' do
    it 'returns all municipalities belongs current province' do
      expect(subject.municipalities).to be_kind_of(Array)
      expect(subject.municipalities.first)
        .to be_kind_of(Municipitaly2::Municipality)
      expect(subject.municipalities.size).to eq(312)
    end
  end
  context 'region' do
    it 'return the belongs region' do
      expect(subject.region)
        .to be_kind_of(Municipitaly2::Region)
      expect(subject.region.name)
        .to eq('Piemonte')
    end
  end
  context 'region_name' do
    it 'delegate to region#name' do
      expect(subject.region_name)
        .to eq('Piemonte')
    end
  end
  context 'zone' do
    it 'return the belongs zone' do
      expect(subject.zone)
        .to be_kind_of(Municipitaly2::Zone)
      expect(subject.zone.name)
        .to eq('Nord-ovest')
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
        .to eq('Nord-ovest')
    end
  end
end

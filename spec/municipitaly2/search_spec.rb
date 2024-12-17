# frozen_string_literal: true

require 'municipitaly2/search'

RSpec.describe Municipitaly2::Search do
  context '.zone_from_code' do
    context 'with an existant param zone code' do
      it 'returns a Zone object' do
        expect(described_class.zone_from_code('5'))
          .to be_kind_of(Municipitaly2::Zone)
        expect(described_class.zone_from_code('5').name)
          .to eq('Isole')
      end
    end
    context 'with nonexistent param zone code' do
      it 'returns nil' do
        expect(described_class.zone_from_code('50'))
          .to be_nil
      end
    end
  end

  context '.region_from_istat' do
    context 'with an existant param region istat' do
      it 'returns a Region object' do
        expect(described_class.region_from_istat('15'))
          .to be_kind_of(Municipitaly2::Region)
        expect(described_class.region_from_istat('15').name)
          .to eq('Campania')
      end
    end
    context 'with nonexistent param region istat' do
      it 'returns nil' do
        expect(described_class.region_from_istat('50'))
          .to be_nil
      end
    end
  end

  context '.regions_from_zone_code' do
    context 'with an existant param zone code' do
      it 'returns an Array of Region objects' do
        expect(described_class.regions_from_zone_code('3'))
          .to be_kind_of(Array)
        expect(described_class.regions_from_zone_code('3').first)
          .to be_kind_of(Municipitaly2::Region)
        expect(
          described_class.regions_from_zone_code('3').first.zone_code
        ).to eq('3')
        expect(
          described_class.regions_from_zone_code('3').last.zone_code
        ).to eq('3')
      end
    end
    context 'with nonexistent param zone code' do
      it 'returns empty array' do
        expect(described_class.regions_from_zone_code('50'))
          .to be_empty
      end
    end
  end

  context '.region_from_name' do
    context 'with an existant param region name' do
      it 'returns a Region object' do
        expect(described_class.region_from_name('liguria'))
          .to be_kind_of(Municipitaly2::Region)
        expect(described_class.region_from_name('liguria').name)
          .to eq('Liguria')
      end
    end
    context 'with nonexistent param region name' do
      it 'returns nil' do
        expect(described_class.region_from_name('shire'))
          .to be_nil
      end
    end
  end

  context '.province_from_name' do
    context 'with an existant param province name' do
      it 'returns a Province object' do
        expect(described_class.province_from_name('aosta').acronym)
          .to eq('AO')
        expect(described_class.province_from_name("valle d' aosta").acronym)
          .to eq('AO')
        expect(described_class.province_from_name('Milan').acronym)
          .to eq('MI')
        expect(described_class.province_from_name('Brianza').acronym)
          .to eq('MB')
        expect(described_class.province_from_name('aquila').acronym)
          .to eq('AQ')
        expect(described_class.province_from_name('Massa').acronym)
          .to eq('MS')
        expect(described_class.province_from_name('emilia').acronym)
          .to eq('RE')
        expect(described_class.province_from_name('basso').acronym)
          .to eq('CB')
      end
    end
    context 'with nonexistent param province istat' do
      it 'returns nil' do
        expect(described_class.province_from_istat('a54'))
          .to be_nil
      end
    end
  end

  context '.province_from_istat' do
    context 'with an existant param province istat' do
      it 'returns a Province object' do
        expect(described_class.province_from_istat('036'))
          .to be_kind_of(Municipitaly2::Province)
        expect(described_class.province_from_istat('036').name)
          .to eq('Modena')
      end
    end
    context 'with nonexistent param province istat' do
      it 'returns nil' do
        expect(described_class.province_from_istat('a54'))
          .to be_nil
      end
    end
  end

  context '.province_from_acronym' do
    context 'with an existant param province acronym' do
      it 'returns a Province object' do
        expect(described_class.province_from_acronym('PE'))
          .to be_kind_of(Municipitaly2::Province)
        expect(described_class.province_from_acronym('PE').name)
          .to eq('Pescara')
      end
    end
    context 'with nonexistent param province acronym' do
      it 'returns nil' do
        expect(described_class.province_from_acronym('AX'))
          .to be_nil
      end
    end
  end

  context '.provinces_from_region_istat' do
    context 'with an existant param region istat' do
      it 'returns an Array of Province objects' do
        expect(described_class.provinces_from_region_istat('05'))
          .to be_kind_of(Array)
        expect(described_class.provinces_from_region_istat('05').first)
          .to be_kind_of(Municipitaly2::Province)
        expect(
          described_class.provinces_from_region_istat('05').first.region_istat
        ).to eq('05')
        expect(
          described_class.provinces_from_region_istat('05').last.region_istat
        ).to eq('05')
      end
    end
    context 'with nonexistent param region istat' do
      it 'returns empty array' do
        expect(described_class.provinces_from_region_istat('70'))
          .to be_empty
      end
    end
  end

  context '.provinces_from_zone_code' do
    context 'with an existant param zone code' do
      it 'returns an Array of Province objects' do
        expect(described_class.provinces_from_zone_code('1'))
          .to be_kind_of(Array)
        expect(described_class.provinces_from_zone_code('1').first)
          .to be_kind_of(Municipitaly2::Province)
        expect(
          described_class.provinces_from_zone_code('1').size
        ).to eq(25)
      end
    end
    context 'with nonexistent param zone code' do
      it 'returns empty array' do
        expect(described_class.provinces_from_zone_code('45'))
          .to be_empty
      end
    end
  end

  context '.municipalities_from_name' do
    context 'with an existant param name' do
      it 'returns an Array of Municipality objects' do
        expect(described_class.municipalities_from_name('monte'))
          .to be_kind_of(Array)
        expect(described_class.municipalities_from_name('monte').first)
          .to be_kind_of(Municipitaly2::Municipality)
        expect(
          described_class.municipalities_from_name('monte').size
        ).to eq(253)
      end
      it 'returns results with case insensitive' do
        expect(described_class.municipalities_from_name('monteforte').size)
          .to eq(3)
        expect(described_class.municipalities_from_name('Monteforte').size)
          .to eq(3)
      end
      it 'returns results from partial term' do
        expect(described_class.municipalities_from_name('terme').size)
          .to eq(47)
      end
    end
    context 'with nonexistent param name' do
      it 'returns empty array' do
        expect(described_class.municipalities_from_name('62'))
          .to be_empty
      end
    end
    context 'greedy param' do
      context 'when is false' do
        it 'return only municipality having exact term name' do
          expect(described_class
                 .municipalities_from_name('Gragnano', greedy: false).size)
            .to eq(1)
        end
      end
      context 'when is not provided or true' do
        it 'return all municipalities having partial term name' do
          expect(described_class
                 .municipalities_from_name('Gragnano').size)
            .to eq(2)
          expect(described_class
                 .municipalities_from_name('Gragnano', greedy: true).size)
            .to eq(2)
        end
      end
    end
  end

  context '.municipality_from_cadastrial' do
    context 'with an existant param cadastrial_code' do
      it 'returns a Municipality object' do
        expect(described_class.municipality_from_cadastrial('E021'))
          .to be_kind_of(Municipitaly2::Municipality)
        expect(described_class.municipality_from_cadastrial('E021').name)
          .to eq('Giavera del Montello')
      end
    end
    context 'with nonexistent param cadastrial_code' do
      it 'returns nil' do
        expect(described_class.municipality_from_cadastrial('ABC8'))
          .to be_nil
      end
    end
  end

  context '.municipality_from_istat' do
    context 'with an existant param istat' do
      it 'returns a Municipality object' do
        expect(described_class.municipality_from_istat('090003'))
          .to be_kind_of(Municipitaly2::Municipality)
        expect(described_class.municipality_from_istat('090003').name)
          .to eq('Alghero')
      end
    end
    context 'with nonexistent param cadastrial_code' do
      it 'returns nil' do
        expect(described_class.municipality_from_istat('000008'))
          .to be_nil
      end
    end
  end

  context '.municipalities_from_postal_code' do
    context 'with an existant param postal_code' do
      it 'returns an Array of Municipality objects' do
        expect(described_class.municipalities_from_postal_code('40127'))
          .to be_kind_of(Array)
        expect(described_class.municipalities_from_postal_code('40127').first)
          .to be_kind_of(Municipitaly2::Municipality)
        expect(
          described_class.municipalities_from_postal_code('40127').first.name
        ).to eq('Bologna')
      end
    end
    context 'with nonexistent param cadastrial_code' do
      it 'returns empty array' do
        expect(described_class.municipalities_from_postal_code('acr43h'))
          .to be_empty
      end
    end
  end

  context '.municipalities_from_postal_code' do
    context 'with an existant param postal_code' do
      it 'returns an Array of Municipality objects' do
        expect(described_class.municipalities_from_postal_code('40127'))
          .to be_kind_of(Array)
        expect(described_class.municipalities_from_postal_code('40127').first)
          .to be_kind_of(Municipitaly2::Municipality)
        expect(
          described_class.municipalities_from_postal_code('40127').first.name
        ).to eq('Bologna')
      end
    end
    context 'with nonexistent param cadastrial_code' do
      it 'returns empty array' do
        expect(described_class.municipalities_from_postal_code('acr43h'))
          .to be_empty
      end
    end
  end

  context '.municipalities_from_region_istat' do
    context 'with an existant param region istat' do
      it 'returns an Array of Municipality objects' do
        expect(described_class.municipalities_from_region_istat('09'))
          .to be_kind_of(Array)
        expect(described_class.municipalities_from_region_istat('09').first)
          .to be_kind_of(Municipitaly2::Municipality)
        expect(
          described_class.municipalities_from_region_istat('09')
          .first.region_istat
        ).to eq('09')
        expect(
          described_class.municipalities_from_region_istat('09')
          .last.region_istat
        ).to eq('09')
      end
    end
    context 'with nonexistent param region istat' do
      it 'returns empty array' do
        expect(described_class.municipalities_from_region_istat('98'))
          .to be_empty
      end
    end
  end

  context '.municipalities_from_zone_code' do
    context 'with an existant param zone code' do
      it 'returns an Array of Municipality objects' do
        expect(described_class.municipalities_from_zone_code('4'))
          .to be_kind_of(Array)
        expect(described_class.municipalities_from_zone_code('4').first)
          .to be_kind_of(Municipitaly2::Municipality)
        expect(
          described_class.municipalities_from_zone_code('4')
          .first.zone_code
        ).to eq('4')
        expect(
          described_class.municipalities_from_zone_code('4')
          .last.zone_code
        ).to eq('4')
      end
    end
    context 'with nonexistent param zone code' do
      it 'returns empty array' do
        expect(described_class.municipalities_from_zone_code('40'))
          .to be_empty
      end
    end
  end
end

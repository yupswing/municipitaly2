#!/usr/bin/env ruby

require 'csv'

def fullpath(relative)
  File.join(__dir__, relative)
end

# ==============================================================================

# #INFO
# municipitalies.csv - generated
# provinces.csv - generated
# regions.csv - static (change manually if needed)
# zones.csv - static (change manually if needed)

def download_gi
  # https://www.gardainformatica.it/database-comuni-italiani
  gi_source = 'https://www.gardainformatica.it/gi_db_comuni/gi_db_comuni-2024-06-30-eb64b.zip'

  # Download the file and extract the content
  `wget -O /tmp/gi_db_comuni.zip #{gi_source}`
  `unzip /tmp/gi_db_comuni.zip -d /tmp/gi_db_comuni -o`

  # gi_comuni_cap.csv
  # gi_comuni_validita.csv
  # gi_regioni.csv
  # gi_comuni.csv
  # gi_nazioni.csv
  # gi_cap.csv
  # gi_comuni_nazioni_cf.csv
  # gi_province.csv
  files = ['gi_province.csv', 'gi_comuni.csv', 'gi_comuni_cap.csv'].map { |f| "/tmp/gi_db_comuni/csv/#{f}" }

  `cp #{files.join(' ')} #{fullpath('./data/')}`

  # quick fix Ionadi -> Jonadi
  `sed -i 's@;Ionadi@;Jonadi@g' #{fullpath('./data/gi_comuni.csv')}`
  `sed -i 's@;Ionadi@;Jonadi@g' #{fullpath('./data/gi_comuni_cap.csv')}`

  # quick fix Moio Alcantara -> Mojo Alcantara'
  `sed -i 's@;"Moio Alcantara@;"Mojo Alcantara@g' #{fullpath('./data/gi_comuni.csv')}`
  `sed -i 's@;"Moio Alcantara@;"Mojo Alcantara@g' #{fullpath('./data/gi_comuni_cap.csv')}`
end

def download_istat
  # sadly the page is protected by cloudflare
  puts "Open manually 'https://dait.interno.gov.it/territorio-e-autonomie-locali/sut/elenco_cens_var_comuni_italiani.php' and copy the table."
  puts "Substitute each 'tab' with a ',' and save it as 'data/istat_comuni_popolazione.csv'"
  puts "Use this as first line 'NR.,DESCRIZIONE COMUNE,SIGLA,NOTE,POPOLAZIONE CENSITA UOMINI,POPOLAZIONE CENSITA DONNE,POPOLAZIONE CENSITA TOTALE'"
end

# ==============================================================================

def log(text, clear: false, end_block: false)
  if clear
    print "\r\x1b[2K#{text}"
  else
    puts text
  end
  puts '-------------------------' if end_block
end

# ==============================================================================

def get_province
  # open csv and read lines
  # <CSV::Row "codice_regione":"07"
  #	          "sigla_provincia":"GE"
  #	          "denominazione_provincia":"Genova"
  #	          "tipologia_provincia":"Citta metropolitana"
  #	          "numero_comuni":"67"
  #	          "superficie_kmq":"1834,1528"
  # 	        "codice_sovracomunale":"210">

  log("Importo province da file 'gi_province.csv'")
  province = []
  CSV.foreach(fullpath('./data/gi_province.csv'), headers: :first_row, col_sep: ';') do |row|
    row['superficie_kmq'] = row['superficie_kmq'].gsub(',', '.').to_f

    row['codice_istat'] = row['codice_sovracomunale']
    # il codice sovracomunale in caso di citta metropolitane e' 200+codice_istat
    row['codice_istat'] = (row['codice_istat'].to_i - 200).to_s.rjust(3, '0') if row['codice_istat'].to_i > 200
    province << row
  end
  province.sort_by! { |p| p['codice_istat'] }
  log("Importate #{province.count} province", end_block: true)
  province
end

def get_comuni
  # <CSV::Row "sigla_provincia":"TO"
  #           "codice_istat":"001001"
  #           "denominazione_ita_altra":"Agliè"
  #           "denominazione_ita":"Agliè"
  #           "denominazione_altra":nil
  #           "flag_capoluogo":"NO"
  #           "codice_belfiore":"A074"
  #           "lat":"45,3634368"
  #           "lon":"7,7685999"
  #           "superficie_kmq":"13,1463"
  #           "codice_sovracomunale":"201">
  log("Importo comuni da file 'gi_comuni.csv'")
  comuni = []
  CSV.foreach(fullpath('./data/gi_comuni.csv'), headers: :first_row, col_sep: ';') do |row|
    row['codice_istat_provincia'] = row['codice_istat'][0...3]
    row['codice_istat_comune'] = row['codice_istat'][3...6]
    row['superficie_kmq'] = row['superficie_kmq'].gsub(',', '.').to_f
    row['lat'] = row['lat'].gsub(',', '.').to_f
    row['lon'] = row['lon'].gsub(',', '.').to_f
    row['cap'] = []
    comuni << row
  end
  log("Importati #{comuni.count} comuni", end_block: true)
  comuni
end

# ==============================================================================

def add_cap_to_comuni(comuni)
  # POSSIBILMENTE MULTIPLE RIGHE PER COMUNE!
  # <CSV::Row "codice_istat":"010025"
  #           "denominazione_ita_altra":"Genova"
  #	          "denominazione_ita":"Genova"
  #	          "denominazione_altra":nil
  #	          "cap":"16121"
  #	          "sigla_provincia":"GE"
  #	          "denominazione_provincia":"Genova"
  #	          "tipologia_provincia":"Citta metropolitana"
  #	          "codice_regione":"07"
  #	          "denominazione_regione":"Liguria"
  #	          "tipologia_regione":"statuto ordinario"
  #	          "ripartizione_geografica":"Nord-ovest"
  #	          "flag_capoluogo":"SI"
  #	          "codice_belfiore":"D969"
  #	          "lat":"44,4114827"
  #	          "lon":"8,9326992"
  #	          "superficie_kmq":"240,6542">
  comuni_copy = comuni.dup
  counter = 0
  log("Integro dati dei CAP da file 'gi_comuni_cap.csv'\n")
  CSV.foreach(fullpath('./data/gi_comuni_cap.csv'), headers: :first_row, col_sep: ';') do |row|
    comune = comuni_copy.find { |c| c['codice_istat'] == row['codice_istat'] }
    next unless comune

    comune['cap'] << row['cap']
    # comuni_copy.delete(comune) # could be more than one, we cannot delete
    counter += 1
    log("Elaborate #{counter} righe", clear: true) if (counter % 100).zero?
  end
  log("Integrati #{counter} su #{comuni.count} comuni\n", clear: true, end_block: true)
end

def add_population_to_comuni(comuni)
  comuni_copy = comuni.dup
  counter = 0
  skipped = []
  log("Integro dati della popolazione da file 'popolazione.csv'\n")
  CSV.foreach(fullpath('./data/istat_comuni_popolazione.csv'), headers: :first_row, col_sep: ',') do |row|
    comune_term_istat = row['DESCRIZIONE COMUNE'].split('/').first
                                                 .downcase.tr('àâçèéêìòôù', 'aaceeeioou').gsub(/[^a-z]/, '')
    comune = comuni_copy.find do |c|
      comune_term_gi = c['denominazione_ita'].downcase.tr('àâçèéêìòôù', 'aaceeeioou').gsub(/[^a-z]/, '')
      row['SIGLA'] == c['sigla_provincia'] && comune_term_istat == comune_term_gi
    end
    if comune
      comune['popolazione'] = row['POPOLAZIONE CENSITA TOTALE'].gsub('.', '').to_i
      comuni_copy.delete(comune)
    else
      skipped << "Comune not found: #{row['DESCRIZIONE COMUNE']}"
    end
    log("Elaborate #{counter} righe", clear: true) if (counter % 100).zero?
    counter += 1
  end
  log("Integrati #{counter} su #{comuni.count} comuni (#{skipped.count} saltati)\n", clear: true, end_block: true)
  pp skipped
end

def find_comune(comuni, text)
  comune_term_istat = text.downcase.tr('àâçèéêìòôù', 'aaceeeioou').gsub(/[^a-z]/, '')
  comuni.find do |c|
    comune_term_gi = c['denominazione_ita'].split('/').first
                                           .downcase.tr('àâçèéêìòôù', 'aaceeeioou').gsub(/[^a-z]/, '')
    comune_term_istat =~ Regexp.new(comune_term_gi)
  end
end

# ==============================================================================

def write_comuni(comuni)
  # <CSV::Row "sigla_provincia":"SU"
  #           "codice_istat":"111107"
  #           "denominazione_ita_altra":"Villaspeciosa"
  #           "denominazione_ita":"Villaspeciosa"
  #           "denominazione_altra":nil
  #           "flag_capoluogo":"NO"
  #           "codice_belfiore":"M026"
  #           "lat":"39,2969845"
  #           "lon":"8,8938220"
  #           "superficie_kmq":"27,1943"
  #           "codice_sovracomunale":"111"
  #           "codice_istat_provincia":"111"
  #           "codice_istat_comune":"107"
  #           "cap":[]
  #           "popolazione":2536>

  # municipalities.csv
  # province_istat,name,partial_istat,cadastrial_code,postal_codes,population,area,latitude,longitude
  # 001,Agliè,,001,A074,10011,2562,13.1463,45.3634368,7.7685999
  log("Scrivo comuni su file 'municipalities.csv'")
  # write CSV.generate to file
  File.write(fullpath('../vendor/data/municipalities.csv'),
             CSV.generate(headers: true) do |csv|
               csv << %w[province_istat
                         name
                         name_alt
                         partial_istat
                         cadastrial_code
                         postal_codes
                         population
                         area
                         latitude
                         longitude]

               comuni.each do |c|
                 csv << [c['codice_istat_provincia'],
                         c['denominazione_ita'],
                         c['denominazione_altra'],
                         c['codice_istat_comune'],
                         c['codice_belfiore'],
                         c['cap'].join(' '),
                         c['popolazione'],
                         c['superficie_kmq'],
                         c['lat'],
                         c['lon']]
               end
             end)
  log("Scritti #{comuni.count} comuni", end_block: true)
end

def write_province(province)
  # <CSV::Row "codice_regione":"19"
  #          "sigla_provincia":"AG"
  #          "denominazione_provincia":"Agrigento"
  #          "tipologia_provincia":"Libero consorzio di comuni"
  #          "numero_comuni":"43"
  #          "superficie_kmq":"3053,8057"
  #          "codice_sovracomunale":"084">

  # provinces.csv
  # region_istat,name,istat,acronym,kind,area
  # 01,Torino,001,TO
  log("Scrivo province su file 'provinces.csv'")
  # write CSV.generate to file
  File.write(fullpath('../vendor/data/provinces.csv'),
             CSV.generate(headers: true) do |csv|
               csv << %w[region_istat acronym name supcode istat kind area]

               province.each do |p|
                 csv << [p['codice_regione'],
                         p['sigla_provincia'],
                         p['denominazione_provincia'],
                         p['codice_sovracomunale'],
                         p['codice_istat'],
                         p['tipologia_provincia'],
                         p['superficie_kmq']]
               end
             end)
end

# <CSV::Row "sigla_nazione":"USA"
#           "codice_belfiore":"Z404"
#           "denominazione_nazione":"STATI UNITI D'AMERICA"
#           "denominazione_cittadinanza":"STATUNITENSE">
# CSV.foreach('/tmp/gi_db_comuni/csv/gi_nazioni.csv', headers: :first_row, col_sep: ';') do |row|
#   puts "#{row['codice_belfiore']} #{row['sigla_nazione']} - #{row['denominazione_nazione']}"
# end

download_gi

comuni = get_comuni
add_cap_to_comuni(comuni)
add_population_to_comuni(comuni)
write_comuni(comuni)

province = get_province
write_province(province)

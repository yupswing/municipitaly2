# frozen_string_literal: true

module Municipitaly2
  # Define collection
  class Data
    @@zones = []
    @@regions = []
    @@provinces = []
    @@municipalities = []

    def zones
      if @@zones.empty?
        CSV.foreach(find_csv('zones.csv'), headers: true) do |row|
          @@zones << Zone.new(
            name: row[0],
            code: row[1]
          )
        end
      end
      @@zones
    end

    def regions
      if @@regions.empty?
        CSV.foreach(find_csv('regions.csv'), headers: true) do |row|
          @@regions << Region.new(
            zone_code: row[0],
            name: row[1],
            istat: row[2],
            partial_iso3166: row[3]
          )
        end
      end
      @@regions
    end

    def provinces
      if @@provinces.empty?
        # #TAG_PROVINCE_DATA
        CSV.foreach(find_csv('provinces.csv'), headers: true) do |row|
          @@provinces << Province.new(
            region_istat: row[0],
            acronym: row[1],
            name: row[2],
            supcode: row[3],
            istat: row[4],
            kind: row[5],
            area: row[6]
          )
        end
      end
      @@provinces
    end

    def municipalities
      if @@municipalities.empty?
        # #TAG_COMUNI_DATA
        CSV.foreach(find_csv('municipalities.csv'), headers: true) do |row|
          @@municipalities <<
            Municipality.new(
              province_istat: row[0],
              name: row[1],
              name_alt: row[2],
              partial_istat: row[3],
              cadastrial_code: row[4],
              postal_codes: row[5],
              population: row[6],
              area: row[7],
              latitude: row[8],
              longitude: row[9]
            )
        end
      end
      @@municipalities
    end

    def find_csv(file)
      File.expand_path(File.join(File.dirname(__FILE__),
                                 "../../vendor/data/#{file}"))
    end
  end
end

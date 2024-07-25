# frozen_string_literal: true

module Municipitaly2
  # Define data structure for a Municipality
  class Municipality
    extend Forwardable
    include DataCaller
    include RegionDelegator
    include ZoneDelegator

    def initialize(province_istat:, name:, name_alt:, partial_istat:,
                   cadastrial_code:, postal_codes:, population:,
                   area:, latitude:, longitude:) # :nodoc:
      @province_istat = province_istat
      @name = name
      @name_alt = name_alt
      @partial_istat = partial_istat
      @cadastrial_code = cadastrial_code
      @postal_codes = postal_codes.split
      @population = population.to_i
      @area = area.to_f
      @latitude = latitude.to_f
      @longitude = longitude.to_f
    end

    # <b>istat code</b> relative to parent province (String)
    attr_reader :province_istat

    # <b>name</b> of municipality (String)
    attr_reader :name

    # <b>alternative name</b> of municipality (String)
    attr_reader :name_alt

    attr_reader :partial_istat # :nodoc:

    # <b>cadastrial code</b> of municipality (String)
    attr_reader :cadastrial_code

    # an Array of one or more postal code (as String)
    attr_reader :postal_codes

    # total <b>population</b> of municipality (Integer)
    attr_reader :population

    # total <b>area</b> of municipality (Float)
    attr_reader :area

    # coordinate <b>latitude</b> of municipality (Float)
    attr_reader :latitude

    # coordinate <b>longitude</b> of municipality (Float)
    attr_reader :longitude

    def_delegator :province, :acronym, :province_acronym
    def_delegator :province, :name, :province_name
    def_delegator :province, :region_istat, :region_istat

    # returns an array of all +Municipitaly2::Municipality+ objects.
    def self.all
      data.municipalities
    end

    # returns <b>istat code</b> for current municipality.
    def istat
      province_istat + partial_istat
    end

    def name_full
      name_alt.nil? ? name : "#{name}/#{name_alt}"
    end

    # returns +Municipitaly2::Province+ object for current municipality.
    def province
      @province ||= Search.province_from_istat(province_istat)
    end
  end
end

# frozen_string_literal: true

module Municipitaly2
  # Define data structure for a Province
  class Province
    extend Forwardable
    include DataCaller
    include RegionDelegator
    include ZoneDelegator

    def initialize(region_istat:, name:, istat:, acronym:, area:, kind:, supcode:)
      @region_istat = region_istat
      @name = name
      @istat = istat
      @supcode = supcode # Codice Unità Territoriale Sovracomunale
      @acronym = acronym
      @area = area.to_f
      @kind = kind
    end

    attr_reader :region_istat, :name, :istat, :supcode, :acronym, :area, :kind

    # returns an array of all +Municipitaly2::Province+ objects.
    def self.all
      data.provinces
    end

    # returns an array of all +Municipitaly2::Municipality+ objects belongs
    # to current province.
    def municipalities
      @municipalities ||= Search.municipalities_from_province_istat(istat)
    end

    # returns ISO 3166-2 code for current province.
    def iso3166_2
      "IT-#{acronym}"
    end

    alias iso3166 iso3166_2
  end
end

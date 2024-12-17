# frozen_string_literal: true

module Municipitaly2
  # +Municipitaly2::Search+ class implement different search methods.
  #
  # You <b>must use</b> shortcut <b>class methods</b> that invoke private
  # instance methods having same method name, for example:
  #
  #   Search.municipalities_from_postal_code('36040')
  #
  # invoke to:
  #
  #   Search.new('36040').municipalities_from_postal_code
  #
  class Search
    include DataCaller

    CLASS_METHODS = %i[zone_from_code
                       region_from_name region_from_istat regions_from_zone_code
                       province_from_name province_from_istat
                       province_from_acronym provinces_from_region_istat
                       provinces_from_zone_code municipalities_from_name
                       municipality_from_cadastrial municipality_from_istat
                       municipalities_from_postal_code
                       municipalities_from_province_istat
                       municipalities_from_region_istat
                       municipalities_from_zone_code].freeze # :nodoc:

    CLASS_METHODS.each do |method|
      define_singleton_method method do |message, opts = {}|
        Search.new(message, opts).send(method)
      end
    end # :nodoc:

    attr_accessor :term, :opts # :nodoc:

    def initialize(term, opts = {}) # :nodoc:
      @term = term.to_s.strip
      @opts = opts
    end

    protected

    # returns a +Municipitaly2::Zone+ object from a <b>zone code</b> term
    #
    # example usage:
    #   zone = Search.zone_from_code('4')
    def zone_from_code # :doc:
      data.zones.find do |z|
        z.code == term
      end
    end

    # returns a +Municipitaly2::Region+ object from a <b>region name</b> term
    #
    # example usage:
    #   region = Search.region_from_name('liguria')
    def region_from_name # :doc:
      term_set = Municipitaly2.sanitize_term(term)
      return nil if term_set.size < 3

      data.regions.find do |r|
        name_set = Municipitaly2.sanitize_term(r.name)
        name_set =~ Regexp.new(term_set)
      end
    end

    # returns a +Municipitaly2::Region+ object from a <b>region istat</b> term
    #
    # example usage:
    #   region = Search.region_from_istat('15')
    def region_from_istat # :doc:
      data.regions.find do |r|
        r.istat == term
      end
    end

    # returns an array of +Municipitaly2::Region+ objects from a <b>zone
    # code</b> term
    #
    # example usage:
    #   regions = Search.regions_from_zone_code('3')
    def regions_from_zone_code # :doc:
      data.regions.select do |r|
        r.zone_code == term
      end
    end

    # returns a +Municipitaly2::Province+ object from a <b>province name</b>
    # term
    #
    # example usage:
    #   province = Search.province_from_name('Paler')
    def province_from_name # :doc:
      term_set = Municipitaly2.sanitize_term(term)
      return nil if term_set.size < 3

      data.provinces.find do |p|
        name_set = Municipitaly2.sanitize_term(p.name)
        name_set =~ Regexp.new(term_set)
      end
    end

    # returns a +Municipitaly2::Province+ object from a <b>province istat</b>
    # term
    #
    # example usage:
    #   province = Search.province_from_istat('061')
    def province_from_istat # :doc:
      data.provinces.find do |p|
        p.istat == term
      end
    end

    # returns a +Municipitaly2::Province+ object from a <b>province acronym</b>
    # term
    #
    # example usage:
    #   province = Search.province_from_acronym('MI')
    def province_from_acronym # :doc:
      data.provinces.find do |p|
        p.acronym == term
      end
    end

    # returns an array of +Municipitaly2::Province+ objects from a <b>region
    # istat</b> term
    #
    # example usage:
    #   provinces = Search.provinces_from_region_istat('05')
    def provinces_from_region_istat # :doc:
      data.provinces.select do |p|
        p.region_istat == term
      end
    end

    # returns an array of +Municipitaly2::Province+ objects from a <b>zone
    # code</b> term
    #
    # example usage:
    #   provinces = Search.provinces_from_zone_code('5')
    def provinces_from_zone_code # :doc:
      region_istats = regions_from_zone_code.map(&:istat)
      data.provinces.select do |p|
        region_istats.include? p.region_istat
      end
    end

    # returns an array of +Municipitaly2::Municipality+ objects from a
    # <b>municipality name</b> term.
    # Term can be a partial string and is case insensitive.
    # The optional parameter +greedy+ [boolean] permit to serch exact term
    # name (if false) or partial word (true by default).
    #
    # example usage:
    #   municipalities = Search.municipalities_from_name('monte')
    #   municipalities = Search.municipalities_from_name('monte', greedy: false)
    def municipalities_from_name # :doc:
      greedy = opts.fetch(:greedy, true)
      term_set = Municipitaly2.sanitize_term(term)

      return [] if term_set.size < 3

      regexp = if greedy
                 Regexp.new(term_set, true)
               else
                 Regexp.new("^#{term_set}$", true)
               end
      data.municipalities.select do |m|
        Municipitaly2.sanitize_term(m.name) =~ regexp || (m.name_alt && Municipitaly2.sanitize_term(m.name_alt) =~ regexp)
      end
    end

    # returns a +Municipitaly2::Municipality+ object from a <b>cadastrial
    # code</b> term
    #
    # example usage:
    #   municipality = Search.municipality_from_cadastrial('D791')
    def municipality_from_cadastrial # :doc:
      data.municipalities.find do |m|
        m.cadastrial_code == term.upcase
      end
    end

    # returns a +Municipitaly2::Municipality+ object from a <b>municipality
    # istat</b> term
    #
    # example usage:
    #   municipality = Search.municipality_from_istat('066032')
    def municipality_from_istat # :doc:
      province_istat = term.slice!(0...3)
      partial_istat = term
      data.municipalities.find do |m|
        m.province_istat == province_istat && m.partial_istat == partial_istat
      end
    end

    # returns an array of +Municipitaly2::Municipality+ objects from a
    # <b>postal code</b> term.
    #
    # example usage:
    #   municipalities = Search.municipalities_from_postal_code('00163')
    def municipalities_from_postal_code # :doc:
      data.municipalities.select do |m|
        m.postal_codes.include? term
      end
    end

    # returns an array of +Municipitaly2::Municipality+ objects from a
    # <b>province istat</b> term.
    #
    # example usage:
    #   municipalities = Search.municipalities_from_province_istat('090')
    def municipalities_from_province_istat # :doc:
      data.municipalities.select do |m|
        m.province_istat == term
      end
    end

    # returns an array of +Municipitaly2::Municipality+ objects from a
    # <b>region istat</b> term.
    #
    # example usage:
    #   municipalities = Search.municipalities_from_region_istat('13')
    def municipalities_from_region_istat # :doc:
      province_istats = provinces_from_region_istat.map(&:istat)
      municipalities_from_province_istats(province_istats)
    end

    # returns an array of +Municipitaly2::Municipality+ objects from a
    # <b>zone code</b> term.
    #
    # example usage:
    #   municipalities = Search.municipalities_from_zone_code('3')
    def municipalities_from_zone_code # :doc:
      province_istats = provinces_from_zone_code.map(&:istat)
      municipalities_from_province_istats(province_istats)
    end

    private

    def municipalities_from_province_istats(istats)
      data.municipalities.select do |m|
        istats.include? m.province_istat
      end
    end
  end
end

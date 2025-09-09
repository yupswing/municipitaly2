# frozen_string_literal: true

require 'csv'
require 'forwardable'

require_relative 'municipitaly2/version'
require_relative 'municipitaly2/data'
require_relative 'municipitaly2/zone_delegator'
require_relative 'municipitaly2/region_delegator'
require_relative 'municipitaly2/data_caller'
require_relative 'municipitaly2/zone'
require_relative 'municipitaly2/region'
require_relative 'municipitaly2/province'
require_relative 'municipitaly2/municipality'
require_relative 'municipitaly2/search'

# top level namespace
module Municipitaly2
  # :nodoc:

  # returns a sanitized term removing everything except letters to make
  # matches less prone to errors (case insensitive and accent insensitive)
  #
  # example usage:
  #   sanitized_term = Search.sanitize_term('Forlì Cesena')
  def self.sanitize_term(term) # :doc:
    term.strip.downcase.tr('àâçèéêìòôù', 'aaceeeioou').gsub(/[^a-z ]/, '')
  end
end

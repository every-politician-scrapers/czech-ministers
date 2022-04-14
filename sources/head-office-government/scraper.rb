#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class Czech < WikipediaDate
  REMAP = {
    'FFF'       => '',
    'ledna'     => 'January',
    'února'     => 'February',
    'MARCH'     => 'March',
    'APRIL'     => 'April',
    'MAY'       => 'May',
    'června'    => 'June',
    'července'  => 'July',
    'srpen'     => 'August',
    'srpna'     => 'August',
    'září'      => 'September',
    'října'     => 'October',
    'listopadu' => 'November',
    'prosince'  => 'December',
  }.freeze

  def remap
    REMAP.merge(super)
  end

  def date_en
    super.gsub(/(\d+)\. /, '\1 ')
  end
end

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Pořadí'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no name dates].freeze
    end

    def raw_combo_date
      super.gsub(/^od (.*)/, '\1 - Incumbent')
    end

    def date_class
      Czech
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv

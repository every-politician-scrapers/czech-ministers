#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      noko.css('h3').text.tidy
    end

    def position
      noko.css('.txt').text.tidy
        .gsub(', Minister', '|Minister')
        .gsub(' and Minister', '|Minister')
        .split('|')
        .map(&:tidy)
    end
  end

  class Members
    def member_container
      noko.css('.record-img')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv

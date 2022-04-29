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
          .gsub(', from 11 November 2021 in resignation.', '')
          .gsub(', Minister', '|Minister')
          .gsub(' and Minister', '|Minister')
          .split('|')
          .map(&:tidy)
    end
  end

  class Members
    def prime_minister
      noko.xpath('.//h2[text()="Prime Minister"]/following-sibling::ul/li[1]').text.tidy
    end

    def members
      super.unshift({ name: prime_minister, position: 'Prime Minister' })
    end

    def member_container
      noko.css('.record-img')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv

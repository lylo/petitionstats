require 'open-uri'

class HomeController < ApplicationController

  def index
    json = HomeController.feed

    country_hash = {}
    @total_signatures = 0
    json["data"]["attributes"]["signatures_by_country"].map do |country|
      signature_count = country["signature_count"].to_i
      country_hash[country["name"]] = signature_count
      @total_signatures += signature_count
    end

    @country_hash = Hash[country_hash.sort_by{|k, v| v}.reverse]
  end

  def self.feed
    Rails.cache.fetch("feed", :expires_in => 1.minutes) do
      JSON.load(open("https://petition.parliament.uk/petitions/241584.json"))
    end
  end
end

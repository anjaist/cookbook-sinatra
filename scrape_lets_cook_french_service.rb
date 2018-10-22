require_relative 'recipe'
require 'nokogiri'
require 'open-uri'

class ScrapeLetsCookFrenchService
  attr_reader :web_recipes
  def initialize(keyword)
    @keyword = keyword
  end

  def call
    url = "http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt=#{@keyword}"
    doc = Nokogiri::HTML(open(url).read)
    @web_recipes = []
    doc.search('.m_contenu_resultat').each do |x|
      @prep_time = x.search('.m_detail_time').text.strip
      @name = x.search('.m_titre_resultat').text.strip
      @description = x.search('.m_titre_resultat a').attribute('href').value
      @difficulty = "-> #{x.search('.m_detail_recette').text.split(" - ")[2]}"
      recipe = Recipe.new(@name, @description, add_prep_time(@prep_time), false, @difficulty)
      @web_recipes << recipe
    end
    @web_recipes
  end

  def add_prep_time(prep_time)
    prep_time = prep_time.gsub(/\D/, ",").split(",")
    prep_time = prep_time.map(&:to_i)
    total_time = prep_time.sum
    total_time += 60 if prep_time.include? 1
    return "#{total_time} min"
  end
end

# ScrapeLetsCookFrenchService.new("curry").call

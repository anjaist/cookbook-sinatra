require 'csv'
require_relative 'recipe'
require_relative 'scrape_lets_cook_french_service'

class Cookbook
  attr_reader :recipes, :web_recipes
  def initialize(filepath)
    @filepath = filepath
    @recipes = []
    CSV.foreach(filepath) do |row|
      boolean = row[3] == "true"
      recipe = Recipe.new(row[0], row[1], row[2], boolean, row[4])
      @recipes << recipe
    end
  end

  def update_recipe_csv(recipe_arr)
    CSV.open(@filepath, 'wb') do |csv|
      recipe_arr.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.prep_time, recipe.done, recipe.difficulty]
      end
    end
  end

  def all
    @recipes
  end

  def scrape(search_word)
    @web_recipes = ScrapeLetsCookFrenchService.new(search_word).call
  end

  def add_recipe(recipe)
    @recipes << recipe
    update_recipe_csv(@recipes)
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    update_recipe_csv(@recipes)
  end

  def mark_as_done!(recipe_index)
    @recipes[recipe_index].done = true
    update_recipe_csv(@recipes)
  end
end

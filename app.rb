require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "recipe"
require_relative "cookbook"
require_relative "scrape_lets_cook_french_service"
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)

  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

post '/recipes' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  recipe = Recipe.new(params[:name], params[:description], params[:prep_time])
  cookbook.add_recipe(recipe)
  redirect to '/'
end

get '/scrape_results' do
  @recipes = ScrapeLetsCookFrenchService.new(params[:query]).call
  erb :scrape
end

#code below not correct, not working
# delete '/recipes' do
#   cookbook.remove_recipe(recipe)
#   redirect to '/'
# end

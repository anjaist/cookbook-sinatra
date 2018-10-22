class Recipe
  attr_accessor :done
  attr_reader :name, :description, :prep_time, :difficulty
  def initialize(name, description, prep_time, done = false, difficulty = "")
    @name = name
    @description = description
    @prep_time = prep_time
    @done = done
    @difficulty = difficulty
  end

  def done?
    @done
  end
end

require_relative './classes.rb'
require 'csv'
require 'tty-prompt'


##### DEFINE THE METHODS #####

prompt = TTY::Prompt.new

### Input checks ###

# Check if user input is valid
def input_check
  loop do
    input = $stdin.gets.chomp
    correctInput = yield input
    # If we have a valid item
    if correctInput
      # Stop looping
      return true
    end
  end
end

def first_opt
  sleep(0.5)
  puts "What would you like to do?"
  puts "1. Start quiz"
  puts "2. Add a new Q&A"
  # puts "3. Exit"
  print "> "
  input_check do |option_input|
    start_input(option_input)
  end
end

# Start
def start_input(option_input)
  option_input = option_input.to_i
  if option_input == 1
    show_categories
    # Until input_check breaks, do check_includes
    input_check do |input|
    check_includes(input)
    end
    quiz(@category_input_push)
    return true
  elsif option_input == 2
    puts "Would you like to:"
    puts "1. Create a new category"
    puts "2. Add to an existing category"
    print "> "
    option_input = input_check do |option_input|
      new_check_category(option_input)
    end
    return true
  else
    puts "Sorry, invalid input"
    puts "What would you like to do?"
    puts "1. Start quiz"
    puts "2. Add a new Q&A"
    # puts "3. Exit"
    print "> "
    return false
  end
end

# New Q&A --> add a current category or create new?
def new_check_category(option_input)
  option_input = option_input.to_i
  if option_input == 1
     make_new_category
    return true
  elsif option_input == 2
    show_categories
    input_check do |input|
      check_includes(input)
    end
    new_qa(@category_input_push)
    return true
  else
    puts "Sorry, invalid input"
      puts "Would you like to:"
      puts "1. Create a new category"
      puts "2. Add to an existing category"
      print "> "
    return false
  end
end


# Checks if the category exists
def check_includes(category_input_get)
  # .map checks through the current array to see if it contains the argument
  # It creates an array that when is does contain the argument it will put
  # true, other wise false. it then checks if the new array has a true
   if @categories.map {|a| a.include?(category_input_get) }.include?(true)
     # Run next method
     @category_input_push = category_input_get
     puts @category_input_push
     return true
     #@x = true
   else
    puts "Sorry, we do not have that category. Please pick another"
    print "> "
    return false
   end
end

### Start Quiz ###
 def quiz(category)
   print "Quiz starting in.. "
   sleep(0.75)
   print "3.. "
   sleep(0.75)
   print "2.. "
   sleep(0.75)
   print "1.."
   puts ""
   ask(category)
 end

 ### Loop through all questions in a category ###
def ask(chosen_category)

  @score = 0
  counter = 0
  i = 0

  category = chosen_category
  link = "#{category}.csv"

  CSV.foreach(link, headers: true) do |row|
    puts "#{ row['question'] }"
    print "> "
    answer_input = $stdin.gets.chomp
    check_answer(answer_input, link, counter)
    counter += 1
    i += 1
  end

  puts "Your score: #{@score} out of #{i}"
end

def check_answer(answer_input, link, counter)

  answers = CSV.read(link, headers:true)

  if answers[counter][1] == answer_input
      puts "That was correct!"
      @score += 1
    else
      puts "Sorry, that was incorrect the answer is: #{answers[counter][1]}"
    end
end

### Create a new category ###
def make_new_category

  puts "Pick a category name"
  print "> "

  category_name = $stdin.gets.chomp

  CSV.open('categories.csv', 'a+') do |csv_file|
    csv_file << [category_name]
  end
  @categories << [category_name]
  @categories_table = Terminal::Table.new :title => "Categories", :rows => @categories

  category = category_name
  link = "#{category}.csv"

  CSV.open(link, 'wb') do |csv|
    csv << ["question", "answer"]
  end

  new_qa(category_name)

end


### Input new question and answer ###

def new_qa(category_input_push)

  category = category_input_push
  link = "#{category}.csv"

  puts "Please input the question"
  print "> "
  question = $stdin.gets.chomp
  puts "Please input the answer"
  print "> "
  answer = $stdin.gets.chomp
  # skip past the headers by setting the headers to true
  CSV.open(link, 'a+') do |csv_file|
  # add a row to the csv file
  csv_file << [question, answer]
  end

  puts "Would you like to input another? (y/n)"
  print "> "
  option_input = $stdin.gets.chomp
  if option_input == "y"
    new_qa(category_input_push)
  elsif option_input == "n"
    exit
  else
    exit
  end
end


### Universal Methods ###

# Puts category table
def show_categories
    sleep(0.5)
    puts "Please pick a category from the list below:"
    puts @categories_table
    print "> "
end

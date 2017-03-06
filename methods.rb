require_relative './classes.rb'
require 'csv'
require 'tty-prompt'
require 'colorize'


##### DEFINE THE METHODS #####

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
  prompt = TTY::Prompt.new

  selector = prompt.select("What would you like to do?") do |menu|
    menu.choice "Start quiz"
    menu.choice "Add a new Q&A"
    menu.choice "Exit"
  end

  case selector
    when "Start quiz"
      # puts "Start quiz"
      show_categories
      # Until input_check breaks, do check_includes
      input_check do |input|
        check_includes(input)
      end
      quiz(@category_input_push)

    when "Add a new Q&A"
      another_qa_opt
    when "Exit"
      exit
  end
end

# New Q&A option

def new_qa_opt
  prompt = TTY::Prompt.new

  selector = prompt.select("Would you like to input another?") do |menu|
    menu.choice "Yes"
    menu.choice "No"
  end

  case selector
    when "Yes"
      new_qa(category_input_push)
    when "No"
      first_opt
  end
end

# Another QA option

def another_qa_opt
  prompt = TTY::Prompt.new

  selector = prompt.select("What would you like to do?") do |menu|
    menu.choice "Create a new category"
    menu.choice "Add to an existing category"
    menu.choice "Go back"
  end

  case selector
    when "Create a new category"
      make_new_category
    when "Add to an existing category"
      show_categories
      input_check do |input|
        check_includes(input)
      end
      new_qa(@category_input_push)
    when "Go back"
      first_opt
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
      puts "That was correct!".green
      @score += 1
    else
      puts "Sorry, that was incorrect the answer is: #{answers[counter][1]}".red
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
  new_qa_opt
end


### Universal Methods ###

# Puts category table
def show_categories
    puts "Please pick a category from the list below:"
    puts @categories_table
    print "> "
end

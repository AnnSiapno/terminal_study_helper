require 'csv'
require 'tty-prompt'
require 'colorize'
require 'terminal-table'


##### DEFINE THE METHODS #####

### Input checks ###

def first_opt
  prompt = TTY::Prompt.new

  puts "\n"

  selector = prompt.select("What would you like to do?") do |menu|
    menu.choice "Study"
    menu.choice "Start quiz"
    menu.choice "Add a new Q&A"
    menu.choice "Exit"
  end

  case selector
    when "Study"
      show_categories
      study(@category_input_push)
    when "Start quiz"

      show_categories
      quiz(@category_input_push)

    when "Add a new Q&A"
      another_qa_opt
    when "Exit"
      exit
  end
end

# Study

def study(category)

  link = "#{category}.csv"

  @study = []

  CSV.foreach(link, headers: true) do |row|
    @study << [row['question'], row['answer']]
  end

  @study_table = Terminal::Table.new :title => category, :headings => ['Questions', 'Answers'], :rows => @study
  @study_table.style = {:padding_left => 3, :border_x => "=", :border_i => "x"}

  puts "\n\n#{@study_table}\n\n"
  first_opt
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
  score_link = "#{category}-score.csv"

  CSV.open(score_link, 'wb') do |csv|
    csv << ["question", "answer", "your_answer"]
  end

  CSV.foreach(link, headers: true) do |row|
    puts "#{ row['question'] }"
    print "> "
    answer_input = $stdin.gets.chomp
    check_answer(answer_input, score_link, link, counter)
    counter += 1
    i += 1
  end

  puts "Your score: #{@score} out of #{i}"
  score_opt(category)
end

def check_answer(answer_input, score_link, link, counter)

  answers = CSV.read(link, headers:true)

  if answers[counter][1] == answer_input

      puts "That was correct!".green

      CSV.open(score_link, 'a+') do |csv_file|
      # add a row to the csv file
      csv_file << [answers[counter][0], answers[counter][1], answer_input]
      end

      @score += 1

    else
      puts "Sorry, that was incorrect the answer is: #{answers[counter][1]}".red

      CSV.open(score_link, 'a+') do |csv_file|
      # add a row to the csv file
      csv_file << [answers[counter][0], answers[counter][1], answer_input]
      end
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

def score_opt(category)
  prompt = TTY::Prompt.new

  puts "\n"

  selector = prompt.select("Would you like to see your score sheet?") do |menu|
    menu.choice "Yes"
    menu.choice "No"
  end

  case selector
  when "Yes"
    see_score_sheet(category)
  when "No"
    first_opt
  end
end

def see_score_sheet(category)

  score_link = "#{category}-score.csv"

  @score = []

  CSV.foreach(score_link, headers: true) do |row|

    if row['answer'] == row['your_answer']
      @score << [row['question'].green, row['answer'].green, row['your_answer'].green]
    else
      @score << [row['question'].red, row['answer'].red, row['your_answer'].red]
    end
  end

  @score_sheet = Terminal::Table.new :title => category, :headings => ['Questions', 'Answers', 'Your Answers'], :rows => @score
  @score_sheet.style = {:padding_left => 3, :border_x => "=", :border_i => "x"}

  puts "\n\n#{@score_sheet}\n\n"
  first_opt
end

### Universal Methods ###

# Puts category table
def show_categories
      prompt = TTY::Prompt.new

      choices = []

      CSV.foreach('categories.csv', headers: true) do |row|
        choices.push(row['category'])
      end

      puts "\n"

      category = prompt.select("Please pick a category from the list below:", choices)
        @category_input_push = category
end

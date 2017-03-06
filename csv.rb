require 'csv'

# Create the CSV files
CSV.open('categories.csv', 'wb') do |csv|
  csv << ["category"]
  csv << ["HTML"]
  csv << ["CSS"]
  csv << ["Ruby"]
  csv << ["Terminal"]
end

CSV.open('html.csv', 'wb') do |csv|
  csv << ["question", "answer"]
  csv << ["What does HTML stand for?", "Hyper Text Markup Language"]
  csv << ["Which HTML element defines the title of a document?", "<title>"]
  csv << ["Which HTML element is used to specify a footer for a document or section?", "<footer>"]
  csv << ["Which HTML element defines navigation links?", "<nav>"]
  csv << ["Which HTML element is used to specify a header for a document or section?", "<header>"]
end

CSV.open('css.csv', 'wb') do |csv|
  csv << ["question", "answer"]
  csv << ["What does HTML stand for?", "Hyper Text Markup Language"]
  csv << ["Which HTML element defines the title of a document?", "<title>"]
  csv << ["Which HTML element is used to specify a footer for a document or section?", "<footer>"]
  csv << ["Which HTML element defines navigation links?", "<nav>"]
  csv << ["Which HTML element is used to specify a header for a document or section?", "<header>"]
end

CSV.open('terminal.csv', 'wb') do |csv|
  csv << ["question", "answer"]
  csv << ["List the files and folders in the current directory", "ls"]
  csv << ["Create a new directory called 'new'", "mkdir new"]
  csv << ["Create a new text file called 'my_file'", "touch my_file.txt"]
  csv << ["Delete the file called 'my_file.txt'", "rm my_file.txt"]
  csv << ["Open the current directory", "open ."]
end

CSV.open('ruby.csv', 'wb') do |csv|
  csv << ["question", "answer"]
  csv << ["Print out 'Hello World' on a new line", "puts 'Hello World'"]
  csv << ["Create a variable with the name of 'number' and a value of 6", "number = 6"]
  csv << ["What is the comparative operator for 'equals to'?'", "=="]
  csv << ["What is the comparative operator for 'not equal to'?'", "!="]
  csv << ["What is the command to convert a string into all lowercase?", ".downcase"]
end

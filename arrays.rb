##### DEFINE THE ARRAYS #####

# list of Categories in terminal-table
require 'terminal-table'
require 'csv'

@categories = []

CSV.foreach('categories.csv', headers: true) do |row|
  @categories << [row['category']]
end

@categories_table = Terminal::Table.new :title => "Categories", :rows => @categories

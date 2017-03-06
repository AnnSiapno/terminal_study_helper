require 'terminal-table'
require 'artii'
require_relative './methods.rb'

title = Artii::Base.new :font => 'slant'


# Set value of Artii and prints it
puts title.asciify("Study Helper")

first_opt

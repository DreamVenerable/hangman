require "yaml"

require_relative 'hangman.rb'

class Game
  def initialize
    puts "Would you like load a saved game or a play a new game?"
    puts "[Type 'N' for New Game - Type 'L' to load game]"
    choice
    choose_game(@letter)
  end

  def choice
    begin
      @letter = gets.downcase.match(/^[ln]{1}$/)[0]
    rescue StandardError
      puts 'Wrong input, Try again!'
      retry
    else
      sleep 0.5
    end
  end

  def choose_game(choice)
    case choice
    when 'n'
      word = random_word
      Hangman.new(word, [], Array.new(word.length, "•"), 6)
    when 'l'
      choose_file
    end
  end

  def choose_file
    puts "Type your file number to choose your game:"
    begin
      num = gets.match(/^[0-9]{1}$/)[0]
    rescue StandardError
      puts 'Wrong input, Try again!'
      retry
    else
      sleep 0.5
      load_game(num)
    end
  end

  def load_game(i)
    game_file = File.read("../game_file/saved#{i}.yaml")
    yaml = YAML.load(game_file)
    Hangman.new(yaml[0], yaml[1], yaml[2], yaml[3])
  end  
end


def random_word
  word_array = []

  words = File.readlines('../english_words.txt')

  words.each do |word|
    word.strip!
    word_array.push(word) if word.length <= 12 && word.length >= 5
  end
  word_array.sample
end

Game.new
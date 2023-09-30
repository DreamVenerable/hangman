require 'yaml'

class Hangman
  def initialize(word, binned, correct, guesses)
    @word = word
    @binned = binned
    @correct_char = correct
    @guesses_left = guesses
    start
  end

  def start
    update_game
    continue?
    while @guesses_left > 0 && @bool
      play
    end

    puts "The word was '#{@word}'" if @guesses_left == 0
  end

  def continue?
    @bool = true if @correct_char.any?('•')
  end

  def exit_game
    @bool = false
  end

  def compare_letter
    place_letter if @word.include?(@letter)
    letter_bin unless @word.include?(@letter) || @binned.include?(@letter)
  end

  def place_letter
    index = (0 ... @word.length).find_all { |i| @word[i] == @letter }.each { |i| @correct_char[i] = @letter }
  end

  def update_game
    puts "                                \n"
    puts "#{@correct_char.join('')}"
    puts "Your incorrect guesses: #{@binned}"
  end

  def letter_bin
    @guesses_left -= 1
    @binned.push(@letter)
  end

  def play
    choice
    compare_letter
    update_game
    save_game?
  end

  def save_game?
    puts "Save game and exit? Y/N"
    begin
      save_choice = gets.downcase.match(/^[yn]{1}$/)[0]
    rescue StandardError
      puts 'Wrong input, Try again!'
      retry
    else
      sleep 0.5
      choose_file if save_choice == 'y'
      update_game if save_choice == 'n'
    end
  end

  def choose_file
    puts "Type your file number to save your game:"
    begin
      num = gets.match(/^[0-9]{1}$/)[0]
    rescue StandardError
      puts 'Wrong input, Try again!'
      retry
    else
      sleep 0.5
      save_game(num)
      exit_game
    end
  end

  def save_game(i)
    yaml = to_yaml
    game_file = File.write("game_file/saved#{i}.yaml", yaml)
  end  

  def to_yaml
    YAML.dump ([@word, @binned, @correct_char, @guesses_left])
  end

  def choice
    begin
      @letter = gets.downcase.match(/^-?[a-z]{1}$/)[0]
    rescue StandardError
      puts 'Wrong input, Try again!'
      retry
    else
      p "You chose #{@letter.upcase}"
      sleep 0.5
    end
  end
end


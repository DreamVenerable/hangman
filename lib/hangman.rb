class Game
  def initialize(word)
    @word = word
    p @word
    @number_of_tries = 6
    @num = word.length
    start
  end

  def start
    @binned = []
    @correct_char = Array.new(@num, "•")
    while @number_of_tries != 0 && continue?
      play
    end
  end

  def continue?
    true if @correct_char.any?('•')
  end

  def compare_letter
    place_letter if @word.include?(@letter)
    letter_bin unless @word.include?(@letter) || @binned.include?(@letter)
  end

  def place_letter
    index = (0 ... @num).find_all { |i| @word[i] == @letter }.each { |i| @correct_char[i] = @letter }
  end

  def update_game
    puts "#{@correct_char.join('')}"
    puts "Your incorrect guesses: #{@binned}"
    puts "                                \n"
  end

  def letter_bin
    @number_of_tries -= 1
    @binned.push(@letter)
  end

  def play
    choice
    compare_letter
    update_game
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

def random_word
  word_array = []

  words = File.readlines('../english_words.txt')

  words.each do |word|
    word.strip!
    word_array.push(word) if word.length <= 12 && word.length >= 5
  end

  word_array.sample
end

Game.new(random_word)
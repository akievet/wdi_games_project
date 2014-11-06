class HangmanGame < ActiveRecord::Base
  has_many :hangman_moves
  belongs_to :user

  def pick_random_word
    line= File.readlines("words.txt").sample
    line.split(',')[0]
  end

  def secret_word
    @secret_word ||= pick_random_word
  end

  def show_correct_letters
    regex_letters = self.not_guessed_letters.join("|")
    regex= /(#{regex_letters})/

    self.word.split(' ').map do |word|
      word.gsub!(regex,"_") || word
    end.join(' ')
  end

  def guessed_letters
    self.hangman_moves.map {|move| move.letter}
  end

  def not_guessed_letters
    all_letters = ("a".."z").to_a
    all_letters - self.guessed_letters
  end

  def correct_letters
    moves_array = self.hangman_moves.select do |move|
      move.is_correct?
    end
    moves_array.map do |move|
      move.letter
    end
  end

  def incorrect_letters
    moves_array = self.hangman_moves.select do |move|
      move.is_correct? == false
    end
    moves_array.map do |move|
      move.letter
    end
  end

  def correct?
    self.word.chars.uniq.sort == correct_letters.uniq.sort
  end

  def attempt_count
    self.incorrect_letters.length
  end

  def lives
    6 - attempt_count
  end

  def another_turn?
    if lives > 0
      true
    else
      false
    end
  end

  def guess_not_valid?(letter)
    self.guessed_letters.include?(letter)
  end


  def guess_entire_word(guess)
    if guess == self.word
      guess.chars.uniq.each do |char|
        HangmanMove.create({letter: char, user_id: self.user_id, hangman_game_id: self.id})
      end
    end
  end

end

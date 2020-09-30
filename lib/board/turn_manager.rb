module TurnManager

  @@PLAYER_COLORS = {
    p1: 'red',
    p2: 'blue'
  }

  def take_turn
    color = @@PLAYER_COLORS[@turn]
    puts "It is #{color}'s turn"

    selected = select_piece
    until confirm_selection
      selected = select_piece
    end

    apply_move selected
    switch
    take_turn
  end

  def select_piece
    selected = nil

    loop do
      print "Select a piece to move:\t"
      selected = at get_position

      if valid_selection? selected
        show_moves(selected)
        break
      end
    end

    puts "Selected:\t#{selected}"
    return selected
  end

  def apply_move(selected)
    valid_moves = selected.move_options self
    selected_move = nil
    until valid_moves.include? selected_move
      print "Select a destination:\t"
      selected_move = get_position
      puts "You can't move there!" unless valid_moves.include? selected_move
    end

    reset_at selected.position
    x, y = selected_move
    selected.position = selected_move
    @content[y][x] = selected
    display self
  end

  def confirm_selection
    loop do
      print "Is this the correct? (Y/n):\t"
      answer = gets.chomp

      if answer.downcase == 'y'
        return true
      elsif answer.downcase == 'n'
        return false
      else
        puts "I'm sorry, I didn't understand that"
      end
    end
  end

  def valid_selection?(selected)
    if selected.is_a? Piece
      if selected.team == @turn
        true
      else
        print "That's not yours!\n\n"
        false
      end
    else
      print "There's no piece there!\n\n"
      false
    end
  end

  def get_position
    begin
      get_valid_position_input
    rescue
      print "Invalid input! Use a letter followed by a number (i.e. A4)\n\n"
      print "Select a position:\t"
      get_position
    end
  end

  def get_valid_position_input
    input = gets.chomp.upcase.split('')

    raise "Wrong number of arguments" unless input.length == 2
    raise "First value must be a character between A and H!" unless valid_alphabetic?(input[0])
    raise "Second value must be a number between 1 and 8!" unless valid_numeric?(input[1])

    return input_to_pos input
  end

  def valid_alphabetic?(string)
    'A' <= string && string <= 'H'
  end

  def valid_numeric?(string)
    '1' <= string && string <= '8'
  end

  def input_to_pos(input)
    input[0] = input[0].codepoints[0] - 65
    input[1] = input[1].to_i - 1
    return input
  end

  def switch
    @turn = @turn == :p1 ? :p2 : :p1
  end
end
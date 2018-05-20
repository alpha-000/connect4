# Ruby Assignment Code Skeleton
# Nigel Ward, University of Texas at El Paso
# April 2015
# borrowing liberally from Gregory Brown's tic-tac-toe game

#------------------------------------------------------------------
class Board
  def initialize
  @board = [[nil,nil,nil,nil,nil,nil,nil],
            [nil,nil,nil,nil,nil,nil,nil],
            [nil,nil,nil,nil,nil,nil,nil],
            [nil,nil,nil,nil,nil,nil,nil],
            [nil,nil,nil,nil,nil,nil,nil],
            [nil,nil,nil,nil,nil,nil,nil] ]
  sum = 0
  prev = -1
  end
  class Board
    attr_accessor :board
  end
  # process a sequence of moves, each just a column number
  def addDiscs(firstPlayer, columns)
    if firstPlayer == :R
      players = [:R, :O].cycle
    else 
      players = [:O, :R].cycle
    end
    columns.each {|c| addDisc(players.next, c)}
  end 
  #adds a disk for specified player to the column
  def addDisc(player, column)
    if column >= 7 || column < 0
      puts "  addDisc(#{player},#{column}): out of bounds"
      return false   
    end 
    firstFreeRow =  @board.transpose.slice(column).rindex(nil)
    if firstFreeRow == nil  
      puts "  addDisc(#{player},#{column}): column full already"
      return false 
    end
    update(firstFreeRow, column, player)
    @board.transpose.slice(column)
    return true
  end
  #updates a spoecific location
  def update(row, col, player)
    @board[row][col] = player
  end
  #prints entire board
  def print
    puts @board.map {|row| row.map { |e| e || " "}.join("|")}.join("\n")
    puts "\n"
  end

  def hasWon? (player)#checks for all wins
    return verticalWin?(player)| horizontalWin?(player) | 
           diagonalUpWin?(player)| diagonalDownWin?(player)
  end 

  def verticalWin? (player)
    (0..6).any? {|c| (0..2).any? {|r| fourFromTowards?(player, r, c, 1, 0)}}
  end

  def horizontalWin? (player)
    (0..3).any? {|c| (0..5).any? {|r| fourFromTowards?(player, r, c, 0, 1)}}
  end

  def diagonalUpWin? (player)
    (0..3).any? {|c| (0..2).any? {|r| fourFromTowards?(player, r, c, 1, 1)}}
  end

  def diagonalDownWin? (player)
    (0..3).any? {|c| (3..5).any? {|r| fourFromTowards?(player, r, c, -1, 1)}}
  end

  def fourFromTowards?(player, r, c, dx, dy)
    return (0..3).all?{|step| @board[r+step*dx][c+step*dy] == player}
  end
  #concepts discussed with adrian for addHorizontal and Verical discussed with Adrian Orquiz
  def stopHorizontal(player)#stops a horizontal win
    if(player == :O)
      endplayer = :R
    else
      endplayer = :O
    end
    col = -1 
    sum = 0
    @board.each do |row|
      sum = 0
      col = 0
      row.each do |index|
        if index == player
          sum += 1
        else
          sum = 0
        end
        if sum == 3
          if  col + 1 < 7 && row[col+1] == nil
            addDisc(endplayer,col+1)
            return col + 1
          end
          if  col - 3 > -1 && row[col-3] == nil
            addDisc(endplayer,col-3)
            return col -3
          end
        end
        col +=1
      end
    end
      return -1       
  end 
  #adds a chip to a horizontal combination of chips of the size num
  def addHorizontal(player, num)
    col = -1 
    sum = 0
    @board.each do |row|#separates board into rows
      sum = 0
      col = 0
      gap = 0
      row.each do |index|#separates board into indexes
        if index == player
          sum += 1
        else
            sum = 0
        end
        if sum == num #Checks if sum combination has been reached and which side to add it on
          if  col + 1 < 7 && row[col+1] == nil
            addDisc(player,col+1)
            return col + 1
          end
          if  col - 3 > -1 && row[col-3] == nil
            addDisc(player,col-3)
            return col -3
          end
        end
        col +=1
      end
    end
      return -1       
  end

  def addGap(player)#Checks if a chip can be inserted into a gap horizontally
    col = -1 
    sum = 0
    @board.each do |row|
      sum = 0
      col = 0
      gap = 0
      row.each do |index|
        if index == player
          sum += 1
        else
          if gap == 0 && sum == 1 #saves there is a gap
            gap = 1
            sum += 1
          else
            gap = 0
            sum = 0
          end
        end
        if sum == 3 && gap == 1 #checks for gap
            addDisc(player,col-1)
            return col - 1
        end
        col +=1
      end
    end
      return -1       
  end
  #blocks a vertical win
  def stopVertical(player)
    if(player == :O)
      endplayer = :R
    else
      endplayer = :O
    end
    col = -1 
    sum = 0
    @board.transpose.each do |column| #grabs each row
      sum = 0
      col += 1
      column.reverse_each do |index| #checks each index in that row
        if index == nil
          break;
        end
        if index == player
          sum += 1
        else
          sum = 0
        end
      end
      if sum == 3
        addDisc(endplayer,col)
        return col
      end
    end
      return -1       
  end
  #adds a chip to a vertical combination of chips of the size num
  def addVertical(player, num)
    col = -1 
    sum = 0
    @board.transpose.each do |column|
      sum = 0
      col += 1
      column.reverse_each do |index|
        if index == nil
          break;
        end
        if index == player
          sum += 1
        else
          sum = 0
        end
      end
      if sum == num
        addDisc(player,col)
        return col
      end
    end
      return -1       
  end
  #enables a state of continuous user input
  # against a bot until game is completed
  def startGame
    turn = true
    while true 
      print
      if(turn)
        robot()
        turn = false
      else
        puts"Please input column"
        column = gets.to_i - 1
        while column < 0 || column > 7
          puts"Please input column"
          column = gets.to_i - 1
        end
        addDisc(:O,column)
        turn = true
      end
      if hasWon? :O
        print
        return true
      end
      if hasWon? :R
        print
        return false
      end
    end
  end
  #pops a chip out of the bottom row then shits index down
  def pop col
    i = 5
    while i > 1
      @board[i][col] = @board[i-1][col]
      i -= 1
    end
    @board[0][col] = nil
  end
  #robot method to choose moves
  def robot   # priority is specified by order
    move = addGap(:R)#adds chip to gap
    if(move > -1)
      return move
    end
    move = addHorizontal(:R, 3)#adds chip for horizontal win
    if(move > -1)
      return move
    end
    move = addHorizontal(:R, 2)#adds chip to 2 chips in a row
    if(move > -1)
      return move
    end
    move = stopHorizontal(:O)#adds chip to stop horizonal win
    if(move > -1)
      return move
    end
    move = addVertical(:R, 3)#adds chip for vertical win
    if(move > -1)
      return move
    end
    move = addVertical(:R, 2)#adds chip to vertical row of 2
    if(move > -1)
      return move
    end
    # move = addVertical(:O, 1)
    # if(move > -1)
    #   return move
    # end
    move = stopVertical(:O)#adds chip to block vertical win
    if(move > -1)
      return move
    end
    addDisc(:R , rand(7))#adds randome chip
    return -1
  end

end # Board
#------------------------------------------------------------------

def robotMove(player, board)   # stub
  move = board.addGap(:R)#adds chip to gap
    if(move > -1)
      return move
    end
    move = board.addHorizontal(:R, 3)#adds chip for horizontal win
    if(move > -1)
      return move
    end
    move = board.addHorizontal(:R, 2)#adds chip to 2 chips in a row
    if(move > -1)
      return move
    end
    move = board.stopHorizontal(:O)#adds chip to stop horizonal win
    if(move > -1)
      return move
    end
    move = board.addVertical(:R, 3)#adds chip for vertical win
    if(move > -1)
      return move
    end
    move = board.addVertical(:R, 2)#adds chip to vertical row of 2
    if(move > -1)
      return move
    end
    # move = addVertical(:O, 1)
    # if(move > -1)
    #   return move
    # end
    move = board.stopVertical(:O)#adds chip to block vertical win
    if(move > -1)
      return move
    end
    board.addDisc(:R , rand(7))#adds randome chip
    return -1
end


#------------------------------------------------------------------
def testResult(testID, move, targets, intent)
  if targets.member?(move)
    puts("testResult: passed test #{testID}")
  else
    puts("testResult: failed test #{testID}: \n moved to #{move}, which wasn't one of #{targets}; \n failed #{intent}")
  end
end


#------------------------------------------------------------------
# test some robot-player behaviors
testboard1 = Board.new

# puts "Pop test"
# testboard1.addDisc(:R,4)
# testboard1.addDisc(:O,4)
# testboard1.addDisc(:R,4)
# testboard1.addDisc(:O,4)
# testboard1.print
# testboard1.pop(4)
# testboard1.print
if testboard1.startGame
  puts"You win"
else
  puts"You lose"
end

# testboard1 = Board.new
# testboard1.addDisc(:R,4)
# testboard1.addDisc(:O,4)
# testboard1.addDisc(:R,5)
# testboard1.addDisc(:O,5)
# testboard1.addDisc(:R,6)
# testboard1.addDisc(:O,6)
# testResult(:block1, robotMove(:R, testboard1),[3], 'robot should block horiz')
# testboard1.print

# testboard2 = Board.new
# testboard2.addDiscs(:R, [3, 1, 3, 2, 3]);
# testResult(:block2, robotMove(:O, testboard2), [3], 'robot should block vert')
# testboard2.print
# puts "Gap test"
# testboard1 = Board.new
# testboard1.addDisc(:R,1)
# testboard1.addDisc(:R,3)
# testboard1.print
# robotMove(:R, testboard1)
# testboard1.print
# puts "horizontal test"
# testboard1 = Board.new
# testboard1.addDisc(:R,4)
# testboard1.addDisc(:R,3)
# testboard1.print
# robotMove(:R, testboard1)
# testboard1.print
# puts "vertical test"
# testboard1 = Board.new
# testboard1.addDisc(:R,4)
# testboard1.addDisc(:R,4)
# testboard1.print
# robotMove(:R, testboard1)
# testboard1.print
# testboard2 = Board.new
# testboard2.addDiscs(:O, [3, 1, 3, 2, 3, 4]);
# testResult(:block2, robotMove(:O, testboard2), [3], 'robot should complete stack')
# testboard2.print

# testboard2 = Board.new
# testboard2.addDiscs(:R, [3, 1, 4, 5, 2, 1, 6, 0, 3, 4, 5, 3, 2, 2, 6 ]);
# testResult(:block2, robotMove(:O, testboard2), [3], 'robot should complete diag')
# testboard2.print

# testboard3 = Board.new
# testboard3.addDiscs(:O, [1,1,2,2,3,3])
# testResult(:avoid, robotMove(:O, testboard3), [0,6], 'robot should avoid giving win')
# testboard3.print


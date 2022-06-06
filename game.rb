require 'yaml'
require 'colorize'
require_relative 'serialization'

class Game
    include Saving
    @@list = File.open("google-10000-english-no-swears.txt")

    def initialize 
        puts "Welcome to Hangman! "
        puts ""
        puts "Would you like to play a new game or load a saved game?"
        puts "Type 'new' for a new game and type 'load' to load a game from your device: "
        answer = gets.chomp
        if answer == 'load'
            load
        end
        @win = false
        @round = 0
        @code = generateCode
        @codeArr = separateCode(@code)
        @guessArr = Array.new(@code.length-1, '_')
        @incorrectLetters = Array.new
        @usedLetters = Array.new
        printArray(@guessArr)
        gameLoop
        
    end

    def generateCode
        loop do
            code = @@list.readlines.select { |i| i.length > 5 && i.length < 14}.sample
            sleep(1)
            if code.length >= 6 && code.length <= 12
                return code
            end
        end
        @@list.close
    end

    def gameLoop 
        while @round < 8 && @win == false
            puts ""
            puts "Mistakes Remaining: #{8-@round}".bold
            @letter = inputLetter
            if @letter.is_a?(Integer)
                break
            end
            checkGuess(@letter)
            printArray(@guessArr)
            printArray(@incorrectLetters)
            puts "\n"
            sleep(1.5)
            puts "----------------------------"
            @win = checkWin
        end

        if @letter.is_a?(Integer)
            printArray(@codeArr)
            @win = true
        end

        if @win == true
            puts "Horray! You won the game with only #{@round} mistakes."
        else
            puts "You lose. The secret word was #{@code.capitalize}".bold
        end
        abort
    end

    def inputLetter
        loop do
            puts "Enter a letter to guess or enter 'save' to save your game: "
            letter = gets.chomp.to_s.downcase

            if letter == @codeArr.join
            return 1
            end
            if letter == 'save'
                save
            end

            if letter.match(/[a-zA-Z]/) && letter.length  == 1
                if @usedLetters.include?(letter) == false
                    @usedLetters.push(letter)
                    return letter
                else
                    puts "You have already guessed this letter."
                    puts ""
                end
            else
                puts "Invalid response"
            end
        end
    end

    def printArray(arr)
        if arr == @guessArr || arr == @codeArr
        puts ""
        print "Results: "
        end
        if arr == @incorrectLetters
            if arr.length >= 1
            puts ""
            print "Incorrect Letters: ".red.bold
            end
        end

        if arr != @codeArr
        arr.each do |i|
            print "#{i} "
        end
    else
        arr.each do |i|
            print"#{i}"
        end
    end
        puts "\n"
    end

    def separateCode(code)
        arr = Array.new
        for i in 0..code.length - 2
            arr[i] = code[i]
        end
        arr
    end

    def checkGuess(letter)
        flag = false
        for i in 0..@codeArr.length - 1
            if @codeArr[i] == letter
                @guessArr[i] = letter
                flag = true
            end
        end
        if flag == false
            @incorrectLetters.push(letter)
            @round += 1
        end
    end

    def checkWin
        if @guessArr == @codeArr
            return true
        end
        return false
    end

   

end

Game.new

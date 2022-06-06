module Saving
    def save
        Dir.mkdir('saves') unless Dir.exist?('saves')
        puts "Name your game save: "
        file_name = gets.chomp.downcase
        puts "Continue saving? (y/n)"
        answer = gets.chomp.downcase
        if answer == 'y'
            file = File.open("saves/#{file_name}.yml", 'w')
            YAML.dump({
                :win => @win,
                :round => @round,
                :code => @code,
                :codeArr => @codeArr,
                :guessArr => @guessArr,
                :incorrectLetters => @incorrectLetters,
                :usedLetters => @usedLetters,
            }, file)
            file.close
            abort "The game has succesfully been saved to your local device".bold
        else
            gameLoop
        end
    end

    def load
        puts "Saved Files: #{Dir.children('./saves').map { |file| file[0...-4]} }"
        puts ""
        puts "Please enter the game file you want to load: "
        file_name = gets.chomp.downcase
        file = YAML.load(File.read("saves/#{file_name}.yml"))
        @win = file[:win]
        @round = file[:round]
        @code = file[:code]
        @codeArr = file[:codeArr]
        @guessArr = file[:guessArr]
        @incorrectLetters = file[:incorrectLetters]
        @usedLetters = file[:usedLetters]
        File.delete("saves/#{file_name}.yml")
        printArray(@guessArr)
        self.gameLoop
    end

end
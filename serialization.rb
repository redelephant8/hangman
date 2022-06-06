module Saving
    def save
        Dir.mkdir('saves') unless Dir.exist?('saves')
        file = File.open("saves/test.yml", 'w')
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
    end

    def load
        file = YAML.load(File.read("saves/test.yml"))
        @win = file[:win]
        @round = file[:round]
        @code = file[:code]
        @codeArr = file[:codeArr]
        @guessArr = file[:guessArr]
        @incorrectLetters = file[:incorrectLetters]
        @usedLetters = file[:usedLetters]
        printArray(@guessArr)
        self.gameLoop
    end

end
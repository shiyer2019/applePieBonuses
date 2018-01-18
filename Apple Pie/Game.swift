//
//  Game.swift
//  Apple Pie
//
//  Created by Student on 1/16/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation
//welcome to the Game structure! this structure is called to update the letters guessed. It takes in the letter on the selected button and iterates through each letter of the word to be guessed. If the word does not contain the letter represented in the button text, the number of moves left and subsequent apples on the tree (see updateUI() function in viewController) is decreased by one. If the button's text matches a letter, the code replaces the corresponding letter where an underscore once was. Otherwise, the underscore stays.
struct Game {
    
    var word: String
    var incorrectMovesRemaining: Int
    var guessedLetters: [Character]
    mutating func playerGuessed(letter: Character) {
        guessedLetters.append(letter)
        if !word.characters.contains(letter) {
            incorrectMovesRemaining -= 1
        }
    }
    var formattedWord: String {
        var guessedWord = ""
        for letter in word.characters {
            if guessedLetters.contains(letter) {
                guessedWord += "\(letter)"
            }
            else {
                guessedWord += "_"
            }
        }
        return(guessedWord)
    }
}

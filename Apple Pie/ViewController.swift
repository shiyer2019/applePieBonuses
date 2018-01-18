//
//  ViewController.swift
//  Apple Pie
//
//  Created by Student on 1/15/18.
//  Copyright © 2018 Student. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    var listOfWords = ["cat", "pope", "mouse", "picnic", "violins", "birthday", "cameramen", "adjectives", "haphazardly", "questionable"] //the list of words to be guessed
    let incorrectMovesAllowed = 7 //this corresponds to the "phases" of the tree, i.e. how many apples are left; after every guess, the tree image updates to the one with the number of apples corresponding to the value of incorrectMovesAllowed.
    var totalWins = 0 { //counting the number of wins
        didSet { //the didSet function sets the game to a new round after total wins is incremented
            newRound()
        }
    }
    var totalLosses = 0  { //counting the number of losses
        didSet { //the didSet function sets the game to a new round after total losses is incremented
            newRound()
        }
    }
    var totalPoints = 0
    @IBOutlet weak var correctWordLabel: UILabel! //establishing a connection between the word that the label is guessing and the code. it starts as a blank: for example, _ _ _. the code updates this string for each correct guess.
    @IBOutlet weak var scoreLabel: UILabel! //updates the total number of wins and losses after every iteration of the game
    @IBOutlet weak var treeImageView: UIImageView! //the image of the tree. this is updated to correspond the value of incorrectMovesRemaining; the name of the image is called as "Tree \(incorrectMovesRemaining)" and each image is named to correspond to this.
    @IBOutlet weak var pointsLabel: UILabel! //updates the *cumulative* number of points earned for each word guessed and each letter guessed. this updates at the end of an iteration.
    @IBOutlet weak var progressBar: UIProgressView! //a progress bar that shows how far the person is to get through each level.
    @IBOutlet weak var progressLabel: UILabel! //a word of encouragement to keep going! says that you are 1/10 more done
    @IBOutlet weak var scoreUpdateLabel: UILabel! //states how many points were earned for letters and how many were earned for guessing the word.
    
    @IBOutlet var letterButtons: [UIButton]! //establishes a connection to the self-created keyboard
    
    func enableLetterButtons(_ enable: Bool) {
        //based on the boolean operator passed through an iteration of this function, buttons are either enabled (enableLetterButtons(true)) or disabled (enableLetterButtons(false))
        for button in letterButtons {
            button.isEnabled = enable
        }
    }

    var currentGame: Game! // creating an instance of the Game structure

    func updateUI() {
        //changes the array of characters from currentGame into an array of strings and updates the correct word label to the guessed string. this was modified to use the map method, hence the commented code directly below. updates the tree image to the number of moves remaining. updates progress and score labels to match the status of currentGame when updateUI() is called
/*        var letters = [String]()
        for letter in currentGame.formattedWord.characters {
            letters.append(String(letter))
        }
*/
// map method
        let letters = currentGame.formattedWord.characters.map{String($0)}
        
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
 
        scoreLabel.text = "Wins = \(totalWins), Losses: \(totalLosses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
        if progressBar.progress == 0{
            progressLabel.text = "Let's guess some words!"
        }
        else if progressBar.progress != 0 {
            progressLabel.text = "You have completed 1/10! See the progress bar below!"
        }
    }
    
    func updateGameState() {
        if currentGame.incorrectMovesRemaining == 0 {
            totalLosses += 1
        }
        else if currentGame.word == currentGame.formattedWord {
            totalWins += 1
            progressBar.progress += 0.1
        }
        else {
            updateUI()
        }
    }
 
 
    
    func newRound() {
        //if the list of words is not empty, a new Round is started. the first word of the list of words is removed, and the new word is prepared to be guessed. an instance of the Game structure called currentGame is called with the initializers all cleared/set to a new round. the buttons are all enabled. the total points is updated. the score update label is updated to correspond with the status of the total points. the UI is then updated.
        if !listOfWords.isEmpty {
            let newWord = listOfWords.removeFirst()
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [])
            enableLetterButtons(true)
            pointsLabel.text = "Total Points = \(totalPoints)"
            if totalPoints == 0 {
                scoreUpdateLabel.text = "earn points by guessing the word!"
            }
            if totalPoints != 0 {
                scoreUpdateLabel.text = "you earned \(newWord.count - 1) points for letters and 5 points for the word."
            }
            totalPoints += 5
            totalPoints += newWord.count
            updateUI()
        }
        // The following else statement says what happens if the game is fully completed. Rather than leaving the UI 'unfinished' and simply disabling all the buttons, I updated the parts of my UI that showed progress to display text and the correct number of points.
        else {
            scoreUpdateLabel.text = "you earned all the points!"
            progressBar.progress = 1
            progressLabel.text = "Congratulations!"
            pointsLabel.text = "Total Points = 125"
            enableLetterButtons(false)
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        //when a player clicks on a button when guessing one word, that button is disabled
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }
    
    override func viewDidLoad() {
        //start a new round and update the UI to match
        super.viewDidLoad()
        newRound()
        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


//
//  ViewController.swift
//  Seven_Swifty_Words
//
//  Created by Marc Moxey on 5/27/22.
//

import UIKit

class ViewController: UIViewController {

    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        
        // create main view
        view = UIView()
        view.backgroundColor = .white
        
        // creates score label
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        scoreLabel.textColor = .black
        view.addSubview(scoreLabel)
        
        // create label for clues
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints =  false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.textColor = .black
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        // create answer label
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.textAlignment = .right
        answersLabel.text = "ANSWER"
        answersLabel.textColor = .black
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        // create current answer label
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        
        // create submit button
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        // create submit button
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        // create container to hold all 20 buttons
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        
        // takes array of constraints to always be active
        NSLayoutConstraint.activate([
            // score label contrains
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            // clue label constraints
            
            // pin the top of the clues label to the bottom of the score label
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            // pin the leading edge of the clues label to the leading edge of our layout margins, adding 100 for some space
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),

            // make the clues label 60% of the width of our layout margins, minus 100
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),

            
            // answerLabel constraint
            // also pin the top of the answers label to the bottom of the score label
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),

            // make the answers label stick to the trailing edge of our layout margins, minus 100
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),

            // make the answers label take up 40% of the available space, minus 100
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),

            // make the answers label match the height of the clues label
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
        
            
            
        ])
        
        // set some values for the width and height of each button
        let width = 150
        let height = 80

        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                //challenge 1
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.lightGray.cgColor

                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                // add it to the buttons view
                buttonsView.addSubview(letterButton)

                // and also to our letterButtons array
                letterButtons.append(letterButton)
            }
        }
        
        //temp code
        
//        answersLabel.backgroundColor = .red
//        cluesLabel.backgroundColor = .blue
//        buttonsView.backgroundColor = .green
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        loadLevel()
    }
    
    
    
    @objc func letterTapped(_ sender: UIButton) {
        
        //check if there a title, exit fi there none
        guard let buttonTitle = sender.titleLabel?.text else { return }
        //add button title to current answer text
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        //add to activatedButtons array
        activatedButtons.append(sender)
        //hide the buttons so it cant be tapped again
        sender.isHidden = true
    }
    
    func loadLevel() {
        var clueString = ""
          var solutionString = ""
          var letterBits = [String]()

          if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
              if let levelContents = try? String(contentsOf: levelFileURL) {
                  var lines = levelContents.components(separatedBy: "\n")
                  lines.shuffle()

                  for (index, line) in lines.enumerated() {
                      let parts = line.components(separatedBy: ": ")
                      let answer = parts[0]
                      let clue = parts[1]

                      clueString += "\(index + 1). \(clue)\n"

                      let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                      solutionString += "\(solutionWord.count) letters\n"
                      solutions.append(solutionWord)

                      let bits = answer.components(separatedBy: "|")
                      letterBits += bits
                    
                }
            }
        }
        //trim white space and new lines from clues and answer label
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterButtons.shuffle()
        
        //if we have same number buttons as bits
        if letterButtons.count == letterBits.count {
            //count through all the letter buttons
            for i in 0..<letterButtons.count {
                //assigned the buttons title to
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    
    @objc func  submitTapped(_ sender: UIButton) {
        
        //read out text from current TextField
        guard let answerText = currentAnswer.text else {return }
        
        //find answer text
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            //if found remove all activated buttons
            activatedButtons.removeAll()
            
            //split answer label
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            
            //at solution where the word is found and replace # of letter with the solution itself
            splitAnswers?[solutionPosition] = answerText
            
            //joined array and put it back into answer label
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            //clear out current answer text field
            currentAnswer.text = ""
            
            score += 1
            
            //deduct points if they player makes incorrect guess
           
            
         
          
            //if score divide into # of 7 evenly  w/ zero left over, level is finished
            if score % 7 == 0 {
                //show message, move to next level
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
               
            } else  if score % 7 == 5 { //challenge 3 pt2
                //Threshold to make to the next level bc of deuced points
                //show message, move to next level
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
       
        } else  {
            //challenge 2
            let ac = UIAlertController(title: "Wrong!", message:  "Try again" , preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(ac, animated: true)
            score -= 1
        }
    }
    
    
    
    
    @objc func clearTapped(_ sender: UIButton) {
        
        //clear out all the text in textField
        currentAnswer.text = ""
        
        //show all buttons in activated Button array
        for button in activatedButtons {
            button.isHidden = false
        }
        
        //remove all items from array
        activatedButtons.removeAll()
        
    }
    
    
    func levelUp(action: UIAlertAction) {
        // add one to level
        level += 1
        
        // remove all items in solutions array
        solutions.removeAll(keepingCapacity: true)
         
        // call load level
        loadLevel()
         
         //make sure all buttons are visible
        for button in letterButtons {
            button.isHidden = false
        }
    }
    
    

}


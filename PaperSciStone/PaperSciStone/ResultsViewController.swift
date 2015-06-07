//
//  ResultsViewController.swift
//  PaperSciStone
//
//  Created by 李正宁 on 6/7/15.
//  Copyright (c) 2015 Zhengning Li. All rights reserved.
//

import Foundation
import UIKit

enum Shape: String {
    case Rock = "Rock"
    case Paper = "Paper"
    case Scissors = "Scissors"
    
    // This function randomly generates an opponent's play
    static func randomShape() -> Shape {
        let shapes = ["Rock", "Paper", "Scissors"]
        let randomChoice = Int(arc4random_uniform(3))
        return Shape(rawValue: shapes[randomChoice])!
    }
}


class ResultsViewController: UIViewController {
    
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    var userChoice: Shape!
    private let opponentChoice: Shape = Shape.randomShape()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        displayResult()
    }
    
    private func displayResult() {
        // Ideally, most of this would be handled by a model.
        var imageName: String
        var imageNameString: String
        var text: String
        let matchup = "\(userChoice.rawValue) vs. \(opponentChoice.rawValue)"
        
        // Why is an exclamation point necessary? :)
        switch (userChoice!, opponentChoice) {
        case let (user, opponent) where user == opponent:
            text = "\(matchup): it's a tie!"
            imageName = "tie"
        case (.Rock, .Scissors), (.Paper, .Rock), (.Scissors, .Paper):
            text = "You win with \(matchup)!"
            imageName = "\(userChoice.rawValue)-\(opponentChoice.rawValue)"
        default:
            text = "You lose with \(matchup) :(."
            imageName = "\(opponentChoice.rawValue)-\(userChoice.rawValue)"
        }
        
        imageName = imageName.lowercaseString
        resultImage.image = UIImage(named: imageName)
        resultLabel.text = text
    }
    
    @IBAction func playAgain() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
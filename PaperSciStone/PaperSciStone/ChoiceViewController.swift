//
//  ViewController.swift
//  PaperSciStone
//
//  Created by 李正宁 on 6/7/15.
//  Copyright (c) 2015 Zhengning Li. All rights reserved.
//

import UIKit

class ChoiceViewController: UIViewController {

    
    @IBAction func playRock(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ResultsViewController") as! ResultsViewController
        vc.userChoice = getUserShape(sender)
        presentViewController(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func playPaper(sender: UIButton) {
        performSegueWithIdentifier("play", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
            if segue.identifier == "play" {
                let vc = segue.destinationViewController as!
                    ResultsViewController
                vc.userChoice = getUserShape(sender as! UIButton)
            }
    }
    
    // The enum "Shape" represents a play or move
    private func getUserShape(sender: UIButton) -> Shape {
        // Titles are set to one of: Rock, Paper, or Scissors
        let shape = sender.titleForState(.Normal)!
        return Shape(rawValue: shape)!
    }
}


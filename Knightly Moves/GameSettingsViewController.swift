//
//  GameSettingsViewController.swift
//  Knightly Moves
//
//  Created by Kiera Cawley on 6/7/16.
//  Copyright © 2016 Kiera Cawley. All rights reserved.
//

import UIKit

class GameSettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var piecePickerView: UIPickerView!
    let chessPieces = ["Knight", "Rook", "Bishop", "Queen"]
    let times = ["10 seconds", "15 seconds", "20 seconds", "25 seconds", "30 seconds"]
    let timeInts = [10, 15, 20, 25, 30]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        piecePickerView.delegate = self
        piecePickerView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1{
            return times.count
        }
        return chessPieces.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1{
            return times[row]
        }
        return chessPieces[row]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationViewController = segue.destinationViewController as! GameViewController
        destinationViewController.chessPiece = chessPieces[piecePickerView.selectedRowInComponent(0)]
        destinationViewController.timeLeft = timeInts[piecePickerView.selectedRowInComponent(1)]
        
        let playerPosition = (Int(arc4random_uniform(4) + 1), Int(arc4random_uniform(8) + 1))
        var monsterPosition = (Int(arc4random_uniform(4) + 5), Int(arc4random_uniform(8) + 1))
        
        while(chessPieces[piecePickerView.selectedRowInComponent(0)] == "Bishop" && getBackgroundColor(NSIndexPath(forItem: playerPosition.0 - 1, inSection: playerPosition.1 - 1)) != getBackgroundColor(NSIndexPath(forItem: monsterPosition.0 - 1, inSection: monsterPosition.1 - 1))){
            monsterPosition = (Int(arc4random_uniform(4) + 5), Int(arc4random_uniform(8) + 1))
        }
        var spikes:[(Int, Int)] = []
        
        for _ in 1...8{
            var newSpike = (0,0)
            while (newSpike == (0,0) || newSpike == playerPosition || newSpike == monsterPosition || isInArray(spikes, element: newSpike)){
                newSpike = (Int(arc4random_uniform(8) + 1), Int(arc4random_uniform(8) + 1))
            }
            spikes.append(newSpike)
        }
        destinationViewController.playerPosition = playerPosition
        destinationViewController.monsterPosition = monsterPosition
        destinationViewController.spikes = spikes
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func getBackgroundColor(indexpath: NSIndexPath) -> UIColor{
        if(indexpath.section % 2 == indexpath.item % 2){
            return UIColor.whiteColor()
        }
        return UIColor.blackColor()
    }

    
    func isInArray(array:[(Int, Int)], element: (Int,Int)) -> Bool{
        for item in array{
            if item == element{
                return true
            }
        }
        return false
    }

}

//
//  GameViewController.swift
//  Knightly Moves
//
//  Created by Kiera Cawley on 6/7/16.
//  Copyright © 2016 Kiera Cawley. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    var chessPiece = "Knight"
    var playerPosition = (0,0)
    var monsterPosition = (0,0)
    var spikes = [(0,0)]
    var timeLeft = 30
    
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var board: UICollectionView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertLabel: UILabel!
    
    func update() {
        if alertView.hidden == true{
            timeLeft -= 1
            timeRemainingLabel.text = String(timeLeft)
            if timeLeft == 0{
                alertView.hidden = false
                alertLabel.text = "Time's up! Try again."
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        board.delegate = self
        board.dataSource = self
        alertView.hidden = true
        _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameViewController.update), userInfo: nil, repeats: true)
        timeRemainingLabel.text = String(timeLeft)
        
        
          // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("boardCell", forIndexPath: indexPath)
        cell.backgroundColor = getBackgroundColor(indexPath)
        let coordiates = (indexPath.item + 1, indexPath.section + 1 )
        
        if isInArray(spikes, element: coordiates){
            let imageView = UIImageView(image: UIImage(named: "spikes"))
            imageView.frame = CGRectMake(0, 0, 40, 40)
            cell.backgroundView = UIView()
            cell.backgroundView?.addSubview(imageView)
        }
        
        if coordiates == playerPosition{
            let imageView = UIImageView(image: UIImage(named: chessPiece.lowercaseString))
            imageView.frame = CGRectMake(0, 0, 40, 40)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            cell.backgroundView = UIView()
            cell.backgroundView?.addSubview(imageView)
        }
        if coordiates == monsterPosition{
            let imageView = UIImageView(image: UIImage(named: "monster"))
            imageView.frame = CGRectMake(0, 0, 40, 40)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            cell.backgroundView = UIView()
            cell.backgroundView?.addSubview(imageView)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var validMove = false
        
        if chessPiece == "Knight"{
            validMove = isValidKnightMove(playerPosition, moveTo: (indexPath.item + 1, indexPath.section + 1 ))
        }
        if chessPiece == "Rook"{
            validMove = isValidRookMove(playerPosition, moveTo: (indexPath.item + 1, indexPath.section + 1 ))
        }
        if chessPiece == "Bishop"{
            validMove = isValidBishopMove(playerPosition, moveTo: (indexPath.item + 1, indexPath.section + 1 ))
        }
        if chessPiece == "Queen"{
            validMove = isValidQueenMove(playerPosition, moveTo: (indexPath.item + 1, indexPath.section + 1 ))
        }

        
        if validMove{
            let oldCell = board.cellForItemAtIndexPath(NSIndexPath(forRow:playerPosition.0 - 1 , inSection: playerPosition.1 - 1))
            let newCell = board.cellForItemAtIndexPath(indexPath)
            
            oldCell!.backgroundView!.subviews[0].removeFromSuperview()
            
            let imageView = UIImageView(image: UIImage(named: chessPiece.lowercaseString))
            imageView.frame = CGRectMake(0, 0, 40, 40)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            newCell!.backgroundView = UIView()
            newCell!.backgroundView?.addSubview(imageView)
            
            playerPosition = (indexPath.item + 1, indexPath.section + 1 )
            if playerPosition == monsterPosition{
                alertView.hidden = false
                alertLabel.text = "Congratulations! You win!"
            }
        }
        
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
    func isValidKnightMove(start:(Int, Int), moveTo: (Int, Int)) -> Bool{
        let isOnSpike: Bool = isInArray(spikes, element: moveTo)
        let differenceInX: Int = abs(start.0 - moveTo.0)
        let differenceInY: Int = abs(start.1 - moveTo.1)
        if (!isOnSpike) && ((differenceInX == 2 && differenceInY == 1) || (differenceInX == 1 && differenceInY == 2)){
            return true
        }
        return false
    }
    func isValidRookMove(start:(Int, Int), moveTo: (Int, Int)) -> Bool{
        let isOnSpike: Bool = isInArray(spikes, element: moveTo)
        if(!isOnSpike){
            if(start.0 == moveTo.0){
                var a = start.1
                var b = moveTo.1
                if (a > b){
                    a = moveTo.1
                    b = start.1
                }
                for x in a...b{
                    if isInArray(spikes, element:(start.0, x)) {
                       return false
                    }
                }
                return true
            }
            if(start.1 == moveTo.1){
                var a = start.0
                var b = moveTo.0
                if (a > b){
                    a = moveTo.0
                    b = start.0
                }
                for x in a...b{
                    if isInArray(spikes, element:(x, start.1)) {
                        return false
                    }
                }
                return true
            }
        }
        return false
    }
    
    func isValidBishopMove(start:(Int, Int), moveTo: (Int, Int)) -> Bool {
        let isOnSpike: Bool = isInArray(spikes, element: moveTo)
        if(!isOnSpike){
            let differenceInX = start.0 - moveTo.0
            let differenceInY = start.1 - moveTo.1
            
            if differenceInX == differenceInY{
                for x in 0...abs(differenceInX){
                    var currentCoordinate = (0,0)
                    if(start.0 > moveTo.0){
                        currentCoordinate = (moveTo.0 + x, moveTo.1 + x)
                    }
                    else{
                        currentCoordinate = (start.0 + x, start.1 + x)
                    }
                    if isInArray(spikes, element: currentCoordinate){
                        return false
                    }
                }
                return true
            }
            if differenceInX == -differenceInY{
                for x in 0...abs(differenceInX){
                    var currentCoordinate = (0,0)
                    if(start.0 > moveTo.0){
                        currentCoordinate = (moveTo.0 + x, moveTo.1 - x)
                    }
                    else{
                        currentCoordinate = (moveTo.0 - x, moveTo.1 + x)
                    }
                    if isInArray(spikes, element: currentCoordinate){
                        return false
                    }
                }
                return true
            }
        }
        return false
    }
    
    func isValidQueenMove(start:(Int, Int), moveTo: (Int, Int)) -> Bool{
        if(isValidRookMove(start, moveTo: moveTo) || isValidBishopMove(start, moveTo: moveTo)){
            return true
        }
        
        return false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

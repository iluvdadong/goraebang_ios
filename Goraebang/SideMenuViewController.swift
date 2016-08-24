//
//  SideMenuViewController.swift
//  Goraebang
//
//  Created by Sohn on 8/22/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

// _rearViewRevealWidth = 220.0f; rearView 

class SideMenuViewController: UIViewController {
    
    var smallUIView:UIView!
    var firstContainer:UIView!
    var secondContainer:UIView!
    var thirdContainer:UIView!
    var fourthContainer:UIView!
    
    // MARK: firstContainer 변수
    var FCStartingXPoint:CGFloat!
    var FCStartingYPoint:CGFloat!
    var FCWidth:CGFloat!
    var FCHeight:CGFloat!
    
    // MARK: secondContainer 변수
    var SCStartingXPoint:CGFloat!
    var SCStartingYPoint:CGFloat!
    var SCWidth:CGFloat!
    var SCHeight:CGFloat!
    
    // MARK: thirdContainer 변수
    var TCStartingXPoint:CGFloat!
    var TCStartingYPoint:CGFloat!
    var TCWidth:CGFloat!
    var TCHeight:CGFloat!
    
    //Mark: fourthContainer 변수
    
    var fourthContainerStartingXPoint:CGFloat!
    var fourthContainerStarintgYPoint:CGFloat!
    var fourthContainerWidth:CGFloat!
    var fourthContainerHeight:CGFloat!
    
    // smallUIVIew 안에 컨테이너 4개 생성
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSize(view.bounds.width)
        
        makeSideView()
        // Do any additional setup after loading the view.
    }
    
    func setSize(phoneSize:CGFloat){
        
        if(phoneSize == 320){ // 4inch
            FCStartingXPoint = 0
            FCStartingYPoint = 0
            FCWidth = 220
            FCHeight = 200
            SCStartingXPoint = 0
            SCStartingYPoint = FCStartingYPoint + FCHeight
            SCWidth = 220
            SCHeight = 120
            TCStartingXPoint = 0
            TCStartingYPoint = SCStartingYPoint + SCHeight
            TCWidth = 220
            TCHeight = 140
            fourthContainerStartingXPoint = 0
            fourthContainerStarintgYPoint = TCStartingYPoint + TCHeight
            fourthContainerWidth = 220
            fourthContainerHeight = 108
        } else if(phoneSize == 375){ // 4.7inch
            
        } else{ // 5.5inch
            
        }
    }
    
    func makeSideView(){
        smallUIView = UIView(frame: CGRect(x: 0, y: 0, width: 220, height: view.bounds.height))
        smallUIView.backgroundColor = UIColor(red: 53/255, green: 53/255, blue: 53/255, alpha: 1.0)
        view.addSubview(smallUIView)
        
        firstContainer = UIView(frame: CGRect(x: FCStartingXPoint, y: FCStartingYPoint, width: FCWidth, height: FCHeight))
        view.addSubview(firstContainer)
        
        fillFirstContainer()
        
        secondContainer = UIView(frame: CGRect(x: SCStartingXPoint, y: SCStartingYPoint, width: SCWidth, height: SCHeight))
        view.addSubview(secondContainer)
        
        fillSecondContainer()
        
        thirdContainer = UIView(frame: CGRect(x: TCStartingXPoint, y: TCStartingYPoint, width: TCWidth, height: TCHeight))
        view.addSubview(thirdContainer)
        
        fillThirdContainer()
        
        fourthContainer = UIView(frame: CGRect(x: fourthContainerStartingXPoint, y: fourthContainerStarintgYPoint, width: fourthContainerWidth, height: fourthContainerHeight))
        view.addSubview(fourthContainer)
        
        fillFourthContainer()
        
        makeDivisionLine()
    }
    
    func makeDivisionLine(){
        let divisionLineWidth:CGFloat = 200
        let divisionLineStartXPoint:CGFloat = 10
        let divisionLineColor = UIColor.darkGrayColor()
        
        let firstDivisionLine = UIView(frame: CGRect(x: divisionLineStartXPoint, y: SCStartingYPoint - 1, width: 200, height: 1))
        firstDivisionLine.backgroundColor = divisionLineColor
        view.addSubview(firstDivisionLine)
        
        let secondDivisionLine = UIView(frame: CGRect(x: divisionLineStartXPoint, y: TCStartingYPoint - 1, width: divisionLineWidth, height: 1))
        secondDivisionLine.backgroundColor = divisionLineColor
        view.addSubview(secondDivisionLine)

        let thirdDivisionLine = UIView(frame: CGRect(x: divisionLineStartXPoint, y: fourthContainerStarintgYPoint - 1, width: divisionLineWidth, height: 1))
        thirdDivisionLine.backgroundColor = divisionLineColor
        view.addSubview(thirdDivisionLine)

    }
    
    func makeContents(){
        
        
        
    }
    
    func fillFirstContainer(){
        let userProfileImage = UIImageView(frame: CGRect(x: 80, y: 40, width: 60, height: 60))
        userProfileImage.backgroundColor = UIColor.blueColor()
        firstContainer.addSubview(userProfileImage)
        
        let userName = UILabel(frame: CGRect(x: 60, y: 110, width: 100, height: 20))
        userName.text = "고래방 님"
        userName.font = userName.font.fontWithSize(14)
        userName.textColor = UIColor.whiteColor()
        userName.textAlignment = NSTextAlignment.Center
        firstContainer.addSubview(userName)
    }
    
    func fillSecondContainer(){
        let homeButton = UIButton(frame: CGRect(x: 40, y: 20, width: 140, height: 20))
        homeButton.setTitle("홈으로", forState: .Normal)
        homeButton.userInteractionEnabled = true
        homeButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        homeButton.tag = 0
        homeButton.addTarget(self, action: #selector(switchTab), forControlEvents: .TouchUpInside)
        secondContainer.addSubview(homeButton)
        
        let searchButton = UIButton(frame: CGRect(x: 40, y: 50, width: 140, height: 20))
        searchButton.setTitle("노래 검색하기", forState: .Normal)
        searchButton.userInteractionEnabled = true
        searchButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        searchButton.tag = 1
        searchButton.addTarget(self, action: #selector(switchTab), forControlEvents: .TouchUpInside)
        secondContainer.addSubview(searchButton)
        
        let recommendButton = UIButton(frame: CGRect(x: 40, y: 80, width: 140, height: 20))
        recommendButton.setTitle("노래 추천받으러 가기", forState: .Normal)
        recommendButton.userInteractionEnabled = true
        recommendButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        recommendButton.tag = 2
        recommendButton.addTarget(self, action: #selector(switchTab), forControlEvents: .TouchUpInside)
        secondContainer.addSubview(recommendButton)
    }
    
    
    
    func fillThirdContainer(){
        let myListButton = UIButton(frame: CGRect(x: 40, y: 10, width: 140, height: 20))
        myListButton.setTitle("마이리스트", forState: .Normal)
        myListButton.userInteractionEnabled = true
        myListButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        myListButton.tag = 3
        myListButton.addTarget(self, action: #selector(switchTab), forControlEvents: .TouchUpInside)
        thirdContainer.addSubview(myListButton)
        
        let statisticButton = UIButton(frame: CGRect(x: 40, y: 40, width: 140, height: 20))
        statisticButton.setTitle("취향통계 분석", forState: .Normal)
        statisticButton.userInteractionEnabled = true
        statisticButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        statisticButton.tag = 3  // 테이블 뷰의 다른 섹션으로 넘어가야 해서 매개변수가 두개 필요하다.
        statisticButton.addTarget(self, action: #selector(switchTab), forControlEvents: .TouchUpInside)
        thirdContainer.addSubview(statisticButton)
        
        let blacklistButton = UIButton(frame: CGRect(x: 40, y: 70, width: 140, height: 20))
        blacklistButton.setTitle("차단한 노래", forState: .Normal)
        blacklistButton.userInteractionEnabled = true
        blacklistButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        blacklistButton.tag = 3
        blacklistButton.addTarget(self, action: #selector(switchTab), forControlEvents: .TouchUpInside)
        thirdContainer.addSubview(blacklistButton)
        
        let settingsButton = UIButton(frame: CGRect(x: 40, y: 100, width: 140, height: 20))
        settingsButton.setTitle("Settings", forState: .Normal)
        settingsButton.userInteractionEnabled = true
        settingsButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        settingsButton.tag = 3
        settingsButton.addTarget(self, action: #selector(switchTab), forControlEvents: .TouchUpInside)
        thirdContainer.addSubview(settingsButton)
    }
    
    func fillFourthContainer(){
        let helpButton = UIButton(frame: CGRect(x: 40, y: 20, width: 140, height: 20))
        helpButton.setTitle("도움말", forState: .Normal)
        helpButton.userInteractionEnabled = true
        helpButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        // tag 4번으로 하나 더 생성
        
        fourthContainer.addSubview(helpButton)
        
        let logoutButton = UIButton(frame: CGRect(x: 40, y: 50, width: 140, height: 20))
        logoutButton.setTitle("로그아웃", forState: .Normal)
        logoutButton.userInteractionEnabled = true
        logoutButton.addTarget(self, action: #selector(logout), forControlEvents: .TouchUpInside)
        // 로그인 화면으로 돌아가는 코드 추가 (새로운 액션 함수)
        
        fourthContainer.addSubview(logoutButton)
    }
    
    func switchTab(sender: UIButton){
        print("home button tapped")
        let tab = self.revealViewController().frontViewController as! MyTabBarController
        tab.changeIndex(sender.tag)
    }
    
    func logout(sender: UIButton){
        self.performSegueWithIdentifier("unwindToLoginView", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

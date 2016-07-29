//
//  MyListTabController.swift
//  Goraebang
//
//  Created by Sohn on 7/23/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class MyListTabController: UIViewController {
    
    // http://52.78.101.90/json/song , json url
    
    // 임시로 현재 마이리스트의 개수를 저장
    let temporaryNumberOfSong = 5
    
    var myListTopBackgroundImageView: UIImageView!
    var myListScrollView: UIScrollView!
    var divisionLineForEachContent: UIView! // 각 컨텐츠 구분선
    var myListContentView : UIView! // 스크롤 뷰의 노래 하나를 담을 뷰
    
    // 아래의 뷰들은 myListContentView에 포함된다.(내부 구분선, 리스트 순서 번호, 앨범 이미지, 노래방 번호, 노래 제목, 가수 제목)
    var divisionLineForContentInside : UIView!
    var numberOfSongLabelForContent: UILabel!
    var albumImageForContent: UIImageView!
    var karaokeNumberOfSongLabelForContent: UILabel!
    var songTitleLabelForContent: UILabel!
    var singerNameLabelForContent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeMylistFixedTopBackground()
        makeMylistScrollView()
        addContents(temporaryNumberOfSong)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeMylistFixedTopBackground(){
        myListTopBackgroundImageView = UIImageView(image: UIImage(named: "HomeTopBackground"))
        myListTopBackgroundImageView.frame = CGRectMake(0, 64, view.bounds.width, 150)
        view.addSubview(myListTopBackgroundImageView)
        
        // MARK: Add Blur Effect
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        // Blur radius 조절, 다른 방법 찾을 것
        blurEffectView.alpha = 0.8
        blurEffectView.frame = CGRectMake(0, 0, view.bounds.width, 150)
        myListTopBackgroundImageView.addSubview(blurEffectView)
    }
    
    func makeMylistScrollView(){
        // 스크롤 뷰를 사용해서 상단 이미지 고정하고 리스트를 수직으로 스크롤 할 수 있도록
        // superview << scrollview << imageview[](or label)
        // MARK: superview << scrollview
        
        myListScrollView = UIScrollView(frame: CGRectMake(5, 220, view.bounds.width-10, view.bounds.height-280))
        
        // remove scroll indicator
        myListScrollView.showsVerticalScrollIndicator = false
        
        myListScrollView.contentSize = CGSizeMake(view.bounds.width-10, 85 * CGFloat(temporaryNumberOfSong)-10)
        myListScrollView.backgroundColor = UIColor(red: 41, green: 45, blue: 46, alpha: 0)
        view.addSubview(myListScrollView)
    }
    
    func addContents(numberOfContents: Int){
        var x = 0
        
        for i in 0...numberOfContents - 1 {
            myListContentView = UIView(frame : CGRectMake(0, CGFloat(x), view.bounds.width-10, 80))
            myListContentView.backgroundColor = UIColor(red: 41, green: 45, blue: 46, alpha: 0)
            myListScrollView.addSubview(myListContentView)
            
            // 노래 순서 라벨, 글씨 크기 조절할 것
            numberOfSongLabelForContent = UILabel(frame: CGRectMake(0, 0, view.bounds.width*0.1, 80))
            numberOfSongLabelForContent.backgroundColor = UIColor(red: 41, green: 45, blue: 46, alpha: 0)
            numberOfSongLabelForContent.text = String(i+1)
            numberOfSongLabelForContent.textAlignment = NSTextAlignment.Center
            numberOfSongLabelForContent.textColor = UIColor.whiteColor()
            numberOfSongLabelForContent.font = UIFont(name: numberOfSongLabelForContent.font.fontName, size:12)
            myListContentView.addSubview(numberOfSongLabelForContent)
            
            // 앨범 이미지 뷰
            albumImageForContent = UIImageView(image: UIImage(named: "AlbumTest1"))
            albumImageForContent.frame = CGRectMake(view.bounds.width*0.1+10, 10, 60, 60)
            myListContentView.addSubview(albumImageForContent)
            
            // 노래방 번호 라벨 추가
            karaokeNumberOfSongLabelForContent = UILabel(frame: CGRectMake(80+view.bounds.width*0.1, 0, view.bounds.width*0.2, 80))
            karaokeNumberOfSongLabelForContent.backgroundColor = UIColor(red: 41, green: 45, blue:46, alpha: 0)
            karaokeNumberOfSongLabelForContent.text = String(i*i*i+20000)
            karaokeNumberOfSongLabelForContent.textAlignment = NSTextAlignment.Center
            karaokeNumberOfSongLabelForContent.textColor = UIColor.whiteColor()
            karaokeNumberOfSongLabelForContent.font = UIFont(name: karaokeNumberOfSongLabelForContent.font.fontName, size:14)
            myListContentView.addSubview(karaokeNumberOfSongLabelForContent)
            
            // Content View 가운데 구분선 추가 (R:60 G:61 B:63)
            divisionLineForContentInside = UIView(frame: CGRectMake(90+view.bounds.width*0.3, 20, 1, 40))
            divisionLineForContentInside.backgroundColor = UIColor.darkGrayColor()
            myListContentView.addSubview(divisionLineForContentInside)
            
            // 노래제목 라벨
            songTitleLabelForContent = UILabel(frame: CGRectMake(100 + view.bounds.width*0.3, 20, view.bounds.width*0.3, 20))
            songTitleLabelForContent.backgroundColor = UIColor(red: 41, green: 45, blue:46, alpha:0)
            songTitleLabelForContent.text = "Oasis"
            songTitleLabelForContent.textAlignment = NSTextAlignment.Center
            songTitleLabelForContent.textColor = UIColor.whiteColor()
            songTitleLabelForContent.font = UIFont(name: songTitleLabelForContent.font.fontName, size:14)
            myListContentView.addSubview(songTitleLabelForContent)
            
            // 가수명 라벨
            singerNameLabelForContent = UILabel(frame: CGRectMake(100 + view.bounds.width*0.3, 40, view.bounds.width*0.3, 20))
            singerNameLabelForContent.backgroundColor = UIColor(red: 41, green: 45, blue:46, alpha:0)
            singerNameLabelForContent.text = "Crush"
            singerNameLabelForContent.textAlignment = NSTextAlignment.Center
            singerNameLabelForContent.textColor = UIColor.whiteColor()
            singerNameLabelForContent.font = UIFont(name: singerNameLabelForContent.font.fontName, size:12)
            myListContentView.addSubview(singerNameLabelForContent)
            
            // 컨텐츠 간의 구분선 뷰 추가
            divisionLineForEachContent = UIView(frame: CGRectMake(0, CGFloat(x+82), view.bounds.width-10, 1))
            divisionLineForEachContent.backgroundColor = UIColor.darkGrayColor()
            myListScrollView.addSubview(divisionLineForEachContent)
            // 이 새로운 View에다가 앨범 이미지뷰, 노래방 번호 라벨, 노래 제목 라벨, 가수명 라벨을 추가하고 for loop이용해서 마이리스트의 개수만큼 반복.
            
            x += 85 // x 좌표 증가
        }
    }
    
    // dictionary에 저장?
    func getJsonFromGoraebang(url: NSURL){
        
    }

}

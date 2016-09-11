
import UIKit
import SwiftyJSON

class HomeTabController: UIViewController, UIScrollViewDelegate {
    // width, 4inch :320, 4.7inch :375, 5.5inch: 414

    let goraebang_url = GlobalSetting.getGoraebangURL()
    // MARK: Variables
    var bottomContainerScrollView: UIScrollView!
    var bottomTopChartContainer: UIView!
    var bottomNewSongContainer: UIView!
    
    //MARK: bottomContainerScrollView variables
    var bottomContainerContentsHeight:CGFloat!
    
    // MARK: bottomTopChartContainer variables
    var bottomTopChartContainerX:CGFloat!
    var bottomTopChartContainerY:CGFloat!
    var bottomTopChartWidth:CGFloat!
    var bottomTopChartHeight:CGFloat!
    
    // MARK: bottomPopularContainer variables
    var bottomNewSongContainerX:CGFloat!
    var bottomNewSongContainerY:CGFloat!
    var bottomNewSongWidth:CGFloat!
    var bottomNewSongHeight:CGFloat!
    
    // MARK: bottomPopularContainer variables
    
    var scrollView: UIScrollView!
    var newSongScrollView: UIScrollView!
    
    var imageView: UIImageView!
    var labelForImageViewArray: UILabel!
    var imageViewForSongTag: UIImageView!
    
    var viewForAlbumTitle: UIView!
    var songLabelForAlbum: UILabel!
    var artistLabelForAlbum: UILabel!
    
    var homeTopBackgroundImageView: UIImageView!
    
    var homeAlbumPageControl: UIPageControl!
    var newSongPageControl: UIPageControl!
    
    var homeNavBar: UINavigationBar!
    
    var themeTitleArray: [String]!
    
    // MARK : 고래방 차트에서 사용할 사이즈 관련 변수
    var contentNum:Int! // chart에서 불러올 개수
    var albumSizeForVariousPhoneWidth:CGFloat! // 각 크기의 휴대폰에서 사용할 앨범의 사이즈
    var albumSmallInterval:CGFloat! // 앨범 사이 작은 간격
    var albumBigInterval:CGFloat! // 3번째 앨범과 다음 페이지 사이의 큰 간격
    var topChartContainerContentsSizeWidth:CGFloat!
    var topChartContainerContentsSizeHeight:CGFloat!
    var phoneSizeString:String!
    
    // MARK: TOP100 Detail View 위치 변수
    var showTop100DetailButtonStartingXPoint:CGFloat!
    var showTop100DetailButtonStartingYPoint:CGFloat!
    var showTop100DetailButtonWidth:CGFloat!
    var showTop100DetailButtonHeight:CGFloat!
    
    // MARK: 좌표 번수들
    var topBackgroundStartingYPoint:CGFloat!
    var topBackgroundHeight:CGFloat!
    
    var bottomContainerStartingYPoint:CGFloat!
    var bottomContainerHeight:CGFloat!
    
    var viewForAlbumTitleStartingYPoint:CGFloat!
    var themeLabelStartingYPoint:CGFloat!
    
    // MARK : JSON 읽을 JSON 변수
    var topChartReadableJSON: JSON!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setSize(view.bounds.width) // 초기설정
        
        getTopChart()
        makeHomeTopBackground()
        makeBottomContainer()
        
        makeAlbumScrollView()
        addAlbumContents()
        
        scrollView.delegate = self
        newSongScrollView.delegate = self
        
        //        print("iPhone width : \(view.bounds.width)")
    }
    
    // MARK: 아이폰 사이즈 마다 변수 값 세팅
    func setSize(phoneSize:CGFloat){
        contentNum = 6
        
        if(phoneSize == 320){ // 4inch
            phoneSizeString = "4inch"
            albumSizeForVariousPhoneWidth = 91
            albumSmallInterval = 3.5
            albumBigInterval = 40
            topBackgroundStartingYPoint = 64
            topBackgroundHeight = 120
            bottomContainerStartingYPoint = topBackgroundStartingYPoint + topBackgroundHeight
            bottomContainerHeight = self.view.bounds.height - bottomContainerStartingYPoint
            viewForAlbumTitleStartingYPoint = albumSizeForVariousPhoneWidth - 40
            themeLabelStartingYPoint = 285
            
        } else if(phoneSize == 375){ // 4.7inch
            phoneSizeString = "4.7inch"
            albumSizeForVariousPhoneWidth = 109
            albumSmallInterval = 4
            albumBigInterval = 40
            topBackgroundStartingYPoint = 64
            topBackgroundHeight = 120
            bottomContainerStartingYPoint = topBackgroundStartingYPoint + topBackgroundHeight
            bottomContainerHeight = self.view.bounds.height - bottomContainerStartingYPoint
            viewForAlbumTitleStartingYPoint = albumSizeForVariousPhoneWidth - 40
            themeLabelStartingYPoint = 305
        } else{ // 5.5inch
            phoneSizeString = "5.5inch"
            albumSizeForVariousPhoneWidth = (phoneSize-27)/3
            albumSmallInterval = 3.5
            albumBigInterval = 40
            topBackgroundStartingYPoint = 64
            topBackgroundHeight = 120
            bottomContainerStartingYPoint = topBackgroundStartingYPoint + topBackgroundHeight
            bottomContainerHeight = self.view.bounds.height - bottomContainerStartingYPoint
            viewForAlbumTitleStartingYPoint = albumSizeForVariousPhoneWidth - 40
            themeLabelStartingYPoint = 365
        }
        
        bottomTopChartHeight = albumSizeForVariousPhoneWidth*2 + 100
        
        bottomNewSongContainerY = bottomTopChartHeight
        bottomNewSongHeight = albumSizeForVariousPhoneWidth + 60
        
        topChartContainerContentsSizeWidth = (phoneSize) * 3
        topChartContainerContentsSizeHeight = albumSizeForVariousPhoneWidth*2 + 20
        // print(albumSizeForVariousPhoneWidth)
        
        // 아래 tab 사이즈 만큼 +70 해줬다.
        bottomContainerContentsHeight = bottomTopChartHeight + bottomNewSongHeight + 70
        // ShowTop100DetailView 설정
        showTop100DetailButtonStartingXPoint = phoneSize - 100
        showTop100DetailButtonStartingYPoint = 20
        showTop100DetailButtonWidth = 80
        showTop100DetailButtonHeight = 50
    }
    
    // MARK: SwiftyJSON 사용해서 top 100 chart를 불러온다.
    func getTopChart(){
        // 서버 문제있을 때?
        let url:NSURL = NSURL(string: "\(goraebang_url)/json/song")!
        let jsonData = NSData(contentsOfURL: url) as NSData!
        
        topChartReadableJSON = JSON(data: jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
    }
    
    // MARK: 화면 상단의 백그라운드 이미지 생성
    func makeHomeTopBackground(){
        homeTopBackgroundImageView = UIImageView(image: UIImage(named: "HomeTopBackground"))
        homeTopBackgroundImageView.frame = CGRectMake(0, topBackgroundStartingYPoint, view.bounds.width, topBackgroundHeight)
        
        view.addSubview(homeTopBackgroundImageView)
        // 4, 4.7, 5.5 inch 크기 별로 설정 view.bounds.width(height)의 배율로 하는게 좋을 것 같다.
    }
    
    // MARK: 화면 하단에 Chart를 표시하는 앨범과, 테마를 담을 Container
    func makeBottomContainer(){
        bottomContainerScrollView = UIScrollView(frame: CGRectMake(0, bottomContainerStartingYPoint, view.bounds.width, bottomContainerHeight))
        bottomContainerScrollView.showsHorizontalScrollIndicator = true
        bottomContainerScrollView.contentSize = CGSizeMake(view.bounds.width, bottomContainerContentsHeight)
        
        // MARK: 고래방 TOP 100 차트 타이틀 라벨
        makeTopChartContainer()
        makeNewSongContainer()
        
        view.addSubview(bottomContainerScrollView)
    }
    
    func makeTopChartContainer(){
        bottomTopChartContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: bottomTopChartHeight))
        //        bottomTopChartContainer.backgroundColor = UIColor.darkGrayColor()
        let chartLabel = UILabel(frame: CGRectMake(20, 0, 200, 50))
        chartLabel.textAlignment = NSTextAlignment.Left
        chartLabel.textColor = UIColor.whiteColor()
        chartLabel.text = "고래방 차트"
        chartLabel.font = UIFont.boldSystemFontOfSize(15)
        bottomTopChartContainer.addSubview(chartLabel)
        
        // MARK: 고래방 Top 100 Detail View 버튼
        
        let showTop100DetailButton = UIButton(frame: CGRectMake(showTop100DetailButtonStartingXPoint, 0, showTop100DetailButtonWidth, showTop100DetailButtonHeight))
//        showTop100DetailButton.backgroundColor = UIColor.blueColor()
        
        let titleForTop100DetailButton = UILabel(frame: CGRect(x: 0, y: 0, width:showTop100DetailButtonWidth, height: 50))
        titleForTop100DetailButton.text = "전체보기 >"
//        titleForTop100DetailButton.tintColor = UIColor.redColor()
        titleForTop100DetailButton.textColor = UIColor.whiteColor()
        titleForTop100DetailButton.font = titleForTop100DetailButton.font.fontWithSize(13)
        
        titleForTop100DetailButton.textAlignment = NSTextAlignment.Right
        showTop100DetailButton.addSubview(titleForTop100DetailButton)
        
        showTop100DetailButton.titleLabel?.textColor = UIColor.whiteColor()
        
        showTop100DetailButton.addTarget(self, action: #selector(showTopDetailButtonAction), forControlEvents: .TouchUpInside)
        bottomTopChartContainer.addSubview(showTop100DetailButton)
        
        makeAlbumPageControl()
        bottomContainerScrollView.addSubview(bottomTopChartContainer)
    }
    
    // MARK: 3개씩 넘기 위해서 PageControl을 생성한다.
    func makeAlbumPageControl(){
        homeAlbumPageControl = UIPageControl(frame: CGRectMake(0, 50, view.bounds.width, topChartContainerContentsSizeHeight*2 + 30))
        homeAlbumPageControl.numberOfPages = 3
        homeAlbumPageControl.currentPage = 0
        homeAlbumPageControl.pageIndicatorTintColor = UIColor.darkGrayColor()
        homeAlbumPageControl.currentPageIndicatorTintColor = UIColor.redColor()
        
        bottomTopChartContainer.addSubview(homeAlbumPageControl)
    }
    
    // MARK: Top100을 담을 ScrollView를 생성한다.
    func makeAlbumScrollView(){
        scrollView = UIScrollView(frame: CGRectMake(0, 0, view.bounds.width, topChartContainerContentsSizeHeight))
        scrollView.tag = 0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        
        // contentSize가 이미지 뷰의 개수만큼 생기면 된다.
        // UIControl과 Scrollview를 이용해서 앨범 3개씩 넘어가도록 할 수 있다.
        scrollView.contentSize = CGSizeMake(topChartContainerContentsSizeWidth, topChartContainerContentsSizeHeight)
        
        homeAlbumPageControl.addSubview(scrollView)
        bottomTopChartContainer.addSubview(homeAlbumPageControl)
    }
    
    func makeNewSongContainer(){
        bottomNewSongContainer = UIView(frame: CGRect(x: 0, y: bottomNewSongContainerY, width: view.bounds.width, height: bottomNewSongHeight))
        //        bottomNewSongContainer.backgroundColor = UIColor.blueColor()
        
        // MARK: 이달의 신곡 타이틀 라벨
        let newSongLabel = UILabel(frame: CGRectMake(20, 0, 200, 50))
        newSongLabel.textAlignment = NSTextAlignment.Left
        newSongLabel.textColor = UIColor.whiteColor()
        newSongLabel.text = "이달의 신곡"
        newSongLabel.font = UIFont.boldSystemFontOfSize(15)
        bottomNewSongContainer.addSubview(newSongLabel)
        
        // MARK: 고래방 Top 100 Detail View 버튼
        
        let showNewSongDetailButton = UIButton(frame: CGRectMake(showTop100DetailButtonStartingXPoint, 0, showTop100DetailButtonWidth, showTop100DetailButtonHeight))
        
        let titleForNewSongDetailButton = UILabel(frame: CGRect(x: 0, y: 0, width:showTop100DetailButtonWidth, height: 50))
        titleForNewSongDetailButton.text = "전체보기 >"
        titleForNewSongDetailButton.textColor = UIColor.whiteColor()
        titleForNewSongDetailButton.font = titleForNewSongDetailButton.font.fontWithSize(13)
        
        titleForNewSongDetailButton.textAlignment = NSTextAlignment.Right
        showNewSongDetailButton.addSubview(titleForNewSongDetailButton)
        
        
        showNewSongDetailButton.titleLabel?.textColor = UIColor.whiteColor()
        showNewSongDetailButton.addTarget(self, action: #selector(showTopDetailButtonAction), forControlEvents: .TouchUpInside)
        bottomNewSongContainer.addSubview(showNewSongDetailButton)
        
        makeNewSongPageControl()
        bottomContainerScrollView.addSubview(bottomNewSongContainer)
    }
    
    func makeNewSongPageControl(){
        newSongPageControl = UIPageControl(frame: CGRectMake(0, 50, view.bounds.width, (topChartContainerContentsSizeHeight/2-10)*2 + 30))
        newSongPageControl.numberOfPages = 3
        newSongPageControl.currentPage = 0
        newSongPageControl.pageIndicatorTintColor = UIColor.darkGrayColor()
        newSongPageControl.currentPageIndicatorTintColor = UIColor.redColor()
        
        
        makeNewSongScrollView()
        
        bottomNewSongContainer.addSubview(newSongPageControl)
    }
    
    func makeNewSongScrollView(){
        newSongScrollView = UIScrollView(frame: CGRectMake(0, 0, view.bounds.width, topChartContainerContentsSizeHeight/2-10))
        newSongScrollView.tag = 1
        
        newSongScrollView.showsHorizontalScrollIndicator = false
        newSongScrollView.pagingEnabled = true
    
        newSongScrollView.contentSize = CGSizeMake(topChartContainerContentsSizeWidth, topChartContainerContentsSizeHeight/2-10)
        newSongPageControl.addSubview(newSongScrollView)
        
        addNewSongContents()
    }
    
    
    func showTopDetailButtonAction(sender: UIButton!){
        print("button tapped")
        self.performSegueWithIdentifier("ShowChartDetail", sender: self)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        if (scrollView.tag == 0){
            homeAlbumPageControl.currentPage = Int(pageNumber)
        }
        else{
            newSongPageControl.currentPage = Int(pageNumber)
        }
        
    }
    
    // MARK: Bottom Container에 앨범 추가
    func addAlbumContents(){
        // 앨범 x 좌표
        var x:CGFloat = 20
        var y:CGFloat = 0
        print(topChartReadableJSON.count)
        for i in 0...17 {
            
            // 이미지의 크기는 아이폰 가로길이에서 양 옆 패딩 각각 10씩 -20, 그리고 앨범 사이 간격 5*2에서 -10으로 총 -30 나누기 3, 높이는 같아진다.
            //            imageViewArray[i].frame = CGRect(x: x, y: 5, width: (CGFloat(view.bounds.width)-40)/3, height: (CGFloat(view.bounds.width)-40)/3)
            let albumSong:Song = Song()
            albumSong.set(topChartReadableJSON, row: i, type: 3)
            
            let albumWebView = albumSong.albumWebView
            albumWebView.frame = CGRect(x: x, y: y, width: albumSizeForVariousPhoneWidth, height: albumSizeForVariousPhoneWidth)
            //            let albumWebView = UIWebView(frame: CGRect(x: x, y: 0, width: albumSizeForVariousPhoneWidth, height: albumSizeForVariousPhoneWidth))
            albumWebView.userInteractionEnabled = false
            scrollView.addSubview(albumWebView)
            
            // MARK**********: Image View Web View 로 변경
            
            //            imageViewArray[i].frame = CGRect(x: x, y: 0, width: albumSizeForVariousPhoneWidth, height: albumSizeForVariousPhoneWidth)
            //            scrollView.addSubview(imageViewArray[i])
            
            // MARK: 노래방 TJ 번호를 표시할 ImageView 태그
            imageViewForSongTag = UIImageView(image: UIImage(named: "SongNumberTag"))
            imageViewForSongTag.frame = CGRectMake(0, 0, 50, 25)
            
            albumWebView.addSubview(imageViewForSongTag)
            //            imageViewArray[i].addSubview(imageViewForSongTag)
            
            labelForImageViewArray = UILabel(frame: CGRect(x: 3, y:0, width:50, height:25))
            labelForImageViewArray.text = String(topChartReadableJSON[i]["song_tjnum"].int!)
            labelForImageViewArray.font = UIFont.boldSystemFontOfSize(12)
            labelForImageViewArray.textColor = UIColor.whiteColor()
            
            imageViewForSongTag.addSubview(labelForImageViewArray)
            
            // MARK: 노래 제목과, 아티스트명을 담을 UIView
            viewForAlbumTitle = UIView(frame: CGRect(x: 0, y: viewForAlbumTitleStartingYPoint, width:albumSizeForVariousPhoneWidth, height: 40))
            viewForAlbumTitle.backgroundColor = UIColor.init(red: 34/255, green: 34/255, blue:34/255, alpha: 0.85)
            albumWebView.addSubview(viewForAlbumTitle)
            
            // MARK : 노래제목 라벨 추가(textView를 이용하면 Inset 넣을 수 있는지 확인)
            songLabelForAlbum = UILabel(frame: CGRect(x: 5, y: 5, width: albumSizeForVariousPhoneWidth - 10, height: 15))
            songLabelForAlbum.text = topChartReadableJSON[i]["title"].string
            songLabelForAlbum.font = UIFont.boldSystemFontOfSize(12)
            songLabelForAlbum.textAlignment = NSTextAlignment.Left
            songLabelForAlbum.textColor = UIColor.whiteColor()
            
            // MARK: artist UILabel
            artistLabelForAlbum = UILabel(frame: CGRect(x: 5, y: 20, width:albumSizeForVariousPhoneWidth - 10, height: 15))
            artistLabelForAlbum.text = topChartReadableJSON[i]["artist_name"].string
            //            artistLabelForAlbum.text = topChartReadableJSON[i]["artist"].string
            artistLabelForAlbum.textAlignment = NSTextAlignment.Left
            artistLabelForAlbum.textColor = UIColor.lightGrayColor()
            artistLabelForAlbum.font = artistLabelForAlbum.font.fontWithSize(11)
            
            viewForAlbumTitle.addSubview(songLabelForAlbum)
            viewForAlbumTitle.addSubview(artistLabelForAlbum)
            
            if((i+1)%3 == 0){
                x += albumBigInterval + albumSizeForVariousPhoneWidth
            } else{
                x += albumSmallInterval + albumSizeForVariousPhoneWidth
            }
            
            if(i == 8){
                y += albumSizeForVariousPhoneWidth + 20
                x = 20
            }
        }
    }
    
    func addNewSongContents(){
        // 앨범 x 좌표
        var x:CGFloat = 20
        var y:CGFloat = 0
        print(topChartReadableJSON.count)
        for i in 0...8 {
            
            // 이미지의 크기는 아이폰 가로길이에서 양 옆 패딩 각각 10씩 -20, 그리고 앨범 사이 간격 5*2에서 -10으로 총 -30 나누기 3, 높이는 같아진다.
            //            imageViewArray[i].frame = CGRect(x: x, y: 5, width: (CGFloat(view.bounds.width)-40)/3, height: (CGFloat(view.bounds.width)-40)/3)
            let albumSong:Song = Song()
            albumSong.set(topChartReadableJSON, row: i, type: 3)
            
            let albumWebView = albumSong.albumWebView
            albumWebView.frame = CGRect(x: x, y: y, width: albumSizeForVariousPhoneWidth, height: albumSizeForVariousPhoneWidth)
            albumWebView.userInteractionEnabled = false
            newSongScrollView.addSubview(albumWebView)
            
            // MARK: 노래방 TJ 번호를 표시할 ImageView 태그
            imageViewForSongTag = UIImageView(image: UIImage(named: "SongNumberTag"))
            imageViewForSongTag.frame = CGRectMake(0, 0, 50, 25)
            
            albumWebView.addSubview(imageViewForSongTag)
            //            imageViewArray[i].addSubview(imageViewForSongTag)
            
            labelForImageViewArray = UILabel(frame: CGRect(x: 3, y:0, width:50, height:25))
            labelForImageViewArray.text = String(topChartReadableJSON[i]["song_tjnum"].int!)
            labelForImageViewArray.font = UIFont.boldSystemFontOfSize(12)
            labelForImageViewArray.textColor = UIColor.whiteColor()
            
            imageViewForSongTag.addSubview(labelForImageViewArray)
            
            // MARK: 노래 제목과, 아티스트명을 담을 UIView
            viewForAlbumTitle = UIView(frame: CGRect(x: 0, y: viewForAlbumTitleStartingYPoint, width:albumSizeForVariousPhoneWidth, height: 40))
            viewForAlbumTitle.backgroundColor = UIColor.init(red: 34/255, green: 34/255, blue:34/255, alpha: 0.85)
            albumWebView.addSubview(viewForAlbumTitle)
            
            // MARK : 노래제목 라벨 추가(textView를 이용하면 Inset 넣을 수 있는지 확인)
            songLabelForAlbum = UILabel(frame: CGRect(x: 5, y: 5, width: albumSizeForVariousPhoneWidth - 10, height: 15))
            songLabelForAlbum.text = topChartReadableJSON[i]["title"].string
            songLabelForAlbum.font = UIFont.boldSystemFontOfSize(12)
            songLabelForAlbum.textAlignment = NSTextAlignment.Left
            songLabelForAlbum.textColor = UIColor.whiteColor()
            
            // MARK: artist UILabel
            artistLabelForAlbum = UILabel(frame: CGRect(x: 5, y: 20, width:albumSizeForVariousPhoneWidth - 10, height: 15))
            artistLabelForAlbum.text = topChartReadableJSON[i]["artist_name"].string
            //            artistLabelForAlbum.text = topChartReadableJSON[i]["artist"].string
            artistLabelForAlbum.textAlignment = NSTextAlignment.Left
            artistLabelForAlbum.textColor = UIColor.lightGrayColor()
            artistLabelForAlbum.font = artistLabelForAlbum.font.fontWithSize(11)
            
            viewForAlbumTitle.addSubview(songLabelForAlbum)
            viewForAlbumTitle.addSubview(artistLabelForAlbum)
            
            if((i+1)%3 == 0){
                x += albumBigInterval + albumSizeForVariousPhoneWidth
            } else{
                x += albumSmallInterval + albumSizeForVariousPhoneWidth
            }
            
            if(i == 8){
                y += albumSizeForVariousPhoneWidth + 20
                x = 20
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
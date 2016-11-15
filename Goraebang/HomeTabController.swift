
import UIKit


class HomeTabController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    // width, 4inch :320, 4.7inch :375, 5.5inch: 414
    
    // 앨범 터치
    let SingleTap = UITapGestureRecognizer()
    
    var userInfo = UserInfoGetter()
    var overlay:UIView!
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
    var homeTopBackgroundWebView: UIWebView!
    var topBackgroundScrollView: UIScrollView!
    
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
    
    
    // MARK: MyList 공유할 뷰
    var myListShareContainer:UIView!
    var bottomMyListContainerY:CGFloat!
    var bottomMyListContainerHeight:CGFloat!
    // MARK: MyList 위치 변수
    
    
    
    // MARK : JSON 읽을 JSON 변수
    var topChartReadableJSON: JSON!
    var newSongReadableJSON: JSON!
    var topBannerJSON: JSON!
    
    // 스크롤 말려 올라가는 코드
    //    func scrollViewDidScroll(scrollView: UIScrollView) {
    //        if(scrollView == self.bottomContainerScrollView){
    //
    //            //
    //
    //            let nextY:CGFloat = 64+topBackgroundHeight - scrollView.contentOffset.y*0.5
    //            // 기존의 높이는 전 체 높이 - 내비바64 - 상단 이미지120 - 탭바30
    //            let originHeight:CGFloat = view.bounds.height - 214
    //            let nextHeight:CGFloat = originHeight + scrollView.contentOffset.y*0.5
    //            if(nextY >= 64){
    //                scrollView.frame = CGRect(x: scrollView.frame.minX, y: nextY, width: scrollView.bounds.width, height: nextHeight)
    //                scrollView.contentSize = CGSizeMake(view.bounds.width, bottomContainerContentsHeight)
    //                homeTopBackgroundImageView.alpha = nextY/184
    //            }
    //            else if(nextY > 5){
    //                scrollView.frame = CGRect(x: scrollView.frame.minX, y: 64, width: scrollView.bounds.width, height: nextHeight)
    //            }
    //        }
    //    }
    
    // 페이지 나갈 때 스크롤 맨 위로
    //    override func viewDidDisappear(animated: Bool) {
    //        bottomContainerScrollView.contentOffset.y = 0
    //    }
    
    
    override func viewDidAppear(animated: Bool) {
        if(overlay != nil){
            overlay.removeFromSuperview()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        overlay = UIView(frame: self.view.frame)
        SingleTap.delegate = self
        setSize(view.bounds.width) // 초기설정
        
        getTopChart()
        
        makeBottomContainer()
        makeHomeTopBackground()
        
        makeAlbumScrollView()
        addAlbumContents()
        
        scrollView.delegate = self
        newSongScrollView.delegate = self
        
        //        print("iPhone width : \(view.bounds.width)")
    }
    
    // MARK: 아이폰 사이즈 마다 변수 값 세팅
    func setSize(phoneSize:CGFloat){
        contentNum = 6
        
        // 아래 스크롤 뷰의 Y 시작점을 구하는 bottomContainerStartingYPoint의 -10은 CGFloat의 오차 때문
        bottomContainerStartingYPoint = (self.navigationController?.navigationBar.bounds.height)! + UIApplication.sharedApplication().statusBarFrame.size.height - 10
        if(phoneSize == 320){ // 4inch
            phoneSizeString = "4inch"
            albumSizeForVariousPhoneWidth = 88
            albumSmallInterval = 8
            albumBigInterval = 40
            topBackgroundStartingYPoint = 0
            topBackgroundHeight = 190
            
            
            bottomContainerHeight = self.view.bounds.height - bottomContainerStartingYPoint
            viewForAlbumTitleStartingYPoint = albumSizeForVariousPhoneWidth - 40
            themeLabelStartingYPoint = 285
            
        } else if(phoneSize == 375){ // 4.7inch
            phoneSizeString = "4.7inch"
            albumSizeForVariousPhoneWidth = 109
            albumSmallInterval = 4
            albumBigInterval = 40
            topBackgroundStartingYPoint = 9
            topBackgroundHeight = 180
            //            bottomContainerStartingYPoint = (self.navigationController?.navigationBar.bounds.height)! + UIApplication.sharedApplication().statusBarFrame.size.height - 10
            print(self.navigationController?.navigationBar.bounds.height)
            bottomContainerHeight = self.view.bounds.height - bottomContainerStartingYPoint
            viewForAlbumTitleStartingYPoint = albumSizeForVariousPhoneWidth - 40
            themeLabelStartingYPoint = 305
        } else{ // 5.5inch
            phoneSizeString = "5.5inch"
            albumSizeForVariousPhoneWidth = (phoneSize-27)/3
            albumSmallInterval = 3.5
            albumBigInterval = 40
            topBackgroundStartingYPoint = 0
            topBackgroundHeight = 190
            
            // bottom Cantiner가 아래 스크롤 뷰로 들어간다.
            //            bottomContainerStartingYPoint = (self.navigationController?.navigationBar.bounds.height)! + UIApplication.sharedApplication().statusBarFrame.size.height - 10
            
            bottomContainerHeight = self.view.bounds.height - bottomContainerStartingYPoint
            viewForAlbumTitleStartingYPoint = albumSizeForVariousPhoneWidth - 40
            themeLabelStartingYPoint = 365
        }
        
        bottomTopChartContainerY = topBackgroundHeight+10
        bottomTopChartHeight = albumSizeForVariousPhoneWidth*2 + 100
        
        bottomNewSongContainerY = bottomTopChartHeight + bottomTopChartContainerY
        bottomNewSongHeight = albumSizeForVariousPhoneWidth + 60
        
        bottomMyListContainerY = bottomNewSongContainerY + bottomNewSongHeight
        bottomMyListContainerHeight = 600
        
        topChartContainerContentsSizeWidth = (phoneSize) * 3
        topChartContainerContentsSizeHeight = albumSizeForVariousPhoneWidth*2 + 20
        // print(albumSizeForVariousPhoneWidth)
        
        // 아래 tab 사이즈 만큼 +70 해줬다.
        bottomContainerContentsHeight = topBackgroundHeight + bottomTopChartHeight + bottomNewSongHeight + 100
        // ShowTop100DetailView 설정
        showTop100DetailButtonStartingXPoint = phoneSize - 100
        showTop100DetailButtonStartingYPoint = 20
        showTop100DetailButtonWidth = 80
        showTop100DetailButtonHeight = 50
    }
    
    // MARK: SwiftyJSON 사용해서 top 100 chart를 불러온다.
    func getTopChart(){
        // 서버 문제있을 때?
        let url:NSURL = NSURL(string: "\(goraebang_url)/json/top100?mytoken=\(userInfo.token)")!
        let jsonData = NSData(contentsOfURL: url) as NSData!
        
        let new_song_url:NSURL = NSURL(string: "\(goraebang_url)/json/month_new?mytoken=\(userInfo.token)")!
        let newSongJsonData = NSData(contentsOfURL: new_song_url) as NSData!
        
        let banner_url:NSURL = NSURL(string: "\(goraebang_url)/json/main_banner")!
        let bannerJsonData = NSData(contentsOfURL: banner_url) as NSData!
        
        topChartReadableJSON = JSON(data: jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
        newSongReadableJSON = JSON(data: newSongJsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
        topBannerJSON = JSON(data: bannerJsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
    }
    
    
    // MARK: 화면 하단에 Chart를 표시하는 앨범과, 테마를 담을 Container
    func makeBottomContainer(){
        bottomContainerScrollView = UIScrollView(frame: CGRectMake(0, bottomContainerStartingYPoint, view.bounds.width, bottomContainerHeight))
        bottomContainerScrollView.showsHorizontalScrollIndicator = true
        bottomContainerScrollView.contentSize = CGSizeMake(view.bounds.width, bottomContainerContentsHeight)
        bottomContainerScrollView.delegate = self
        
        bottomContainerScrollView.backgroundColor = UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 1.0)
        //        bottomContainerScrollView.translatesAutoresizingMaskIntoConstraints = false
        // MARK: 고래방 TOP 100 차트 타이틀 라벨
        makeTopChartContainer()
        makeNewSongContainer()
//        makeMyListContainer()
        
        
        bottomContainerScrollView.layer.zPosition = 2
        view.addSubview(bottomContainerScrollView)
        //        view.bringSubviewToFront(bottomContainerScrollView)
    }
    
    // MARK: 화면 상단의 백그라운드 이미지 생성
    func makeHomeTopBackground(){
//        homeTopBackgroundWebView.frame = CGRectMake(0, topBackgroundStartingYPoint, view.bounds.width, topBackgroundHeight)
        
        let topBackgroundPageControl = UIPageControl(frame: CGRect(x: 0, y: topBackgroundStartingYPoint, width: view.bounds.width, height: topBackgroundHeight))
        topBackgroundPageControl.numberOfPages = 3
        topBackgroundPageControl.currentPage = 0
        topBackgroundPageControl.backgroundColor = UIColor.blueColor()
//        topBackgroundPageControl.appearne
        
//        topBackgroundPageControl.layer.position.y = self.view.frame.height - 200
//        topBackgroundPageControl.
//        topBackgroundPageControl.
//        topBackgroundPageControl.backgroundColor = UIColor(red: 49/255, green: 50/255, blue: 52/255, alpha: 1.0)
        bottomContainerScrollView.addSubview(topBackgroundPageControl)
        
        
        let topBackgroundScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: topBackgroundHeight))
        
        
        topBackgroundScrollView.showsHorizontalScrollIndicator = false
        topBackgroundScrollView.pagingEnabled = true
        topBackgroundScrollView.contentSize = CGSizeMake(view.bounds.width*3, topBackgroundHeight)
        
        var x:CGFloat = 0
        
        for i in 0...2 {
            homeTopBackgroundWebView = UIWebView(frame: CGRect(x: x, y: 0, width: view.bounds.width, height: topBackgroundHeight))
            homeTopBackgroundWebView.scalesPageToFit = true
            homeTopBackgroundWebView.scrollView.scrollEnabled = false
            homeTopBackgroundWebView.loadRequest(NSURLRequest(URL: NSURL(string: topBannerJSON[i]["image"].string!)!))
            homeTopBackgroundWebView.layer.zPosition = 3
            
            topBackgroundScrollView.addSubview(homeTopBackgroundWebView)
            x = x + view.bounds.width
        }
//        homeTopBackgroundWebView = UIWebView(frame: CGRect(x: 0, y: topBackgroundStartingYPoint, width: view.bounds.width, height: topBackgroundHeight))
//        homeTopBackgroundWebView.scalesPageToFit = true
//        homeTopBackgroundWebView.scrollView.scrollEnabled = false
//        homeTopBackgroundWebView.loadRequest(NSURLRequest(URL: NSURL(string: topBannerJSON[0]["image"].string!)!))
//        homeTopBackgroundWebView.layer.zPosition = 1
        
        topBackgroundPageControl.addSubview(topBackgroundScrollView)
        bottomContainerScrollView.addSubview(topBackgroundPageControl)
        
        
//        homeTopBackgroundImageView = UIImageView(image: UIImage(named: "HomeTopBackground"))
//        homeTopBackgroundImageView.frame = CGRectMake(0, topBackgroundStartingYPoint, view.bounds.width, topBackgroundHeight)
//        homeTopBackgroundImageView.layer.zPosition = 1
//        bottomContainerScrollView.addSubview(homeTopBackgroundImageView)
        // 4, 4.7, 5.5 inch 크기 별로 설정 view.bounds.width(height)의 배율로 하는게 좋을 것 같다.
    }
    
    
    func makeTopChartContainer(){
        bottomTopChartContainer = UIView(frame: CGRect(x: 0, y: bottomTopChartContainerY, width: view.bounds.width, height: bottomTopChartHeight))
        //                bottomTopChartContainer.backgroundColor = UIColor.darkGrayColor()
        //        bottomTopChartContainer.autoresizesSubviews = true
        
//        bottomTopChartContainer.layer.zPosition = 5
        // 고래방 TOP 라벨 앞에 선을 UILabel로 추가한다.
        let preChartLabel = UILabel()
        //        preChartLabel.clipsToBounds = true
        //        preChartLabel.translatesAutoresizingMaskIntoConstraints = false
        //        preChartLabel.allowsDefaultTighteningForTruncation = false
        preChartLabel.frame = CGRect(x: 20, y: 15, width: 5, height: 20)
        preChartLabel.backgroundColor = UIColor(red: 232/255, green: 56/255, blue: 61/255, alpha: 1.0)
        bottomTopChartContainer.addSubview(preChartLabel)
        
        // TOP CHART 글자 라벨
        let chartLabel = UILabel(frame: CGRectMake(30, 0, 200, 50))
        chartLabel.textAlignment = NSTextAlignment.Left
        chartLabel.textColor = UIColor.whiteColor()
        chartLabel.text = "고래방 TOP 차트"
        chartLabel.font = UIFont.boldSystemFontOfSize(15)
        bottomTopChartContainer.addSubview(chartLabel)
        
        // TOP CHART 글자 라벨 아래 구분선
        let chartTextDivisionLine = UILabel()
        chartTextDivisionLine.frame = CGRect(x: 20, y: 41, width: view.bounds.width - 40, height: 1)
        chartTextDivisionLine.backgroundColor = UIColor.darkGrayColor()
        bottomTopChartContainer.addSubview(chartTextDivisionLine)
        
        // MARK: 고래방 Top 100 Detail View 버튼
        
        let showTop100DetailButton = UIButton(frame: CGRectMake(showTop100DetailButtonStartingXPoint, 0, showTop100DetailButtonWidth, showTop100DetailButtonHeight))
        //        showTop100DetailButton.backgroundColor = UIColor.blueColor()
        
        let titleForTop100DetailButton = UILabel(frame: CGRect(x: 0, y: 0, width:showTop100DetailButtonWidth, height: 50))
        titleForTop100DetailButton.text = "더 보기 >"
        //        titleForTop100DetailButton.tintColor = UIColor.redColor()
        titleForTop100DetailButton.textColor = UIColor.whiteColor()
        titleForTop100DetailButton.font = titleForTop100DetailButton.font.fontWithSize(13)
        
        titleForTop100DetailButton.textAlignment = NSTextAlignment.Right
        showTop100DetailButton.addSubview(titleForTop100DetailButton)
        
        showTop100DetailButton.titleLabel?.textColor = UIColor.whiteColor()
        
        showTop100DetailButton.addTarget(self, action: #selector(showTopDetailButtonAction), forControlEvents: .TouchUpInside)
        bottomTopChartContainer.addSubview(showTop100DetailButton)
        
        makeAlbumPageControl()
        
        //        // 인기차트와 신곡 사이 구분선
        //        let bottomTopChartContainerDivisionLine = UILabel()
        //        bottomTopChartContainerDivisionLine.frame = CGRect(x: 20, y: bottomTopChartHeight - 3, width: view.bounds.width-40, height: 1)
        //        bottomTopChartContainerDivisionLine.backgroundColor = UIColor.darkGrayColor()
        //        bottomTopChartContainer.addSubview(bottomTopChartContainerDivisionLine)
        
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
        
        // 신곡 타이틀 라벨 앞 세로 굵은 선을 UILabel로 추가
        let preNewSongLabel = UILabel()
        preNewSongLabel.frame = CGRect(x: 20, y: 15, width: 5, height: 20)
        preNewSongLabel.backgroundColor = UIColor(red: 232/255, green: 56/255, blue: 61/255, alpha: 1.0)
        bottomNewSongContainer.addSubview(preNewSongLabel)
        
        // MARK: 이달의 신곡 타이틀 라벨
        let newSongLabel = UILabel(frame: CGRectMake(30, 0, 200, 50))
        newSongLabel.textAlignment = NSTextAlignment.Left
        newSongLabel.textColor = UIColor.whiteColor()
        newSongLabel.text = "이달의 신곡"
        newSongLabel.font = UIFont.boldSystemFontOfSize(15)
        bottomNewSongContainer.addSubview(newSongLabel)
        
        // NEW SONG 글자 라벨 아래 구분선
        let newSongTextDivisionLine = UILabel()
        newSongTextDivisionLine.frame = CGRect(x: 20, y: 41, width: view.bounds.width - 40, height: 1)
        newSongTextDivisionLine.backgroundColor = UIColor.darkGrayColor()
        bottomNewSongContainer.addSubview(newSongTextDivisionLine)
        
        // MARK: 고래방 Top 100 Detail View 버튼
        
        let showNewSongDetailButton = UIButton(frame: CGRectMake(showTop100DetailButtonStartingXPoint, 0, showTop100DetailButtonWidth, showTop100DetailButtonHeight))
        
        let titleForNewSongDetailButton = UILabel(frame: CGRect(x: 0, y: 0, width:showTop100DetailButtonWidth, height: 50))
        titleForNewSongDetailButton.text = "더 보기 >"
        titleForNewSongDetailButton.textColor = UIColor.whiteColor()
        titleForNewSongDetailButton.font = titleForNewSongDetailButton.font.fontWithSize(13)
        
        titleForNewSongDetailButton.textAlignment = NSTextAlignment.Right
        showNewSongDetailButton.addSubview(titleForNewSongDetailButton)
        
        
        showNewSongDetailButton.titleLabel?.textColor = UIColor.whiteColor()
        showNewSongDetailButton.addTarget(self, action: #selector(showNewSongButtonAction), forControlEvents: .TouchUpInside)
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
    
    
    // MyList 공유할 뷰들 넣을 컨테이너
    
    func makeMyListContainer(){
        myListShareContainer = UIView(frame: CGRect(x: 0, y: bottomMyListContainerY, width: view.bounds.width, height: bottomMyListContainerHeight))
        //        myListShareContainer.backgroundColor = UIColor.blueColor()
        
        let firstMyList = UIView(frame: CGRect(x: 20, y: 40, width: view.bounds.width-40, height: 70))
        firstMyList.backgroundColor = UIColor.redColor()
        firstMyList.alpha = 0.6
        //        firstMyList.layer.borderWidth = 3
        firstMyList.layer.cornerRadius = 10
        myListShareContainer.addSubview(firstMyList)
        
        let firstMyListTitle = UILabel(frame: CGRect(x: 20, y: 115, width: view.bounds.width-40, height: 20))
        firstMyListTitle.text = "Gorae`s List"
        firstMyListTitle.textColor = UIColor.whiteColor()
        firstMyListTitle.font = firstMyListTitle.font.fontWithSize(12)
        myListShareContainer.addSubview(firstMyListTitle)
        
        let secondMyList = UIView(frame: CGRect(x: 20, y: 145, width: view.bounds.width-40, height: 70))
        secondMyList.backgroundColor = UIColor.blueColor()
        secondMyList.alpha = 0.6
        //        secondMyList.layer.borderWidth = 3
        secondMyList.layer.cornerRadius = 10
        myListShareContainer.addSubview(secondMyList)
        
        let secondMyListTitle = UILabel(frame: CGRect(x: 20, y: 220, width: view.bounds.width-40, height: 20))
        secondMyListTitle.text = "Gorae`s List2"
        secondMyListTitle.textColor = UIColor.whiteColor()
        secondMyListTitle.font = secondMyListTitle.font.fontWithSize(12)
        myListShareContainer.addSubview(secondMyListTitle)
        
        let thirdMyList = UIView(frame: CGRect(x: 20, y: 250, width: view.bounds.width-40, height: 70))
        thirdMyList.backgroundColor = UIColor.redColor()
        thirdMyList.alpha = 0.6
        //        thirdMyList.layer.borderWidth = 3
        thirdMyList.layer.cornerRadius = 10
        myListShareContainer.addSubview(thirdMyList)
        
        let thirdMyListTitle = UILabel(frame: CGRect(x: 20, y: 325, width: view.bounds.width-40, height: 20))
        thirdMyListTitle.text = "Gorae`s List3"
        thirdMyListTitle.textColor = UIColor.whiteColor()
        thirdMyListTitle.font = thirdMyListTitle.font.fontWithSize(12)
        myListShareContainer.addSubview(thirdMyListTitle)
        
        
        let fourthMyList = UIView(frame: CGRect(x: 20, y: 355, width: view.bounds.width-40, height: 70))
        fourthMyList.backgroundColor = UIColor.blueColor()
        fourthMyList.alpha = 0.6
        //        fourthMyList.layer.borderWidth = 3
        fourthMyList.layer.cornerRadius = 10
        myListShareContainer.addSubview(fourthMyList)
        
        let fourthMyListTitle = UILabel(frame: CGRect(x: 20, y: 430, width: view.bounds.width-40, height: 20))
        fourthMyListTitle.text = "Gorae`s List4"
        fourthMyListTitle.textColor = UIColor.whiteColor()
        fourthMyListTitle.font = fourthMyListTitle.font.fontWithSize(12)
        myListShareContainer.addSubview(fourthMyListTitle)
        
        
        // Dont touch
        bottomContainerScrollView.addSubview(myListShareContainer)
    }
    
    func showTopDetailButtonAction(sender: UIButton!){
        //        print("button tapped")
        //        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .Alert)
        //
        //        alert.view.tintColor = UIColor.blackColor()
        //        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        //        loadingIndicator.hidesWhenStopped = true
        //        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        //        loadingIndicator.startAnimating();
        //
        //        alert.view.addSubview(loadingIndicator)
        //        presentViewController(alert, animated: true, completion: nil)
        //                dismissViewControllerAnimated(false, completion: nil)
        
        //        overlay:UIView!
        
        // overlay 추가 로딩 애니메이션 추가
        overlay = UIView(frame: self.view.frame)
        overlay!.backgroundColor = UIColor.blackColor()
        overlay!.alpha = 0.4
        self.view.addSubview(overlay!)
        self.performSegueWithIdentifier("ShowChartDetail", sender: self)
    }
    
    func showNewSongButtonAction(sender: UIButton!){
        // overlay 추가 로딩 애니메이션 추가
        overlay = UIView(frame: self.view.frame)
        overlay!.backgroundColor = UIColor.blackColor()
        overlay!.alpha = 0.4
        self.view.addSubview(overlay!)
        self.performSegueWithIdentifier("ShowNewSong", sender: self)
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
        for i in 0...17 {
            
            // 이미지의 크기는 아이폰 가로길이에서 양 옆 패딩 각각 10씩 -20, 그리고 앨범 사이 간격 5*2에서 -10으로 총 -30 나누기 3, 높이는 같아진다.
            //            imageViewArray[i].frame = CGRect(x: x, y: 5, width: (CGFloat(view.bounds.width)-40)/3, height: (CGFloat(view.bounds.width)-40)/3)
            let albumSong:Song = Song()
            albumSong.set(topChartReadableJSON, row: i, type: 3)
            
            let albumWebView = albumSong.albumWebView
            albumWebView.frame = CGRect(x: x, y: y, width: albumSizeForVariousPhoneWidth, height: albumSizeForVariousPhoneWidth)
            //            let albumWebView = UIWebView(frame: CGRect(x: x, y: 0, width: albumSizeForVariousPhoneWidth, height: albumSizeForVariousPhoneWidth))
            //            albumWebView.userInteractionEnabled = true
            
            //            albumWebView.enable
            scrollView.addSubview(albumWebView)
            
            // MARK**********: Image View Web View 로 변경
            
            //            imageViewArray[i].frame = CGRect(x: x, y: 0, width: albumSizeForVariousPhoneWidth, height: albumSizeForVariousPhoneWidth)
            //            scrollView.addSubview(imageViewArray[i])
            
            // MARK: 노래방 TJ 번호를 표시할 ImageView 태그
            imageViewForSongTag = UIImageView(image: UIImage(named: "SongNumberTag"))
            imageViewForSongTag.frame = CGRectMake(0, 0, 50, 25)
            
            albumWebView.addSubview(imageViewForSongTag)
            //            imageViewArray[i].addSubview(imageViewForSongTag)
            albumWebView.userInteractionEnabled = false
            //            SingleTap.delegate = self
            
            labelForImageViewArray = UILabel(frame: CGRect(x: 3, y:0, width:50, height:25))
            labelForImageViewArray.text = String(topChartReadableJSON[i]["song_tjnum"].int!)
            labelForImageViewArray.font = UIFont.boldSystemFontOfSize(12)
            labelForImageViewArray.textColor = UIColor.whiteColor()
            
            imageViewForSongTag.addSubview(labelForImageViewArray)
            
            // MARK: 노래 제목과, 아티스트명을 담을 UIView
            // GradientLayer
            
            viewForAlbumTitle = UIView(frame: CGRect(x: 0, y: viewForAlbumTitleStartingYPoint, width:albumSizeForVariousPhoneWidth, height: 40))
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = CGRect(x: 0, y: 0, width: viewForAlbumTitle.bounds.width, height: viewForAlbumTitle.bounds.height)
            let color1 = UIColor(white: 0.2, alpha: 0.0).CGColor as CGColorRef
            let color2 = UIColor(white: 0.2, alpha: 0.2).CGColor as CGColorRef
            let color3 = UIColor(white: 0.2, alpha: 0.4).CGColor as CGColorRef
            let color4 = UIColor(white: 0.2, alpha: 0.6).CGColor as CGColorRef
            let color5 = UIColor(white: 0.2, alpha: 0.75).CGColor as CGColorRef
            let color6 = UIColor(white: 0.2, alpha: 1.0).CGColor as CGColorRef
            gradientLayer.colors = [color1, color2, color3, color4, color5, color6]
            gradientLayer.locations = [0.0, 0.1, 0.2, 0.35, 0.5, 1.0]
            
            viewForAlbumTitle.layer.addSublayer(gradientLayer)
            //            viewForAlbumTitle.backgroundColor = UIColor.init(red: 34/255, green: 34/255, blue:34/255, alpha: 0.85)
            
            albumWebView.addSubview(viewForAlbumTitle)
            
            // MARK : 노래제목 라벨 추가(textView를 이용하면 Inset 넣을 수 있는지 확인)
            songLabelForAlbum = UILabel(frame: CGRect(x: 5, y: 5, width: albumSizeForVariousPhoneWidth - 10, height: 15))
            songLabelForAlbum.text = topChartReadableJSON[i]["title"].string
            songLabelForAlbum.font = UIFont.boldSystemFontOfSize(12)
            // 글씨 굵게
            songLabelForAlbum.textAlignment = NSTextAlignment.Left
            songLabelForAlbum.textColor = UIColor.whiteColor()
            
            // MARK: artist UILabel
            artistLabelForAlbum = UILabel(frame: CGRect(x: 5, y: 20, width:albumSizeForVariousPhoneWidth - 10, height: 15))
            artistLabelForAlbum.text = topChartReadableJSON[i]["artist_name"].string
            //            artistLabelForAlbum.text = topChartReadableJSON[i]["artist"].string
            artistLabelForAlbum.textAlignment = NSTextAlignment.Left
            artistLabelForAlbum.textColor = UIColor.whiteColor()
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
            albumSong.set(newSongReadableJSON, row: i, type: 3)
            
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
            labelForImageViewArray.text = String(newSongReadableJSON[i]["song_tjnum"].int!)
            labelForImageViewArray.font = UIFont.boldSystemFontOfSize(12)
            labelForImageViewArray.textColor = UIColor.whiteColor()
            
            imageViewForSongTag.addSubview(labelForImageViewArray)
            
            // MARK: 노래 제목과, 아티스트명을 담을 UIView
            viewForAlbumTitle = UIView(frame: CGRect(x: 0, y: viewForAlbumTitleStartingYPoint, width:albumSizeForVariousPhoneWidth, height: 40))
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = CGRect(x: 0, y: 0, width: viewForAlbumTitle.bounds.width, height: viewForAlbumTitle.bounds.height)
            let color1 = UIColor(white: 0.2, alpha: 0.0).CGColor as CGColorRef
            let color2 = UIColor(white: 0.2, alpha: 0.2).CGColor as CGColorRef
            let color3 = UIColor(white: 0.2, alpha: 0.4).CGColor as CGColorRef
            let color4 = UIColor(white: 0.2, alpha: 0.6).CGColor as CGColorRef
            let color5 = UIColor(white: 0.2, alpha: 0.75).CGColor as CGColorRef
            let color6 = UIColor(white: 0.2, alpha: 1.0).CGColor as CGColorRef
            gradientLayer.colors = [color1, color2, color3, color4, color5, color6]
            gradientLayer.locations = [0.0, 0.1, 0.2, 0.35, 0.5, 1.0]
            
            viewForAlbumTitle.layer.addSublayer(gradientLayer)
//            viewForAlbumTitle.backgroundColor = UIColor.init(red: 34/255, green: 34/255, blue:34/255, alpha: 0.85)
            albumWebView.addSubview(viewForAlbumTitle)
            
            // MARK : 노래제목 라벨 추가(textView를 이용하면 Inset 넣을 수 있는지 확인)
            songLabelForAlbum = UILabel(frame: CGRect(x: 5, y: 5, width: albumSizeForVariousPhoneWidth - 10, height: 15))
            songLabelForAlbum.text = newSongReadableJSON[i]["title"].string
            songLabelForAlbum.font = UIFont.boldSystemFontOfSize(12)
            songLabelForAlbum.textAlignment = NSTextAlignment.Left
            songLabelForAlbum.textColor = UIColor.whiteColor()
            
            // MARK: artist UILabel
            artistLabelForAlbum = UILabel(frame: CGRect(x: 5, y: 20, width:albumSizeForVariousPhoneWidth - 10, height: 15))
            artistLabelForAlbum.text = newSongReadableJSON[i]["artist_name"].string
            //            artistLabelForAlbum.text = newSongReadableJSON[i]["artist"].string
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

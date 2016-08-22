
import UIKit
import SwiftyJSON

class HomeTabController: UIViewController {
    
    // 아이폰 화면비율 9:16
    // 아이폰 5s 640x1136
    // width, 4inch :320, 4.7inch :375, 5.5inch: 414
    // 각 크기마다 따로 설정해야 하는지?
    
    // http://52.78.113.43, top chart json url
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    // MARK : Variables
    var bottomContainerScrollView: UIScrollView!
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var imageViewArray: [UIImageView]!
    var labelForImageViewArray: UILabel!
    var imageViewForSongTag: UIImageView!
    
    var viewForAlbumTitle: UIView!
    var songLabelForAlbum: UILabel!
    var artistLabelForAlbum: UILabel!
    
    var homeTopBackgroundImageView: UIImageView!
    
    var homeAlbumPageControl: UIPageControl!
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
    
    // MARK : JSON 읽을 JSON 변수
    var topChartReadableJSON: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hi")
        if self.revealViewController() != nil {
            print("Cool")
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        setSize(view.bounds.width) // 초기설정
        
        getTopChart()
        makeHomeTopBackground()
        makeBottomContainer()
        makeAlbumImageView()
        makeAlbumPageControl()
        makeAlbumScrollView()
        addAlbumContents()
        addThemeContents()
        
//        print("iPhone width : \(view.bounds.width)")
    }
    
    // MARK: 아이폰 사이즈 마다 변수 값 세팅
    func setSize(phoneSize:CGFloat){
        contentNum = 6
        
        if(phoneSize == 320){ // 4inch
            phoneSizeString = "4inch"
            albumSizeForVariousPhoneWidth = (phoneSize-26)/3
            albumSmallInterval = 3
            albumBigInterval = 20
        } else if(phoneSize == 375){ // 4.7inch
            phoneSizeString = "4.7inch"
            albumSizeForVariousPhoneWidth = (phoneSize-27)/3
            albumSmallInterval = 3.5
            albumBigInterval = 20
        } else{ // 5.5inch
            phoneSizeString = "5.5inch"
            albumSizeForVariousPhoneWidth = (phoneSize-27)/3
            albumSmallInterval = 3.5
            albumBigInterval = 20
        }
        
        topChartContainerContentsSizeWidth = phoneSize * (CGFloat(contentNum)/3)
        topChartContainerContentsSizeHeight = albumSizeForVariousPhoneWidth + 45
        // print(albumSizeForVariousPhoneWidth)
        
        // ShowTop100DetailView 설정
        showTop100DetailButtonStartingXPoint = phoneSize - 90
        showTop100DetailButtonStartingYPoint = 20
        showTop100DetailButtonWidth = 80
        showTop100DetailButtonHeight = 20
    }
    
    // MARK: SwiftyJSON 사용해서 top 100 chart를 불러온다.
    func getTopChart(){
        // 서버 문제있을 때?
        let url:NSURL = NSURL(string: "http://52.78.113.43/json/song")!
        let jsonData = NSData(contentsOfURL: url) as NSData!
        
        topChartReadableJSON = JSON(data: jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
//        print(topChartReadableJSON)
        
        
//        print(topChartReadableJSON.count)
//        print(topChartReadableJSON[0]["id"].type)
//        print(topChartReadableJSON[0]["id"])
//        print(topChartReadableJSON[0]["jacket"])
//        print(topChartReadableJSON[0]["lyrics"])
    }
    
    // MARK: 화면 상단의 백그라운드 이미지 생성
    func makeHomeTopBackground(){
        homeTopBackgroundImageView = UIImageView(image: UIImage(named: "HomeTopBackground"))
        homeTopBackgroundImageView.frame = CGRectMake(0, 64, view.bounds.width, 100)
        
        view.addSubview(homeTopBackgroundImageView)
        // 4, 4.7, 5.5 inch 크기 별로 설정 view.bounds.width(height)의 배율로 하는게 좋을 것 같다.
    }
    
    // MARK: 화면 하단에 Chart를 표시하는 앨범과, 테마를 담을 Container
    func makeBottomContainer(){
        bottomContainerScrollView = UIScrollView(frame: CGRectMake(0, 164, view.bounds.width, view.bounds.height - 214))
        bottomContainerScrollView.showsHorizontalScrollIndicator = true
        bottomContainerScrollView.contentSize = CGSizeMake(view.bounds.width, view.bounds.height + 45)
        
        // MARK: 고래방 TOP 100 차트 타이틀 라벨
        let chartLabel = UILabel(frame: CGRectMake(10, 0, 200, 50))
        chartLabel.textAlignment = NSTextAlignment.Left
        chartLabel.textColor = UIColor.init(red: 171/255, green: 171/255, blue: 171/255, alpha: 1.0)
        chartLabel.text = "고래방 차트"
        chartLabel.font = UIFont.boldSystemFontOfSize(15)
        bottomContainerScrollView.addSubview(chartLabel)
        
        // MARK: 고래방 Top 100 Detail View 버튼
        
        let showTop100DetailButton = UIButton(frame: CGRectMake(showTop100DetailButtonStartingXPoint, showTop100DetailButtonStartingYPoint, showTop100DetailButtonWidth, showTop100DetailButtonHeight))
//        showTop100DetailButton.backgroundColor = UIColor.whiteColor()
        showTop100DetailButton.tintColor = UIColor.redColor()
        showTop100DetailButton.setTitle("전체보기 >", forState: .Normal)
        showTop100DetailButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
//        let showTop100AllLabel = UILabel()
//        showTop100AllLabel.text = "전체보기 >"
//        showTop100AllLabel.font = showTop100AllLabel.font.fontWithSize(13)
//        
//        showTop100DetailButton.setTitle(showTop100AllLabel.text, forState: .Normal)
        
        showTop100DetailButton.addTarget(self, action: #selector(showTopDetailButtonAction), forControlEvents: .TouchUpInside)
        bottomContainerScrollView.addSubview(showTop100DetailButton)
        
        // MARK: TOP100 차트, 테마 구분선
        let divisionLine:UIView = UIView(frame: CGRectMake(15, 210, view.bounds.width-30, 1))
        divisionLine.backgroundColor = UIColor.init(red: 61/255, green: 63/255, blue: 62/255, alpha: 1.0)
        bottomContainerScrollView.addSubview(divisionLine)
        
        // MARK: 고래방 테마 타이틀 라벨
        let themeLabel = UILabel(frame: CGRectMake(10, 225, 200, 20))
        themeLabel.textAlignment = NSTextAlignment.Left
        themeLabel.textColor = UIColor.init(red: 171/255, green: 171/255, blue: 171/255, alpha: 1.0)
        themeLabel.text = "고래방 테마"
        themeLabel.font = UIFont.boldSystemFontOfSize(15)
        bottomContainerScrollView.addSubview(themeLabel)
        
        view.addSubview(bottomContainerScrollView)
    }
    
    func showTopDetailButtonAction(sender: UIButton!){
        print("button tapped")
        self.performSegueWithIdentifier("ShowChartDetail", sender: self)
    }
    
    // MARK: 3개씩 넘기 위해서 PageControl을 생성한다.
    func makeAlbumPageControl(){
        
        homeAlbumPageControl = UIPageControl(frame: CGRectMake(0, 50, view.bounds.width, topChartContainerContentsSizeHeight))
        bottomContainerScrollView.addSubview(homeAlbumPageControl)
    }
    
    // MARK: Top100을 담을 앨범 ImageView를 생성한다.
    func makeAlbumImageView(){
        imageViewArray = [UIImageView(image: UIImage(named: "AlbumTest1")), UIImageView(image: UIImage(named: "AlbumTest2")), UIImageView(image: UIImage(named: "AlbumTest3")), UIImageView(image: UIImage(named: "AlbumTest1")), UIImageView(image: UIImage(named: "AlbumTest2")), UIImageView(image: UIImage(named: "AlbumTest3"))]
    }
    
    // MARK: Top100을 담을 ScrollView를 생성한다.
    func makeAlbumScrollView(){
        scrollView = UIScrollView(frame: CGRectMake(0, 0, view.bounds.width, topChartContainerContentsSizeHeight))
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        
        // contentSize가 이미지 뷰의 개수만큼 생기면 된다.
        // UIControl과 Scrollview를 이용해서 앨범 3개씩 넘어가도록 할 수 있다.
        scrollView.contentSize = CGSizeMake(topChartContainerContentsSizeWidth, topChartContainerContentsSizeHeight)
        
        homeAlbumPageControl.addSubview(scrollView)
        bottomContainerScrollView.addSubview(homeAlbumPageControl)
    }
    
    // MARK: Bottom Container에 앨범 추가
    func addAlbumContents(){
        // 앨범 x 좌표
        var x:CGFloat = 10
        
        for i in 0...contentNum-1 {
            // 이미지의 크기는 아이폰 가로길이에서 양 옆 패딩 각각 10씩 -20, 그리고 앨범 사이 간격 5*2에서 -10으로 총 -30 나누기 3, 높이는 같아진다.
//            imageViewArray[i].frame = CGRect(x: x, y: 5, width: (CGFloat(view.bounds.width)-40)/3, height: (CGFloat(view.bounds.width)-40)/3)
            imageViewArray[i].frame = CGRect(x: x, y: 0, width: albumSizeForVariousPhoneWidth, height: albumSizeForVariousPhoneWidth)
            scrollView.addSubview(imageViewArray[i])
            
            // MARK: 노래방 TJ 번호를 표시할 ImageView 태그
            imageViewForSongTag = UIImageView(image: UIImage(named: "SongNumberTag"))
            imageViewForSongTag.frame = CGRectMake(0, 10, 50, 25)
            
            imageViewArray[i].addSubview(imageViewForSongTag)
            
            labelForImageViewArray = UILabel(frame: CGRect(x: 3, y:0, width:50, height:25))
            labelForImageViewArray.text = String(topChartReadableJSON[i]["song_tjnum"].int!)
            labelForImageViewArray.font = UIFont.boldSystemFontOfSize(12)
            labelForImageViewArray.textColor = UIColor.whiteColor()
            
            imageViewForSongTag.addSubview(labelForImageViewArray)
            
            // MARK: 노래 제목과, 아티스트명을 담을 UIView
            viewForAlbumTitle = UIView(frame: CGRect(x: x, y: albumSizeForVariousPhoneWidth, width:albumSizeForVariousPhoneWidth, height: 40))
            viewForAlbumTitle.backgroundColor = UIColor.init(red: 34/255, green: 34/255, blue:34/255, alpha: 1.0)
            scrollView.addSubview(viewForAlbumTitle)
            
            // MARK : 노래제목 라벨 추가(textView를 이용하면 Inset 넣을 수 있는지 확인)
            songLabelForAlbum = UILabel(frame: CGRect(x: 5, y: 5, width: albumSizeForVariousPhoneWidth - 10, height: 15))
            songLabelForAlbum.text = topChartReadableJSON[i]["title"].string
            songLabelForAlbum.font = UIFont.boldSystemFontOfSize(12)
            songLabelForAlbum.textAlignment = NSTextAlignment.Left
            songLabelForAlbum.textColor = UIColor.whiteColor()
            
            // MARK: artist UILabel
            artistLabelForAlbum = UILabel(frame: CGRect(x: 5, y: 20, width:albumSizeForVariousPhoneWidth - 10, height: 15))
            artistLabelForAlbum.text = "Unknown Artist"
            //            artistLabelForAlbum.text = topChartReadableJSON[i]["artist"].string
            artistLabelForAlbum.textAlignment = NSTextAlignment.Left
            artistLabelForAlbum.textColor = UIColor.darkGrayColor()
            artistLabelForAlbum.font = artistLabelForAlbum.font.fontWithSize(12)
            
            viewForAlbumTitle.addSubview(songLabelForAlbum)
            viewForAlbumTitle.addSubview(artistLabelForAlbum)
        
            if((i+1)%3 == 0){
                x += albumBigInterval + albumSizeForVariousPhoneWidth
            } else{
                x += albumSmallInterval + albumSizeForVariousPhoneWidth
            }
        }
    }
    
    // MARK: 테마
    // TOP100 앨범처럼 자체로 스크롤 기능이 없고 Bottom Container에 바로 들어간다.
    // 테마 6개 정도?
    // 각 컨텐츠는 하나의 뷰에 이미지 뷰와 다른 뷰 하나가 더 들어간다. 안쪽의 뷰는 라벨을 포함한다.
    func addThemeContents(){
        let themeContainer:UIView = UIView(frame: CGRectMake(10, 260, view.bounds.width-20, 350))
        bottomContainerScrollView.addSubview(themeContainer)
        
        imageViewArray = [UIImageView(image: UIImage(named: "AlbumTest1")), UIImageView(image: UIImage(named: "AlbumTest2")), UIImageView(image: UIImage(named: "AlbumTest3")), UIImageView(image: UIImage(named: "AlbumTest1")), UIImageView(image: UIImage(named: "AlbumTest2")), UIImageView(image: UIImage(named: "AlbumTest3"))]
        
        themeTitleArray = ["지하철에서 부를 노래", "버스에서 부르는 노래", "기차에서 부르는 노래", "사무실에서" , "학교에서" , "집에서"]
        
        var x:Double = 0
        var y = 0
        for i in 0...5{
            let themeContentsContainer:UIView = UIView(frame: CGRectMake(CGFloat(x), CGFloat(y), themeContainer.bounds.width/2 - 5, 110))
            //            themeContentsContainer.backgroundColor = UIColor.blueColor()
            themeContainer.addSubview(themeContentsContainer)
            
            imageViewArray[i].frame = CGRect(x: 0, y: 0, width: themeContentsContainer.bounds.width, height: 80)
            themeContentsContainer.addSubview(imageViewArray[i])
            
            let themeLabel: UILabel = UILabel(frame: CGRectMake(0, 80, themeContainer.bounds.width/2 - 5, 30))
            themeLabel.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1.0)
            themeLabel.text = themeTitleArray[i]
            
            themeLabel.textColor = UIColor.whiteColor()
            themeLabel.textAlignment = NSTextAlignment.Center
            themeLabel.font = themeLabel.font.fontWithSize(14)
            themeContentsContainer.addSubview(themeLabel)
            
            if(i%2 == 0){
                x = Double(themeContainer.bounds.width/2) + 5
            } else{
                x = 0
                y += 120
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
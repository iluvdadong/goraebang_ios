
import UIKit
import SwiftyJSON

class HomeTabController: UIViewController {
    
    // 아이폰 화면비율 9:16
    // 아이폰 5s 640x1136
    
    // http://52.78.101.90/json/song , json url
    
    // MARK : Variables
    var bottomContainerScrollView: UIScrollView!
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var imageViewArray: [UIImageView]!
    var labelForImageViewArray: UILabel!
    
    var viewForAlbumTitle: UIView!
    var songLabelForAlbum: UILabel!
    var artistLabelForAlbum: UILabel!
    
    var homeTopBackgroundImageView: UIImageView!
    
    var homeAlbumPageControl: UIPageControl!
    var homeNavBar: UINavigationBar!
    
    var themeTitleArray: [String]!
    
    // chart에서 불러올 개수
    let contentNum = 6
    
    var topChartReadableJSON: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTopChart()
        makeHomeTopBackground()
        makeBottomContainer()
        makeAlbumImageView()
        makeAlbumPageControl()
        makeAlbumScrollView()
        addAlbumContents()
        addThemeContents()
    }
    
    // MARK: SwiftyJSON 사용해서 top 100 chart를 불러온다.
    func getTopChart(){
        let url:NSURL = NSURL(string: "http://52.78.101.90/json/song")!
        let jsonData = NSData(contentsOfURL: url) as NSData!
        
        topChartReadableJSON = JSON(data: jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
        
//        print(topChartReadableJSON[0]["id"].type)
//        print(topChartReadableJSON[0]["id"])
//        print(topChartReadableJSON[0]["jacket"])
    }
    
    // MARK: 화면 상단의 백그라운드 이미지 생성
    func makeHomeTopBackground(){
        homeTopBackgroundImageView = UIImageView(image: UIImage(named: "HomeTopBackground"))
        homeTopBackgroundImageView.frame = CGRectMake(0, 64, view.bounds.width, 130)
        
        view.addSubview(homeTopBackgroundImageView)
        // 4, 4.7, 5.5 inch 크기 별로 설정 view.bounds.width(height)의 배율로 하는게 좋을 것 같다.
    }
    
    // MARK: 화면 하단에 Chart를 표시하는 앨범과, 테마를 담을 Container
    func makeBottomContainer(){
        bottomContainerScrollView = UIScrollView(frame: CGRectMake(0, 194, view.bounds.width, view.bounds.height - 254))
        bottomContainerScrollView.showsHorizontalScrollIndicator = true
        bottomContainerScrollView.contentSize = CGSizeMake(view.bounds.width, view.bounds.height + 45)
        
        // MARK: 고래방 TOP 100 차트 타이틀 라벨
        let chartLabel = UILabel(frame: CGRectMake(10, 5, 200, 50))
        chartLabel.textAlignment = NSTextAlignment.Left
        chartLabel.textColor = UIColor.grayColor()
        chartLabel.text = "TOP 100"
        bottomContainerScrollView.addSubview(chartLabel)
        
        // MARK: TOP100 차트, 테마 구분선
        let divisionLine:UIView = UIView(frame: CGRectMake(5, 210, view.bounds.width-10, 1))
        divisionLine.backgroundColor = UIColor.grayColor()
        bottomContainerScrollView.addSubview(divisionLine)
        
        // MARK: 고래방 테마 타이틀 라벨
        let themeLabel = UILabel(frame: CGRectMake(10, 220, 200, 20))
        themeLabel.textAlignment = NSTextAlignment.Left
        themeLabel.textColor = UIColor.grayColor()
        themeLabel.text = "Theme"
        bottomContainerScrollView.addSubview(themeLabel)
        
        view.addSubview(bottomContainerScrollView)
    }
    
    // 3개씩 넘기 위해서 PageControl을 생성한다.
    func makeAlbumPageControl(){
        homeAlbumPageControl = UIPageControl(frame: CGRectMake(5, 50, view.bounds.width-10, imageViewArray[0].bounds.height + 10))
        view.addSubview(homeAlbumPageControl)
    }
    
    // Top100을 담을 앨범 ImageView를 생성한다.
    func makeAlbumImageView(){
        imageViewArray = [UIImageView(image: UIImage(named: "AlbumTest1")), UIImageView(image: UIImage(named: "AlbumTest2")), UIImageView(image: UIImage(named: "AlbumTest3")), UIImageView(image: UIImage(named: "AlbumTest1")), UIImageView(image: UIImage(named: "AlbumTest2")), UIImageView(image: UIImage(named: "AlbumTest3"))]
    }
    
    // Top100을 담을 ScrollView를 생성한다.
    func makeAlbumScrollView(){
        scrollView = UIScrollView(frame: CGRectMake(0, 0, view.bounds.width-10, imageViewArray[0].bounds.height + 10 + imageViewArray[0].bounds.height/3))
        // remove scroll indicator
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        
        // contentSize가 이미지 뷰의 개수만큼 생기면 된다.
        // UIControl과 Scrollview를 이용해서 앨범 3개씩 넘어가도록 할 수 있다.
        scrollView.contentSize = CGSizeMake(imageViewArray[0].bounds.width*CGFloat(contentNum)+5*CGFloat(contentNum-1), imageViewArray[0].bounds.height + 10 + imageViewArray[0].bounds.height/3)
        
        homeAlbumPageControl.addSubview(scrollView)
        bottomContainerScrollView.addSubview(homeAlbumPageControl)
    }
    
    // Bottom Container에 앨범 추가
    func addAlbumContents(){
        var x = 0
        
        for i in 0...contentNum-1 {
            imageViewArray[i].frame = CGRect(x: x, y: 5, width: Int(imageViewArray[i].bounds.width), height: Int(imageViewArray[i].bounds.height))
            scrollView.addSubview(imageViewArray[i])
            
            // MARK: 노래방 TJ 번호를 담을 라벨
            labelForImageViewArray = UILabel(frame: CGRect(x: 0, y:15, width:50, height:20))
            labelForImageViewArray.text = String(topChartReadableJSON[i]["song_tjnum"].int!)
            labelForImageViewArray.font = labelForImageViewArray.font.fontWithSize(14)
            labelForImageViewArray.backgroundColor = UIColor.redColor() // 끝이 삼각형인 이미지로 변경
            labelForImageViewArray.textColor = UIColor.whiteColor()
            imageViewArray[i].addSubview(labelForImageViewArray)
            
            // MARK: 노래 제목과, 아티스트명을 담을 UIView
            // CHECK: viewForAlbumTitle UIView frame이 Int로 설정되어있는데 CGFloat으로 바꿀 것
            viewForAlbumTitle = UIView(frame: CGRect(x: x, y: Int(imageViewArray[i].bounds.height) + 5, width:Int(imageViewArray[i].bounds.width), height: Int(10 + imageViewArray[0].bounds.height/3)))
            viewForAlbumTitle.backgroundColor = UIColor.init(red: 34/255, green: 34/255, blue:34/255, alpha: 1.0)
            scrollView.addSubview(viewForAlbumTitle)
            
            // MARK : 노래제목 라벨 추가(textView를 이용하면 Inset 넣을 수 있는지 확인)
            songLabelForAlbum = UILabel(frame: CGRect(x: 0, y: 5, width:Int(imageViewArray[i].bounds.width), height: 15))
            songLabelForAlbum.text = topChartReadableJSON[i]["title"].string
            songLabelForAlbum.textAlignment = NSTextAlignment.Left
            songLabelForAlbum.textColor = UIColor.whiteColor()
            
            // 라벨에 Padding 추가
            //            songLabelForAlbum.drawTextInRect(CGRect(x: 10, y: 0, width: songLabelForAlbum.bounds.width, height: songLabelForAlbum.bounds.height))
            
            songLabelForAlbum.font = songLabelForAlbum.font.fontWithSize(14)
            
            // MARK: artist UILabel
            artistLabelForAlbum = UILabel(frame: CGRect(x: 0, y: 20, width:Int(imageViewArray[i].bounds.width), height: 15))
            artistLabelForAlbum.text = topChartReadableJSON[i]["artist"].string
            artistLabelForAlbum.textAlignment = NSTextAlignment.Left
            artistLabelForAlbum.textColor = UIColor.whiteColor()
            artistLabelForAlbum.font = artistLabelForAlbum.font.fontWithSize(14)
            
            viewForAlbumTitle.addSubview(songLabelForAlbum)
            viewForAlbumTitle.addSubview(artistLabelForAlbum)
            
            x = x + Int(imageViewArray[i].bounds.width+5)
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
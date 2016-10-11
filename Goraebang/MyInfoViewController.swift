//
//  MyInfoViewController.swift
//  Goraebang
//
//  Created by Sohn on 08/10/2016.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class MyInfoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var womanButton: UIButton!
    
    @IBOutlet weak var noneButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var email:String!
    var name:String!
    var gender:Int!
    
    let goraebang_url = GlobalSetting.getGoraebangURL()
    let userInfo = UserInfoGetter()
    let communicator = Communicator()
    
    var currentTabIndex:Int!
    
    override func viewDidDisappear(animated: Bool) {
        // 탭 간 이동시에만 사라져야 한다.
        if(currentTabIndex != self.tabBarController?.selectedIndex){
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        self.tabBarController?.selectedIndex
    }
    override func viewDidAppear(animated: Bool) {
        currentTabIndex = self.tabBarController?.selectedIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        setInfo()
        makeProfileImage()
        // Do any additional setup after loading the view.
    }
    
    func setInfo(){
        emailTextField.text = email
        nameTextField.text = name
        setGender(gender)
    }
    
    func makeProfileImage(){
        let documentPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        
        let imagePath = documentPath.URLByAppendingPathComponent("profile.png")
        
        if NSFileManager.defaultManager().fileExistsAtPath(imagePath!.path!){
            profileImage.image = UIImage(contentsOfFile: imagePath!.path!)
        } else {
            // 기본 이미지 삽입
        }
        
        profileImage.layer.cornerRadius = 35
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.darkGrayColor().CGColor
        profileImage.layer.masksToBounds = false
        profileImage.clipsToBounds = true // 이거때문에 원이 유지
    }
    
    @IBAction func uploadProfileImage(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.image = pickedImage
            // 앱에 이미지를 저장해야 한다.
            let documentPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
            
            let imagePath = documentPath.URLByAppendingPathComponent("profile.png")
            
            if let data = UIImagePNGRepresentation(pickedImage){
                
                let result = try? data.writeToURL(imagePath!, options: NSDataWritingOptions.AtomicWrite)
                print(result)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveInfo(sender: AnyObject) {
        // 폰에 name 저장
        
        userInfo.setName(nameTextField.text!)
        // UTF8로 세면 한글 3, 영어 1
                // 인코딩 하면 한글 9, 영어 1
        let name_UTF8 = nameTextField.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        
        let original_number = nameTextField.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        let converted_number = name_UTF8?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        let hangul_count = (converted_number! - original_number!)/6
        let alphabet_count = original_number! - hangul_count*3
        // 영어 숫자(conver - ori) / 6 = 1
        let total_count = hangul_count*2 + alphabet_count
        
        if(total_count < 17){
            let post:NSString = "mytoken=\(userInfo.token)&user[name]=\(name_UTF8!)&user[gender]=\(gender)"
            let url:NSURL = NSURL(string: "\(goraebang_url)/json/user_modify")!
            
            communicator.communicateWithRequest(post, url: url, method: "POST")
            
            self.navigationController?.popViewControllerAnimated(true)
        } else{
            let alert = GoraeAlert(message: "이름 최대 16")
            self.presentViewController(alert.alertController, animated: true, completion: nil)
            alert.dissapear()
        }
    }
    
    // 성별 선택
    
    @IBAction func ClickMan(sender: AnyObject) {
        setGender(1)
    }
    
    @IBAction func ClickWoman(sender: AnyObject) {
        setGender(2)
    }
    
    @IBAction func ClickNone(sender: AnyObject) {
        setGender(3)
    }
    
    func setGender(gender: Int){
        self.gender = gender
        if gender == 0 { // 없는 경우
            manButton.backgroundColor = UIColor.whiteColor()
            womanButton.backgroundColor = UIColor.whiteColor()
            noneButton.backgroundColor = UIColor.whiteColor()
        } else if gender == 1 { // 남자
            manButton.backgroundColor = UIColor.redColor()
            womanButton.backgroundColor = UIColor.whiteColor()
            noneButton.backgroundColor = UIColor.whiteColor()
        } else if gender == 2 { // 여자
            manButton.backgroundColor = UIColor.whiteColor()
            womanButton.backgroundColor = UIColor.redColor()
            noneButton.backgroundColor = UIColor.whiteColor()
        } else {  // 무관
            manButton.backgroundColor = UIColor.whiteColor()
            womanButton.backgroundColor = UIColor.whiteColor()
            noneButton.backgroundColor = UIColor.redColor()
        }
    }
    
    // 바깥쪽 터치 시 키보드 사라짐
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        nameTextField.endEditing(true)
    }
    
    // 이름 입력 후 return Did End on exit
    @IBAction func nameReturn(sender: AnyObject) {
        sender.resignFirstResponder()
        
    }

    
    
    // 성별 선택 끝
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

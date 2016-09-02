//
//  globalSetting.swift
//  Goraebang
//
//  Created by Sohn on 8/27/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import Foundation

class GlobalSetting{
    
    // static function
    class func getGoraebangURL() -> String {
        struct Holder{
//            static var goraebang_url = "https://whale-likelionsunwoo.c9users.io"
            static var goraebang_url = "http://localhost:3000"
//            static var goraebang_url = "http://52.78.113.43"
        }
        return Holder.goraebang_url
    }

}

// 수정
/*
 테마 사이즈, 좌측상단 아이콘,
 
 */

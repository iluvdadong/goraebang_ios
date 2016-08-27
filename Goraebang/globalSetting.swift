//
//  globalSetting.swift
//  Goraebang
//
//  Created by Sohn on 8/27/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import Foundation

class globalSetting{
    
    // static function
    class func getGoraebangURL()->String {
        struct Holder {
            static var goraebang_url = "http://52.78.113.43"
        }
        return Holder.goraebang_url
    }
}

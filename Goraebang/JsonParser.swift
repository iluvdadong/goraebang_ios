//
//  JsonParser.swift
//  Goraebang
//
//  Created by Sohn on 7/26/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import Foundation

class JsonParser {
    func parseJSONResults(data:NSData?) -> [String: AnyObject]? {
        do {
            if let data = data,
                json = try NSJSONSerialization.JSONObjectWithData(data, options:[]) as? [String: AnyObject] {
                return json
            } else {
                print("No Data :/")
            }
        } catch {
            // 실패한 경우, 오류 메시지를 출력합니다.
            print("Error, Could not parse the JSON request")
        }
        
        return nil
    }
}

//: Playground - noun: a place where people can play

import UIKit

let text = "{ \"id\": 123, \"name\": \"Jordan G\", \"age\": 17 }"
let data = text.dataUsingEncoding(NSUTF8StringEncoding)
/////

class OurJSONParser {
    func parseJSONResults() -> [String: AnyObject]? {
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

let parser = OurJSONParser()
let result = parser.parseJSONResults()

if let result = result,
    id = result["id"] as? Int,
    name = result["name"] as? String {
    print ("Found User id: \(id) called \(name)")
}
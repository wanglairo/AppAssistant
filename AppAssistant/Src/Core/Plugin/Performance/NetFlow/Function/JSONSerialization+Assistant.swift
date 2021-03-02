//
//  JSONSerialization+Assistant.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/19.
//

extension JSONSerialization {

    static func jsonObject(with data: Data) -> (json: Any?, error: Error?) {

        var json: Any?
        var err = JsonError(error: nil)
        do {

             json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        } catch {

            err = JsonError(error: error)
        }
        return (json, err.error)
    }

    static func jsonObject(withString dataString: String) -> (json: Any?, error: Error?) {

        var json: Any?
        var err = JsonError(error: nil)
        do {
            let data = dataString.data(using: .utf8) ?? Data()
            json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        } catch {

            err = JsonError(error: error)
        }
        return (json, err.error)
    }

    static func data(with JSONObject: Any) -> (data: Data?, error: Error?) {
        var data: Data?
        var err = JsonError(error: nil)

        do {
             data = try JSONSerialization.data(withJSONObject: JSONObject, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            err = JsonError(error: error)
        }
        return (data, err.error)
    }
}

struct JsonError: LocalizedError {

    var error: Error?
}

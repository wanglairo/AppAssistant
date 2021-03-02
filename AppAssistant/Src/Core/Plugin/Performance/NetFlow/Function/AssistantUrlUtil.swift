//
//  AssistantUrlUtil.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/19.
//

struct AssistantUrlUtil {

    static func convertJsonFromData(_ data: Data) -> String {
        if data.isEmpty {
            return ""
        }
        var jsonString = ""
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
        if JSONSerialization.isValidJSONObject(jsonObject ?? AnyObject.self) {

            let dataObj = try? JSONSerialization.data(withJSONObject: jsonObject as Any, options: .prettyPrinted)
            jsonString = String(data: dataObj ?? Data(), encoding: String.Encoding.utf8) ?? ""
            jsonString = jsonString.replacingOccurrences(of: "\\/", with: "/")
        } else {
            jsonString = String(data: data, encoding: String.Encoding.utf8) ?? ""
        }
        return jsonString
    }

    static func getRequestLength(_ request: URLRequest) -> UInt {
        var headerFields: [String: String] = request.allHTTPHeaderFields ?? [:]
        let cookiesHeader: [String: String] = self.getCookies(request: request)
        if !cookiesHeader.isEmpty {
            let headerFieldsWithCookies = NSMutableDictionary(dictionary: headerFields)
            headerFieldsWithCookies.addEntries(from: cookiesHeader)
            headerFields = headerFieldsWithCookies as? [String: String] ?? [:]
        }

        let headersLength: UInt = self.getHeadersLength(headerFields)
        let httpBody: NSData = getHttpBodyFromRequest(request) as NSData
        let bodyLength = UInt(httpBody.length)
        return headersLength + bodyLength
    }

    static func getHeadersLength(_ headers: [String: String]) -> UInt {
        var headersLength: UInt = 0
        let data = JSONSerialization.data(with: headers)
        headersLength = UInt(data.0?.count ?? 0)
        return headersLength
    }

    static func getCookies(request: URLRequest) -> [String: String] {

        var cookiesHeader = [String: String]()

        let cookieStorage = HTTPCookieStorage.shared

        if let url = request.url, let cookies = cookieStorage.cookies(for: url), !cookies.isEmpty {
            cookiesHeader = HTTPCookie.requestHeaderFields(with: cookies)
        }
        return cookiesHeader
    }

    static func getResponseLength(_ response: HTTPURLResponse, data responseData: Data) -> Int64 {
        var responseLength: Int64 = 0
        if response.isKind(of: HTTPURLResponse.self) {

            var headersLength: UInt = 0
            if let headerFields = response.allHeaderFields as? [String: String] {
                headersLength = getHeadersLength(headerFields)
            }

            var contentLength: Int64
            contentLength = response.expectedContentLength
            if response.expectedContentLength != NSURLSessionTransferSizeUnknown {
                contentLength = response.expectedContentLength
            } else {
                contentLength = Int64(responseData.count)
            }
            responseLength = Int64(headersLength) + contentLength
        }
        return responseLength
    }

    static func getHttpBodyFromRequest(_ request: URLRequest) -> Data {
        var httpBody = Data()
        if let body = request.httpBody {
            httpBody = body
        } else {
            if request.httpMethod == "POST" {
                if request.httpBody == nil {
                    let bufferSize = 1024
                    var myBuffer = [UInt8](repeating: 0, count: bufferSize)
                    let stream = request.httpBodyStream ?? InputStream()
                    let data = NSMutableData()
                    stream.open()
                    while stream.hasBytesAvailable {
                        let len: Int = stream.read(&myBuffer, maxLength: bufferSize)
                        if len > 0 && stream.streamError == nil {
                            data.append(&myBuffer, length: len)
                        }
                    }
                    httpBody = data as Data
                    stream.close()
                }
            }
        }
        return httpBody
    }
}

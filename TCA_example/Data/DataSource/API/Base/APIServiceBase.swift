import Alamofire
import Foundation
import UIKit

public typealias JSONDictionary = [String: Any]
public typealias JSONArray = [JSONDictionary]
public typealias ResponseHeader = [AnyHashable: Any]

public protocol JSONData {
    init()
    static func equal(left: JSONData, right: JSONData) -> Bool
}

extension JSONDictionary: JSONData {
    public static func equal(left: JSONData, right: JSONData) -> Bool {
        NSDictionary(dictionary: left as! JSONDictionary).isEqual(to: right as! JSONDictionary) // swiftlint:disable:this force_cast
    }
}

extension JSONArray: JSONData {
    public static func equal(left: JSONData, right: JSONData) -> Bool {
        let leftArray = left as! JSONArray // swiftlint:disable:this force_cast
        let rightArray = right as! JSONArray // swiftlint:disable:this force_cast

        guard leftArray.count == rightArray.count else {
            return false
        }

        for (index, leftElement) in leftArray.enumerated() where index < rightArray.count {
            if !JSONDictionary.equal(left: leftElement, right: rightArray[index]) {
                return false
            }
        }

        return true
    }
}

open class APIBase {
    public var manager: Alamofire.Session
    public var logOptions = LogOptions.default

    public convenience init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60

        self.init(configuration: configuration)
    }

    public init(configuration: URLSessionConfiguration) {
        manager = Alamofire.Session(configuration: configuration)
    }

    open func request<T: Decodable>(_ input: APIInputBase) async throws -> APIResponse<T> {
        let response: APIResponse<JSONDictionary> = try await requestJSON(input)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response.data, options: .prettyPrinted)
            let decodedObject = try JSONDecoder().decode(T.self, from: jsonData)
            return APIResponse(header: response.header, data: decodedObject)
        } catch {
            throw APIInvalidResponseError()
        }
    }

    open func request<T: Decodable>(_ input: APIInputBase) async throws -> T {
        let response: APIResponse<T> = try await request(input)
        return response.data
    }

    open func request<T: Codable>(_ input: APIInputBase) async throws -> APIResponse<[T]> {
        let response: APIResponse<JSONArray> = try await requestJSON(input)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response.data, options: .prettyPrinted)
            let items = try JSONDecoder().decode([T].self, from: jsonData)
            return APIResponse(header: response.header, data: items)
        } catch {
            throw APIInvalidResponseError()
        }
    }

    open func request<T: Decodable>(_ input: APIInputBase) async throws -> [T] {
        let response: APIResponse<[T]> = try await request(input)
        return response.data
    }

    open func requestJSON<U: JSONData>(_ input: APIInputBase) async throws -> APIResponse<U> {
        let username = input.username
        let password = input.password

        let inputProcessed = try await preprocess(input)
        let dataRequest: DataRequest

        if let uploadInput = inputProcessed as? APIUploadInputBase {
            dataRequest = manager.upload(
                multipartFormData: { multipartFormData in
                    inputProcessed.parameters?.forEach { key, value in
                        if let data = String(describing: value).data(using: .utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                    for item in uploadInput.data {
                        multipartFormData.append(item.data, withName: item.name, fileName: item.fileName, mimeType: item.mimeType)
                    }
                },
                to: uploadInput.urlString,
                method: uploadInput.method,
                headers: uploadInput.headers
            )
        } else {
            dataRequest = manager.request(inputProcessed.urlString,
                                          method: inputProcessed.method,
                                          parameters: inputProcessed.parameters,
                                          encoding: inputProcessed.encoding,
                                          headers: inputProcessed.headers)
        }

        if let username = username, let password = password {
            dataRequest.authenticate(username: username, password: password)
        }

        let dataResponse = await dataRequest.serializingData().response
        return try process(dataResponse, input: inputProcessed)
    }

    open func preprocess(_ input: APIInputBase) async throws -> APIInputBase {
        return input
    }

    open func process<U: JSONData>(_ dataResponse: DataResponse<Data, AFError>, input _: APIInputBase) throws -> APIResponse<U> {
        let error: Error

        switch dataResponse.result {
        case let .success(data):
            let json: U? = (try? JSONSerialization.jsonObject(with: data, options: [])) as? U

            guard let statusCode = dataResponse.response?.statusCode else {
                throw APIUnknownError(statusCode: nil)
            }

            switch statusCode {
            case 200 ..< 300:
                if logOptions.contains(.responseStatus) {
                    print("👍 [\(statusCode)] " + (dataResponse.response?.url?.absoluteString ?? ""))
                }

                if logOptions.contains(.dataResponse) {
                    print(dataResponse)
                }

                if logOptions.contains(.responseData) {
                    print("[RESPONSE DATA]")
                    print(json ?? data)
                }

                return APIResponse(header: dataResponse.response?.allHeaderFields, data: json ?? U())
            default:
                error = handleResponseError(dataResponse: dataResponse, json: json)

                if logOptions.contains(.responseStatus) {
                    print("❌ [\(statusCode)] " + (dataResponse.response?.url?.absoluteString ?? ""))
                }

                if logOptions.contains(.dataResponse) {
                    print(dataResponse)
                }

                if logOptions.contains(.error) || logOptions.contains(.responseData) {
                    print("[RESPONSE DATA]")
                    print(json ?? data)
                }
            }

        case let .failure(afError):
            error = afError
        }

        throw error
    }

    open func handleRequestError<U: JSONData>(_ error: Error, input _: APIInputBase) throws -> APIResponse<U> {
        throw error
    }

    open func handleResponseError<U: JSONData>(dataResponse: DataResponse<Data, AFError>, json: U?) -> Error {
        if let jsonDictionary = json as? JSONDictionary {
            return handleResponseError(dataResponse: dataResponse, json: jsonDictionary)
        } else if let jsonArray = json as? JSONArray {
            return handleResponseError(dataResponse: dataResponse, json: jsonArray)
        }

        return handleResponseUnknownError(dataResponse: dataResponse)
    }

    open func handleResponseError(dataResponse: DataResponse<Data, AFError>, json _: JSONDictionary?) -> Error {
        return APIUnknownError(statusCode: dataResponse.response?.statusCode)
    }

    open func handleResponseError(dataResponse: DataResponse<Data, AFError>, json _: JSONArray?) -> Error {
        return APIUnknownError(statusCode: dataResponse.response?.statusCode)
    }

    open func handleResponseUnknownError(dataResponse: DataResponse<Data, AFError>) -> Error {
        return APIUnknownError(statusCode: dataResponse.response?.statusCode)
    }
}

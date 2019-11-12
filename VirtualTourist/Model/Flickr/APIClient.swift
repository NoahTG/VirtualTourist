//
//  APIClient.swift
//  VirtualTourist
//
//  Created by NTG on 11/11/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation

struct APIClient: APIClientProtocol {
    
    // MARK: Properties
    
    var session: URLSession
    
    // MARK: Initializers
    
    init(session: URLSession) {
        self.session = session
    }
    
    // MARK: Imperatives
        
    func createGETDataTask(
         withURL resourceURL: URL,
              parameters: [String : String],
              headers: [String: String]?,
              andCompletionHandler handler: @escaping (APIClientProtocol.JsonData?, URLSessionTask.TaskError?) -> Void
              ) -> URLSessionDataTask {
        
        
        var components = URLComponents(url: resourceURL, resolvingAgainstBaseURL: false)!
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }

               var request = URLRequest(url: components.url!)
               request.httpMethod = "GET"
               if let headers = headers {
                   headers.forEach { key, value in
                       request.addValue(value, forHTTPHeaderField: key)
                   }
               } else {
                   // The default headers for calling restful APIs.
                   request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                   request.addValue("application/json", forHTTPHeaderField: "Accept")
               }

               return session.dataTask(with: request) { data, response, error in
                   guard error == nil, let data = data else {
                       handler(nil, .connection)
                       return
                   }

                   guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                       handler(nil, .serverResponse)
                       return
                   }

                   handler(data, nil)
               }
           }
}

extension URLSessionTask {

    // Handle possible errors
    enum TaskError: Error {
        case connection
        case serverResponse
        case malformedJsonResponse
        case unexpectedResource
    }
}

// Generate a URL data task
protocol APIClientProtocol {

    // MARK: Types

    // A Data json object waiting to be deserialized.
    typealias JsonData = Data

    // MARK: Properties

    /// The session used by the APIClientProtocol adopter to create the data tasks.
    var session: URLSession { get }

    // MARK: Initializers

    init(session: URLSession)

    // MARK: Imperatives

    /// Creates and configures a data task for a GET HTTP method with the passed parameters.
    /// - Parameters:
    ///     - resourceUrl: the url of the desired resource.
    ///     - parameters: the parameters to be passed with the request.
    ///     - headers: the headers to be sent with the request.
    ///     - completionHandler: the completion handler called when the task finishes, with an error or the data.
    /// - Returns: the configured and not resumed data task.
    func createGETDataTask(
        withURL resourceURL: URL,
        parameters: [String: String],
        headers: [String: String]?,
        andCompletionHandler handler: @escaping (JsonData?, URLSessionTask.TaskError?) -> Void
    ) -> URLSessionDataTask
}










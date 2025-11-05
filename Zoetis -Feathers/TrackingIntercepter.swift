//
//  TrackingIntercepter.swift
//  Zoetis -Feathers
//
//  Created by Nitin Agnihotri on 6/6/25.
//

import Alamofire

class TrackingInterceptor: RequestInterceptor, EventMonitor {
    let queue = DispatchQueue(label: "tracking.interceptor")

    // MARK: - RequestInterceptor
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest)) // no changes, just forward
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry) // no retry logic
    }

    // MARK: - EventMonitor
    func requestDidResume(_ request: Request) {
//        APIActivityTracker.shared.startRequest()
    }

    func requestDidFinish(_ request: Request) {
//        APIActivityTracker.shared.endRequest()
    }

    func request(_ request: DataRequest, didFailWithError error: Error) {
//        APIActivityTracker.shared.endRequest()
    }

    func request(_ request: UploadRequest, didFailWithError error: Error) {
//        APIActivityTracker.shared.endRequest()
    }
}

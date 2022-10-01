//
//  Observable+Ext.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 01/10/22.
//

import Foundation
import RxCocoa
import RxSwift

extension Observable where Element == (HTTPURLResponse, Data) {
    func expectingObject<T: Decodable>(ofType type: T.Type) -> Observable<Result<T, ApiErrorMessage>>{
        return self.map { (httpUrlResponse, data) -> Result<T, ApiErrorMessage> in
            switch httpUrlResponse.statusCode {
            case 200...299:
                let object = try JSONDecoder().decode(type, from: data)
                return .success(object)
                
            default:
                let apiError: ApiErrorMessage
                
                do {
                    apiError = try JSONDecoder().decode(ApiErrorMessage.self, from: data)
                } catch {
                    apiError = ApiErrorMessage(error: ApiErrorDataMessage(message: "Server Error", code: nil))
                }
                
                return .failure(apiError)
            }
        }
    }
}

extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }
}

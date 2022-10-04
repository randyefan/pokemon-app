//
//  JSONFileLoader.swift
//  NostraMiniProjectTests
//
//  Created by Albert Pangestu on 17/07/22.
//

import Foundation

final class JsonFileLoader {
    
    private init() { }
    
    enum Error: Swift.Error {
        case fileNotFound
        case cannotDecodeDataFromURL
    }
    
    static func load(fileName: String, for bundle: Bundle) throws -> Data {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw Error.fileNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            throw Error.cannotDecodeDataFromURL
        }
    }
}

//
//  ViewModelType.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 01/10/22.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

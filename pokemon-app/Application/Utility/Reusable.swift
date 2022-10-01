//
//  Reusable.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 01/10/22.
//

import UIKit
import RxSwift

// MARK: - Reusable

protocol Reusable {
    static var reuseId: String { get }
}

extension Reusable {
    static var reuseId: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: Reusable {}

// MARK: - Reusable View Controller

protocol MVVMViewControllerProtocol: AnyObject {
    associatedtype T
    init(viewModel: T)
}

class MVVMViewController<U>: UIViewController, MVVMViewControllerProtocol {
    
    typealias T = U
    let viewModel: T
    let disposeBag = DisposeBag()
    
    convenience init(){
        fatalError( "init() has not been implemented" )
    }
    
    required init?(coder Decoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    required init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
}


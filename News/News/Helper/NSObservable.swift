//
//  NSObservable.swift
//  News
//
//  Created by Pradeep Selvaraj on 24/04/22.
//

import Foundation
import UIKit

protocol NSBind {
   
    associatedtype ValueType
    associatedtype Listener
    
    var value: ValueType { get set }
    
    /**
     It call back to the binding properties `closure` when `dynamic datas` are changed.
     
     - Parameters:
        - listener: Listener closure function with associated-type.
     - Note: `Optional function parameter is @escaping by default`
     */
    func bind(_ listener: ((ValueType?) -> Void)?)
    
    /**
     It call back to the binding properties `closure` suddenly and when `dynamic datas` are changed.
     
     - Parameters:
        - listener: Listener closure function with associated-type.
     - Note: `Optional function parameter is @escaping by default`
     */
    func bindAndFire(_ listener: ((ValueType?) -> Void)?)
    
}

class Observable<Value>: NSBind {
    
    typealias ValueType = Value
    typealias Listener = (ValueType?) -> Void
    
    var listener: Listener?
    var value: Value {
        didSet {
            listener?(value)
        }
    }
 
    // MARK: - Init methods
    
    init(_ value: Value) {
        self.value = value
    }
    
    // MARK: - Custom methods
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
}


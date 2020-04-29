//
//  Bindable.swift
//  tinderFood
//
//  Created by macOS on 14/04/2020.
//  Copyright © 2020 alex-buduianu. All rights reserved.
//

import Foundation

//https://www.swiftbysundell.com/articles/bindable-values-in-swift/
// because NoSQL permit multiple connection on the same time, it binds action related to firebase actions (dureaza pana se face un query si trebuie sa astept sa se termine query-ul astfel incat sa pot folosi/modifca datele din Database)
class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}

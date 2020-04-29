//
//  User.swift
//  tinderFood
//
//  Created by macOS on 14/04/2020.
//  Copyright © 2020 alex-buduianu. All rights reserved.
//

import UIKit

struct User: ProducesCardViewModel {
    
    // define our properties for our model
    var name: String?
    var firma: String?
    var desc: String?
    var imageURL1: String?
    var uid: String?
    
    init(dictionary: [String: Any]) {
        // we'll initialize our User here
        self.firma = dictionary["firma"] as? String
        self.desc = dictionary["desc"] as? String
        self.name = dictionary["fullName"] as? String
        self.imageURL1 = dictionary["imageURL1"] as? String
        self.uid = dictionary["uid"] as? String
    }
    
    func toCardViewModel() -> CardViewModel {
        
        // NSMutableAttributedString mutable string object that also contains attributes (such as visual style)
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        let firmaString = firma != nil ? "\(firma!)" : "N\\A"
        attributedText.append(NSAttributedString(string: "  \(firmaString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        let descString = desc != nil ? desc! : "Not Available"
        attributedText.append(NSAttributedString(string: "\n\(descString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageNames: [imageURL1 ?? ""], attributedString: attributedText, textAlignment: .left)
    }
}



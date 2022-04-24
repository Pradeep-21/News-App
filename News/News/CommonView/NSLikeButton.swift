//
//  NSLikeButton.swift
//  NEWS
//
//  Created by Pradeep Selvaraj on 24/04/22.
//

import UIKit

class NSLikeButton: NSButton {

    func liked() {
        setImage(UIImage(systemName: "heart.fill"), for: .normal)
        setTitle("Liked", for: .normal)
    }
    
    func unLiked() {
        setImage(UIImage(systemName: "heart"), for: .normal)
        setTitle("Like", for: .normal)
    }

}

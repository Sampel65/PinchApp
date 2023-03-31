//
//  PageModel.swift
//  PinchApp
//
//  Created by Sampel on 04/03/2023.
//

import Foundation

struct Page : Identifiable {
    let id : Int
    let imageName : String
}

extension Page {
    var thumbName : String {
        return "thumb-" + imageName
    }
}

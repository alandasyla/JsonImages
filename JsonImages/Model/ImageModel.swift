//
//  ImageModel.swift
//  JsonImages
//
//  Created by Alanda Syla on 11/5/17.
//  Copyright © 2017 Alanda Syla. All rights reserved.
//

import Foundation
import SwiftyJSON


class ImageModel: NSObject {
    
    var title: String = ""
    var imageDescription : String = ""
    var filename : String = ""
    var height : Int = 0
    var width : Int = 0
    var month: Int = 0
    var year: Int = 0
    
    var imageURL : URL? {
        return URL.init(string: Constants.imageUrl + filename)
    }
    
static func create(from json: JSON) -> ImageModel? {
        
        if let filename = json["filename"].string {
            
            let img = ImageModel()

            img.filename = filename
            img.title = json["title"].string ?? ""
            img.imageDescription = json["description"].string ?? ""
            img.height = json["height"].int ?? 0
            img.width = json["widht"].int ?? 0
            img.month = json["month"].int ?? 0
            img.year = json["year"].int ?? 0
            
            return img
        }
        return nil
    }
}

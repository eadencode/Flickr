//
//  Movie.swift
//  fliCKr
//
//  Created by CK on 4/1/17.
//  Copyright © 2017 CK. All rights reserved.
//

import Foundation
import UIKit

class Movie  {
    
    var title:String
    var overview:String
    var posterUrl:String?
    var id:Int?
    var rating:Double?
    var popularity:Double?
    
    init(details:Dictionary<String, Any>) {
        self.title = details["title"] as! String
        self.overview = details["overview"] as! String
        self.posterUrl = details["poster_path"] as? String
        self.id = details["id"] as? Int
        self.rating = details["vote_average"] as? Double
        self.popularity = details["popularity"] as? Double
    }
    
    
}

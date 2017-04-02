//
//  MovieDB.swift
//  fliCKr
//
//  Created by CK on 4/1/17.
//  Copyright © 2017 CK. All rights reserved.
//

import Foundation


import AFNetworking

class MovieDB {
    
    let apiKey = "64fbef25d73629486460569cef65ac57"
    let apiBaseUrl = "https://api.themoviedb.org/3"
    let lowRes = "w45"
    let highRes = "original"
    let posterSuffix = "w342"
    let imageBaseUrl = "https://image.tmdb.org/t/p/"
    var currentPage:Int = 1
    
//    https://api.themoviedb.org/3/movie/top_rated?api_key=64fbef25d73629486460569cef65ac57&page=1

    static let sharedInstance: MovieDB = { MovieDB() }()
    
    init() {
    }
    
    
    
    func withMovies(endPoint:String , completionHandler:@escaping ([Movie])->()) {
        
        let moviesUrl = "\(apiBaseUrl)/movie/\(endPoint)?api_key=\(apiKey)&page=\(currentPage)"
        var request = URLRequest(url: URL(string:moviesUrl)!)
        
        //Forces requests not to be cached - to simulate network error.
        request.cachePolicy = .reloadIgnoringLocalCacheData
    
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        print("Calling for movies for page \(self.currentPage) ")
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                
                    if let data = data {
                        if let responseDictionary = try! JSONSerialization.jsonObject(
                            with: data, options:[]) as? NSDictionary {
                            let movieResults = responseDictionary["results"] as! [Dictionary<String,Any>]
                            var movieArray = [Movie]()
                            for m in movieResults {
                                print("Movie is \(Movie(details: m).title)")
                                movieArray.append(Movie(details: m))
                            }
                            
                            completionHandler(movieArray)
                        }
                    }else {
                        completionHandler([])
                    }
        });
        task.resume()
    }
    
    //This monitoring - does not work correctly.. even after startmonitoring. Probably use Reachability from Apple.
    func connected()->Bool  {
        return AFNetworkReachabilityManager.shared().isReachable
    }
    
    func movieVideoDetails(id:Int,completionHandler:@escaping (String)->()) {
        
        let moviesUrl = "\(apiBaseUrl)/movie/\(id)/videos?api_key=\(apiKey)"
        let request = URLRequest(url: URL(string:moviesUrl)!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        let movieResults = responseDictionary["results"] as! [Dictionary<String,Any>]
                        var youTubeKey  = ""
                        for m in movieResults {
                            youTubeKey = m["key"] as! String
                        }
                        completionHandler(youTubeKey)
                    }
                }
        });
        task.resume()
    }
    
    
    func highResolutionUrl()-> String {
        return "\(imageBaseUrl)\(highRes)"
    }
    
    func lowResolutionUrl()-> String {
        return "\(imageBaseUrl)\(lowRes)"
    }
    
    func posterUrl()-> String {
        return "\(imageBaseUrl)\(posterSuffix)"
    }
    
}
    

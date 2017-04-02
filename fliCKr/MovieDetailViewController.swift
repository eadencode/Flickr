//
//  MovieDetailViewController.swift
//  fliCKr
//
//  Created by CK on 4/1/17.
//  Copyright © 2017 CK. All rights reserved.
//

import UIKit
import AFNetworking
import youtube_ios_player_helper

class MovieDetailViewController: UIViewController  {
    

    @IBOutlet weak var ytPlayerView: YTPlayerView!
   
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieOverview: UIView!
    
    @IBOutlet weak var movieSummary: UILabel!
    
    var ytPlayerVars = [
        "controls" : 0,
        "playsinline" : 1,
        "autohide" : 1,
        "showinfo" : 0,
        "modestbranding" : 1
        ]

    var movie:Movie?

    var overViewLockedY =  CGFloat(543)
    var overViewLockedX =  CGFloat(0)
    var youTubeTrailerKey:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        renderMovie()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "tvnav"))
        if let mv = movie {
            renderMovie()
            MovieDB.sharedInstance.movieVideoDetails(id: (mv.id)!) { (youTubeKey) in
                self.youTubeTrailerKey  = youTubeKey
                if let ytKey = self.youTubeTrailerKey {
                    self.ytPlayerView.load(withVideoId: ytKey, playerVars: self.ytPlayerVars)
                }
            }
        }
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        ytPlayerView.stopVideo()
    }
    @IBAction func handlePanGesture(_ sender: Any) {
        
        let panRecog = sender as! UIPanGestureRecognizer
        let vel = panRecog.velocity(in: self.view)

        let recogView = panRecog.view
        let translation = panRecog.translation(in: recogView)
        let curY = recogView?.frame.origin.y
        let curX = recogView?.frame.origin.x
        if(vel.y < 0 ) {
            if(panRecog.state == UIGestureRecognizerState.began) {
                overViewLockedY = curY!
                overViewLockedX = curX!
            }
            if(panRecog.state == UIGestureRecognizerState.changed)  {
                var frame = recogView?.frame
                frame?.origin.y = curY!+translation.y
                recogView?.frame = frame!
                panRecog.setTranslation(CGPoint(x:0,y:0), in: recogView)
            }
            else if(panRecog.state == UIGestureRecognizerState.ended) {
                let finalX = recogView?.frame.origin.x
                let finalY = CGFloat(90)
                let curY = recogView?.frame.origin.y
                let distance = curY! - finalY
                let animationDuration = CGFloat(3.0)
                let sprintVelocity = -3.0 * vel.y / distance
                let springDampening = CGFloat(0.5)
                UIView.animate(withDuration: TimeInterval(animationDuration), delay: 0, usingSpringWithDamping: springDampening, initialSpringVelocity: sprintVelocity, options: .curveLinear, animations: {
                    var frame = recogView?.frame;
                    frame?.origin.x = finalX!;
                    frame?.origin.y = finalY;
                    recogView?.frame = frame!;
                    recogView?.alpha = 0.95
                    self.ytPlayerView.playVideo()

                }) { _ in
                    print("doneanimatiing")
                }
                
            }
        }
        else {
            UIView.animate(withDuration: 1, animations: { 
                var frame = recogView?.frame;
                frame?.origin.x = self.overViewLockedX;
                frame?.origin.y = self.overViewLockedY
                recogView?.frame = frame!;
                recogView?.alpha = 0.4
                self.ytPlayerView.stopVideo()

            })
        }
        
        
    }

    
    func renderMovie(){
        if let selectedMovie = movie {
            
            let imageUrlLow = "\(MovieDB.sharedInstance.lowResolutionUrl())/\(selectedMovie.posterUrl!)"
            let imageNetworkUrlLow:URLRequest = URLRequest(url:URL(string:imageUrlLow)!)
            let imageUrlHigh = "\(MovieDB.sharedInstance.highResolutionUrl())/\(selectedMovie.posterUrl!)"
            let imageNetworkUrlHigh:URLRequest = URLRequest(url:URL(string:imageUrlHigh)!)
            moviePoster.setImageWith(imageNetworkUrlLow, placeholderImage: nil, success: {( req, res, result) -> Void in
                    self.moviePoster.image = result
                    self.moviePoster.setImageWith(imageNetworkUrlHigh, placeholderImage: nil, success: {( req, res, rresult) -> Void in
                        UIView.animate(withDuration: 3.0, animations: { () -> Void in
                            self.moviePoster.image = rresult
                        })
                    }, failure: {(req, res, result) -> Void in
                        
                    })
            }, failure: {(req, res, result) -> Void in
                
            })
  
        }
        
//        movieSummary.text = movie?.overview
        // create attributed string
        if let mv = movie   {
            let movieTitle = "\(mv.title)\\n"
            let movieDetails = "\(mv.title) \(mv.overview)"
            let boldAttributedString = NSMutableAttributedString(string: movieDetails)
            boldAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Avenir-Heavy", size: 19)!, range: (movieDetails as NSString).range(of: movieTitle))
            
            // set attributed text on a UILabel
            movieSummary.attributedText = boldAttributedString
            
        }
        
        


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

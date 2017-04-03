//
//  MoviesListControllerViewController.swift
//  fliCKr
//
//  Created by CK on 4/1/17.
//  Copyright © 2017 CK. All rights reserved.
//

import UIKit
import ICSPullToRefresh
import JGProgressHUD
import AFNetworking

class MoviesListControllerViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource ,UISearchBarDelegate ,UICollectionViewDelegate, UICollectionViewDataSource{
   
    @IBOutlet weak var search: UIBarButtonItem!
    @IBOutlet weak var displayType: UISegmentedControl!
    @IBOutlet weak var moviesList: UITableView!
    @IBOutlet weak var movieGrid: UICollectionView!
    
    
    @IBOutlet weak var networkError: UIView!
    
    
    var queryFor = "now_playing"
    var movies = [Movie]()
    var moviesOriginal = [Movie]()
    var searchBar = UISearchBar(frame: CGRect(x: CGFloat(0), y: UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.size.width, height: CGFloat(44)))
    
    
    let progressHUD = JGProgressHUD(style: JGProgressHUDStyle.dark)

    // MARK : View Controllers.
    // ---------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesList.delegate = self
        moviesList.dataSource = self
        movieGrid.delegate = self
        movieGrid.dataSource = self
        networkError.isHidden = true

        moviesList.addPullToRefreshHandler {
            self.refreshEnded(list:true)
        }
        
        movieGrid.addPullToRefreshHandler {
            self.refreshEnded(list:false)
        }
        
        moviesList.addInfiniteScrollingWithHandler {
            self.infiniteScroll(list: true)
        }
        
        movieGrid.addInfiniteScrollingWithHandler {
            self.infiniteScroll(list: false)
        }
        
        toReload(segmentIndex: displayType.selectedSegmentIndex)
        moviesList.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(.flexibleHeight)
        //        movieGrid.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(.flexibleHeight)
        addSearchButton()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white , NSFontAttributeName: UIFont.init(name: "Avenir Next Regular", size: CGFloat(14)) ?? UIFont.systemFont(ofSize: CGFloat(14))]
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "tvnav"))
        self.displayType.setImage(AppUtils.imagesizeToFit(image: UIImage(named:"List")!, newSize: CGSize(width:22,height:22), offset: CGPoint(x: 0, y: 0)), forSegmentAt: 1)
        self.displayType.setImage(AppUtils.imagesizeToFit(image: UIImage(named:"Grid")!, newSize: CGSize(width:22,height:22), offset: CGPoint(x: 0, y: 0)), forSegmentAt: 0)
//        loadMovies()
    }

    override func viewWillAppear(_ animated: Bool) {
        progressHUD?.show(in: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.refreshEnded(list:true)
//        self.refreshEnded(list:false)
        MovieDB.sharedInstance.currentPage = 1
        loadMovies()
        
    }
    
    func refreshEnded(list:Bool) {
        DispatchQueue.global(qos: .userInitiated).async{
            sleep(1)
            MovieDB.sharedInstance.currentPage = 1;
            self.movies = [Movie]()
            self.loadMovies()
            DispatchQueue.main.async { [unowned self] in
                if(list){
                    self.moviesList.pullToRefreshView?.stopAnimating()
                }else{
                    self.movieGrid.pullToRefreshView?.stopAnimating()
                }
            }
        }
    }

    func infiniteScroll(list:Bool) {
        DispatchQueue.global(qos: .userInitiated).async {
            sleep(1)
            DispatchQueue.main.async { [unowned self] in
                MovieDB.sharedInstance.currentPage += 1
                self.loadMovies()
                if(list){
                    self.moviesList.infiniteScrollingView?.stopAnimating()
                }else{
                    self.movieGrid.infiniteScrollingView?.stopAnimating()
                }
            }
        }
    }

    
    override func viewDidDisappear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK : Network Calls and Data Loading.
    // ---------------------------------------------------------------------

    func loadMovies() {
        MovieDB.sharedInstance.withMovies(endPoint: queryFor) { (moviesArg) in
            if(moviesArg.isEmpty) {
                self.networkError.isHidden = false
            }else {
                if(MovieDB.sharedInstance.currentPage == 1) {
                    self.movies = [Movie]()
                }
                self.movies.append(contentsOf: moviesArg)
                self.moviesOriginal = self.movies
                self.moviesList.reloadData()
                self.movieGrid.reloadData()
                self.networkError.isHidden = true
            }
            self.progressHUD?.dismiss()
        }
    }
    
    // MARK: Display Change {Grid | Table }
    // ---------------------------------------------------------------------
    
    @IBAction func displayTypeChanged(_ sender: UISegmentedControl) {
        toReload(segmentIndex: sender.selectedSegmentIndex)
    }

    func toReload(segmentIndex:Int) {
        
        if(segmentIndex == 0) {
            movieGrid.isHidden = true
            moviesList.isHidden = false
            moviesList.reloadData()
        }else {
            movieGrid.isHidden = false
            moviesList.isHidden = true
            movieGrid.reloadData()
        }
        self.movies = self.moviesOriginal
    }
    
    
    
    // MARK: Table View Rendering
    // ---------------------------------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "movieTableViewCell", for: indexPath) as! MovieTableCell
        if(!movies.isEmpty) {
            let rowMovie:Movie = movies[indexPath.row]
            if let imgUrl = rowMovie.posterUrl {
                let imageUrlHigh = "\(MovieDB.sharedInstance.posterUrl())/\(imgUrl)"
                let imageNetworkUrl:URLRequest = URLRequest(url:URL(string:imageUrlHigh)!)
                
                movieCell.movieImage.setImageWith(imageNetworkUrl, placeholderImage: nil, success: {( req, res, result) -> Void in
                    if res != nil {
                        movieCell.movieImage.alpha = 0.0
                        movieCell.movieImage.image = result
                        UIView.animate(withDuration: 3.0, animations: { () -> Void in
                            movieCell.movieImage.alpha = 1.2
                        })
                    }else{
                        movieCell.movieImage.image = result
                    }
                }, failure: {(req, res, result) -> Void in
                    
                })
            }
            movieCell.summary.text = rowMovie.overview
            movieCell.summary.sizeToFit()
            movieCell.movieTitle.text = rowMovie.title
            movieCell.movieTitle.sizeToFit()
            movieCell.selectionStyle = UITableViewCellSelectionStyle.gray
            movieCell.accessoryType = UITableViewCellAccessoryType.none
            movieCell.rating.text = "\(rowMovie.rating!)"
            
        }
        return movieCell
    }
    
    
    
    // MARK: Collection View Rendering
    // ---------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieGridCell", for: indexPath) as! MovieGridCell
        if(!movies.isEmpty) {
            let rowMovie:Movie = movies[indexPath.row]
            if let imgUrl = rowMovie.posterUrl {
                let imageUrl = "\(MovieDB.sharedInstance.posterUrl())/\(imgUrl)"
                let imageNetworkUrl:URLRequest = URLRequest(url:URL(string:imageUrl)!)
                
                movieCell.gridMovieImage.setImageWith(imageNetworkUrl, placeholderImage: nil, success: {( req, res, result) -> Void in
                    if res != nil {
                        movieCell.gridMovieImage.alpha = 0.0
                        movieCell.gridMovieImage.image = result
                        UIView.animate(withDuration: 3.0, animations: { () -> Void in
                            movieCell.gridMovieImage.alpha = 1.2
                        })
                    }else{
                        movieCell.gridMovieImage.image = result
                    }
                }, failure: {(req, res, result) -> Void in
                    
                })
            }
            movieCell.gridMovieTitle.text = rowMovie.title
            movieCell.gridMovieTitle.layer.borderColor = UIColor.gray.cgColor
            movieCell.gridMovieTitle.layer.borderWidth = 0.3
            movieCell.gridMovieImage.layer.borderWidth = 0.3
            movieCell.gridMovieImage.layer.borderColor = UIColor.gray.cgColor
        }
        return movieCell
    }
    
    // MARK : Search Bar
    // TODO : Search from api. But looks like no api for search.
    // ---------------------------------------------------------------------
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        UIView.animate(withDuration: 0.5) {
            self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "tvnav"))
            self.addSearchButton()
            self.searchBar.alpha = 0
            self.movies = self.moviesOriginal
            self.moviesList.reloadData()
            self.movieGrid.reloadData()

        }
        
    }
    
    func addSearchButton() {
        let searchIconButton = UIButton(type: .custom)
        searchIconButton.setImage(UIImage(named: "search"), for: .normal)
        searchIconButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        searchIconButton.addTarget(self, action: #selector(self.showSearchBar), for: .touchUpInside)
        let buttonitem = UIBarButtonItem(customView: searchIconButton)
        self.navigationItem.rightBarButtonItem = buttonitem
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        movies = [Movie]()
        let searchLowerCase = searchText.lowercased()
        for movie in moviesOriginal {
            if movie.title.lowercased().contains(searchLowerCase) || movie.overview.lowercased().contains(searchLowerCase){
                let moviesNSArray = movies as NSArray
                if( !moviesNSArray.contains(movie)) {
                    movies.append(movie)
                }
            }
        }
        if searchText == "" {
            movies = moviesOriginal
        }
        moviesList.reloadData()
        movieGrid.reloadData()
    }
    
    
    
    @IBAction func tapSearch(_ sender: Any) {
        showSearchBar()
    }
    
    func showSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: CGFloat(-3), y: UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.size.width, height: CGFloat(44)))
        searchBar.backgroundColor = UIColor.black
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search Movies.."
        searchBar.delegate = self
        UIView.animate(withDuration: 0.5) {
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.titleView = self.searchBar
            self.searchBar.alpha = 0
        }
        
        UIView.animate(withDuration: 0.5) {
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.titleView = self.searchBar
            self.searchBar.alpha = 1
            self.searchBar.becomeFirstResponder()
        }

    }
    

    // MARK: - Navigation to movie detail
    // ---------------------------------------------------------------------

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var selectedCell:Any?
        var indexPath:IndexPath?

        if(displayType.selectedSegmentIndex == 0 ) {
            selectedCell = sender as! MovieTableCell
            indexPath = moviesList.indexPath(for: selectedCell as! MovieTableCell)
        }else{
            selectedCell = sender as! MovieGridCell
            indexPath = movieGrid.indexPath(for: selectedCell as! MovieGridCell)

        }
        if(!movies.isEmpty) {
            let movie = movies[indexPath!.row]
            let detailViewController = segue.destination as! MovieDetailViewController
            detailViewController.movie = movie
        }
    }

}

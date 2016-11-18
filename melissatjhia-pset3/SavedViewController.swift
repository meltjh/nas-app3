//
//  SavedViewController.swift
//  melissatjhia-pset3
//
//  Created by Melissa Tjhia on 16-11-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var savedMoviesTableView: UITableView!
    var selectedId = ""
    var watchList: [String]? = []
    
    /// Reloads the data everytime the ViewController is shown.
    override func viewWillAppear(_ animated: Bool) {
        watchList = UserDefaults.standard.object(forKey: "WatchList") as? [String]
        
        if watchList == nil {
            watchList = []
        }
        self.savedMoviesTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Determine the height of the TableViewCell, would not work when using the Utilities only.
        savedMoviesTableView.rowHeight = UITableViewAutomaticDimension
        savedMoviesTableView.rowHeight = 150
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Go to the view with the details of the selected movie TableViewCell.
    func tableView(_ didSelectRowAttableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedId = (watchList?[indexPath.row])!
        self.performSegue(withIdentifier: "detailedMovieSegue", sender: self)
    }
    
    /// Returns the number of TableViewCells that have to be filled.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchList!.count
    }
    
    /// Fills the TableViewCell with the movie data.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.savedMoviesTableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! SingleResultTableViewCell
        let imdbID =  watchList?[indexPath.row]
        let urlString = "https://www.omdbapi.com/?i=" + imdbID!
        let request = URLRequest(url: URL(string: urlString)!)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            // Guards execute when the condition is NOT met.
            guard let data = data, error == nil else {
                self.changeToDefault(cell: cell)
                return
            }
            
            // Get access to the main thread and the interface elements:
            DispatchQueue.main.async {
                do {
                    
                    // Convert data to json.
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    
                    // Check if the response is true.
                    if json["Error"] != nil {
                        self.changeToDefault(cell: cell)
                    }
                    else {
                        // Fill the TableViewCell Labels with the movie data.
                        cell.titleLabel.text = json["Title"] as! String?
                        cell.yearLabel.text = json["Year"] as! String?
                        cell.yearLabel.text = json["imdbRating"] as! String?
                        cell.posterImageView.image = nil
                        
                        if let tempUrl = json["Poster"] as? String {
                            // Urls with http do not return an image, should have https.
                            let url = NSURL(string: tempUrl.replacingOccurrences(of: "http:", with: "https:"))
                            if let poster = NSData(contentsOf: url as! URL) {
                                cell.posterImageView.image = UIImage(data: poster as Data)
                            }
                        }
                    }
                } catch {
                    self.changeToDefault(cell: cell)
                }
            }
            
        }).resume()
        
        return cell
    }
    
    /// Empties the Labels in case of an error.
    func changeToDefault(cell: SingleResultTableViewCell) {
        cell.titleLabel.text = ""
        cell.yearLabel.text = ""
    }
    
    /// Prepares the movie information that has to be shown in the DetailedViewController.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailedViewController {
            vc.imdbID = selectedId
            vc.getData(id: selectedId)
        }
    }
    
}


//
//  DetailedViewController.swift
//  melissatjhia-pset3
//
//  Created by Melissa Tjhia on 16-11-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    
    @IBOutlet var detailedView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var plotTextView: UITextView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    var movieInfo : Dictionary<String, AnyObject> = [:]
    var imdbID = ""
    var watchList: [String]? = []
    
    /// Reloads the data everytime the DetailedViewController is shown.
    override func viewWillAppear(_ animated: Bool) {
        watchList = UserDefaults.standard.object(forKey: "WatchList") as? [String]
        
        if watchList == nil {
            watchList = []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButtonEnabledDisabled()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Adds the movie to the Bookmarks when the 'Add' Button is clicked.
    @IBAction func addMovie(_ sender: Any) {
        watchList = UserDefaults.standard.object(forKey: "WatchList") as? [String]
        
        // Check if WatchList exists in the UserDefaults.
        if watchList != nil {
            // Only add to Bookmarks if it is not already bookmarked.
            if !watchList!.contains(imdbID)  {
                watchList!.append(imdbID)
                UserDefaults.standard.set(watchList, forKey: "WatchList")
            }
        }
        else {
            watchList = [imdbID]
            UserDefaults.standard.set(watchList, forKey: "WatchList")
        }
        changeButtonEnabledDisabled()
    }
    
    /// Removes the movie from the Bookmarks when the 'Remove' Button is clicked.
    @IBAction func removeMovie(_ sender: Any) {
        watchList = UserDefaults.standard.object(forKey: "WatchList") as? [String]
        
        // Check if WatchList exists in the UserDefaults.
        if watchList != nil {
            // Only remove if it is in Bookmarks.
            if watchList!.contains(imdbID) {
                if let index = watchList?.index(of: imdbID) {
                    watchList?.remove(at: index)
                    UserDefaults.standard.set(watchList, forKey: "WatchList")
                }
            }
        }
        changeButtonEnabledDisabled()
    }
    
    /// Enable or disable the 'Add' and 'Remove' Buttons according to if the movie is in the Bookmarks.
    func changeButtonEnabledDisabled() {
        watchList = UserDefaults.standard.object(forKey: "WatchList") as? [String]
        
        if watchList != nil {
            if watchList!.contains(imdbID)  {
                addButton.isEnabled = false
                removeButton.isEnabled = true
            }
            else {
                addButton.isEnabled = true
                removeButton.isEnabled = false
            }
        }
        else {
            addButton.isEnabled = true
            removeButton.isEnabled = false
        }
    }
    
    /// Empties the Labels in case of an error.
    func changeToDefault() {
        self.yearLabel.text = ""
        self.ratingLabel.text = ""
        self.typeLabel.text = ""
        self.plotTextView.text = ""
    }
    
    /// Fills in the ImageView, Label and TextView with the data that belongs to the movie.
    func getData(id: String) {
        let urlString = "https://www.omdbapi.com/?i=" + id + "&y=&plot=full&r=json"
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            // Guards execute when the condition is NOT met.
            guard let data = data, error == nil else {
                self.changeToDefault()
                return
            }
            // Get access to the main thread and the interface elements:
            DispatchQueue.main.async {
                do {
                    // Convert data to json.
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    
                    // Check if the response is true.
                    if json["Error"] != nil {
                        self.changeToDefault()
                    }
                    else {
                        // Fill the ImageView, Labels and TextView with the movie data.
                        self.movieInfo = json
                        self.imdbID = self.movieInfo["imdbID"] as! String
                        self.title = json["Title"] as! String?
                        self.yearLabel.text = json["Year"] as! String?
                        self.ratingLabel.text = json["imdbRating"] as! String?
                        self.typeLabel.text = json["Type"] as! String?
                        self.plotTextView.text = json["Plot"] as! String?
                        self.posterImageView.image = nil
                        
                        if let tempUrl = json["Poster"] as? String {
                            // Urls with http do not return an image, should have https.
                            let url = NSURL(string: tempUrl.replacingOccurrences(of: "http:", with: "https:"))
                            if let poster = NSData(contentsOf: url as! URL) {
                                self.posterImageView.image = UIImage(data: poster as Data)
                            }
                        }
                    }
                } catch {
                    self.changeToDefault()
                }
            }
        }).resume()
    }
}

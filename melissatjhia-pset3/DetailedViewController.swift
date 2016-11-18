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
    let defaults = UserDefaults.standard
    var watchList: [String]? = []
    
    override func viewWillAppear(_ animated: Bool) {
        watchList = defaults.object(forKey: "WatchList") as? [String]
        
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
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addMovie(_ sender: Any) {
        watchList = defaults.object(forKey: "WatchList") as? [String]
        
        if watchList != nil {
            if !watchList!.contains(imdbID)  {
                watchList!.append(imdbID)
                defaults.set(watchList, forKey: "WatchList")
            }
        }
        else {
            watchList = [imdbID]
            defaults.set(watchList, forKey: "WatchList")
        }
        changeButtonEnabledDisabled()
    }
    
    @IBAction func removeMovie(_ sender: Any) {
        watchList = defaults.object(forKey: "WatchList") as? [String]
        
        if watchList != nil {
            if watchList!.contains(imdbID)  {
                if let index = watchList?.index(of: imdbID) {
                    watchList?.remove(at: index)
                    defaults.set(watchList, forKey: "WatchList")
                }
            }
        }
        changeButtonEnabledDisabled()
    }
    
    func changeButtonEnabledDisabled() {
        watchList = defaults.object(forKey: "WatchList") as? [String]
        
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
    
    
    func getData(id: String) {
        let urlString = "https://www.omdbapi.com/?i=" + id + "&y=&plot=full&r=json"
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            // Guards execute when the condition is NOT met.
            guard let data = data, error == nil else {
                let httpResponse = response as? HTTPURLResponse
                print("Status code: (\(httpResponse?.statusCode))")
                
                // Error handling: what does the user expect when this fails?
                return
            }
            // Get access to the main thread and the interface elements:
            DispatchQueue.main.async {
                do {
                    
                    // Convert data to json. (You’ll need the do-catch code for this part.)
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    
                    // Check if the response is true. (Was the movie found? What to do if not?)
                    if json["Error"] != nil {
                        print("Error: " + (json["Error"]! as! String))
                    }
                    else {
                        self.movieInfo = json
                        self.imdbID = self.movieInfo["imdbID"] as! String
                        self.title = json["Title"] as! String?
                        
                        self.yearLabel.text = json["Year"] as! String?
                        self.ratingLabel.text = json["imdbRating"] as! String?
                        self.typeLabel.text = json["Type"] as! String?
                        self.plotTextView.text = json["Plot"] as! String?
                        
                        self.posterImageView.image = nil

                        if let tempUrl = json["Poster"] as? String {
                            let url = NSURL(string: tempUrl.replacingOccurrences(of: "http:", with: "https:"))
                            if let poster = NSData(contentsOf: url as! URL) {
                                self.posterImageView.image = UIImage(data: poster as Data)
                            }
                        }
                    }
                } catch {
                    // Error handling: what does the user expect when this fails?
                }
            }
        }).resume()
    }
}

//
//  SecondViewController.swift
//  melissatjhia-pset3
//
//  Created by Melissa Tjhia on 16-11-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var savedMoviesTableView: UITableView!
    let defaults = UserDefaults.standard
    var selectedId = ""
    var watchList: [String]? = []
    
    override func viewWillAppear(_ animated: Bool) {
        watchList = defaults.object(forKey: "WatchList") as? [String]
        
        if watchList == nil {
            watchList = []
        }
        self.savedMoviesTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedMoviesTableView.rowHeight = UITableViewAutomaticDimension
        savedMoviesTableView.rowHeight = 150
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ didSelectRowAttableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedId = (watchList?[indexPath.row])!
        self.performSegue(withIdentifier: "detailedMovieSegue", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.savedMoviesTableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! SingleResultTableViewCell
        let imdbID =  watchList?[indexPath.row]
        let urlString = "https://www.omdbapi.com/?i=" + imdbID!
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
                        
                        cell.titleLabel.text = json["Title"] as! String?
                        cell.yearLabel.text = json["Year"] as! String?
                        cell.yearLabel.text = json["imdbRating"] as! String?
                        cell.posterImageView.image = nil
                        
                        if let tempUrl = json["Poster"] as? String {
                            let url = NSURL(string: tempUrl.replacingOccurrences(of: "http:", with: "https:"))
                            if let poster = NSData(contentsOf: url as! URL) {
                                cell.posterImageView.image = UIImage(data: poster as Data)
                            }
                        }
                    }
                } catch {
                    // Error handling: what does the user expect when this fails?
                }
            }
            
        }).resume()
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailedViewController {
            vc.imdbID = selectedId
            vc.getData(id: selectedId)
        }
    }
    
}


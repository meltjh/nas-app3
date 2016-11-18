//
//  FirstViewController.swift
//  melissatjhia-pset3
//
//  Created by Melissa Tjhia on 16-11-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    var searchResults: [Dictionary<String, AnyObject>] = []
    var selectedId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsTableView.rowHeight = UITableViewAutomaticDimension
        searchResultsTableView.estimatedRowHeight = 300
        let title = "Melissa"
        getData(urlString: "https://www.omdbapi.com/?s=" + title)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ didSelectRowAttableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellInfo = searchResults[indexPath.row]
        selectedId = cellInfo["imdbID"] as! String
        self.performSegue(withIdentifier: "detailedResultSegue", sender: self)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchResultsTableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! SingleResultTableViewCell
        let cellInfo =  searchResults[indexPath.row]
        cell.titleLabel.text = cellInfo["Title"] as! String?
        cell.yearLabel.text = cellInfo["Year"] as! String?
        
        cell.posterImageView.image = nil

        if let tempUrl = cellInfo["Poster"] as? String {
            let url = NSURL(string: tempUrl.replacingOccurrences(of: "http:", with: "https:"))
            if let poster = NSData(contentsOf: url as! URL) {
                cell.posterImageView.image = UIImage(data: poster as Data)
            }
        }
        
        return cell
    }
    
    
    func getData(urlString: String) {
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
                        self.searchResults = json["Search"]! as! [Dictionary<String, AnyObject>]
                    }
                } catch {
                    // Error handling: what does the user expect when this fails?
                }
                
                self.searchResultsTableView.reloadData()
            }
            
        }).resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as?
            DetailedViewController {
            vc.imdbID = selectedId
            vc.getData(id: selectedId)
        }
    }
}


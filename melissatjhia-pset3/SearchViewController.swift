//
//  SearchViewController.swift
//  melissatjhia-pset3
//
//  Created by Melissa Tjhia on 16-11-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    var searchResults: [Dictionary<String, AnyObject>] = []
    var selectedId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Determine the height of the TableViewCell, would not work when using the Utilities only.
        searchResultsTableView.rowHeight = UITableViewAutomaticDimension
        searchResultsTableView.rowHeight = 150
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    /// Search for the input of the SearchBar.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // For more than one search term.
        let searchTerms = searchText.replacingOccurrences(of: " ", with: "+")
        getData(searchTerms: searchTerms)
    }
    
    /// Go to the view with the details of the selected movie TableViewCell.
    func tableView(_ didSelectRowAttableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellInfo = searchResults[indexPath.row]
        selectedId = cellInfo["imdbID"] as! String
        self.performSegue(withIdentifier: "detailedResultSegue", sender: self)
    }
    
    /// Returns the number of TableViewCells that have to be filled.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    /// Fills the TableViewCell with the movie data.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchResultsTableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! SingleResultTableViewCell
        let cellInfo =  searchResults[indexPath.row]
        cell.titleLabel.text = cellInfo["Title"] as! String?
        cell.yearLabel.text = cellInfo["Year"] as! String?
        
        cell.posterImageView.image = nil
        
        if let tempUrl = cellInfo["Poster"] as? String {
            // Urls with http do not return an image, should have https.
            let url = NSURL(string: tempUrl.replacingOccurrences(of: "http:", with: "https:"))
            if let poster = NSData(contentsOf: url as! URL) {
                cell.posterImageView.image = UIImage(data: poster as Data)
            }
        }
        return cell
    }
    
    /// Returns a dictionary with the results that correspond to the search terms.
    func getData(searchTerms: String) {
        let urlString = "https://www.omdbapi.com/?s=" + searchTerms
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            // Guards execute when the condition is NOT met.
            guard let data = data, error == nil else {
                self.searchResults = []
                return
            }
            
            // Get access to the main thread and the interface elements:
            DispatchQueue.main.async {
                do {
                    // Convert data to json.
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    
                    // Check if the response is true.
                    if json["Error"] != nil {
                        self.searchResults = []
                    }
                    else {
                        // The list with results.
                        self.searchResults = json["Search"]! as! [Dictionary<String, AnyObject>]
                    }
                } catch {
                    self.searchResults = []
                }
                self.searchResultsTableView.reloadData()
            }
        }).resume()
    }
    
    /// Prepares the movie information that has to be shown in the DetailedViewController.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as?
            DetailedViewController {
            vc.imdbID = selectedId
            vc.getData(id: selectedId)
        }
    }
}


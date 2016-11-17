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
    var results: Dictionary<String, AnyObject> = [:]
    var selectedId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsTableView.rowHeight = UITableViewAutomaticDimension
        searchResultsTableView.estimatedRowHeight = 300
        let title = "Twilight"
        getData(urlString: "https://www.omdbapi.com/?s=" + title)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(_ didSelectRowAttableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResults = self.results["Search"]!
        let selectedResult = searchResults[indexPath.row] as! [String: Any]
        selectedId = selectedResult["imdbID"] as! String
        print(selectedId)
        self.performSegue(withIdentifier: "detailedResultSegue", sender: self)
        
        
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchResultsTableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! SingleResultTableViewCell
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
            do {
                
                // Convert data to json. (You’ll need the do-catch code for this part.)
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                
                // Check if the response is true. (Was the movie found? What to do if not?)
                if json["Error"] != nil {
                    print("Error: " + (json["Error"]! as! String))
                }
                else {
                    self.results = json
                    
                    // Get access to the main thread and the interface elements:
                    DispatchQueue.main.async {
                        print("hi")
                    }
                }
            } catch {
                // Error handling: what does the user expect when this fails?
            }
        }).resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let vc = segue.destination as? DetailedViewController {
        vc.getData(id: selectedId)
        }
    }
}


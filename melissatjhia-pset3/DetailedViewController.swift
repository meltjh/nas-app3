//
//  DetailedViewController.swift
//  melissatjhia-pset3
//
//  Created by Melissa Tjhia on 16-11-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var plotTextView: UITextView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!

    var movieInfo : Dictionary<String, AnyObject> = [:]
    var imdbID = ""
    let defaults = UserDefaults.standard
    var watchList: [String]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("watchList")
        print(watchList!)
        // Do any additional setup after loading the view.
        
//        let defaults = UserDefaults.standard
//        defaults.set(waarde, forKey: key)
//        let defaults = UserDefaults.standard
//        let waarde = defaults.bool(forKey: key)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @IBAction func addMovie(_ sender: Any) {
//        let present = defaults.bool(forKey: imdbID)
//        print("present" + String(present))
//        defaults.set(true, forKey: imdbID)
//    }
    
    @IBAction func addMovie(_ sender: Any) {
        watchList = defaults.object(forKey: "WatchList") as? [String]


        
        if watchList != nil {
            print("Before")
            print(watchList!)
            if !watchList!.contains(imdbID)  {
                watchList!.append(imdbID)
                defaults.set(watchList, forKey: imdbID)
            }
        }
        else {
            watchList = [imdbID]
            defaults.set(watchList, forKey: imdbID)
        }
        print("After")
        print(watchList)

//        print("defaults")
//        print(UserDefaults.standard.dictionaryRepresentation().keys)
    }
    
    @IBAction func removeMovie(_ sender: Any) {
//        let present = defaults.bool(forKey: imdbID)
//        if present == true {
//            defaults.removeObject(forKey: imdbID)
//        }
        print("defaults")
        print(UserDefaults.standard.dictionaryRepresentation().keys)
    }
    
    
    func getData(id: String) {
        let urlString = "https://www.omdbapi.com/?i=" + id + "&y=&plot=full&r=json"
        print(urlString)
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
                        self.movieInfo = json
                        self.imdbID = self.movieInfo["imdbID"] as! String
                        self.title = json["Title"] as! String?

                        // Get access to the main thread and the interface elements:
                        DispatchQueue.main.async {

                            self.yearLabel.text = json["Year"] as! String?
                            self.ratingLabel.text = json["imdbRating"] as! String?
                            self.languageLabel.text = json["Language"] as! String?
                            self.plotTextView.text = json["Plot"] as! String?

                            if let url = NSURL(string: json["Poster"] as! String) {
                                if let poster = NSData(contentsOf: url as URL) {
                                    self.posterImageView.image = UIImage(data: poster as Data)
                                }
                            }
                        }
                }
            } catch {
                // Error handling: what does the user expect when this fails?
            }
        }).resume()
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

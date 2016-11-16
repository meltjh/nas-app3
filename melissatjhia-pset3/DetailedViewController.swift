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

    override func viewDidLoad() {
        super.viewDidLoad()
        let title = "twilight"
        getData(urlString: "https://www.omdbapi.com/?t=" + title + "&y=&plot=full&r=json")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                        let title = json["Title"]!
                        print(title)
                        self.title = json["Title"] as! String?
                    }
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

//
//  homeTableViewController.swift
//  Twitter
//
//  Created by Jeury Tineo on 3/2/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class homeTableViewController: UITableViewController {
    var tweets = [NSDictionary]()
    var numOfTweets: Int!
    
    @IBAction func logoutButton(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    func loadTweet(){
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": 300]

        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: params, success: { (tweets: [NSDictionary]) in

            self.tweets.removeAll()
            for tweet in tweets{
                self.tweets.append(tweet)
            }
            self.tableView.reloadData()

        }, failure: { (Error) in
            print("Could not collect tweets!")
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! tweetCell
        
        let tweet = tweets[indexPath.row]
        let userName = tweet["name"] as? String
        let content = (tweets[indexPath.row]["text"]) as! String
        
        cell.usernameLabel.text = userName
        cell.tweetContent.text = content
        
        let user = tweets[indexPath.row]["user"] as! NSDictionary

        cell.usernameLabel.text = user["name"] as? String
        cell.tweetContent.text = (tweets[indexPath.row]["text"] as! String)

        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageURL!)

        if let imageData = data {
            cell.profileView.image = UIImage(data: imageData)
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        
        self.tableView.rowHeight = 140
    }

    // MARK: - Table view data source

    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
}

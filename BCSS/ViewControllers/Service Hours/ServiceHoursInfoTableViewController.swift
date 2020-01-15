//
//  ServiceHoursInfoTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-10-17.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit

class ServiceHoursInfoTableViewController: UITableViewController {
    
    //VARIABLES
    var name: String!
    var date: String!
    var hours: Double!
    var desc: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SETUP
        
        //Initializing service hours info
        nameLabel.text = name!
        dateLabel?.text = "Date: \(date!)"
        hoursLabel?.text = String("Hours: \(hours!)")
        descText.text = desc

        
    }
    
    //OUTLETS
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descText: UITextView!
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    

}

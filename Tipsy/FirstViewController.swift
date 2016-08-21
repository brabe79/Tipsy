//
//  FirstViewController.swift
//  Tipsy
//
//  Created by Brian Rabe on 8/16/16.
//  Copyright © 2016 Tipsy. All rights reserved.
//

import UIKit


class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

@IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
       
}
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell
    }
}


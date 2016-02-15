//
//  ViewController.swift
//  Demo
//
//  Created by Wesley Cope on 2/11/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import UIKit
import Inquire

class ViewController: UITableViewController {
    let identifier  = "cell.ident"
    let form        = RegisterForm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: identifier)
        
        automaticallyAdjustsScrollViewInsets    = true
        edgesForExtendedLayout                  = .None
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.fields.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(identifier) else {
            fatalError("NO CELL")
        }
        cell.selectionStyle = .None
        
        let field   = form.fields[indexPath.row] as! TextField
        field.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60)
        
        cell.contentView.addSubview(field)

        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
}


//
//  TableViewController.swift
//  lab03
//
//  Created by Piotr Ziniewicz on 25/10/16.
//  Copyright © 2016 Użytkownik Piotr Ziniewicz. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController, ViewControllerDelegate {
    
    @IBOutlet weak var plusButton: UIButton!
    
    @IBAction func addButtonAction(sender: UIButton) {
        
    }
    
    // Array containing Songs.plist data
    var albums: NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting Songs.plist path
        let plistCatPath = NSBundle.mainBundle().pathForResource("Songs", ofType: "plist");
        
        // inserting data into array
        albums = NSMutableArray(contentsOfFile:plistCatPath!)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return albums.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)

        cell.textLabel!.text = albums[indexPath.row]["artist"] as? String
        cell.detailTextLabel!.text = albums[indexPath.row]["title"] as? String

        return cell
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "tableViewSegue" {
            if let destinationView = segue.destinationViewController as? ViewController {
                let indexPath = self.tableView.indexPathForSelectedRow
                destinationView.passedAlbum = albums[indexPath!.row] as? NSDictionary
                destinationView.currentAlbum = indexPath!.row
                
                destinationView.delegate = self
            }
        }
        else if segue.identifier == "plusButtonSegue" {
            if let destinationView = segue.destinationViewController as? ViewController {
                destinationView.passedAlbum = nil
                
                destinationView.delegate = self
            }
        }
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
    
    func viewControllerDidSave(album: NSDictionary?, albumIndex: Int?) {
        
        if albumIndex == nil {
            albums.addObject(album!)
        }
        else {
            albums.removeObjectAtIndex(albumIndex!)
            albums.insertObject(album!, atIndex: albumIndex!)
        }
    }
    
    func viewControllerDidDelete(albumIndex: Int?) {
        
        if albumIndex != nil {
            albums.removeObjectAtIndex(albumIndex!)
        }
        else {
            print("Tried to delete album but passed albumIndex is nil.")
        }
    }
}

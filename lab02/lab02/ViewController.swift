//
//  ViewController.swift
//  lab02
//
//  Created by Użytkownik Piotr Ziniewicz on 11.10.2016.
//  Copyright © 2016 Użytkownik Piotr Ziniewicz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentAlbum = 0
    var ratingValue: Double = 0
    
    // Array containing Songs.plist data
    var albums: NSMutableArray = []
    
    var albumsDocPath: String = ""
    
    // Labels
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    // Text fields
    @IBOutlet weak var artistField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var genreField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var newButton: UIButton!
    
    // Button actions
    @IBAction func prevButtonAction(sender: UIButton) {
        currentAlbum -= 1
        updateView()
    }
    
    @IBAction func nextButtonAction(sender: UIButton) {
        if currentAlbum == (albums.count - 1) {
            generateAddNewAlbumView()
        }
        else {
            currentAlbum += 1
            updateView()
        }
    }
    
    @IBAction func saveButtonAction(sender: UIButton) {
        
        let newAlbum : [String : AnyObject] =
        [   "artist" : artistField.text!,
            "title" : titleField.text!,
            "genre" : genreField.text!,
            "date" : Double(yearField.text!)!,
            "rating" : Double(ratingValueLabel.text!)!
        ]
        
        // case when we want to add new album
        if currentAlbum == albums.count {
        
            albums.addObject(newAlbum)
        }
            
        // case when we want to edit existing album
        else {
            albums.removeObjectAtIndex(currentAlbum)
            albums.insertObject(newAlbum, atIndex: currentAlbum)
        }
        
        saveButton.enabled = false
        nextButton.enabled = true
        deleteButton.enabled = true
    }
    
    @IBAction func deleteButtonAction(sender: UIButton) {
        albums.removeObjectAtIndex(currentAlbum)
        
        if currentAlbum > 0 {
            
           currentAlbum -= 1
        }
        
        updateView()
    }
    
    @IBAction func newButtonAction(sender: UIButton) {
        currentAlbum = albums.count - 1
        generateAddNewAlbumView()
    }
    
    func textFieldDidChange(textField: UITextField) {
        saveButton.enabled = true
    }
    
    func stepperValueDidChange(step: UIStepper) {
        
        let stepperMapping: [UIStepper: UILabel] = [stepper: ratingValueLabel]
        
        stepperMapping[step]!.text = "\(Int(step.value))"
        
        saveButton.enabled = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting change listener for text fields
        artistField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        titleField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        genreField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        yearField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        // setting stepper properly
        stepper.autorepeat = true
        stepper.maximumValue = 5.0
        stepper.minimumValue = 0.0
        stepper.value = ratingValue
        stepper.addTarget(self, action: "stepperValueDidChange:", forControlEvents: .ValueChanged)
        
        // searching for the application document directory path
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        albumsDocPath = documentsPath.stringByAppendingString("/albums.plist")
        
        // setting Songs.plist path
        let plistCatPath = NSBundle.mainBundle().pathForResource("Songs", ofType: "plist")
        
        let fileManager = NSFileManager.defaultManager()
        
        if !fileManager.fileExistsAtPath(albumsDocPath) {
            try? fileManager.copyItemAtPath(plistCatPath!, toPath: albumsDocPath)
        }
        
        // inserting data into array
        albums = NSMutableArray(contentsOfFile:plistCatPath!)!
        
        updateView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateView() {
        
        artistField.text = albums[currentAlbum]["artist"] as? String
        titleField.text = albums[currentAlbum]["title"] as? String
        genreField.text = albums[currentAlbum]["genre"] as? String
        yearField.text = String(albums[currentAlbum]["date"]!!)
            
        ratingValue = albums[currentAlbum]["rating"]!! as! Double
        stepper.value = ratingValue
        ratingValueLabel.text = String(Int(ratingValue))
            
        counterLabel.text = "Record \(currentAlbum + 1) of \(albums.count)"
            
        if currentAlbum == 0 {
                prevButton.enabled = false
        }
        else {
            prevButton.enabled = true
        }
            
        nextButton.enabled = true
        newButton.enabled = true
        saveButton.enabled = false
        deleteButton.enabled = true
    }
    
    func generateAddNewAlbumView() {
        currentAlbum += 1
        
        artistField.text = ""
        titleField.text = ""
        genreField.text = ""
        yearField.text = ""
        ratingValueLabel.text = "0"
        ratingValue = 0
        stepper.value = ratingValue
        
        counterLabel.text = "Record \(albums.count + 1) of \(albums.count + 1)"
        
        saveButton.enabled = true
        prevButton.enabled = true
        nextButton.enabled = false
        newButton.enabled = false
        deleteButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


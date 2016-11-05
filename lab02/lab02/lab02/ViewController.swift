//
//  ViewController.swift
//  lab02
//
//  Created by Użytkownik Gość on 11.10.2016.
//  Copyright © 2016 Użytkownik Gość. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentSong = 0
    var ratingValue: Double = 0
    
    // Array containing Songs.plist data
    var songs: NSMutableArray? = [NSMutableDictionary()]
    
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
        currentSong -= 1
        updateView()
    }
    
    @IBAction func nextButtonAction(sender: UIButton) {
        if currentSong == (songs!.count - 1) {
            generateAddNewAlbumView()
        }
        else {
            currentSong += 1
            updateView()
        }
    }
    
    @IBAction func saveButtonAction(sender: UIButton) {
        saveButton.enabled = false
    }
    
    @IBAction func deleteButtonAction(sender: UIButton) {
    }
    
    @IBAction func newButtonAction(sender: UIButton) {
        currentSong = songs!.count - 1
        generateAddNewAlbumView()
    }
    
    func stepperValueDidChange(step: UIStepper) {
        
        let stepperMapping: [UIStepper: UILabel] = [stepper: ratingValueLabel]
        
        stepperMapping[step]!.text = "\(Int(step.value))"
        
        saveButton.enabled = true
    }
    
    func textFieldDidChange(textField: UITextField) {
        saveButton.enabled = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting stepper properly
        stepper.autorepeat = true
        stepper.maximumValue = 5.0
        stepper.minimumValue = 0.0
        stepper.value = ratingValue
        stepper.addTarget(self, action: "stepperValueDidChange:", forControlEvents: .ValueChanged)
        
        // setting action triggers for text fields
        artistField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        titleField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        genreField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        yearField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        // setting Songs.plist path
        let plistCatPath = NSBundle.mainBundle().pathForResource("Songs", ofType: "plist");
        
        // inserting data into array
        songs = NSMutableArray(contentsOfFile:plistCatPath!)
        
        updateView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateView() {
        
        if songs != nil {
            artistField.text = songs![currentSong]["artist"] as? String
            titleField.text = songs![currentSong]["title"] as? String
            genreField.text = songs![currentSong]["genre"] as? String
            yearField.text = String(songs![currentSong]["date"]!!)
            
            ratingValue = songs![currentSong]["rating"]!! as! Double
            stepper.value = ratingValue
            ratingValueLabel.text = String(Int(ratingValue))
            
            counterLabel.text = "Record \(currentSong + 1) of \(songs!.count)"
            
            if currentSong == 0 {
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
    }
    
    func generateAddNewAlbumView() {
        currentSong += 1
        
        artistField.text = ""
        titleField.text = ""
        genreField.text = ""
        yearField.text = ""
        ratingValueLabel.text = "0"
        ratingValue = 0
        stepper.value = ratingValue
        
        counterLabel.text = "Record \(songs!.count + 1) of \(songs!.count + 1)"
        
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


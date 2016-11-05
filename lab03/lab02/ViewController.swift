//
//  ViewController.swift
//  lab02
//
//  Created by Użytkownik Piotr Ziniewicz on 11.10.2016.
//  Copyright © 2016 Użytkownik Piotr Ziniewicz. All rights reserved.
//

import UIKit

protocol ViewControllerDelegate {
    
    func viewControllerDidSave(album: NSDictionary?, albumIndex: Int?)
    func viewControllerDidDelete(albumIndex: Int?)
}

class ViewController: UIViewController {
    
    var delegate: ViewControllerDelegate?
    
    var ratingValue: Double = 0
    
    var passedAlbum: NSDictionary?
    var currentAlbum: Int = 0
    
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
    
    // Buttons
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // Button actions
    @IBAction func saveButtonAction(sender: UIButton) {
        
        let newAlbum : [String : AnyObject] =
        [   "artist" : artistField.text!,
            "title" : titleField.text!,
            "genre" : genreField.text!,
            "date" : Double(yearField.text!)!,
            "rating" : Double(ratingValueLabel.text!)!
        ]
        
        // case when we want to add new album
        if passedAlbum == nil {
            self.delegate?.viewControllerDidSave(newAlbum, albumIndex: nil)
        }
            
        // case when we want to edit existing album
        else {
            self.delegate?.viewControllerDidSave(newAlbum, albumIndex: currentAlbum)
        }
        
        saveButton.enabled = false
        deleteButton.enabled = true
        
        self.performSegueWithIdentifier("unwindToMenu", sender: self)
    }
    
    @IBAction func cancelButtonAction(sender: UIButton) {
        self.performSegueWithIdentifier("unwindToMenu", sender: self)
    }

    @IBAction func deleteButtonAction(sender: UIButton) {
        self.delegate?.viewControllerDidDelete(currentAlbum)
        
        self.performSegueWithIdentifier("unwindToMenu", sender: self)
    }
    
    // Change listeners
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
        stepper.addTarget(self, action: "stepperValueDidChange:", forControlEvents: .ValueChanged)
        
        if passedAlbum != nil {
            artistField.text = passedAlbum!["artist"] as? String
            titleField.text = passedAlbum!["title"] as? String
            genreField.text = passedAlbum!["genre"] as? String
            yearField.text = String(passedAlbum!["date"]!)
            
            ratingValue = passedAlbum!["rating"]! as! Double
            stepper.value = ratingValue
            ratingValueLabel.text = String(Int(ratingValue))
            
            saveButton.enabled = false
            deleteButton.enabled = true
        }
        else {
            generateAddNewAlbumView()
        }
    }
    
    func generateAddNewAlbumView() {
        artistField.text = ""
        titleField.text = ""
        genreField.text = ""
        yearField.text = ""
        ratingValueLabel.text = "0"
        ratingValue = 0
        stepper.value = ratingValue
                
        saveButton.enabled = true
        deleteButton.enabled = false
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


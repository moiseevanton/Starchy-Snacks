//
//  ViewController.swift
//  Stretchy Snacks
//
//  Created by Anton Moiseev on 2016-06-09.
//  Copyright © 2016 Anton Moiseev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var navBarHeightConstraint: NSLayoutConstraint!
    var dropped: Bool = false
    var rotated: Bool = false
    @IBOutlet weak var navBarView: UIView!
    var stackView: UIStackView?
    @IBOutlet weak var tableView: UITableView!
    var objects: NSMutableArray = []
    var centerYConstraint: NSLayoutConstraint?
    var snackLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        addSnacks()
        addSnacksLabel()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel!.text = objects[indexPath.row] as? String
        return cell
    }
    
    @IBAction func plusButtonPressed(sender: UIButton) {
        
        UIView.animateWithDuration(2, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 4, options: [.CurveEaseOut], animations: {
            self.navBarHeightConstraint.constant = self.dropped ? 64 : 200
            self.stackView?.hidden = self.dropped
            self.centerYConstraint?.constant = !self.dropped ? -40 : 0
            self.snackLabel?.text = !self.dropped ? "Add a snack" : "SNACKS"
            let angle = self.rotated ? 0 : CGFloat(M_PI_4)
            sender.transform = CGAffineTransformMakeRotation(angle)
            self.dropped = !self.dropped
            self.rotated = !self.rotated
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func addSnacksLabel() {
        let label = UILabel()
        label.text = "SNACKS"
        label.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(label)
        
        // add constraints
        label.centerXAnchor.constraintEqualToAnchor(navBarView.centerXAnchor).active = true
        centerYConstraint = label.centerYAnchor.constraintEqualToAnchor(navBarView.centerYAnchor)
        centerYConstraint?.active = true
        centerYConstraint?.identifier = "centerYSnackLabel"
        
        self.snackLabel = label
    }
    
    func addSnacks() {
        
        let arrayOfSnacks = ["oreos", "pizza_pockets", "pop_tarts", "popsicle", "ramen"]
        let arrayOfButtons = [].mutableCopy()
        var count: Int = 1
        for snack: String in arrayOfSnacks {
            let newButton = UIButton()
            newButton.setImage(UIImage.init(named: snack), forState: UIControlState.Normal)
            newButton.addTarget(self, action: #selector(ViewController.buttonTapped(_:)) , forControlEvents: UIControlEvents.TouchUpInside)
            arrayOfButtons.addObject(newButton)
            newButton.tag = count
            count += 1
        }
        let stack = UIStackView(arrangedSubviews: arrayOfButtons as! [UIView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(stack)
        
        // set it up
        stack.axis = .Horizontal
        stack.distribution = .FillEqually
        stack.alignment = .Fill
        stack.spacing = 5
        
        // add constraints
        stack.heightAnchor.constraintEqualToConstant(100).active = true
        stack.bottomAnchor.constraintEqualToAnchor(navBarView.bottomAnchor, constant: -10).active = true
        stack.leftAnchor.constraintEqualToAnchor(navBarView.leftAnchor, constant: 30).active = true
        stack.rightAnchor.constraintEqualToAnchor(navBarView.rightAnchor, constant: -30).active = true
        self.stackView = stack
        self.stackView?.hidden = true
    }
    
    func buttonTapped(sender: UIButton) {
        let id = sender.tag
        switch id {
        case 1:
            objects.insertObject("Oreos", atIndex: 0)
        case 2:
            objects.insertObject("Pizza Pockets", atIndex: 0)
        case 3:
            objects.insertObject("Pop Tarts", atIndex: 0)
        case 4:
            objects.insertObject("Popsicle", atIndex: 0)
        case 5:
            objects.insertObject("Ramen", atIndex: 0)
        default:
            print("hey")
        }
        tableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}


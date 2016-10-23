//
//  ViewController.swift
//  HSegmentControl
//
//  Created by Chang, Hao on 08/29/2016.
//  Copyright (c) 2016 Chang, Hao. All rights reserved.
//

import UIKit
import HSegmentControl

class ViewController: UIViewController, HSegmentControlDataSource {

    @IBOutlet weak var segmentControl: HSegmentControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        segmentControl.dataSource = self
        segmentControl.numberOfDisplayedSegments = 4
        segmentControl.segmentIndicatorViewContentMode = UIViewContentMode.bottom
        segmentControl.selectedTitleFont = UIFont.boldSystemFont(ofSize: 17)
        segmentControl.selectedTitleColor = UIColor(red: 232/255, green: 76/255, blue: 86/255, alpha: 1)
        segmentControl.unselectedTitleFont = UIFont.systemFont(ofSize: 17)
        segmentControl.unselectedTitleColor = UIColor.darkGray
        segmentControl.segmentIndicatorImage = UIImage(named: "ind_img")
        segmentControl.segmentIndicatorView.backgroundColor = UIColor.white
    }

    // MARK: - HSegmentControlDataSource protocol
    func numberOfSegments(_ segmentControl: HSegmentControl) -> Int {
        return 10
    }
    
    func segmentControl(_ segmentControl: HSegmentControl, titleOfIndex index: Int) -> String {
        return ["1","two", "threeeeeee", "four", "five", "1","two", "threeeeeee", "four", "five"][index]
    }
    
    func segmentControl(_ segmentControl: HSegmentControl, segmentBackgroundViewOfIndex index: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        return view
    }
    
    @IBAction func valueChanged(_ sender: AnyObject) {
        print("value did change to \((sender as! HSegmentControl).selectedIndex)")
    }

}


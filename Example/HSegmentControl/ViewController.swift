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
        segmentControl.numberOfDisplayedSegments = 3
        segmentControl.segmentIndicatorViewContentMode = UIViewContentMode.Bottom
        segmentControl.selectedTitleFont = UIFont.boldSystemFontOfSize(17)
        segmentControl.selectedTitleColor = UIColor(red: 232/255, green: 76/255, blue: 86/255, alpha: 1)
        segmentControl.unselectedTitleFont = UIFont.systemFontOfSize(17)
        segmentControl.unselectedTitleColor = UIColor.darkGrayColor()
        segmentControl.segmentIndicatorImage = UIImage(named: "ind_img")
        segmentControl.segmentIndicatorView.backgroundColor = UIColor.whiteColor()
    }

    // MARK: - HSegmentControlDataSource protocol
    func numberOfSegments(segmentControl: HSegmentControl) -> Int {
        return 5
    }
    
    func segmentControl(segmentControl: HSegmentControl, titleOfIndex index: Int) -> String {
        return ["1","two", "threeeeeee", "four", "five"][index]
    }
    
    func segmentControl(segmentControl: HSegmentControl, segmentBackgroundViewOfIndex index: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        return view
    }
    
    @IBAction func valueChanged(sender: AnyObject) {
        print("value did change to \((sender as! HSegmentControl).selectedIndex)")
    }

}


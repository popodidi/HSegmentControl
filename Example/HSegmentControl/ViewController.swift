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
        segmentControl.segmentIndicatorImage = UIImage(named: "ind_img")
        segmentControl.segmentIndicatorView.backgroundColor = UIColor.whiteColor()
        segmentControl.segmentIndicatorView.layer.cornerRadius = 10
    }

    // MARK: - HSegmentControlDataSource protocol
    func numberOfSegments(segmentControl: HSegmentControl) -> Int {
        return 5
    }
    
    func segmentControl(segmentControl: HSegmentControl, titleOfIndex index: Int) -> String {
        return ["1","two", "threeeeeee", "four", "five"][index]
    }
    
    func segmentControl(segmentControl: HSegmentControl, segmentViewOfIndex index: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        return view
    }
    

}


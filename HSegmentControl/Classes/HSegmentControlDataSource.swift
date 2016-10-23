//
//  HSegmentControlDataSource.swift
//  Pods
//
//  Created by Chang, Hao on 8/30/16.
//
//

import Foundation

@objc
public protocol HSegmentControlDataSource {
    /**
     Retrun the total number of segments
     */
    func numberOfSegments(segmentControl: HSegmentControl) -> Int
    /**
     Return the title of each segment
     */
    func segmentControl(segmentControl: HSegmentControl, titleOfIndex index: Int) -> String
    /**
     Return background view of each segment.
     The background view will be set with constraints to fit the size of each segment and will be set to `UIView()` if this method is not implemented.
     */
    optional func segmentControl(segmentControl: HSegmentControl, segmentBackgroundViewOfIndex index: Int) -> UIView
}

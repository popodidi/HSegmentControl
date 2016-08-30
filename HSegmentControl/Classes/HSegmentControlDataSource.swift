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
    func numberOfSegments(segmentControl: HSegmentControl) -> Int
    func segmentControl(segmentControl: HSegmentControl, titleOfIndex index: Int) -> String
    optional func segmentControl(segmentControl: HSegmentControl, segmentViewOfIndex index: Int) -> UIView
}
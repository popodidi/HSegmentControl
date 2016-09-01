//
//  HSegmentControl.swift
//  Pods
//
//  Created by Chang, Hao on 8/29/16.
//
//

import UIKit

@IBDesignable
public class HSegmentControl: UIControl {

    // MARK: - Data Source
    public var dataSource: HSegmentControlDataSource?{
        didSet{
            reloadData()
            if selectedIndex >= numberOfSegments {
                selectedIndex = numberOfSegments - 1
            }
        }
    }
    
    // MARK: - Calculated variables from data source
    public var segmentTitles: [String]{
        get{
            var titles = [String]()
            for index in 0 ..< numberOfSegments {
                titles.append(dataSource?.segmentControl(self, titleOfIndex: index) ?? "")
            }
            return titles
        }
    }
    private var numberOfSegments: Int{
        get{
            return dataSource?.numberOfSegments(self) ?? 0
        }
    }
    
    // MARK: - Control Status
    public var selectedIndex: Int = 0 {
        didSet{
            if selectedIndex < numberOfSegments{
                if selectedIndex != oldValue {
                    select(atIndex: selectedIndex, previousIndex: oldValue)
                }
            }else{
                selectedIndex = numberOfSegments - 1
            }
        }
    }
    
    // MARK: - Configuration
    @IBInspectable public var numberOfDisplayedSegments: Int = 3{
        didSet{
            reloadData()
        }
    }
    @IBInspectable public var segmentIndicatorImage: UIImage?{
        didSet{
            reloadData()
        }
    }
    @IBInspectable public var segmentIndicatorViewContentMode: UIViewContentMode?{
        didSet{
            reloadData()
        }
    }
    @IBInspectable public var segmentIndicatorBackgroundColor: UIColor?{
        didSet{
            reloadData()
        }
    }
    @IBInspectable public var unselectedTitleColor: UIColor?{
        didSet{
            reloadData()
        }
    }
    @IBInspectable public var selectedTitleColor: UIColor?{
        didSet{
            reloadData()
        }
    }
    public var unselectedTitleFont: UIFont?{
        didSet{
            reloadData()
        }
    }
    public var selectedTitleFont: UIFont?{
        didSet{
            reloadData()
        }
    }
    private let defaultFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
    
    // MARK: - UI Elements
    public var segmentIndicatorView: UIView = UIView()
    
    private var baseView: UIView!
    private var segmentBaseViews: [UIView] = []
    private var segmentTitleLabels: [UILabel] = []
    
    // MARK: - Constraints for animation
    private var indicatorXConstraint = NSLayoutConstraint()
    private var selectedSegmentXContraint = NSLayoutConstraint()
    
    // MARK: - init
    override public init(frame: CGRect){
        super.init(frame: frame)
        configure()
        reloadData()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        reloadData()
    }
    
    func configure(){
        clipsToBounds = true
    }
    
    // MARK: - reload data
    public func reloadData(){
        configureBaseView()
        configureSegmentBaseViews()
        configureIndicatorView()
        configureSegmentTitleLabels()
        layoutIfNeeded()
    }

    // MARK: - View Configuration
    func configureBaseView(){
        baseView = UIView(frame: CGRect(origin: CGPointZero, size: self.frame.size))
        baseView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(baseView)
        
        let heightContraint = NSLayoutConstraint(item: baseView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1, constant: 0)
        let yContraint = NSLayoutConstraint(item: baseView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
        
        self.addConstraints([heightContraint, yContraint])
    }
    
    func configureSegmentBaseViews(){
        for segmentBaseView in segmentBaseViews{
            segmentBaseView.removeFromSuperview()
        }
        segmentBaseViews.removeAll(keepCapacity: true)
        
        for index in 0 ..< numberOfSegments{
            let segmentBaseView = dataSource?.segmentControl?(self, segmentBackgroundViewOfIndex: index) ?? UIView()
            segmentBaseView.translatesAutoresizingMaskIntoConstraints = false
            
            segmentBaseViews.append(segmentBaseView)
            baseView.addSubview(segmentBaseView)
            
            // width constraint
            self.addConstraint(NSLayoutConstraint(item: segmentBaseView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1/CGFloat(numberOfDisplayedSegments), constant: 0))
            // height constraint
            baseView.addConstraint(NSLayoutConstraint(item: segmentBaseView, attribute: .Height, relatedBy: .Equal, toItem: baseView, attribute: .Height, multiplier: 1, constant: 0))
            // y constraint
            baseView.addConstraint(NSLayoutConstraint(item: segmentBaseView, attribute: .CenterY, relatedBy: .Equal, toItem: baseView, attribute: .CenterY, multiplier: 1, constant: 0))
            
            // leading constraint
            if index == 0 {
                baseView.addConstraint(NSLayoutConstraint(item: segmentBaseView, attribute: .Leading, relatedBy: .Equal, toItem: baseView, attribute: .Leading, multiplier: 1, constant: 0))
            }else{
                baseView.addConstraint(NSLayoutConstraint(item: segmentBaseView, attribute: .Leading, relatedBy: .Equal, toItem: segmentBaseViews[index-1], attribute: .Trailing, multiplier: 1, constant: 0))
            }
            
            // trailing constraint
            if index == numberOfSegments - 1 {
                baseView.addConstraint(NSLayoutConstraint(item: segmentBaseView, attribute: .Trailing, relatedBy: .Equal, toItem: baseView, attribute: .Trailing, multiplier: 1, constant: 0))
            }
            
            // total x constraint
            if index == selectedIndex {
                self.removeConstraint(selectedSegmentXContraint)
                if index == 0{
                    selectedSegmentXContraint = NSLayoutConstraint(item: segmentBaseView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0)
                }else if index == numberOfSegments - 1 {
                    selectedSegmentXContraint = NSLayoutConstraint(item: segmentBaseView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0)
                }else{
                    selectedSegmentXContraint = NSLayoutConstraint(item: segmentBaseView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
                }
                self.addConstraint(selectedSegmentXContraint)
            }
            
        }
    }
    
    func configureIndicatorView(){
        segmentIndicatorView.removeFromSuperview()
        segmentIndicatorView = UIImageView()
        segmentIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        (segmentIndicatorView as? UIImageView)?.image = segmentIndicatorImage
        (segmentIndicatorView as? UIImageView)?.contentMode = segmentIndicatorViewContentMode ?? .Bottom
        
        baseView.addSubview(segmentIndicatorView)
        
        // width constraint
        self.addConstraint(NSLayoutConstraint(item: segmentIndicatorView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1/CGFloat(numberOfDisplayedSegments), constant: 0))
        // height constraint
        baseView.addConstraint(NSLayoutConstraint(item: segmentIndicatorView, attribute: .Height, relatedBy: .Equal, toItem: baseView, attribute: .Height, multiplier: 1, constant: 0))
        // y constraint
        baseView.addConstraint(NSLayoutConstraint(item: segmentIndicatorView, attribute: .CenterY, relatedBy: .Equal, toItem: baseView, attribute: .CenterY, multiplier: 1, constant: 0))
        
        
        setIndicatorXConstraint()
        
    }
    
    func configureSegmentTitleLabels(){
        for segmentTitleLabel in segmentTitleLabels{
            segmentTitleLabel.removeFromSuperview()
        }
        segmentTitleLabels.removeAll(keepCapacity: true)
        
        for index in 0 ..< numberOfSegments{
            let titleLabel = UILabel()
            titleLabel.text = segmentTitles[index]
            titleLabel.textAlignment = .Center
            titleLabel.textColor = index == selectedIndex ? selectedTitleColor : unselectedTitleColor
            
            titleLabel.font = (index == selectedIndex ? selectedTitleFont : unselectedTitleFont) ?? defaultFont
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            baseView.addSubview(titleLabel)
            segmentTitleLabels.append(titleLabel)
            
            let widthContraint = NSLayoutConstraint(item: titleLabel, attribute: .Width, relatedBy: .Equal, toItem: segmentBaseViews[index], attribute: .Width, multiplier: 0.8, constant: 0)
            let heightContraint = NSLayoutConstraint(item: titleLabel, attribute: .Height, relatedBy: .Equal, toItem: segmentBaseViews[index], attribute: .Height, multiplier: 0.8, constant: 0)
            let xContraint = NSLayoutConstraint(item: titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: segmentBaseViews[index], attribute: .CenterX, multiplier: 1, constant: 0)
            let yContraint = NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: segmentBaseViews[index], attribute: .CenterY, multiplier: 1, constant: 0)
            
            baseView.addConstraints([widthContraint, heightContraint, xContraint, yContraint])
        }
    }
    
    // MARK: - Subclassing UIView
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        guard let location = touches.first?.locationInView(baseView) else{
            return
        }
        guard let calculatedIndex = { () -> Int? in
            for (index, segmentBaseView) in segmentBaseViews.enumerate() {
                if segmentBaseView.frame.contains(location) {
                    return index
                }
            }
            return nil
            }()
            else{
                return
        }
        
        if selectedIndex != calculatedIndex{
            selectedIndex = calculatedIndex
            sendActionsForControlEvents(.ValueChanged)
        }
    }
    
    // MARK: - Animation
    func select(atIndex nextIndex: Int, previousIndex preIndex: Int){
        UIView.animateWithDuration(0.1, animations: {
            if preIndex < self.numberOfSegments{
                for label in self.segmentTitleLabels{
                    label.textColor = self.unselectedTitleColor
                    label.font = self.unselectedTitleFont ?? self.defaultFont
                }
            }
        }) { (completed) in
            UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .CurveEaseOut, animations: {
                self.setTotalXConstraint()
                self.setIndicatorXConstraint()
                self.addConstraint(self.selectedSegmentXContraint)
                self.layoutIfNeeded()
            }){ (completed) in
                UIView.animateWithDuration(0.1){
                    if nextIndex < self.numberOfSegments{
                        self.segmentTitleLabels[nextIndex].textColor = self.selectedTitleColor
                        self.segmentTitleLabels[nextIndex].font = self.selectedTitleFont ?? self.defaultFont
                    }
                }
            }
        }
    }
    
    // MARK: - Set x position constraints
    func setTotalXConstraint(){
        if numberOfSegments > numberOfDisplayedSegments
            && selectedIndex < numberOfSegments
            && segmentBaseViews.count > 0{
            // total x constraint
            self.removeConstraint(self.selectedSegmentXContraint)
            if CGFloat(selectedIndex) < CGFloat(self.numberOfDisplayedSegments)/2{
                self.selectedSegmentXContraint = NSLayoutConstraint(item: self.segmentBaseViews.first!, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0)
            }else if CGFloat(selectedIndex) > CGFloat(self.numberOfSegments) - CGFloat(self.numberOfDisplayedSegments)/2 - 1 {
                self.selectedSegmentXContraint = NSLayoutConstraint(item: self.segmentBaseViews.last!, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0)
            }else{
                self.selectedSegmentXContraint = NSLayoutConstraint(item: self.segmentBaseViews[selectedIndex], attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
            }
        }
    }
    
    func setIndicatorXConstraint(){
        if selectedIndex < self.numberOfSegments {
            self.baseView.removeConstraint(self.indicatorXConstraint)
            self.indicatorXConstraint = NSLayoutConstraint(item: self.segmentIndicatorView, attribute: .CenterX, relatedBy: .Equal, toItem: self.segmentBaseViews[selectedIndex], attribute: .CenterX, multiplier: 1, constant: 0)
            self.baseView.addConstraint(self.indicatorXConstraint)
        }
    }
}

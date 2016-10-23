//
//  HSegmentControl.swift
//  Pods
//
//  Created by Chang, Hao on 8/29/16.
//
//

import UIKit

@IBDesignable
open class HSegmentControl: UIControl {

    // MARK: - Data Source
    /**
     HSegmentControlDataSource
     */
    open var dataSource: HSegmentControlDataSource?{
        didSet{
            reloadData()
            if selectedIndex >= numberOfSegments {
                selectedIndex = numberOfSegments - 1
            }
        }
    }
    
    // MARK: - Calculated variables from data source
    /**
     Array of segment titles
     */
    open var segmentTitles: [String]{
        get{
            var titles = [String]()
            for index in 0 ..< numberOfSegments {
                titles.append(dataSource?.segmentControl(self, titleOfIndex: index) ?? "")
            }
            return titles
        }
    }
    fileprivate var numberOfSegments: Int{
        get{
            return dataSource?.numberOfSegments(self) ?? 0
        }
    }
    
    // MARK: - Control Status
    /**
     Selected Index of segment control
     */
    open var selectedIndex: Int = 0 {
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
    /**
     The number of displayed segments with 3 as default value
     */
    @IBInspectable open var numberOfDisplayedSegments: Int = 3{
        didSet{
            reloadData()
        }
    }
    /**
     The indicator image of segment control with nil as default value
     */
    @IBInspectable open var segmentIndicatorImage: UIImage?{
        didSet{
            reloadData()
        }
    }
    /**
     The `ContentMode` of segment indicator image view
     */
    @IBInspectable open var segmentIndicatorViewContentMode: UIViewContentMode?{
        didSet{
            reloadData()
        }
    }
    /**
     The bakcgorundColor of segment indicator image view
     */
    @IBInspectable open var segmentIndicatorBackgroundColor: UIColor?{
        didSet{
            reloadData()
        }
    }
    /**
     The title color of unselected segment
     */
    @IBInspectable open var unselectedTitleColor: UIColor?{
        didSet{
            reloadData()
        }
    }
    /**
     The title color of selected segment
     */
    @IBInspectable open var selectedTitleColor: UIColor?{
        didSet{
            reloadData()
        }
    }
    /**
     The font of unselected segment with `UIFont.systemFontOfSize(UIFont.systemFontSize())` as default value
     */
    open var unselectedTitleFont: UIFont?{
        didSet{
            reloadData()
        }
    }
    /**
     The font of selected segment with `UIFont.systemFontOfSize(UIFont.systemFontSize())` as default value
     */
    open var selectedTitleFont: UIFont?{
        didSet{
            reloadData()
        }
    }
    fileprivate let defaultFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    
    // MARK: - UI Elements
    open var segmentIndicatorView: UIView = UIView()
    
    fileprivate var baseView: UIView!
    fileprivate var segmentBaseViews: [UIView] = []
    fileprivate var segmentTitleLabels: [UILabel] = []
    
    // MARK: - Constraints for animation
    fileprivate var indicatorXConstraint = NSLayoutConstraint()
    fileprivate var selectedSegmentXContraint = NSLayoutConstraint()
    
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
    /**
     Reload the segment control
     */
    open func reloadData(){
        configureBaseView()
        configureSegmentBaseViews()
        configureIndicatorView()
        configureSegmentTitleLabels()
        layoutIfNeeded()
    }

    // MARK: - View Configuration
    func configureBaseView(){
        baseView = UIView(frame: CGRect(origin: CGPoint.zero, size: self.frame.size))
        baseView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(baseView)
        
        let heightContraint = NSLayoutConstraint(item: baseView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        let yContraint = NSLayoutConstraint(item: baseView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        self.addConstraints([heightContraint, yContraint])
    }
    
    func configureSegmentBaseViews(){
        for segmentBaseView in segmentBaseViews{
            segmentBaseView.removeFromSuperview()
        }
        segmentBaseViews.removeAll(keepingCapacity: true)
        
        for index in 0 ..< numberOfSegments{
            let segmentBaseView = dataSource?.segmentControl?(self, segmentBackgroundViewOfIndex: index) ?? UIView()
            segmentBaseView.translatesAutoresizingMaskIntoConstraints = false
            
            segmentBaseViews.append(segmentBaseView)
            baseView.addSubview(segmentBaseView)
            
            // width constraint
            self.addConstraint(NSLayoutConstraint(item: segmentBaseView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1/CGFloat(numberOfDisplayedSegments), constant: 0))
            // height constraint
            baseView.addConstraint(NSLayoutConstraint(item: segmentBaseView, attribute: .height, relatedBy: .equal, toItem: baseView, attribute: .height, multiplier: 1, constant: 0))
            // y constraint
            baseView.addConstraint(NSLayoutConstraint(item: segmentBaseView, attribute: .centerY, relatedBy: .equal, toItem: baseView, attribute: .centerY, multiplier: 1, constant: 0))
            
            // leading constraint
            if index == 0 {
                baseView.addConstraint(NSLayoutConstraint(item: segmentBaseView, attribute: .leading, relatedBy: .equal, toItem: baseView, attribute: .leading, multiplier: 1, constant: 0))
            }else{
                baseView.addConstraint(NSLayoutConstraint(item: segmentBaseView, attribute: .leading, relatedBy: .equal, toItem: segmentBaseViews[index-1], attribute: .trailing, multiplier: 1, constant: 0))
            }
            
            // trailing constraint
            if index == numberOfSegments - 1 {
                baseView.addConstraint(NSLayoutConstraint(item: segmentBaseView, attribute: .trailing, relatedBy: .equal, toItem: baseView, attribute: .trailing, multiplier: 1, constant: 0))
            }
            
            // total x constraint
            if index == selectedIndex {
                self.removeConstraint(selectedSegmentXContraint)
                if index == 0{
                    selectedSegmentXContraint = NSLayoutConstraint(item: segmentBaseView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
                }else if index == numberOfSegments - 1 {
                    selectedSegmentXContraint = NSLayoutConstraint(item: segmentBaseView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
                }else{
                    selectedSegmentXContraint = NSLayoutConstraint(item: segmentBaseView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
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
        (segmentIndicatorView as? UIImageView)?.contentMode = segmentIndicatorViewContentMode ?? .bottom
        
        baseView.addSubview(segmentIndicatorView)
        
        // width constraint
        self.addConstraint(NSLayoutConstraint(item: segmentIndicatorView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1/CGFloat(numberOfDisplayedSegments), constant: 0))
        // height constraint
        baseView.addConstraint(NSLayoutConstraint(item: segmentIndicatorView, attribute: .height, relatedBy: .equal, toItem: baseView, attribute: .height, multiplier: 1, constant: 0))
        // y constraint
        baseView.addConstraint(NSLayoutConstraint(item: segmentIndicatorView, attribute: .centerY, relatedBy: .equal, toItem: baseView, attribute: .centerY, multiplier: 1, constant: 0))
        
        
        setIndicatorXConstraint()
        
    }
    
    func configureSegmentTitleLabels(){
        for segmentTitleLabel in segmentTitleLabels{
            segmentTitleLabel.removeFromSuperview()
        }
        segmentTitleLabels.removeAll(keepingCapacity: true)
        
        for index in 0 ..< numberOfSegments{
            let titleLabel = UILabel()
            titleLabel.text = segmentTitles[index]
            titleLabel.textAlignment = .center
            titleLabel.textColor = index == selectedIndex ? selectedTitleColor : unselectedTitleColor
            
            titleLabel.font = (index == selectedIndex ? selectedTitleFont : unselectedTitleFont) ?? defaultFont
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            baseView.addSubview(titleLabel)
            segmentTitleLabels.append(titleLabel)
            
            let widthContraint = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: segmentBaseViews[index], attribute: .width, multiplier: 0.8, constant: 0)
            let heightContraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: segmentBaseViews[index], attribute: .height, multiplier: 0.8, constant: 0)
            let xContraint = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: segmentBaseViews[index], attribute: .centerX, multiplier: 1, constant: 0)
            let yContraint = NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: segmentBaseViews[index], attribute: .centerY, multiplier: 1, constant: 0)
            
            baseView.addConstraints([widthContraint, heightContraint, xContraint, yContraint])
        }
    }
    
    // MARK: - Subclassing UIView
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let location = touches.first?.location(in: baseView) else{
            return
        }
        guard let calculatedIndex = { () -> Int? in
            for (index, segmentBaseView) in segmentBaseViews.enumerated() {
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
            sendActions(for: .valueChanged)
        }
    }
    
    // MARK: - Animation
    func select(atIndex nextIndex: Int, previousIndex preIndex: Int){
        UIView.animate(withDuration: 0.1, animations: {
            if preIndex < self.numberOfSegments{
                for label in self.segmentTitleLabels{
                    label.textColor = self.unselectedTitleColor
                    label.font = self.unselectedTitleFont ?? self.defaultFont
                }
            }
        }, completion: { (completed) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseOut, animations: {
                self.setTotalXConstraint()
                self.setIndicatorXConstraint()
                self.addConstraint(self.selectedSegmentXContraint)
                self.layoutIfNeeded()
            }){ (completed) in
                UIView.animate(withDuration: 0.1, animations: {
                    if nextIndex < self.numberOfSegments{
                        self.segmentTitleLabels[nextIndex].textColor = self.selectedTitleColor
                        self.segmentTitleLabels[nextIndex].font = self.selectedTitleFont ?? self.defaultFont
                    }
                })
            }
        }) 
    }
    
    // MARK: - Set x position constraints
    func setTotalXConstraint(){
        if numberOfSegments > numberOfDisplayedSegments
            && selectedIndex < numberOfSegments
            && segmentBaseViews.count > 0{
            // total x constraint
            self.removeConstraint(self.selectedSegmentXContraint)
            if CGFloat(selectedIndex) < CGFloat(self.numberOfDisplayedSegments)/2{
                self.selectedSegmentXContraint = NSLayoutConstraint(item: self.segmentBaseViews.first!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
            }else if CGFloat(selectedIndex) > CGFloat(self.numberOfSegments) - CGFloat(self.numberOfDisplayedSegments)/2 - 1 {
                self.selectedSegmentXContraint = NSLayoutConstraint(item: self.segmentBaseViews.last!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
            }else{
                self.selectedSegmentXContraint = NSLayoutConstraint(item: self.segmentBaseViews[selectedIndex], attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            }
        }
    }
    
    func setIndicatorXConstraint(){
        if selectedIndex < self.numberOfSegments {
            self.baseView.removeConstraint(self.indicatorXConstraint)
            self.indicatorXConstraint = NSLayoutConstraint(item: self.segmentIndicatorView, attribute: .centerX, relatedBy: .equal, toItem: self.segmentBaseViews[selectedIndex], attribute: .centerX, multiplier: 1, constant: 0)
            self.baseView.addConstraint(self.indicatorXConstraint)
        }
    }
}

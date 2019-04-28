//
//  ColorPickerManager.swift
//  ColorPicker_Example
//
//  Created by Nguyen Tan hung on 4/24/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Cocoa

public class ColorPickerManager: NSObject {
    
    public static let shared = ColorPickerManager()
    
    var popover: NSPopover = NSPopover()
    var popoverViewController = ColorPickerGridVC()
    let colorPanel = NSColorPanel.shared
    
    static var defaultColorList: [[NSColor]] = [
        [NSColor.white,  NSColor.gray,    NSColor.darkGray, NSColor.black, NSColor.green],
        [NSColor.red,    NSColor.magenta, NSColor.purple,   NSColor.orange, NSColor.blue]
    ]
    
    var colors: [[NSColor]] = defaultColorList
    /// The number of rows of colors.
    var rows: Int { get { return colors.count  } }
    /// The number of columns of colors.
    var columns: Int { get { return colors[0].count } }
    
    var usesCustomColor: Bool = true
    var boxHeight: CGFloat = 20.0
    var boxWidth: CGFloat = 20.0
    var horizontalMargin: CGFloat = 4.0
    var horizontalBoxSpacing: CGFloat = 4.0
    var verticalBoxSpacing: CGFloat = 4.0
    var verticalMargin: CGFloat = 4.0
    var menuHeight: CGFloat { get { return ((2.0 * verticalMargin) + boxHeight) } }
    
    var selectedBoxBorderWidth: CGFloat = 4.0
    var selectedMenuItemColor: NSColor = NSColor.selectedMenuItemColor
    var selectedBoxColor: NSColor = NSColor.selectedMenuItemColor
    var customColorTitle: NSString = "Custom Color"
    var defaultColor: NSColor = NSColor.black
    var customColor: NSColor = NSColor.magenta
    var boxBorderWidth: CGFloat = 1.0
    var boxBorderColor: NSColor = NSColor.lightGray
    
    var completedBlock: ((NSColor?) -> Void)?
    
    override init() {
        super.init()
        
        popoverViewController.view.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: popoverRequiredFrameSize())
        popover.contentViewController = popoverViewController
        popoverViewController.delegate = self
    }
    
    public func showColorPickerForView(view: NSView, completed: @escaping (NSColor?)->Void) {
        completedBlock = completed
        showColorPopover(view: view)
    }
    
    fileprivate func showColorPopover(view: NSView) {
        if popover.isShown { return }
        popoverViewController.reloadData()
        popover.contentSize = popoverRequiredFrameSize()
        popover.behavior = .transient
        popover.animates = true
        popover.show(relativeTo: view.bounds, of: view, preferredEdge: .minY)
    }
    
    func popoverRequiredFrameSize() -> NSSize {
        let verticalSpace = CGFloat(2 * 20 + 2 + 2 + 2)
        let horizontalSpace = CGFloat(6 * 20 + 8 + 2 + 2)
        
        return NSMakeSize(horizontalSpace, verticalSpace)
    }
    
    func colorBrightness(_ color: NSColor) -> CGFloat {
        return color.usingColorSpaceName(NSColorSpaceName.calibratedRGB)!.brightnessComponent
    }
    
    func configureColorPanel() {
        colorPanel.setTarget(self)
        colorPanel.setAction(#selector(self.colorFromPanel(_:)))
    }
    
    @objc func colorFromPanel(_ sender: AnyObject?) {
        if !colorPanel.isVisible { return }
        completedBlock?(colorPanel.color)
    }
}

extension ColorPickerManager: ColorPickerGridVCDelegate {
    func selectedColor(color: NSColor) {
        completedBlock?(color)
    }
    
    func showColorPannel() {
        configureColorPanel()
        colorPanel.isContinuous = true
        NSApplication.shared.orderFrontColorPanel(self)
    }
}

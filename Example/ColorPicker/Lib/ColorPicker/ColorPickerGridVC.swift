//
//  ColorPickerGridVC.swift
//  ColorPicker_Example
//
//  Created by Nguyen Tan hung on 4/24/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Cocoa

protocol ColorPickerGridVCDelegate : class {
    func selectedColor(color: NSColor)
    func showColorPannel()
}

class ColorPickerGridVC: NSViewController {

    var defaultColorList: [NSColor] = [
        NSColor.red,  NSColor.gray,    NSColor.darkGray, NSColor.black, NSColor.red,    NSColor.magenta, NSColor.purple,   NSColor.orange,
        NSColor.yellow, NSColor.blue
    ]
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    weak var delegate: ColorPickerGridVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibItem = NSNib(nibNamed: NSNib.Name("ColorItem"), bundle: nil)
        collectionView.register(nibItem, forItemWithIdentifier: NSUserInterfaceItemIdentifier("ColorItem"))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isSelectable = true
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
}

extension ColorPickerGridVC: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.defaultColorList.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("ColorItem"), for: indexPath) as? ColorItem
        if indexPath.item == 9 {
            cell?.lbl.drawsBackground = false
            cell?.lbl.stringValue = "..."
        }
        else{
            cell?.lbl.drawsBackground = true
            cell?.lbl.stringValue = ""
            cell?.lbl.backgroundColor = defaultColorList[indexPath.item]
        }

        return cell!
    }
}

extension ColorPickerGridVC: NSCollectionViewDelegateFlowLayout, NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: 20, height: 20)
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        if let value = indexPaths.first?.item {
            if value == 9 {
                collectionView.deselectItems(at: indexPaths)
                delegate?.showColorPannel()
            }
            else{
                delegate?.selectedColor(color: defaultColorList[value])
            }
        }
    }
}

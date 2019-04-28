//
//  ViewController.swift
//  ColorPicker
//
//  Created by Hung Nguyen on 04/21/2019.
//  Copyright (c) 2019 Hung Nguyen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    self.view.wantsLayer = true
  }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }
    
    @IBAction func touchOnButton(_ sender: NSButton) {
        debugPrint("Touch")
        ColorPickerManager.shared.showColorPickerForView(view: sender) { [weak self] (color) in
            self?.view.layer?.backgroundColor = color?.cgColor
        }
    }
}


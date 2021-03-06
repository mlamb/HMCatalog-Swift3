/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The `SegmentedControlCharacteristicCell` displays characteristics with associated values.
*/

import UIKit
import HomeKit

/**
    A `CharacteristicCell` subclass that contains a `UISegmentedControl`.

    Used for `HMCharacteristic`s which have associated, non-numeric values, like Lock Management State.
*/
class SegmentedControlCharacteristicCell: CharacteristicCell {
    // MARK: Properties
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    /**
        Calls the super class's didSet, and also computes a list
        of possible values.
    */
    override var characteristic: HMCharacteristic! {
        didSet {
            segmentedControl.alpha = enabled ? 1.0 : CharacteristicCell.DisabledAlpha
            segmentedControl.isUserInteractionEnabled = enabled

            if let values = characteristic.allPossibleValues as? [Int] {
                possibleValues = values
            }
        }
    }
    
    /**
        The possible values for this characteristic.
        When this is set, adds localized descriptions to the segmented control.
    */
    var possibleValues = [Int]() {
        didSet {
            segmentedControl.removeAllSegments()
            for index in 0..<possibleValues.count {
                let value: AnyObject = possibleValues[index] as AnyObject
                let title = characteristic.localizedDescriptionForValue(value)
                segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
            }

            resetSelectedIndex()
        }
    }
    
    /**
        Responds to the segmented control's segment changing.
        Sets the value and notifies its delegate.
    
        - parameter sender: The segmented control that changed.
    */
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        let value = possibleValues[sender.selectedSegmentIndex]
        setValue(value as NSNumber?, notify: true)
    }
    
    /**
        If notify is false, then this is an external change,
        so update the selected segment on the segmented control.
        
        - parameter newValue: The new value.
        - parameter notify:   Whether or not to notify the delegate.
    */
    override func setValue(_ newValue: CellValueType?, notify: Bool) {
        super.setValue(newValue, notify: notify)
        if !notify {
            resetSelectedIndex()
        }
    }
    
    /// Sets the segmented control based on the set value.
    func resetSelectedIndex() {
        if let intValue = value as? Int, let index = possibleValues.firstIndex(of: intValue) {
            segmentedControl.selectedSegmentIndex = index
        }
    }
    
}

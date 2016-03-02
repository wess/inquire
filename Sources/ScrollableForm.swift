//
//  ScrollableForm.swift
//  Pods
//
//  Created by Wesley Cope on 2/26/16.
//
//

import Foundation
import UIKit

public protocol ScrollableForm {
    var form:Form               {get set}
    
    func addKeyboardObserver()
    func removeKeyboardObserver()
    func keyboardWillShow(notification:NSNotification)
    func keyboardWillHide(notification:NSNotification)
    func scrollTo(frame:CGRect, duration:NSTimeInterval)
    func scrollView() -> UIScrollView
}

public extension ScrollableForm where Self:UIViewController {
    func addKeyboardObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardWillShow(notification:NSNotification) {
        if let userInfo     = notification.userInfo, currentField = form.currentField {
            let frame       = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
            let size        = frame.size
            let height      = size.height
            let duration    = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber) as NSTimeInterval
            
            scrollTo(currentField.frame, duration: duration)
        }
    }
    
    func keyboardWillHide(notification:NSNotification) {
        if let userInfo = notification.userInfo, currentField = form.currentField {
            if let userInfo     = notification.userInfo {
                let duration    = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber) as NSTimeInterval
                
                scrollTo(.zero, duration: duration)
            }
        }
    }
    
    func scrollTo(frame:CGRect, duration:NSTimeInterval = 0.25) {
        UIView.animateWithDuration(duration, delay: 0.25, options: .CurveEaseInOut, animations: {
            self.scrollView().scrollRectToVisible(frame, animated: false)
        }, completion: nil)
    }
}

public protocol ScrollableTableViewForm : ScrollableForm {
    var tableView:UITableView {get}
}

internal extension ScrollableTableViewForm {
    internal func scrollView() -> UIScrollView {
        return tableView
    }
}

public protocol ScrollableCollectionViewForm : ScrollableForm {
    var collectionView:UICollectionView {get}
}

internal extension ScrollableCollectionViewForm {
    internal func scrollView() -> UIScrollView {
        return collectionView
    }
}













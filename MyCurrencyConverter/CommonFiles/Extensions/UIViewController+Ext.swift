//
//  UIViewController+Ext.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 17.10.2022.
//

import UIKit

extension UIViewController {
    // MARK: - Keyboard Notification
    
    func registerForKeyboardNotifications() {
        let center = NotificationCenter.default
        center.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        center.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        if let scrollView = scrollViewForKeyboard() {
            var insets = scrollView.contentInset
            insets.bottom = scrollViewBottomInsetForHideKeyboard()
            scrollView.contentInset = insets
        }
    }
    
    func unregisterForKeyboardNotifications() {
        let center = NotificationCenter.default
        center.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        center.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let scrollView = scrollViewForKeyboard() else { return }

        var inset = scrollView.contentInset
        inset.bottom = value.cgRectValue.size.height - 20
        scrollView.contentInset = inset
    }

    @objc func keyboardWillHide(notification _: NSNotification) {
        guard let scrollView = scrollViewForKeyboard() else { return }

        var inset = scrollView.contentInset
        inset.bottom = scrollViewBottomInsetForHideKeyboard()
        scrollView.contentInset = inset
    }

    func scrollViewForKeyboard() -> UIScrollView? {
        for subview in view.subviews {
            if let subview = subview as? UIScrollView {
                return subview
            }
        }
        return nil
    }

    func scrollViewBottomInsetForHideKeyboard() -> CGFloat {
        0
    }

    // MARK: - UITapGestureRecognizer
    
    func registerTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(
            self,
            action: #selector(endEditing)
        )
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    func registerTapGestureRecognizer(customView: UIView) {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(
            self,
            action: #selector(endEditing)
        )
        tapGestureRecognizer.cancelsTouchesInView = false
        customView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func endEditing() {
        view.endEditing(true)
    }
}

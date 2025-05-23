//
//  UIViewX.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//
import UIKit

extension UIView {
    func rounded() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}

//
//  GridCell.swift
//  GridView
//
//  Created by Corné on 23/02/2018.
//  Copyright © 2018 CP3. All rights reserved.
//

import UIKit

public final class GridCell: UIView {

    // MARK: - Private properties

    private lazy var backgroundView: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.alpha = 0
        view.clipsToBounds = false
        view.isUserInteractionEnabled = false

        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(
            width: 3,
            height: 3)

        view.layer.addSublayer(backgroundGradientLayer)

        return view
    }()

    private lazy var backgroundGradientLayer: CAGradientLayer = {

        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0, 1]
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.1).cgColor]

        return gradientLayer
    }()

    private let color: UIColor

    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?

    // MARK: - Initialization

    init(color: UIColor) {
        self.color = color

        super.init(frame: CGRect.zero)

        configure()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configure() {
        backgroundView.backgroundColor = color

        addSubview(backgroundView)

        widthConstraint = backgroundView.widthAnchor.constraint(equalToConstant: bounds.width)
        heightConstraint = backgroundView.heightAnchor.constraint(equalToConstant: bounds.height)
        widthConstraint?.isActive = true
        heightConstraint?.isActive = true

        backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    // MARK: - Layout

    override public func layoutSubviews() {
        super.layoutSubviews()

        backgroundGradientLayer.frame = backgroundView.frame

        // set rounded corners
        backgroundView.layer.cornerRadius = min(backgroundView.bounds.width, backgroundView.bounds.height) / 2
        backgroundGradientLayer.cornerRadius = min(backgroundGradientLayer.bounds.width, backgroundGradientLayer.bounds.height) / 2

        setNeedsUpdateConstraints()
    }

    // MARK: - Animation

    func appearAnimation(withDuration
        duration: TimeInterval = 0.25, andDelay
        delay: TimeInterval = 0) {

//        guard backgroundView.alpha != 1 else {
//            return
//        }

//        backgroundView.backgroundColor = color
//        self.backgroundView.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)

        widthConstraint?.constant = bounds.width
        heightConstraint?.constant = bounds.height

        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.curveEaseOut, .allowUserInteraction],
            animations: {
                self.layoutIfNeeded()
//                self.backgroundView.alpha = 1
//                self.backgroundView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        })
    }

    func disappear(animated: Bool = true) {

//        guard backgroundView.alpha != 0 else {
//            return
//        }

        widthConstraint?.constant = 22
        heightConstraint?.constant = 22

        UIView.animate(
            withDuration: animated ? 0.25 : 0,
            delay: 0,
            options: [.curveEaseOut, .allowUserInteraction],
            animations: {
//                self.backgroundView.alpha = 0
                self.layoutIfNeeded()
        })
    }

    func pulseAnimation() {

//        backgroundView.alpha = 1

//        let scale: CGFloat = 0.7
//        self.backgroundView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)

//        widthConstraint?.constant = 22
//        heightConstraint?.constant = 22



        widthConstraint?.constant = bounds.width
        heightConstraint?.constant = bounds.height

        layoutIfNeeded()

        disappear()

//        UIView.animate(
//            withDuration: 0.25,
//            delay: 0,
//            options: [.curveEaseOut, .allowUserInteraction],
//            animations: {
//                self.layoutIfNeeded()
////                let scale: CGFloat = 1
////                self.backgroundView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
//        }, completion: { [weak self] hasCompleted in
//            // fade out
//            if hasCompleted {
//                self?.disappear()
//            }
//        })
    }
}

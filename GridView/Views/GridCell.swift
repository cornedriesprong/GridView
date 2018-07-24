//
//  GridCell.swift
//  GridView
//
//  Created by Corné on 23/02/2018.
//  Copyright © 2018 CP3. All rights reserved.
//

import UIKit
import SnapKit

public final class GridCell: UIView {

    // MARK: - Private properties

    private lazy var backgroundView: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.layer.cornerRadius = 5

        return view
    }()

    private let color: UIColor

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
    }

    // MARK: - Layout

    override public func layoutSubviews() {
        super.layoutSubviews()

        setNeedsUpdateConstraints()
    }

    // MARK: - Constraints

    override public func updateConstraints() {
        super.updateConstraints()

        let margin: CGFloat = 3
        backgroundView.snp
        backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: margin).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: -margin).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin).isActive = true
    }

    // MARK: - Animation

    func appearAnimation(withDuration
        duration: TimeInterval = 0.25, andDelay
        delay: TimeInterval = 0) {

        guard backgroundView.alpha != 1 else {
            return
        }

        backgroundView.backgroundColor = color
        self.backgroundView.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)

        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.curveEaseOut, .allowUserInteraction],
            animations: {
                self.backgroundView.alpha = 1
                self.backgroundView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        })
    }

    func disappearAnimation(withDuration
        duration: TimeInterval = 0.25, andDelay
        delay: TimeInterval = 0) {

        guard backgroundView.alpha != 0 else {
            return
        }

        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.curveEaseOut, .allowUserInteraction],
            animations: {
                self.backgroundView.alpha = 0
        })
    }

    func pulseAnimation() {

        backgroundView.alpha = 1

        let scale: CGFloat = 0.7
        self.backgroundView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)

        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.curveEaseOut, .allowUserInteraction],
            animations: {
                let scale: CGFloat = 1
                self.backgroundView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
        }, completion: { [weak self] hasCompleted in
            // fade out
            if hasCompleted {
                self?.disappearAnimation()
            }
        })
    }
}

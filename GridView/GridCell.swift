//
//  GridCell.swift
//  GridView
//
//  Created by Corné on 23/02/2018.
//  Copyright © 2018 CP3. All rights reserved.
//

import UIKit

public final class GridCell: UIView {

    // MARK: - Static properties

    static let defaultBackgroundDimension: CGFloat = 10

    // MARK: - Private properties

    private lazy var backgroundView: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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

        widthConstraint = backgroundView.widthAnchor.constraint(equalToConstant: type(of: self).defaultBackgroundDimension)
        heightConstraint = backgroundView.heightAnchor.constraint(equalToConstant: type(of: self).defaultBackgroundDimension)
        widthConstraint?.isActive = true
        heightConstraint?.isActive = true

        backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        backgroundGradientLayer.frame = backgroundView.frame
    }

    // MARK: - Layout

    override public func layoutSubviews() {
        super.layoutSubviews()

        // set rounded corners
        backgroundView.layer.cornerRadius = min(backgroundView.bounds.width, backgroundView.bounds.height) / 2
        backgroundGradientLayer.cornerRadius = min(backgroundGradientLayer.bounds.width, backgroundGradientLayer.bounds.height) / 2

        setNeedsUpdateConstraints()
    }

    func disappear(animated: Bool = true) {

        widthConstraint?.constant = type(of: self).defaultBackgroundDimension
        heightConstraint?.constant = type(of: self).defaultBackgroundDimension

        UIView.animate(
            withDuration: animated ? 0.25 : 0,
            delay: 0,
            options: [.curveEaseOut, .allowUserInteraction],
            animations: {
                self.layoutIfNeeded()
        })
    }

    func pulseAnimation() {

        backgroundView.layer.removeAllAnimations()

        let margin: CGFloat = 3
        widthConstraint?.constant = bounds.width - (margin * 2)
        heightConstraint?.constant = bounds.height - (margin * 2)

        layoutIfNeeded()

        disappear()
    }
}

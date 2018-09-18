//
//  GridView.swift
//  GridView
//
//  Created by Corné on 23/02/2018.
//  Copyright © 2018 CP3. All rights reserved.
//

import UIKit

public protocol GridViewDelegate: class {
    func play(forTouchWithIndex touchIndex: Int, atCoordinate coordinate: GridCoordinate)
    func stopPlaying(forTouchWithCoordinate: GridCoordinate, andIndex touchIndex: Int)
    func activeTouchCountDidChange(_ touchCount: Int)
}

public final class GridView: UIView {

    // MARK: - Private properties

    private let gridSize: GridSize
    private let color: UIColor

    // outer array is columns, inner array is rows
    private var cells = [[GridCell]]()
    private var activeTouches = [Touch]()
    private var sendsTouchOffs: Bool

    private var touchCount = 0 {
        didSet {
            delegate?.activeTouchCountDidChange(touchCount)
        }
    }

    public weak var delegate: GridViewDelegate?

    // MARK: - Initialization

    public init(
        gridSize: GridSize,
        color: UIColor,
        sendsTouchOffs: Bool = false) {

        self.gridSize = gridSize
        self.color = color
        self.sendsTouchOffs = sendsTouchOffs

        super.init(frame: .zero)

        configure()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configure() {

        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true

        configureGrid()
    }

    private func configureGrid() {

        // create grid
        for column in 0..<gridSize.columns {

            cells.append([GridCell]())

            for _ in 0..<gridSize.rows {

                let cell = GridCell(color: color)
                cells[column].append(cell)
                addSubview(cell)
            }
        }
    }

    // MARK: - Layout

    override public func layoutSubviews() {
        super.layoutSubviews()

        CATransaction.setDisableActions(true)

        let width = bounds.width / CGFloat(gridSize.columns)
        let height = bounds.height / CGFloat(gridSize.rows)

        // set grid dimensions
        for (x, column) in cells.enumerated() {
            for (y, cell) in column.enumerated() {

                let origin = CGPoint(
                    x: CGFloat(x) * width,
                    y: CGFloat(y) * height)

                let size = CGSize(
                    width: width,
                    height: height)

                cell.frame = CGRect(origin: origin, size: size)
            }
        }

        CATransaction.setDisableActions(false)

        setNeedsUpdateConstraints()
    }

    // MARK: - Animation

    public func pulseCell(withCoordinate coordinate: GridCoordinate) {

        let reversedY = (coordinate.y * -1) + cells[0].count
        cells[coordinate.x][reversedY].pulseAnimation()
    }

    // MARK: - Touches

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        for touch in touches {

            let location = touch.location(in: self)

            guard let coordinate = self.coordinate(for: location) else {
                continue
            }

            let touch = Touch(
                index: touchCount,
                touch: touch,
                coordinate: coordinate)
            self.activeTouches.append(touch)

            touchCount += 1
        }

        // send playing data to delegate
        self.activeTouches.forEach {
            self.delegate?.play(forTouchWithIndex: $0.index, atCoordinate: $0.coordinate)
        }
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        for touch in touches {

            let location = touch.location(in: self)

            if let newCoordinate = coordinate(for: location) {

                // if touch moved to different cell, call corresponding animations
                if let oldCoordinate = activeTouches.filter({ $0.touch == touch }).first?.coordinate,
                    oldCoordinate != newCoordinate {

                    // TODO: implement propery Y coordinate offsetting

                    let oldReversedY = (oldCoordinate.y * -1) + cells[0].count
                    cells[oldCoordinate.x][oldReversedY].disappear(animated: false)

                    // send stop playing event to for old coordinate (for drums AND when switching y coordinates only)
                    if sendsTouchOffs && oldCoordinate.y != newCoordinate.y {
                        let touch = activeTouches.filter({ $0.touch == touch })[0]
                        delegate?.stopPlaying(forTouchWithCoordinate: touch.coordinate, andIndex: touch.index)
                    }

                    // update coordinate
                    let index = activeTouches.enumerated().filter({ $0.1.touch == touch })[0].0
                    activeTouches[index].coordinate = newCoordinate

                    // ...and send updated touch events to Pd
                    activeTouches.forEach {
                        self.delegate?.play(forTouchWithIndex: $0.index, atCoordinate: $0.coordinate)
                    }
                }
            }
        }
    }

    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        remove(touches: touches)
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        remove(touches: touches)
    }

    // MARK: - Helpers

    private func remove(touches: Set<UITouch>) {

        for touch in touches {

            touchCount -= 1

            // stop playing pattern
            if let touchAndCoordinate = activeTouches.filter({ $0.touch == touch }).first {

                let index = touchAndCoordinate.index
                let coordinate = touchAndCoordinate.coordinate
                delegate?.stopPlaying(forTouchWithCoordinate: coordinate, andIndex: index)
            }

            // animate cells
            let location = touch.location(in: self)
            cell(at: location)?.disappear()

            // remove touch from array
            let index = activeTouches.enumerated().filter({ $0.1.touch == touch })[0].0
            activeTouches.remove(at: index)

            // clear to avoid hanging touches
            if touchCount == 0 {

                cells.joined().forEach {
                    $0.disappear()
                }
            }
        }
    }

    private func cell(at point: CGPoint) -> GridCell? {

        for row in cells {
            for cell in row where cell.frame.contains(point) {
                return cell
            }
        }

        return nil
    }

    private func coordinate(for point: CGPoint) -> GridCoordinate? {

        for (x, column) in cells.enumerated() {
            // reverse column because it needs to start counting from the bottom (i.e. low to high)
            for (var y, cell) in column.reversed().enumerated() where cell.frame.contains(point) {
                // offset y by one because 0 is a rest
                y = y + 1
                return GridCoordinate(x: x, y: y)
            }
        }

        return nil
    }
}

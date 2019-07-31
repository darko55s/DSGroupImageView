//
//  DSGroupImageView.swift
//  DSGroupImageView
//
//  Created by Darko Spasovski on 7/31/19.
//  Copyright © 2019 Zootch. All rights reserved.
//

import UIKit
import Kingfisher
import RandomColorSwift

enum AlwaysBigSide {
    case left
    case right
}

enum DoubleImageSplit {
    case vertical
    case horizontal
}

enum ConstraintSize {
    case leading
    case trailing
    case bottom
    case top
}

protocol DSGroupImageViewDataSource: class {
    func numberOfImagesInView() -> Int
    func imageAt(index: Int) -> String
}

class DSGroupImageView: UIView {
    private var numberOfImages = 0
    private var images = [String]()
    private var firstBigSize: AlwaysBigSide = .left
    private var doubleImageSplit: DoubleImageSplit = .vertical

    weak var dataSource: DSGroupImageViewDataSource?

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    init() {
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupImages() {
        guard let count = dataSource?.numberOfImagesInView() else {
            fatalError("Datasource Method: NumberOfImagesInView notfound")
        }

        if count > 4 {
            fatalError("We support max 4 images at the moment!")
        }

        var views = [String:Any]()

        for index in 0..<count {
            guard let imageUrl = dataSource?.imageAt(index: index) else {
                fatalError("Image for index \(index) not found")
            }
            let imageView = getImageViewFor(index: index, imageUrl: imageUrl)
            addSubview(imageView)
            views[getViewNameFor(index: index)] = imageView
        }
        setupConstraints(views: views)
    }

    private func getViewNameFor(index: Int) -> String {
        switch index {
        case 0:
            return "viewOne"
        case 1:
            return "viewTwo"
        case 2:
            return "viewThree"
        case 3:
            return "viewFour"
        default:
            return "viewFive"
        }
    }

    private func getMetricsNameFor(index: Int, isHeight: Bool) -> String {
        return (getViewNameFor(index: index) + (isHeight ? "_height" : "_width"))
    }

    private func getImageViewFor(index: Int, imageUrl: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.tag = index+1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = randomColor()
        imageView.kf.setImage(with: URL(string: imageUrl))
        return imageView
    }

    private func setupConstraints(views: [String:Any]) {
        for i in 0..<views.keys.count {
            let metrics = getMetricsForSize(count: views.keys.count)
            let visualFormatH = "H:" + getPositionFor(index: i, side: .leading) + "[" + getViewNameFor(index: i) + "(" + getMetricsNameFor(index: i, isHeight: false) + ")]" + getPositionFor(index: i, side: .trailing)
            let visualFormatV = "V:" + getPositionFor(index: i, side: .top) + "[" + getViewNameFor(index: i) + "(" + getMetricsNameFor(index: i, isHeight: true) + ")]" + getPositionFor(index: i, side: .bottom)
            setVisualConstraints(visualFormat: visualFormatH, views: views, metrics: metrics)
            setVisualConstraints(visualFormat: visualFormatV, views: views, metrics: metrics)
        }
    }

    private func getPositionFor(index: Int, side: ConstraintSize) -> String {
        switch side {
        case .trailing:
            return (index == 0 || index == 2) ? "" : "-0-|"
        case .leading:
            return (index == 0 || index == 2) ? "|-0-" : ""
        case .top:
            return (index == 0 || index == 1) ? "|-0-" : ""
        case .bottom:
            return (index == 0 || index == 1) ? "" : "-0-|"
        }
    }

    private func getMetricsForSize(count: Int) -> [String:Any] {
        var metrics = [String:Any]()
        switch count {
        case 1:
             metrics[getMetricsNameFor(index: 0, isHeight: false)] = bounds.width
             metrics[getMetricsNameFor(index: 0, isHeight: true)] = bounds.height
        case 2:
            for i in 0..<count {
                metrics[getMetricsNameFor(index: i, isHeight: false)] = doubleImageSplit == .vertical ? bounds.width / 2.0 : bounds.width
                metrics[getMetricsNameFor(index: i, isHeight: true)] = doubleImageSplit == .vertical ? bounds.height : bounds.height / 2.0
            }
        case 3:
            for i in 0..<count {
                metrics[getMetricsNameFor(index: i, isHeight: false)] = bounds.width / 2.0
                metrics[getMetricsNameFor(index: i, isHeight: true)] = (i == 1) ? bounds.height : bounds.height / 2.0
            }
        case 4:
            for i in 0..<count {
                metrics[getMetricsNameFor(index: i, isHeight: false)] = bounds.width / 2.0
                metrics[getMetricsNameFor(index: i, isHeight: true)] =  bounds.height / 2.0
            }
        default:
            break
        }
        return metrics
    }

    private func setVisualConstraints(visualFormat: String, views: [String:Any], metrics: [String:Any]?) {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: [], metrics: metrics, views: views))
    }

    private func removeAllViews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

    private func performImageRefresh() {
        guard let count = dataSource?.numberOfImagesInView() else {
            fatalError("Datasource Method: NumberOfImagesInView notfound")
        }
        if subviews.count != count {
            reloadViews()
            return
        }

        for index in 0..<count {
            guard let imageUrl = dataSource?.imageAt(index: index) else {
                fatalError("Image for index \(index) not found")
            }
            guard let imageView = viewWithTag(index+1) as? UIImageView else {
                fatalError("ImageView for index \(index) not yet setup. Call \"reloadViews()\" instead!")
            }
            imageView.kf.setImage(with: URL(string: imageUrl), options: [.forceRefresh])
        }
    }

    func changeAlwaysBigSize() {
        firstBigSize = firstBigSize == .left ? .right : .left
    }

    func reloadViews() {
        removeAllViews()
        setupImages()
    }

    func refreshImages() {
        performImageRefresh()
    }
}

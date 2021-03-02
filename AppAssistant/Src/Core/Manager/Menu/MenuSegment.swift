//
//  MenuSegment.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/9.
//

import UIKit

class MenuSegmentThemes {
    enum ThemeStyle {
        case orange
    }

    var style = ThemeStyle.orange {
        didSet {
            switch self.style {
            case .orange:
                break
            }
        }
    }

    required init(style: ThemeStyle? = .orange) {
        self.style = style ?? .orange
    }

    var itemMinWidth: CGFloat = 45.0
    var itemMinHeight: CGFloat = 24.0

    var sliderColor = UIColor(red: 255 / 255.0, green: 133 / 255.0, blue: 52 / 255.0, alpha: 1.0)
    var highLightTextColor = UIColor.white
    var normalTextColor = UIColor(red: 255 / 255.0, green: 133 / 255.0, blue: 52 / 255.0, alpha: 1.0)

    var radius: CGFloat = 3.0
    var borderWidth: CGFloat = 1.0
    var borderColor = UIColor(red: 255 / 255.0, green: 133 / 255.0, blue: 52 / 255.0, alpha: 1.0)
}

protocol MenuSegmentDelegate: NSObjectProtocol {
    func segmentItemDidSelected(index: Int)
}

class MenuSegment: UIView {

    private var theme = MenuSegmentThemes()

    required init(theme: MenuSegmentThemes? = MenuSegmentThemes()) {
        super.init(frame: .zero)
        self.theme = theme ?? MenuSegmentThemes()

        self.addSubview(slider)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var delegate: MenuSegmentDelegate?

    private var index = 0

    private var items: [UILabel] = []

    var titles: [String] = [] {
        didSet {
            for item in self.items {
                item.removeFromSuperview()
            }
            items.removeAll()
            for (index, title) in self.titles.enumerated() {
                let item = UILabel()
                item.numberOfLines = 1
                item.textAlignment = .center
                item.textColor = (index == 0) ? theme.highLightTextColor : theme.normalTextColor
                item.font = UIFont.systemFont(ofSize: 13.0)
                item.text = title

                item.tag = index
                item.isUserInteractionEnabled = true
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(itemDidSelected(gesture:)))
                singleTap.numberOfTapsRequired = 1
                singleTap.numberOfTouchesRequired = 1
                item.addGestureRecognizer(singleTap)

                items.append(item)

                self.addSubview(item)
            }
            // 重置
            itemWidth = 0
            itemHeight = 0
            setNeedsLayout()
            layoutIfNeeded()
            invalidateIntrinsicContentSize()
        }
    }

    private lazy var slider: UIView = {
        let slider = UIView(frame: .zero)
        slider.backgroundColor = self.theme.sliderColor
        return slider
    }()

    private var itemWidth: CGFloat = 0
    private var itemHeight: CGFloat = 0

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: itemWidth * CGFloat(items.count), height: max(size.height, itemHeight))
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: itemWidth * CGFloat(items.count), height: itemHeight)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.masksToBounds = true
        self.layer.cornerRadius = theme.radius

        self.layer.borderWidth = theme.borderWidth
        self.layer.borderColor = theme.borderColor.cgColor

        // 求出单个最大宽高
        for item in items {
            item.sizeToFit()
            itemWidth = max(item.bounds.width + 8.0, itemWidth)
            itemHeight = max(item.bounds.height + 4.0, itemHeight)
        }
        // 如果外部设置了更大的总宽高
//        if (self.bounds.width > itemWidth * CGFloat(items.count)) {
//            itemWidth = self.bounds.width / CGFloat(items.count)
//        }
//        if (self.bounds.height > itemHeight) {
//            itemHeight = self.bounds.height
//        }
        // 保证不小于
        itemWidth = max(theme.itemMinWidth, itemWidth)
        itemHeight = max(theme.itemMinHeight, itemHeight)

        for (index, item) in items.enumerated() {
            item.frame = CGRect(x: itemWidth * CGFloat(index), y: 0, width: itemWidth, height: itemHeight)
        }

        slider.frame = CGRect(x: itemWidth * CGFloat(index), y: 0, width: itemWidth, height: itemHeight)  // animatable
    }

    @objc
    private func itemDidSelected(gesture: UITapGestureRecognizer) {
        index = gesture.view?.tag ?? 0
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self else {
                return
            }
            for (index, item) in self.items.enumerated() {
                item.textColor = (index == self.index) ? self.theme.highLightTextColor : self.theme.normalTextColor
            }

            self.setNeedsLayout()
            self.layoutIfNeeded()
        }, completion: { [weak self] (_) in
            guard let self = self else {
                return
            }
            if self.delegate != nil {
                self.delegate?.segmentItemDidSelected(index: self.index)
            }
        })
    }

}

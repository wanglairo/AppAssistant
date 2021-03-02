//
//  AssistantOscillogramView.swift
//  AppAssistant
//
//  Created by zhaochangwu on 2020/10/15.
//

import UIKit

class AssistantPoint: NSObject {
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
}

class AssistantOscillogramView: UIScrollView {

    var strokeColor = UIColor.orange
    var numberOfPoints = 12

    private var kStartX = 52.fitSizeFrom750Landscape
    private var pointList: [AssistantPoint] = []
    private var pointLayerList: [CALayer] = []
    private var x: CGFloat = 0
    private var y: CGFloat = 0

    private lazy var bottomLine: UIView = {
        let view = UIView()

        view.frame = CGRect(
            x: kStartX,
            y: assk.height - 1.fitSizeFrom750Landscape,
            width: assk.width,
            height: 1.fitSizeFrom750Landscape
        )

        view.backgroundColor = UIColor.assistant_colorWithString("#999999")

        return view
    }()

    private lazy var lowValueLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(
            x: 0,
            y: assk.height - 28.fitSizeFrom750Landscape / 2,
            width: kStartX,
            height: 28.fitSizeFrom750Landscape
        )
        label.text = "0"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()

    private lazy var highValueLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(
            x: 0,
            y: -28.fitSizeFrom750Landscape / 2,
            width: kStartX,
            height: 28.fitSizeFrom750Landscape
        )
        label.text = "100"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()

    private var lineLayer: CAShapeLayer?

    private var tipLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.assistant_colorWithString("#00DFDD")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20.fitSizeFrom750Landscape)
        label.lineBreakMode = .byClipping
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        delegate = self
        clipsToBounds = false
        addSubview(bottomLine)
        addSubview(lowValueLabel)
        addSubview(highValueLabel)
        addSubview(tipLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addHeightValue(_ showHeight: CGFloat, tipValue: String) {
        let width = self.assk.width
        let height = self.assk.height
        let step = width / CGFloat(numberOfPoints)
        if pointList.isEmpty {
            x = kStartX
        } else if x <= width - step {
            x += step
        }

        y = abs(min(height, showHeight))
        let point = AssistantPoint()
        point.x = x
        point.y = y
        pointList.append(point)

        if pointList.count > numberOfPoints {
            var oldList = [AssistantPoint]()

            for point in pointList {
                point.x -= step
                if point.x < kStartX {
                    oldList.append(point)
                }
            }
            pointList.removeAll(where: { oldList.contains($0) })
        }
        drawLine()
        drawTipViewWithValue(tipValue, point: point)
    }

    func setLowValue(_ value: String) {
        lowValueLabel.text = value
    }

    func setHightValue(_ value: String) {
        highValueLabel.text = value
    }

    func clear() {
        if pointLayerList.isEmpty == false {
            for layer in pointLayerList {
                layer.removeFromSuperlayer()
            }
            pointLayerList = []
        }
        lineLayer?.removeFromSuperlayer()
        pointList = []
        tipLabel.isHidden = true
    }

    private func drawLine() {

        lineLayer?.removeFromSuperlayer()

        if pointLayerList.isEmpty == false {
            for layer in pointLayerList {
                layer.removeFromSuperlayer()
            }
            pointLayerList = []
        }
        if pointList.isEmpty {
            return
        }
        let path = UIBezierPath()
        let point = pointList[0]
        let point1 = CGPoint(x: point.x, y: assk.height - point.y)
        path.move(to: point1)
        addPointLayer(point1)

        for index in 1..<pointList.count {
            let point = pointList[index]
            let point2 = CGPoint(x: point.x, y: assk.height - point.y)
            path.addLine(to: point2)
            addPointLayer(point2)
        }

        path.lineWidth = 2

        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = UIColor.assistant_colorWithString("#00DFDD").cgColor
        layer.fillColor = UIColor.clear.cgColor

        lineLayer = layer

        self.layer.addSublayer(layer)

        for layerItem in pointLayerList {
            self.layer.addSublayer(layerItem)
        }
    }

    private func addPointLayer(_ point: CGPoint) {
        let pointLayer = CALayer()
        pointLayer.backgroundColor = UIColor.assistant_colorWithString("#00DFDD").cgColor
        pointLayer.cornerRadius = 2
        pointLayer.frame = CGRect(
            x: point.x - 8.fitSizeFrom750Landscape / 2,
            y: point.y - 8.fitSizeFrom750Landscape / 2,
            width: 8.fitSizeFrom750Landscape,
            height: 8.fitSizeFrom750Landscape
        )
        pointLayerList.append(pointLayer)
    }

    private func drawTipViewWithValue(_ tip: String, point: AssistantPoint, time: String = "") {

        if tipLabel.isHidden {
            tipLabel.isHidden = false
        }

        if time.isEmpty == false {
            tipLabel.text = "\(tip)\n\(time)"
            tipLabel.numberOfLines = 2
        } else {
            tipLabel.text = tip
            tipLabel.numberOfLines = 1
        }

        tipLabel.sizeToFit()
        tipLabel.frame = CGRect(
            x: point.x,
            y: assk.height - point.y - tipLabel.assk.height,
            width: tipLabel.assk.width,
            height: tipLabel.assk.height
        )
    }
}

extension AssistantOscillogramView: UIScrollViewDelegate {}

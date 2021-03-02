//
//  ViewAlignView.swift
//  Alamofire
//
//  Created by 王来 on 2020/11/9.
//

import UIKit

class ViewAlignView: UIView {

    private let color = UIColor.red

    private lazy var imageView = UIImageView(image: UIImage.assistant_xcassetImageNamed(name: "doraemon_visual"))
    private lazy var lines = (horizontal: UIView(), vertical: UIView())
    private lazy var labels = (top: UILabel(), left: UILabel(), bottom: UILabel(), right: UILabel())

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup() {
        backgroundColor = .clear

        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        imageView.addGestureRecognizer(pan)
        imageView.isUserInteractionEnabled = true
        addSubview(imageView)

        defer { bringSubviewToFront(imageView) }

        [lines.0, lines.1].forEach {
            $0.backgroundColor = color
            addSubview($0)
        }

        [labels.0, labels.1, labels.2, labels.3].forEach {
            $0.font = .systemFont(ofSize: 12)
            $0.textColor = color
            $0.textAlignment = $0 == labels.top || $0 == labels.bottom ? .right : .center
            addSubview($0)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let target = imageView.center

        lines.0.frame = .init(x: 0, y: target.y, width: assk.width, height: 0.5)
        lines.1.frame = .init(x: target.x, y: 0, width: 0.5, height: assk.height)

        labels.0.frame = .init(x: 0, y: target.y / 2 - 10, width: target.x, height: 20)
        labels.1.frame = .init(x: 0, y: target.y - 20, width: target.x, height: 20)
        labels.2.frame = .init(x: 0, y: target.y + (assk.height - target.y) / 2 - 10, width: target.x, height: 20)
        labels.3.frame = .init(x: target.x, y: target.y - 20, width: assk.width - target.x, height: 20)

        labels.0.text = .init(format: "%.1f", target.y)
        labels.1.text = .init(format: "%.1f", target.x)
        labels.2.text = .init(format: "%.1f", assk.height - target.y)
        labels.3.text = .init(format: "%.1f", assk.width - target.x)

        let string = String(
            format: "位置：上%@  下%@  左%@  右%@",
            labels.0.text ?? "",
            labels.2.text ?? "",
            labels.1.text ?? "",
            labels.3.text ?? ""
        )
        VisualInfo.defalut.view.set(text: string)

        // 超出范围 重置位置
        guard !bounds.contains(target) else {
            return
        }
        reset()
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return imageView.frame.contains(point)
    }
}

extension ViewAlignView {

    @objc
    private func panAction(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view else {
            return
        }

        let offset = sender.translation(in: view)
        sender.setTranslation(.zero, in: view)
        view.center = .init(
            x: max(0, min(assk.width, view.center.x + offset.x)),
            y: max(0, min(assk.height, view.center.y + offset.y))
        )
        layoutSubviews()
    }
}

extension ViewAlignView {

    /// 重置位置
    func reset() {

        imageView.center = .init(x: assk.width / 2, y: assk.height / 2)
        layoutSubviews()
    }
}

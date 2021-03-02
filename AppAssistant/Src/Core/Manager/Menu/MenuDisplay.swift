//
//  MenuDisplay.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/9.
//

import UIKit

extension AssistantMenu.Display {

    static var selectedItem: AssistantMenu.Item?

    func configView(options: [AssistantMenu.Config.Option], backAction: (() -> Void)?) {
        for item in items {
            item.removeFromSuperview()
        }
        items.removeAll()

        back.isHidden = backAction == nil ? true : false
        back.bindItem {
            backAction?()
        }

        var currentOptions: [AssistantMenu.Config.Option] = []
        var moreOptions: [AssistantMenu.Config.Option] = []

        if options.count <= 7 {
            currentOptions = options
            more.isHidden = true
        } else {
            currentOptions = Array(options.prefix(7))
            moreOptions = Array(options.suffix(from: 7))
            more.isHidden = false
            more.bindItem {
                self.backgroundColor = .clear
                self.openSubMenu(options: moreOptions, selItem: self.more)
            }
        }

        for option in currentOptions {
            let item = AssistantMenu.Item(style: .item(title: option.title))
            item.configItem(skin: option.skin)
            item.bindItem {
                if !option.subOption.isEmpty {
                    self.backgroundColor = .clear
                    self.openSubMenu(options: option.subOption, selItem: item)
                }
                option.action?()
            }
            items.append(item)
        }

        for item in items {
            if AssistantMenu.core.config.debuging == true {
                item.layer.borderWidth = 0.5
                item.layer.borderColor = UIColor.black.cgColor
            }
            if let selectedItem = AssistantMenu.Display.selectedItem {
                item.frame = selectedItem.frame
            }
            self.addSubview(item)
        }

        setNeedsLayout()
        layoutIfNeeded()
    }

    private func openSubMenu(options: [AssistantMenu.Config.Option], selItem: AssistantMenu.Item) {

        AssistantMenu.Display.selectedItem = selItem

        for item in items {
            item.isHidden = true
        }

        let subDisplay = AssistantMenu.Display()
        self.addSubview(subDisplay)
        subDisplay.frame = self.bounds
        subDisplay.configView(options: options) {

            for (index, item) in subDisplay.items.enumerated() {
                if let selectedItem = AssistantMenu.Display.selectedItem {
                    UIView.animate(withDuration: 0.2, animations: {
                        item.frame = selectedItem.frame
                    }, completion: { [weak self] (_) in
                        guard let self = self else {
                            return
                        }
                        if index == subDisplay.items.count - 1 {
                            subDisplay.removeFromSuperview()
                            self.backgroundColor = UIColor.assistant_colorWithHex(0x000000, andAlpha: 0.3)
                            for ite in self.items {
                                ite.isHidden = false
                            }
                        }
                    })
                }
            }
        }
    }

    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    // swiftlint:disable override_in_extension
    override func layoutSubviews() {
        super.layoutSubviews()

        let hgap: CGFloat = 15.0
        let vgap: CGFloat = 15.0
        let itemSize = CGSize(width: 80.0, height: 80.0)
        let po0 = CGPoint(x: hgap + (hgap + itemSize.width) * 0, y: vgap + (vgap + itemSize.height) * 0)
        let po1 = CGPoint(x: hgap + (hgap + itemSize.width) * 1, y: po0.y)
        let po2 = CGPoint(x: hgap + (hgap + itemSize.width) * 2, y: po0.y)
        let po3 = CGPoint(x: po0.x, y: vgap + (vgap + itemSize.height) * 1)
        let po4 = CGPoint(x: po1.x, y: po3.y)
        let po5 = CGPoint(x: po2.x, y: po3.y)
        let po6 = CGPoint(x: po0.x, y: vgap + (vgap + itemSize.height) * 2)
        let po7 = CGPoint(x: po1.x, y: po6.y)
        let po8 = CGPoint(x: po2.x, y: po6.y)

        back.frame = CGRect(origin: po4, size: itemSize)
        more.frame = CGRect(origin: po8, size: itemSize)

        for (index, item) in items.enumerated() {

            UIView.animate(withDuration: 0.2) {
                switch self.items.count {
                case 1:
                    item.frame = CGRect(origin: po1, size: itemSize)
                case 2:
                    switch index {
                    case 0:
                        item.frame = CGRect(origin: po3, size: itemSize)
                    case 1:
                        item.frame = CGRect(origin: po5, size: itemSize)
                    default:
                        break
                    }
                case 3:
                    switch index {
                    case 0:
                        item.frame = CGRect(origin: po1, size: itemSize)
                    case 1:
                        item.frame = CGRect(origin: po3, size: itemSize)
                    case 2:
                        item.frame = CGRect(origin: po5, size: itemSize)
                    default:
                        break
                    }
                case 4:
                    switch index {
                    case 0:
                        item.frame = CGRect(origin: po1, size: itemSize)
                    case 1:
                        item.frame = CGRect(origin: po3, size: itemSize)
                    case 2:
                        item.frame = CGRect(origin: po5, size: itemSize)
                    case 3:
                        item.frame = CGRect(origin: po7, size: itemSize)
                    default:
                        break
                    }
                case 5:
                    switch index {
                    case 0:
                        item.frame = CGRect(origin: po0, size: itemSize)
                    case 1:
                        item.frame = CGRect(origin: po1, size: itemSize)
                    case 2:
                        item.frame = CGRect(origin: po2, size: itemSize)
                    case 3:
                        item.frame = CGRect(origin: po3, size: itemSize)
                    case 4:
                        item.frame = CGRect(origin: po5, size: itemSize)
                    default:
                        break
                    }
                case 6:
                    switch index {
                    case 0:
                        item.frame = CGRect(origin: po0, size: itemSize)
                    case 1:
                        item.frame = CGRect(origin: po1, size: itemSize)
                    case 2:
                        item.frame = CGRect(origin: po2, size: itemSize)
                    case 3:
                        item.frame = CGRect(origin: po3, size: itemSize)
                    case 4:
                        item.frame = CGRect(origin: po5, size: itemSize)
                    case 5:
                        item.frame = CGRect(origin: po6, size: itemSize)
                    default:
                        break
                    }
                case 7:
                    switch index {
                    case 0:
                        item.frame = CGRect(origin: po0, size: itemSize)
                    case 1:
                        item.frame = CGRect(origin: po1, size: itemSize)
                    case 2:
                        item.frame = CGRect(origin: po2, size: itemSize)
                    case 3:
                        item.frame = CGRect(origin: po3, size: itemSize)
                    case 4:
                        item.frame = CGRect(origin: po5, size: itemSize)
                    case 5:
                        item.frame = CGRect(origin: po6, size: itemSize)
                    case 6:
                        item.frame = CGRect(origin: po7, size: itemSize)
                    default:
                        break
                    }
                default:
                    break
                }
            }
        }
    }

}

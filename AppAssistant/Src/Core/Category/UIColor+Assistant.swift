//
//  UIColor+Assistant.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/9.
//

extension String {
    func subString(with range: NSRange) -> String {
        return (self as NSString).substring(with: range)
    }
}

func assistantColorComponentFrom(_ string: String, _ start: UInt, _ length: UInt) -> CGFloat {

    let substring = string.subString(with: NSRange(location: Int(start), length: Int(length)))
    let fullHex: String = length == 2 ? substring : "\(substring)\(substring)"
    var hexComponent: UInt32 = 0
    Scanner(string: fullHex).scanHexInt32(&hexComponent)
    return CGFloat(hexComponent) / 255.0
}

extension UIColor {

    func colorSpaceModel() -> CGColorSpaceModel {
        return self.cgColor.colorSpace?.model ?? CGColorSpaceModel.unknown
    }

    func canProvideRGBComponents() -> Bool {

        switch colorSpaceModel() {
        case .rgb, .monochrome:
            return true
        default:
            return false
        }
    }

    static func assistant_colorWithHex(_ hex: Int) -> UIColor {
        return UIColor.assistant_colorWithHex(hex, andAlpha: 1)
    }

    static func assistant_colorWithHex(_ hex: Int, andAlpha alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(((hex >> 16) & 0xFF)) / 255.0,
                       green: CGFloat(((hex >> 8) & 0xFF)) / 255.0,
                       blue: CGFloat((hex & 0xFF)) / 255.0,
                       alpha: alpha)
    }

    static func assistant_colorWithString(_ hexString: String) -> UIColor {
        guard let color = self.assistant_colorWithHexString(hexString) else {
            return UIColor()
        }
        return color
    }

    static func assistant_colorWithHexString(_ hexString: String) -> UIColor? {
        var alpha: CGFloat
        var red: CGFloat = 0
        var blue: CGFloat
        var green: CGFloat
        let colorString: String = hexString.replacingOccurrences(of: "#", with: "").uppercased()
        switch colorString.count {
            case 3:

            // #RGB
            alpha = 1.0
            green = assistantColorComponentFrom(colorString, 1, 1)
            blue = assistantColorComponentFrom(colorString, 2, 1)
            case 4:

            // #ARGB
            alpha = assistantColorComponentFrom(colorString, 0, 1)
            red = assistantColorComponentFrom(colorString, 1, 1)
            green = assistantColorComponentFrom(colorString, 2, 1)
            blue = assistantColorComponentFrom(colorString, 3, 1)
            case 6:

            // #RRGGBB
            alpha = 1.0
            red = assistantColorComponentFrom(colorString, 0, 2)
            green = assistantColorComponentFrom(colorString, 2, 2)
            blue = assistantColorComponentFrom(colorString, 4, 2)
            case 8:

            // #AARRGGBB
            alpha = assistantColorComponentFrom(colorString, 0, 2)
            red = assistantColorComponentFrom(colorString, 2, 2)
            green = assistantColorComponentFrom(colorString, 4, 2)
            blue = assistantColorComponentFrom(colorString, 6, 2)
            default :
            return nil
        }
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    static func assistant_black_1() -> UIColor {
        // #333333
//        if #available(iOS 13.0, *) {
//           return UIColor.init { (traitCollection) -> UIColor in
//                if traitCollection.userInterfaceStyle == UIUserInterfaceStyle.light {
//                    return UIColor.assistant_colorWithString("#333333")
//                } else {
//                    return UIColor.assistant_colorWithString("#DDDDDD")
//                }
//            }
//        }
        return UIColor.assistant_colorWithString("#333333")
    }

    static func assistant_black_2() -> UIColor {
        // #666666
//        if #available(iOS 13.0, *) {
//           return UIColor.init { (traitCollection) -> UIColor in
//                if traitCollection.userInterfaceStyle == UIUserInterfaceStyle.light {
//                    return UIColor.assistant_colorWithString("#666666")
//                } else {
//                    return UIColor.assistant_colorWithString("#AAAAAA")
//                }
//            }
//        }
        return UIColor.assistant_colorWithString("#666666")
    }

    static func assistant_black_3() -> UIColor {
        // #999999
//        if #available(iOS 13.0, *) {
//           return UIColor.init { (traitCollection) -> UIColor in
//                if traitCollection.userInterfaceStyle == UIUserInterfaceStyle.light {
//                    return UIColor.assistant_colorWithString("#999999")
//                } else {
//                    return UIColor.assistant_colorWithString("#666666")
//                }
//            }
//        }
        return UIColor.assistant_colorWithString("#999999")
    }

    static func assistant_blue() -> UIColor {
        // #337CC4
//        if #available(iOS 13.0, *) {
//           return UIColor.init { (traitCollection) -> UIColor in
//                if traitCollection.userInterfaceStyle == UIUserInterfaceStyle.light {
//                    return UIColor.assistant_colorWithString("#337CC4")
//                } else {
//                    return UIColor.systemBlue
//                }
//            }
//        }
        return UIColor.assistant_colorWithString("#337CC4")
    }

    static func assistant_bg() -> UIColor {
        // #F4F5F6
        return UIColor.assistant_colorWithString("#F4F5F6")
    }

    static func assistant_orange() -> UIColor {
        // #FF8903
        return UIColor.assistant_colorWithString("#FF8903")
    }

    static func assistant_black_4() -> UIColor {
        // #324456
        return UIColor.assistant_colorWithString("#324456")
    }

    static func assistant_line() -> UIColor {

//        if #available(iOS 13.0, *) {
//           return UIColor.init { (traitCollection) -> UIColor in
//                if traitCollection.userInterfaceStyle == UIUserInterfaceStyle.light {
//                    return UIColor.assistant_colorWithHex(0x000000, andAlpha: 0.1)
//                } else {
//                    return UIColor.assistant_colorWithHex(0x68686B, andAlpha: 0.6)
//                }
//            }
//        }
        return UIColor.assistant_colorWithHex(0x000000, andAlpha: 0.1)
    }

    // swiftlint 
    static func assistant_randomColor() -> UIColor {

        // swiftlint:disable legacy_random
        let red: CGFloat = (CGFloat(arc4random() % 255) / 255.0)
        let green: CGFloat = (CGFloat(arc4random() % 255) / 255.0)
        let blue: CGFloat = (CGFloat(arc4random() % 255) / 255.0)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    /// Hexadecimal value string (read-only).
    var hexString: String {
        let components: [Int] = {
            let comps = cgColor.components ?? [0.0, 0.0]
            let components = comps.count == 4 ? comps : [comps[0], comps[0], comps[0], comps[1]]
            return components.map { Int($0 * 255.0) }
        }()
        return String(format: "#%02X%02X%02X", components[0], components[1], components[2])
    }

    static func dynamic(with light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor {
                switch $0.userInterfaceStyle {
                case .light:        return light
                case .dark:         return dark
                case .unspecified:  return light
                @unknown default:   return light
                }
            }
        } else {
            return light
        }
    }

}

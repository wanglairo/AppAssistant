//
//  ByteConvertible.swift
//  AppAssistant
//
//  Created by zhaochangwu on 2020/10/15.
//

import Foundation

protocol ByteConvertible {

    var KBToByte: Int { get }
}

private extension ByteConvertible {

    var KBToByteRate: Int {

        return 1000
    }
}

private extension ByteConvertible {

    func convert<Target>(target: Target, rate: Int) -> Int where Target: BinaryFloatingPoint {

        return Int(CGFloat(target) * CGFloat(rate))
    }

    func convert<Target>(target: Target, rate: Int) -> Int where Target: BinaryInteger {

        return Int(target) * rate
    }
}

extension BinaryFloatingPoint where Self: ByteConvertible {

    var KBToByte: Int {

        return convert(target: self, rate: KBToByteRate)
    }
}

extension BinaryInteger where Self: ByteConvertible {

    var KBToByte: Int {

        return convert(target: self, rate: KBToByteRate)
    }
}

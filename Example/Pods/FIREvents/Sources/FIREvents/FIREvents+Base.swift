//
//  FIREvents+Base.swift
//  FIREvents
//
//  Created by DongDong on 2023/8/15.
//

import Foundation

public protocol FIREventBaseType: Hashable {
    var category: String { get }
}

public protocol FIRParameterEnumStringType {
    var typeValue: String { get }
}

public protocol FIRParameterEnumNumberType {
    var typeValue: NSNumber { get }
}

public protocol FIRParameterDataType: Hashable, RawRepresentable where RawValue == String {
    static var properties: [Self] { get }
    static var propertiesTypes: [Self: Any.Type] { get }
}
public protocol FIREventSendable: FIREventBaseType, RawRepresentable where RawValue == String {
    associatedtype Parameter: FIRParameterDataType

    static func eventNameMapping(platform: Platform) -> [Self: String]?

    var platforms: Set<Platform> { get }
}

extension FIREventSendable {

    public static func eventNameMapping(platform: Platform) -> [Self: String]? {
        nil
    }
}

public protocol FIRUserPropertySendable: Hashable, RawRepresentable where RawValue == String {
    static var propertiesTypes: [Self: Any.Type] { get }

    var platforms: Set<Platform> { get }
}

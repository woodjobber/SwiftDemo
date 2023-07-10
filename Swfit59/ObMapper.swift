//
//  ObMapper.swift
//  Swfit59
//
//  Created by chengbin on 2023/7/9.
//

//import Foundation
//import ObjectMapper
//
//struct Student: Mappable {
//    var id: Int?
//    var birthday: Date?
//    var imgUrl: URL?
//
//    init?(map: Map) {}
//
//    mutating func mapping(map: Map) {
//        self.id <- (map["id"], TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
//            guard let value = value else { return nil }
//            return Int(value)
//        }, toJSON: { (value: Int?) -> String? in
//            guard let value = value else { return nil }
//            return String(value)
//        }))
//        self.birthday <- (map["birthday"], DateTransform())
//        self.imgUrl <- (map["img"], URLTransform())
//    }
//}

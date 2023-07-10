//
//  CPSearchEventsApiModel.swift
//  Swfit59
//
//  Created by chengbin on 2023/7/12.
//

import Foundation
import RxSwift
import Alamofire

final class CPSearchEventsApiModel {
    func searchEvents(word: String) -> Observable<Events?> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return Observable.create { observer in
            let url = "https://connpass.com/api/v1/event/?keyword=\(word)"
            AF.request(url,method: .get,parameters:nil).responseDecodable(of: Events.self, decoder: decoder,completionHandler: {response in
                switch response.result {
                case .success(_):
                    print(response.data!.toJson)
                    if let result = response.value {
                        observer.onNext(result)
                    }
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
    }
}
struct Events: Codable {
    let events: [Event]?
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        events = try values.decodeIfPresent([Event].self, forKey: .events)
    }
}

struct Event: Codable {
    let title: String?
    let startedAt: String?
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.startedAt = try container.decodeIfPresent(String.self, forKey: .startedAt)
    }
}

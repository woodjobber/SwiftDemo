//
//  SampleViewModel.swift
//  Swfit59
//
//  Created by chengbin on 2023/7/12.
//

import Foundation
import RxCocoa
import RxSwift
//https://github.com/ytkawas/MVVMSample/blob/master/MVVMSample/ViewModel/SampleViewModel.swift
class SampleViewModel {
    private let disposeBag = DisposeBag()
    
    private let searchWordStream = PublishSubject<String>()
    private let eventsStream = PublishSubject<Events?>()
    
    private let startedAtStream = PublishSubject<String>()
    private let formattedDateStream = PublishSubject<String>()
    
    init() {
        searchWordStream.flatMapLatest { word -> Observable<Events?> in
            let model = CPSearchEventsApiModel()
            return model.searchEvents(word: word).catchAndReturn(nil)
        }.subscribe(eventsStream).disposed(by: disposeBag)
        
        startedAtStream.flatMapLatest { st -> Observable<String> in
            return self.format(dateString: st)
        }.subscribe(formattedDateStream).disposed(by: disposeBag)
    }
    
    func format(dateString: String) -> Observable<String> {
        return Observable.create { observer in
            let formatter = ISO8601DateFormatter()
            let date = formatter.date(from: dateString)
            if let date = date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM(EEE)", options: 0, locale: nil)
                let result = dateFormatter.string(from: date)
                observer.onNext(result)
            }
            
            return Disposables.create()
        }
    }
}
extension SampleViewModel {
    var searchWord: AnyObserver<(String)>{
        return searchWordStream.asObserver()
    }
    var startedAt: AnyObserver<String> {
        return startedAtStream.asObserver()
    }
    
}

extension SampleViewModel {
    var events: Observable<Events?> {
        return eventsStream.asObservable()
    }
    var formattedDate: Observable<String> {
        return formattedDateStream.asObservable()
    }
}

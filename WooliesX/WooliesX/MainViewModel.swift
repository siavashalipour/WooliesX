//
//  MainViewModel.swift
//  WooliesX
//
//  Created by Siavash on 24/9/20.
//  Copyright © 2020 Siavash. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class MainViewModel {
    
    // outputs Driver
    var reloadTableView: Driver<ModelResult<Bool>> { return relaodRelay.asDriver() }
    var isAscending: Driver<Bool?> { return isAscendingRelay.asDriver() }
    
    // Internal relays
    private let relaodRelay = BehaviorRelay<ModelResult<Bool>>(value: .result(false))
    private let isAscendingRelay = BehaviorRelay<Bool?>(value: nil)
    
    private let disposeBag = DisposeBag()
    private var response: [ApiResponse] = []
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        isAscendingRelay.accept(nil)
        
        MainApiService.shared.getData().subscribe(onNext: { [weak self] (responses) in
            guard let weakself = self else { return }
            // making sure data we show have lifeSpans because we want to sort based on lifeSpan
            let filtered = responses.filter({
                $0.breeds?.first?.lifeSpan != nil
            })
            weakself.response = filtered
            weakself.relaodRelay.accept(.result(true))
        }, onError: { [weak self] (error) in
            guard let weakself = self else { return }
            weakself.response = []
            weakself.relaodRelay.accept(.error(error))
        }).disposed(by: disposeBag)
    }
    
    func compare(first: String, second: String, isAscending: Bool) -> Bool {
        if isAscending {
            return first.maxLifeSpan < second.maxLifeSpan
        } else {
            return first.maxLifeSpan > second.maxLifeSpan
        }
    }
    
    // This sorts based on the max life span
    @objc
    func sort() {
        // toggel
        let isAscending = isAscendingRelay.value ?? false
        isAscendingRelay.accept(!isAscending)
        
        response.sort { (a, b) -> Bool in
            guard let aLifeSpan = a.breeds?.first?.lifeSpan,
                let bLifeSpan = b.breeds?.first?.lifeSpan else { return false }
            
            return compare(first: aLifeSpan, second: bLifeSpan, isAscending: !isAscending)
        }
        relaodRelay.accept(.result(true))
    }
    
    func numberOfItems() -> Int {
        return response.count
    }
    
    func item(at: IndexPath) -> ApiResponse? {
        guard at.row < response.count else { return nil}
        return response[at.row]
    }
}

// make this fileprivate so just the ViewModel have access to it
fileprivate class MainApiService: AbstractAPIService {
    static let shared = MainApiService()
    
    func getData() -> Observable<[ApiResponse]> {
        return self.get(url: "https://api.thedogapi.com/v1/images/search?limit=50", encoding: JSONEncoding.default)
    }
}

// Model
struct ApiResponse: Codable {
    
    let imageURL: String?
    let breeds: [Breed]?

    struct Breed: Codable {
        let name: String?
        let lifeSpan: String?
        let origin: String?

        private enum CodingKeys: String, CodingKey {
            case lifeSpan =  "life_span"
            case name
            case origin
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case imageURL =  "url"
        case breeds
    }
}

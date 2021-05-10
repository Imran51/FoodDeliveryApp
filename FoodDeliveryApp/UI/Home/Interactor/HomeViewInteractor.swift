//
//  HomeViewInteractor.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 9/5/21.
//

import Foundation
import RxSwift

class HomeViewInteractor: Interactor {
    var presenter: Presenter?
    
    private let service: NetworkManager
    let disposeBag = DisposeBag()
    
    init(service: NetworkManager = NetworkManager()) {
        self.service = service
    }
    
    func getDiscountImageResouce() {
        service.fetchDiscountImageResourceName().subscribe(onSuccess: {[weak self] response in
            print("response ---> \(response)")
            self?.presenter?.interactorDidFecthDiscountImageResouce(with: response)
            
        }, onError: {[weak self] error in
            self?.presenter?.interactorDidFailFetch(with: error.localizedDescription)
            
        }).disposed(by: disposeBag)
       
//
//        Observable<DiscountImageResourceResponse>.zip(service.fetchDiscountImageResourceName()).subscribe(onNext: ({ (response) in
//            let (upcomingResponse) = response
//            self.upcomingMovieResponse(response: upcomingResponse)
//            self.playingNowResponse(response: playingNowResponse)
//            self.popularMovieResponse(response: popularResponse)
//            self.genreMovieResponse(response: genreResponse)
//            self.presenter?.isLoading(isLoading: false)
//        }), onError: ({(error) in
//            guard let errorValue = error as? APIError else { return }
//            self.presenter?.fetchFailed(error: errorValue.message)
//            self.presenter?.isLoading(isLoading: false)
//        })).disposed(by: disposeBag)
    }
    
    
}

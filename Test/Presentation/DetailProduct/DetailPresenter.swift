//
//  DetailPresenter.swift
//  Test
//
//  Created by Igor Skripnik on 8/31/19.
//  Copyright © 2019 IS. All rights reserved.
//

import Foundation

protocol DetailPresenterProtocol: class {
//    func post(_ review: String, with rate: String)
    func addReviewTapped()
    func getReviewList(by id: String)
    func configure(_ cell: ReviewCell, by index: Int)
    func send(_ review: String, rate: Int)
    var reviews: ReviewList? { get }
    var product: Product? { get }
}

class DetailPresenter: DetailPresenterProtocol {
    
    weak private var view: DetailViewProtocol?
    let networkClient: ProductClient
    var product: Product?
    var reviews: ReviewList? {
        didSet {
            view?.updateView()
        }
    }
    init(_ interface: DetailViewProtocol, reviewList: ReviewList, prod: Product) {
        view = interface
        product = prod
        networkClient = ProductClient()
        reviews = reviewList
    }
    
    private func post(_ review: String, with rate: String) {
        
    }
    
    private func show() {
        DispatchQueue.main.async {
            let controller: ControllerType = .reviewViewController
            if let view = controller.instantiateViewController() as? ReviewViewController {
                view.presenter = self
                self.view?.show(view)
            }
        }
    }
    
    func send(_ review: String, rate: Int) {
        guard let prodId = product?.id else { return }
        let endpoint = ProductEndpoint.review(rate: rate, review: review, prodId: String(prodId))
        networkClient.enterData(endpoint: endpoint) {[weak self] _ in
            self?.getReviewList(by: String(prodId))
        }
    }
    
    func getReviewList(by id: String) {
        let endpoint = ProductEndpoint.reviews(productId: String(id))
        networkClient.reviews(endpoint: endpoint) {[weak self] either in
            guard let self = self else { return }
            switch either {
            case .success(let reviews):
                self.reviews = reviews
            case .error(let error):
                print(error)
            }
        }
    }
    
    func addReviewTapped() {
        show()
    }
    
    func configure(_ cell: ReviewCell, by index: Int) {
        guard let review = reviews?[index] else { return }
        cell.reitingView.rating = Double(review.rate ?? 0)
        cell.nameLbl.text = review.created_by?.username
        cell.reviewLbl.text = review.text
    }
}

//
//  ProductPresenter.swift
//  Test
//
//  Created by Igor Skripnik on 8/31/19.
//  Copyright © 2019 IS. All rights reserved.
//

import Foundation

protocol ProductPresenterProtocol: class {
    func productTapped(by index: Int)
    func configure(_ cell: ProductCell, by index: Int)
    var products: ProductList? { get }
}

class ProductPresenter: ProductPresenterProtocol {
    weak private var view: ProductsViewProtocol?
    let networkClient: ProductClient
    var products: ProductList?
    init(_ interface: ProductsViewProtocol, prodList: ProductList) {
        view = interface
        networkClient = ProductClient()
        products = prodList
    }
    
    func productTapped(by index: Int) {
        
        guard let products = self.products else { return }
        let product = products[index]
        getReviews(for: product)
    }
    
    func configure(_ cell: ProductCell, by index: Int) {
        if let product = products?[index] {
            let pathToImg = StorageUrl + product.img
            cell.mainImage.loadImage(urlString: pathToImg)
            cell.titleLbl.text = product.title
        }
    }
    
    private func show(review list: ReviewList, with product: Product) {
        DispatchQueue.main.async {
            let controller: ControllerType = .detailViewController
            if let view = controller.instantiateViewController() as? DetailViewController {
                let detailPresenter = DetailPresenter(view, reviewList: list, prod: product)
                view.presenter = detailPresenter
                self.view?.show(view)
            }
        }
    }
    
    private func getReviews(for product: Product) {
        let endpoint = ProductEndpoint.reviews(productId: String(product.id))
        networkClient.reviews(endpoint: endpoint) {[weak self] either in
            guard let self = self else { return }
            switch either {
            case .success(let reviews):
                self.show(review: reviews, with: product)
            case .error(let error):
                print(error)
            }
        }
    }
}

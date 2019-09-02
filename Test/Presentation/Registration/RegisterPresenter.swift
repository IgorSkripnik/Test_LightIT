//
//  RegisterPresenter.swift
//  Test
//
//  Created by Igor Skripnik on 8/31/19.
//  Copyright © 2019 IS. All rights reserved.
//

import Foundation

protocol RegisterPresenterProtocol: class {
    func enterDataTappet(with user: User, type: ViewType)
    func continueTapped()// add view
}

class RegisterPresenter: RegisterPresenterProtocol {
    weak private var view: RegisterViewProtocol?
    let networkClient: ProductClient
    
    init(_ inteface: RegisterViewProtocol) {
        networkClient = ProductClient()
        view = inteface
    }
    
    func enterDataTappet(with user: User, type: ViewType) {
        var endpoint: ProductEndpoint
        switch type {
        case .signIn:
            endpoint = ProductEndpoint.login(username: user.username, password: user.password)
        case .signUp:
            endpoint = ProductEndpoint.register(username: user.username, password: user.password)
        }
        networkClient.enterData(endpoint: endpoint) {[weak self] either in
            guard let self = self else { return }
            switch either {
            case .success(let result):
                if let token = result.token {
                    self.getProducts(with: token)
                } else {
                    self.view?.showError("User exist", title: "")
                }
            case .error(let error):
                print(error)
            }
        }
    }
    
    func continueTapped() {
        let endpoint = ProductEndpoint.products
        networkClient.products(endpoint: endpoint, completion: {[weak self] either in
            guard let self = self else { return }
            switch either {
            case .success(let products):
                self.show(product: products)
            case .error(let error):
                print(error)
            }
        })
    }
    
    private func getProducts(with token: String) {
        Settings.token = token
        let endpoint = ProductEndpoint.products
        networkClient.products(endpoint: endpoint, completion: {[weak self] either in
            guard let self = self else { return }
            switch either {
            case .success(let products):
                self.show(product: products)
            case .error(let error):
                print(error)
            }
        })
    }
    
    private func show(product list: ProductList) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            let controller: ControllerType = .productsViewController
            if let view = controller.instantiateViewController() as? ProductsViewController {
                let productPresenter = ProductPresenter(view, prodList: list)
                view.presenter = productPresenter
                self.view?.show(view)
            }
        }
    }
}

//
//  ProductsViewController.swift
//  Test
//
//  Created by Igor Skripnik on 8/31/19.
//  Copyright © 2019 IS. All rights reserved.
//

import UIKit

protocol ProductsViewProtocol: class {
    func show(_ detailViewController: UIViewController) 
}

class ProductsViewController: UIViewController {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var presenter: ProductPresenterProtocol?
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let identifire = String(describing: ProductCell.self)
        let productCell = UINib(nibName: identifire, bundle: Bundle.main)
        collectionView.register(productCell, forCellWithReuseIdentifier: identifire)
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Products"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.hidesBackButton = true
    }
    
    private func startSpinner() {
        view.alpha = 0.8
        view.isUserInteractionEnabled = false
        spinner.startAnimating()
    }
    
    private func stopSpinner() {
        view.alpha = 1
        view.isUserInteractionEnabled = true
        spinner.stopAnimating()
    }
}

//MARK: - - - - - - - UICollectionViewDelegate

extension ProductsViewController: ProductsViewProtocol {
    func show(_ detailViewController: UIViewController) {
        stopSpinner()
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

//MARK: - - - - - - - UICollectionViewDelegate

extension ProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        startSpinner()
        presenter?.productTapped(by: indexPath.item)
    }
}

//MARK: - - - - - - - UICollectionViewDataSource

extension ProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductCell.self), for: indexPath) as? ProductCell else {
            debugPrint("ProductCell creation failed -> return empty cell")
            return ProductCell()
        }
        presenter?.configure(cell, by: indexPath.item)
        return cell
    }
}

//MARK: - - - - - - - UICollectionViewDelegate

extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = self.view.frame.height / 5
        let width: CGFloat = self.view.frame.width - 20
        let size = CGSize(width: width, height: height)
        return size
    }
}

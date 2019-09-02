//
//  DetailViewController.swift
//  Test
//
//  Created by Igor Skripnik on 8/31/19.
//  Copyright © 2019 IS. All rights reserved.
//

import UIKit

protocol DetailViewProtocol: class {
    func show(_ reviewViewController: UIViewController)
    func updateView()
}

class DetailViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainImage: BWPImageView!
    var presenter: DetailPresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        let identifire = String(describing: ReviewCell.self)
        let productCell = UINib(nibName: identifire, bundle: Bundle.main)
        collectionView.register(productCell, forCellWithReuseIdentifier: identifire)
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Product"
        descriptionLbl.text = presenter?.product?.text
        titleLbl.text = presenter?.product?.text
        guard let curentImgPath = presenter?.product?.img else { return }
        let pathToImg = StorageUrl + curentImgPath
        mainImage.loadImage(urlString: pathToImg)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.hidesBackButton = false
    }
    
    @IBAction func addReviewAvtion(_ sender: Any) {
        if let _ = Settings.token {
            presenter?.addReviewTapped()
        } else {
            alertDissmiss(message: "Need to register")
        }
    }
}

//MARK: - - - - - - - DetailViewProtocol

extension DetailViewController: DetailViewProtocol {
    func show(_ reviewViewController: UIViewController) {
        present(reviewViewController, animated: true, completion: nil)
    }
    
    func updateView() {
        DispatchQueue.main.async {[weak self] in
            self?.collectionView.reloadData()
        }
    }
}

//MARK: - - - - - - - UICollectionViewDataSource

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.reviews?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ReviewCell.self), for: indexPath) as? ReviewCell else {
            debugPrint("ReviewCell creation failed -> return empty cell")
            return ReviewCell()
        }
        presenter?.configure(cell, by: indexPath.item)
        return cell
    }
}

//MARK: - - - - - - - UICollectionViewDelegate

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = self.view.frame.height / 8
        let width: CGFloat = self.view.frame.width - 20
        let size = CGSize(width: width, height: height)
        return size
    }
}

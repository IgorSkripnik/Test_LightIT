//
//  ReviewViewController.swift
//  Test
//
//  Created by Igor Skripnik on 8/31/19.
//  Copyright © 2019 IS. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    var presenter: DetailPresenterProtocol?
    
    @IBOutlet weak var conteinerView: UIView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var rateLbl: CustomTextFields!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.reviewTextView.layer.borderWidth = 1.0
        self.reviewTextView.layer.borderColor = UIColor.gray.cgColor
        self.reviewTextView.layer.masksToBounds = true
        self.conteinerView.layer.cornerRadius = 16
        self.conteinerView.layer.masksToBounds = false
    }
    
    @IBAction func tapAction(_ sender: Any) {
        reviewTextView.resignFirstResponder()
        rateLbl.resignFirstResponder()
    }
    
    @IBAction func sendAction(_ sender: Any) {
        let rate = rateLbl.text ?? "0"
        let review = reviewTextView.text ?? "no info"
        guard let intRate = Int(rate) else { return }
        presenter?.send(review, rate: intRate)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - - - - - - - -  UITextFieldDelegate

extension ReviewViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if updatedText.count > 20 {
                alert(message: "To many characters", title: "😰 😰 😰")
                return false
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - - - - - - - -  UITextViewDelegate

extension ReviewViewController: UITextViewDelegate {
    
}

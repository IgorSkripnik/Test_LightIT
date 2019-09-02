//
//  ViewController.swift
//  Test
//
//  Created by Igor Skripnik on 8/31/19.
//  Copyright © 2019 IS. All rights reserved.
//

import UIKit

protocol RegisterViewProtocol: class {
    func showError(_ message: String, title: String)
    func show(_ products: UIViewController)
}

class ViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var presenter: RegisterPresenterProtocol!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var passwordTxt: CustomTextFields!
    @IBOutlet weak var usernameTxt: CustomTextFields!
    @IBOutlet weak var barButton: UIBarButtonItem!
    var viewType: ViewType = .signUp
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RegisterPresenter(self)
    }

    @IBAction func enterDataAction(_ sender: Any) {
        startSpinner()
        guard let password = passwordTxt.text, let username = usernameTxt.text else {
            alert(message: "fill in all fields", title: "📝 📝 📝")
            stopSpinner()
            return
        }
        if password.count < 3 || username.count < 3 {
            alert(message: "must be more than 3 characters", title: "👇")
            stopSpinner()
            return
        }
        let user = User(name: username, pass: password)
        presenter.enterDataTappet(with: user, type: viewType)
    }
    
    @IBAction func tapAction(_ sender: Any) {
        passwordTxt.resignFirstResponder()
        usernameTxt.resignFirstResponder()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        startSpinner()
        presenter.continueTapped()
    }
    
    @IBAction func barButtonAction(_ sender: Any) {
        setUpView()
    }
    
    private func setUpView() {
        viewType = (viewType == .signUp) ? .signIn : .signUp
        switch viewType {
        case .signIn:
            navigationItem.title = "Sign In"
            enterButton.setTitle("Sign In", for: .normal)
            barButton.title = "Sign Up"
        case .signUp:
            navigationItem.title = "Sign Up"
            enterButton.setTitle("Sign Up", for: .normal)
            barButton.title = "Sign In"
        }
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

//MARK: - - - - - - - -  RegisterViewProtocol

extension ViewController: RegisterViewProtocol {
    func showError(_ message: String, title: String) {
        stopSpinner()
        alert(message: message, title: title)
    }
    
    func show(_ productsViewController: UIViewController) {
        stopSpinner()
        self.navigationController?.pushViewController(productsViewController, animated: true)
    }
}

//MARK: - - - - - - - -  UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
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

enum ViewType {
    case signUp
    case signIn
}

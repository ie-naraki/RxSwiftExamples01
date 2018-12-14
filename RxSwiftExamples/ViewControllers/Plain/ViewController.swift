//
//  ViewController.swift
//  RxSwiftExamples
//
//  Created by Naraki on 12/10/18.
//  Copyright © 2018 i-enter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var remainTextCountLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    private let maxLength: Int = 10
    private let minimumTextLength: Int = 6
    private let normalTextColor: UIColor = .black
    private let limitedTextColor: UIColor = .red

    override func viewDidLoad() {
        super.viewDidLoad()

        button.setBackgroundImage(UIImage(color: .lightGray), for: .disabled)

        setRemainCount(text: inputTextField.text)
        changeTextColorBy(limit: maxLength, textField: inputTextField)
        changeButtonEnableBy(length: minimumTextLength, textField: inputTextField)

        inputTextField.delegate = self
        inputTextField.addTarget(self,
                                 action: #selector(textFieldEditingChanged(sender:)),
                                 for: .editingChanged)
    }

    /// ボタンがタップされたとき
    @IBAction func buttonTapped(_ sender: UIButton) {
        if let viewController = UIStoryboard(name: "SecondViewController", bundle: nil)
            .instantiateInitialViewController() as? SecondViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    /// テキストフィールドに入力された文字列に変化があったときに実行される
    @objc private func textFieldEditingChanged(sender: UITextField) {
        if let text = sender.text, text.count > maxLength {
            sender.text = text.prefix(maxLength).description
        }
        outputLabel.text = sender.text

        setRemainCount(text: sender.text)
        changeTextColorBy(limit: maxLength, textField: inputTextField)
        changeButtonEnableBy(length: minimumTextLength, textField: inputTextField)
    }

    /// あと何文字入力できるかを表示する
    private func setRemainCount(text: String?) {
        let text = text ?? ""
        let remainCount = maxLength - text.count
        remainTextCountLabel.text = "あと\(remainCount)文字入力できます"
    }

    /// 入力された文字数が制限数を超えた場合に文字色を変更する
    private func changeTextColorBy(limit: Int, textField: UITextField) {
        guard let text = textField.text else { return }

        textField.textColor = (text.count >= limit) ? limitedTextColor : normalTextColor
    }

    /// 入力されている文字数に応じてボタンの押下制御を行う
    private func changeButtonEnableBy(length: Int, textField: UITextField) {
        if let text = textField.text, text.count >= length {
            button.isEnabled = true
        } else {
            button.isEnabled = false
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

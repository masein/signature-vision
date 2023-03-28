//
//  ColorOptions.swift
//  HandPose
//
//  Created by Arsh on 3/27/23.
//  Copyright © 2023 Apple. All rights reserved.
//
import UIKit
protocol ColorOptionsDelegate: NSObject {
    func didTouchUpInsideRedColor()
    func didTouchUpInsideBlueColor()
    func didTouchUpInsideBlackColor()
    func didTouchUpInsideClear()
}

class ColorOptions: UIView {
    let redColor = UIButton()
    let blueColor = UIButton()
    let blackColor = UIButton()
    let clearButton = UIButton()
    weak var delegate: ColorOptionsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func configureView() {
        configureRedButton()
        configureBlueButton()
        configureBlackButton()
        configureClearButton()
        configureStackView()
    }
    private func configureRedButton() {
        redColor.backgroundColor = .red
        redColor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            redColor.widthAnchor.constraint(equalToConstant: 50),
            redColor.heightAnchor.constraint(equalToConstant: 50)
        ])
        redColor.layer.cornerRadius = 24
        redColor.addTarget(self, action: #selector(didTouchUpInsideRedColor), for: .touchUpInside)
    }
    private func configureBlueButton() {
        blueColor.backgroundColor = .blue
        blueColor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blueColor.widthAnchor.constraint(equalToConstant: 50),
            blueColor.heightAnchor.constraint(equalToConstant: 50)
        ])
        blueColor.layer.cornerRadius = 24
        blueColor.addTarget(self, action: #selector(didTouchUpInsideBlueColor), for: .touchUpInside)
    }
    private func configureBlackButton() {
        blackColor.backgroundColor = .black
        blackColor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blackColor.widthAnchor.constraint(equalToConstant: 50),
            blackColor.heightAnchor.constraint(equalToConstant: 50)
        ])
        blackColor.layer.cornerRadius = 24
        blackColor.addTarget(self, action: #selector(didTouchUpInsideBlackColor), for: .touchUpInside)
    }
    private func configureClearButton() {
        clearButton.backgroundColor = .clear
        clearButton.setTitle("Clear", for: .normal)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clearButton.widthAnchor.constraint(equalToConstant: 50),
            clearButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        clearButton.layer.cornerRadius = 26
        clearButton.addTarget(self, action: #selector(didTouchUpInsideClear), for: .touchUpInside)
    }
    private func configureStackView() {
        let stack = UIStackView(arrangedSubviews: [redColor, blueColor, blackColor, clearButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 20
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: 10).isActive = true
    }
    @objc func didTouchUpInsideRedColor() {
        delegate?.didTouchUpInsideRedColor()
    }
    @objc func didTouchUpInsideBlueColor() {
        delegate?.didTouchUpInsideBlueColor()
    }
    @objc func didTouchUpInsideBlackColor() {
        delegate?.didTouchUpInsideBlackColor()
    }
    @objc func didTouchUpInsideClear() {
        delegate?.didTouchUpInsideClear()
    }
}

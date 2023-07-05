//
//  HeroHeadUIView.swift
//  Netflix-Universe
//
//  Created by ROHIT MISHRA on 04/07/23.
//

import UIKit

class HeroHeadUIView: UIView {
    private let downloadButton: UIButton = {
        let button = UIButton()
         button.setTitle("Download", for: .normal)
         button.layer.borderColor = UIColor.white.cgColor
         button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
         button.translatesAutoresizingMaskIntoConstraints = false
         return button
    }()
    private let playButton: UIButton = {
       let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let heroImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "HeroImage")
        return imageView
    }()

    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        playButtonConstraints()
        
        addSubview(downloadButton)
        downloadButtonConstraints()
    }
    
    private func playButtonConstraints() {
        
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            playButton.widthAnchor.constraint(equalToConstant: 100)
            
        ])
    }
    
    private func downloadButtonConstraints() {
        NSLayoutConstraint.activate([
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }

}

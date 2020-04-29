//
//  CardView.swift
//  tinderFood
//
//  Created by macOS on 14/04/2020.
//  Copyright © 2020 alex-buduianu. All rights reserved.
//

import UIKit
import SDWebImage

class CardView: UIView {
    
    var cardViewModel: CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageNames.first ?? ""
            // load our image using an url
            if let url = URL(string: imageName) {
                imageView.sd_setImage(with: url)
            }
            
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageNames.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = UIColor(white: 0, alpha: 0.1)
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
           // setupImageIndexObserver()
        }
    }
    
// click pe img
//    fileprivate func setupImageIndexObserver() {
//        cardViewModel.imageIndexObserver = { [weak self] (idx, image) in
//            print("Changing photo from view model")
//            self?.imageView.image = image
//
//            self?.barsStackView.arrangedSubviews.forEach({ (v) in
//                v.backgroundColor = self?.barDeselectedColor
//            })
//            self?.barsStackView.arrangedSubviews[idx].backgroundColor = .white
//        }
//    }
    
    fileprivate let imageView = UIImageView()
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel()
    fileprivate let barsStackView = UIStackView()
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    // Configurations - swipe handler
    fileprivate let threshold: CGFloat = 80
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        
        if shouldAdvanceNextPhoto {
            cardViewModel.advanceToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    fileprivate func setupLayout() {
        // custom drawing code
        layer.cornerRadius = 12
        clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()
        
        //setupBarsStackView()
        
        // add a gradient layer
        setupGradientLayer()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
    }
    
    //bara pentru derularea pozelor (cand sunt mai multe pe acelasi profil
    
//    fileprivate func setupBarsStackView() {
//
//        addSubview(barsStackView)
//        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
//        barsStackView.spacing = 4
//        barsStackView.distribution = .fillEqually
//
//    }
    
    override func layoutSubviews() {
        // Gradient - bottom part of the card it's more darker
        gradientLayer.frame = self.frame
    }
    
    fileprivate func setupGradientLayer() {
        // how to draw a gradient with Swift
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        // self.frame is actually zero frame
        
        layer.addSublayer(gradientLayer)
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChange(gesture)
        case .ended:
            handledEnded(gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleChange(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        // rotation
        // some math to convert radians to degrees
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handledEnded(_ gesture: UIPanGestureRecognizer) {
        
        // dismiss card if dragged to the left
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        // move the card with curved direction
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                
                self.frame = CGRect(x: 600 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
                
            } else {
                self.transform = .identity
            }
            
        }) { (_) in
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
            
            //            self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
        }
    }
    
// https://stackoverflow.com/questions/38386339/what-exactly-is-init-coder-adecoder
// NSCoding protocol defines two methods to serialize and deserialize objects
    required init?(coder aDecoder: NSCoder) {
        //Object Deserialized
        fatalError("init(coder:) has not been implemented")
    }
    
}

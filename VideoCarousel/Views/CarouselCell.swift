//
//  CarouselCell.swift
//  VideoCarousel
//
//  Created by Koushal, KumarAjitesh on 2019/09/25.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import UIKit

class CarouselCell: UICollectionViewCell {
    
    // MARK: - Private Properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.textColor = .white
        return lbl
    }()
    
    private lazy var titleBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Configuration.TitleBackgroundColor
        return view
    }()

    private let maskShapeLayer: CAShapeLayer = CAShapeLayer()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .gray
        layer.mask = maskShapeLayer
        setupCellSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        maskShapeLayer.path = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 12).cgPath
    }
    
    func configureCell(with video: Video) {
        guard let title = video.tvShow?.titleDefault, let channelId = video.tvShow?.channelId else { return}
        
        let imageBaseUrl = Configuration.ImageBaseURL
        let completeImageUrl = "\(imageBaseUrl)\(channelId)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        
        nameLabel.text = title
        imageView.loadImageUsingCacheWithURLString(completeImageUrl, placeHolder: UIImage(named: "iconVideoPlaceholder")) { (bool) in
            //perform actions if needed
        }
    }
    
    // MARK: - Private Methods
    
    private func setupCellSubviews() {
        setupImageView()
        setupDetails()
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupDetails() {
        addSubview(titleBackgroundView)
        addSubview(nameLabel)
        
        titleBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleBackgroundView.heightAnchor.constraint(equalToConstant: CellConstants().cellWidth/3).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40).isActive = true
    }
}

extension CarouselCell {
    class var reusableIndentifer: String { return String(describing: self) }
}

//
//  DynamicCell.swift
//  DynamicCellCollectionViewExample
//
//  Created by Panda on 2021/05/10.
//

import UIKit
import SnapKit
import Then

class DynamicCell: UICollectionViewCell {
  static let identifier: String = "DynamicCell"
  
  private let croppedImageView: UIImageView = UIImageView()
  
  let screenSize = UIScreen.main.bounds.size
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.masksToBounds = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  private func setupUI() {
    backgroundColor = .white
    contentView.addSubview(croppedImageView)
  }
  
  func configure(image: UIImage) {
    
    setupUI()
    croppedImageView.image = image
    
    let width = image.size.width
    let height = image.size.height
    
    if width > height { // landscape
      croppedImageView.snp.makeConstraints {
        $0.center.equalToSuperview()
        $0.width.equalToSuperview()
        $0.height.equalTo(croppedImageView.snp.width).multipliedBy(0.5625)
      }
    }
    
    if width < height { // portrait
      croppedImageView.snp.makeConstraints {
        $0.center.equalToSuperview()
        $0.height.equalToSuperview()
        $0.width.equalTo(croppedImageView.snp.height).multipliedBy(0.8)
      }
    }
    
    if width == height { // square
      croppedImageView.snp.makeConstraints {
        $0.center.equalToSuperview()
        $0.height.equalToSuperview()
        $0.width.equalToSuperview()
      }
    }
  }
}

//
//  ViewController.swift
//  DynamicCellCollectionViewExample
//
//  Created by Panda on 2021/05/10.
//

import UIKit

final class ViewController: UIViewController {
  
  var item: [UIImage] = [
    UIImage(named: "landscape1")!,
    UIImage(named: "square1")!,
    UIImage(named: "portrait1")!
  ]
  
  let screenSize = UIScreen.main.bounds
  
  var currentIndex: CGFloat = 0
  var isOneStepPaging = true
  
  lazy var flowLayout: UICollectionViewFlowLayout = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumLineSpacing = 16
    flowLayout.minimumInteritemSpacing = 16
    flowLayout.scrollDirection = .horizontal
    flowLayout.itemSize = CGSize(width: screenSize.width - 50, height: screenSize.width - 50)
    
    return flowLayout
  }()
  
  lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupCollectionView()
  }
  
  private func setupCollectionView() {
    collectionView.setCollectionViewLayout(flowLayout, animated: false)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.isPagingEnabled = false
    collectionView.backgroundColor = .clear
    collectionView.layer.masksToBounds = false
    collectionView.register(DynamicCell.self, forCellWithReuseIdentifier: DynamicCell.identifier)
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    collectionView.decelerationRate = .fast
    
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(view.snp.width).offset(-40)
    }
  }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return item.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DynamicCell.identifier, for: indexPath) as! DynamicCell
    cell.configure(image: item[indexPath.item])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let image = item[indexPath.item]
    
    if image.size.width > image.size.height {
      return CGSize(width: view.frame.width - 50, height: (view.frame.width - 50) * 0.5625)
    } else if image.size.width < image.size.height {
      return CGSize(width: (view.frame.width - 50) * 0.8, height: view.frame.width - 50)
    } else {
      return CGSize(width: view.frame.width - 50, height: view.frame.width - 50)
    }
  }
}

extension ViewController: UIScrollViewDelegate {
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    let cellwidthIncludingSpaing = layout.itemSize.width + layout.minimumLineSpacing
    
    var offset = targetContentOffset.pointee
    let index = (offset.x + scrollView.contentInset.left) / cellwidthIncludingSpaing
    var roundedIndex = round(index)
    
    if scrollView.contentOffset.x > offset.x {
      roundedIndex = floor(index)
    }
    if scrollView.contentOffset.x < offset.x {
      roundedIndex = ceil(index)
    }
    if scrollView.contentOffset.x == offset.x {
      roundedIndex = round(index)
    }
    
    if isOneStepPaging {
        if currentIndex > roundedIndex {
            currentIndex -= 1
            roundedIndex = currentIndex
        } else if currentIndex < roundedIndex {
            currentIndex += 1
            roundedIndex = currentIndex
        }
    }
    
    offset = CGPoint(x: roundedIndex * cellwidthIncludingSpaing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
    targetContentOffset.pointee = offset
  }
}

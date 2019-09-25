//
//  ViewController.swift
//  VideoCarousel
//
//  Created by Koushal, KumarAjitesh on 2019/09/25.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = PagingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: CellConstants().sectionSpacing, bottom: 0, right: CellConstants().sectionSpacing)
        layout.itemSize = CGSize(width: CellConstants().cellWidth, height: CellConstants().cellWidth)
        layout.minimumLineSpacing = CellConstants().cellSpacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reusableIndentifer)
        collectionView.alpha = 0.0
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - Private Properties
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let actInd = UIActivityIndicatorView(frame: .zero)
        actInd.translatesAutoresizingMaskIntoConstraints = false
        actInd.style = .gray
        actInd.startAnimating()
        actInd.hidesWhenStopped = true
        return actInd
    }()
    
    //save the indexPath of last selected cell
    private var lastSelectedIndexPath: IndexPath?
    
    // MARK: - Injection
    let viewModel = VideoViewModel(manager: NetworkManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setUpSubviews()
        attemptFetchDatasource()
    }

    // MARK: - Private Methods
    
    private func setUpSubviews() {
        title = Titles.title
        setupCollectionView()
        setupActIndicator()
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: CellConstants().cellWidth).isActive = true
    }
    
    private func setupActIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func attemptFetchDatasource() {
        viewModel.fetchVideos()
    
        viewModel.updateLoadingStatus = {
            let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
        }
        
        viewModel.showAlertClosure = {
            if let error = self.viewModel.error {
                print(error)
            }
        }
        
        viewModel.didFinishFetch = {
            //Update UI
            print(self.viewModel.videosList)
            DispatchQueue.main.async {
                self.collectionView.alpha = 1.0
                self.collectionView.reloadData()
            }
        }
    }
    
    private func activityIndicatorStart() {
        // Code for show activity indicator view
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    private func activityIndicatorStop() {
        // Code for stop activity indicator view
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}

extension ViewController: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.videosList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.reusableIndentifer, for: indexPath) as? CarouselCell else { return UICollectionViewCell()}
        cell.configureCell(with: viewModel.videosList[indexPath.item])
        
        //update last select state from lastSelectedIndexPath
        cell.isSelected = (lastSelectedIndexPath == indexPath)
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //if selected item is equal to current selected item, ignore it
        guard lastSelectedIndexPath != indexPath, let selectedCell = collectionView.cellForItem(at: indexPath) as? CarouselCell else {
            return
        }
        
        if lastSelectedIndexPath != nil {
            collectionView.deselectItem(at: lastSelectedIndexPath!, animated: false)
        }
                
        selectedCell.isSelected = true
        lastSelectedIndexPath = indexPath
    }
}

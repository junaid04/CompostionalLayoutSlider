//
//  ViewController.swift
//  CompositionalLayoutSlider
//
//  Created by Hafiz Muhammad Junaid on 06/10/2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let layout = SliderLayout()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        // This will start auto scrolling
        layout.startAutoScroll(collectionView: self.collectionView, interval: 5, section: 0, totalItems: 5)
    }
    
    // MARK: - Methods
    private func setupCollectionView() {
        let supplimentaryViewNibs = [
            HeaderCollectionViewCell.self,
            FooterCollectionViewCell.self]
        supplimentaryViewNibs.forEach {
            collectionView.register(UINib(nibName: String(describing: $0), bundle: nil),
                                    forSupplementaryViewOfKind: String(describing: $0),
                                    withReuseIdentifier: String(describing: $0))
        }
        
        collectionView.register(
            UINib(nibName: String(describing: ItemCollectionViewCell.self), bundle: nil),
            forCellWithReuseIdentifier: "ItemCollectionViewCell")
        collectionView.dataSource = self
        configureDataSource()
    }
    
    private func configureLayout() {
        var layoutConfig = SliderLayoutConfig()
        layoutConfig.height = 162.0
        layoutConfig.sectionContentInset = NSDirectionalEdgeInsets(top: 16.0, leading: 16.0, bottom: 0, trailing: 16.0)
        layoutConfig.itemContentInset = NSDirectionalEdgeInsets(top: 0, leading: 16.0, bottom: 0, trailing: 16.0)
        layoutConfig.headerName = "HeaderCollectionViewCell"
        layoutConfig.footerName = "FooterCollectionViewCell"
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: layout.createLayout(config: layoutConfig))
    }
    
    private func configureDataSource() {
        configureLayout()
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        switch indexPath.item {
        case 0:
            cell.imageView.backgroundColor = .red
        case 1:
            cell.imageView.backgroundColor = .green
        case 2:
            cell.imageView.backgroundColor = .blue
        case 3:
            cell.imageView.backgroundColor = .yellow
        case 4:
            cell.imageView.backgroundColor = .magenta
        default:
            cell.imageView.backgroundColor = .black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplimentaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind, for: indexPath)
        if let headerCell = supplimentaryView as? HeaderCollectionViewCell {
            headerCell.lblTitle.text = "Slider"
        }
        if let footerCell = supplimentaryView as? FooterCollectionViewCell {
            footerCell.pageControl.numberOfPages = 5
        }
        return supplimentaryView
    }
}

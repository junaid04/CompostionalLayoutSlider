//
//  SliderLayout.swift
//  CompositionalLayoutSlider
//
//  Created by Hafiz Muhammad Junaid on 06/10/2024.
//

import UIKit

final class SliderLayout {
    private var collectionView: UICollectionView?
    private var interval: Int?
    private var totalItems: Int = 0
    private var section: Int = 0
    private var timer: Timer?
    private var currentIndexPath: IndexPath? = nil
    
    func createLayout(config: SliderLayoutConfig) -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = config.itemContentInset
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(config.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        // Section
        section.visibleItemsInvalidationHandler = { [weak self] visibileItems, scrolllOffset, environment in
            guard let self = self else { return }
            
            if let currentSection = visibileItems.first?.indexPath.section {
                let page = Int(scrolllOffset.x / environment.container.contentSize.width)
                let pageIndexPath = IndexPath(item: 0, section: currentSection)
                
                guard let footerCell = self.collectionView?.supplementaryView(forElementKind: config.footerName, at: pageIndexPath) as? FooterCollectionViewCell else { return }
                
                footerCell.setPage(with: page)
                self.currentIndexPath = IndexPath(item: page, section: currentSection)
                self.startTimer(section: currentSection)
            }
        }
        
        // Header
        if !config.headerName.isEmpty {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(56))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: config.headerName, alignment: .top)
            section.boundarySupplementaryItems.append(header)
        }
        
        // Footer
        if !config.footerName.isEmpty {
            let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30))
            let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: config.footerName, alignment: .bottom)
            section.boundarySupplementaryItems.append(footer)
        }
        
        if config.hasBackground {
            let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: "BackgroundClassName")
            section.decorationItems = [backgroundItem]
        }
        
        return section
    }
    
    deinit {
        stopTimer()
    }
}

// MARK: - Methods
extension SliderLayout {
    func startAutoScroll(collectionView: UICollectionView, interval: Int?, section: Int, totalItems: Int) {
        self.collectionView = collectionView
        self.interval = interval
        self.section = section
        self.totalItems = totalItems
        self.startTimer(section: section)
    }
    
    private func startTimer(section: Int) {
        if self.totalItems > 1 {
            var currentIndexPath = self.currentIndexPath ?? IndexPath(item: 0, section: section)
            if let interval = interval {
                stopTimer()
                timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: false) { [weak self] timer in
                    guard let self = self else { return }
                    if currentIndexPath.item < self.totalItems - 1 {
                        currentIndexPath = IndexPath(item: currentIndexPath.item + 1, section: section)
                    } else {
                        currentIndexPath = IndexPath(item: 0, section: section)
                    }
                    UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut) {
                        self.collectionView?.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
                    }
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

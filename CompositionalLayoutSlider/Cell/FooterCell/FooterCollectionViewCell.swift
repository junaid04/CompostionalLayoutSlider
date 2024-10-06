//
//  FooterCollectionViewCell.swift
//  CompositionalLayoutSlider
//
//  Created by Hafiz Muhammad Junaid on 06/10/2024.
//

import UIKit

class FooterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .red
    }
    
    func setPage(with page: Int) {
        pageControl.currentPage = page
    }
}

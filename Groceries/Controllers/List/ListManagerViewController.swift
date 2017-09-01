//
//  ListManagerViewController.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-08.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class ListManagerViewController: BaseViewController {

    // MARK: - Properties
    
    var userIsSearching: Bool = false {
        didSet {
            collectionView.isScrollEnabled = !userIsSearching
            collectionView.collectionViewLayout.invalidateLayout()
            UIView.animate(withDuration: 0.3) {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    var elements: [Element] = TempDataService.elements
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UI Elements
    
    fileprivate lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel.generateTitleLabel()
        label.text = "Appartement"
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapTitleLabel))
        label.addGestureRecognizer(tapGestureRecognizer)
        
        return label
    }()
    
    fileprivate lazy var leftPageButton: GRButton = {
        let button = GRButton()
        button.setTitle(L10n.overview, for: .normal)
        button.setTitleColor(.flatBelizeHole, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.selectLeftPage), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var rightPageButton: GRButton = {
        let button = GRButton()
        button.setTitle(L10n.needToBuy, for: .normal)
        button.setTitleColor(.flatBlack, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.selectRightPage), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var pageSelectionIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatBelizeHole
        return view
    }()
    
    fileprivate lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(LeftListCollectionViewCell.self, forCellWithReuseIdentifier: LeftListCollectionViewCell.reuseIdentifier)
        collectionView.register(RightListCollectionViewCell.self, forCellWithReuseIdentifier: RightListCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var leftListCollectionViewCell: LeftListCollectionViewCell? = nil
    var rightListCollectionViewCell: RightListCollectionViewCell? = nil
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .flatCloud
        statusBackgroundView.backgroundColor = .flatMidnightBlue
        
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(leftPageButton)
        headerView.addSubview(rightPageButton)
        headerView.addSubview(pageSelectionIndicatorView)
        
        view.addSubview(collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        titleLabel.frame.origin.y = 30
        titleLabel.center.x = view.bounds.width/2
        
        leftPageButton.frame.size.width = view.bounds.width/2
        leftPageButton.frame.size.height = 40
        leftPageButton.frame.origin.x = 0
        leftPageButton.frame.origin.y = titleLabel.frame.maxY + 15
        
        rightPageButton.frame.size = leftPageButton.frame.size
        rightPageButton.frame.origin.x = leftPageButton.frame.maxX
        rightPageButton.frame.origin.y = leftPageButton.frame.origin.y
        
        pageSelectionIndicatorView.frame.size.width = leftPageButton.titleLabel!.frame.size.width
        pageSelectionIndicatorView.frame.size.height = 3
        pageSelectionIndicatorView.frame.origin.y = leftPageButton.frame.maxY
        pageSelectionIndicatorView.center.x = leftPageButton.center.x
        pageSelectionIndicatorView.layer.cornerRadius = pageSelectionIndicatorView.frame.height/2
        
        headerView.frame.size.width = view.bounds.width
        headerView.frame.size.height = userIsSearching ? 20 : pageSelectionIndicatorView.frame.maxY
        
        collectionView.frame.size.width = view.bounds.width
        collectionView.frame.size.height = view.bounds.height - headerView.frame.maxY
        collectionView.frame.origin.y = headerView.frame.maxY
    }
    
    // MARK: - Selector Methods
    
    func didTapTitleLabel() {
        let settingsViewController = SettingsViewController()
        present(settingsViewController, animated: true, completion: nil)
    }
    
    func selectLeftPage() {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
    }
    
    func selectRightPage() {
        collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .left, animated: true)
    }
    
    // MARK: - Private Methods
    
    fileprivate func updatePagingLayout() {
        
        // Calculate progress
        
        var progress = collectionView.contentOffset.x / collectionView.frame.width
        
        if progress < 0 { progress = 0 }
        if progress > 1 { progress = 1 }
        
        // Update selection line position
        
        let leftPosition = leftPageButton.center.x
        let rightPosition = rightPageButton.center.x
        let distance = rightPosition - leftPosition
        
        pageSelectionIndicatorView.center.x = leftPosition + distance * progress
      
        // Update selection line width
        
        let leftWidth = leftPageButton.titleLabel!.frame.width
        let rightWidth = rightPageButton.titleLabel!.frame.width
        let widthDifference = rightWidth - leftWidth
        
        pageSelectionIndicatorView.frame.size.width = leftWidth + widthDifference * progress
        
        // Update left color
    
        let leftColor = UIColor(fromColor: .flatBelizeHole, toColor: .flatBlack, progress: progress)
        leftPageButton.setTitleColor(leftColor, for: .normal)
        
        // Update right color
        
        let rightColor = UIColor(fromColor: .flatBlack, toColor: .flatBelizeHole, progress: progress)
        rightPageButton.setTitleColor(rightColor, for: .normal)
    }

}

// MARK: - LeftListCollectionViewCellDelegate & LeftListCollectionViewCellDataSource

extension ListManagerViewController: LeftListCollectionViewCellDelegate, LeftListCollectionViewCellDataSource {
    
    func userDidStartSearching() {
        userIsSearching = true
    }
    
    func userDidStopSearching() {
        userIsSearching = false
    }
    
    func shouldRefreshNeedToBuyList() {
        rightListCollectionViewCell?.refresh()
    }
    
    func unactiveElements() -> [Element] {
        return elements.filter({ element in return !element.active})
    }
    
}

// MARK: - RightListCollectionViewCellDelegate & RightListCollectionViewCellDataSource

extension ListManagerViewController: RightListCollectionViewCellDelegate, RightListCollectionViewCellDataSource {
    
    func shouldRefreshOverviewList() {
//        leftListCollectionViewCell?.refresh()
    }
    
    func onShelfElements() -> [Element] {
        return elements.filter({ element in return element.active && !element.inCart})
    }
    
    func inCartElements() -> [Element] {
        return elements.filter({ element in return element.active && element.inCart})
    }
    
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension ListManagerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updatePagingLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LeftListCollectionViewCell.reuseIdentifier, for: indexPath) as! LeftListCollectionViewCell
            cell.delegate = self
            cell.dataSource = self
            leftListCollectionViewCell = cell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RightListCollectionViewCell.reuseIdentifier, for: indexPath) as! RightListCollectionViewCell
            cell.delegate = self
            cell.dataSource = self
            rightListCollectionViewCell = cell
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
}

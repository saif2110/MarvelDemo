//
//  ComicViewController.swift
//  MarvelDemo
//
//  Created by Admin on 07/10/23.
//

import UIKit

class ComicViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var selectedDate = ""
    
    
    let viewModel = ComicViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        viewModel.delegate = self
        
        selectedDate = viewModel.calculateCurrentWeekDates()
        viewModel.apiRequeset(dateString: selectedDate)
        
    }
    
    
    private func registerNibs(){
        
        self.collectionView.register(PrimeryCollectionViewCell.identifier, forCellWithReuseIdentifier: PrimeryCollectionViewCell.name)
        
    }
    
    
    @IBAction func filterButton(_ sender: UIButton) {
        applyFilters(sender: sender)
    }
    
    
    private func applyFilters(sender:UIButton) {
        switch sender.currentTitle {
        case FilterType.thisWeek.rawValue:
            sender.setTitle(FilterType.nextWeek.rawValue, for: .normal)
            selectedDate = viewModel.calculateNextWeekDates()
            break
            
        case FilterType.nextWeek.rawValue:
            sender.setTitle(FilterType.lastWeek.rawValue, for: .normal)
            selectedDate = viewModel.calculateLastWeekDates()
            break
            
        case FilterType.lastWeek.rawValue:
            sender.setTitle(FilterType.thisMonth.rawValue, for: .normal)
            selectedDate = viewModel.calculateCurrentMonthDates()
            break
            
        case FilterType.thisMonth.rawValue:
            sender.setTitle(FilterType.thisWeek.rawValue, for: .normal)
            viewModel.apiRequeset(dateString: selectedDate)
            
            break
        case .none:
            break
        case .some(_):
            break
        }
        
        //Reset as we want pegination even to filters
        viewModel.resetModel()
        viewModel.apiRequeset(dateString: selectedDate)
    }
    
    
    enum FilterType : String {
        case thisWeek = "This Week"
        case lastWeek = "Last Week"
        case nextWeek = "Next Week"
        case thisMonth = "This Month"
    }
    
    
    
}

//CollectionView
extension ComicViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrimeryCollectionViewCell.name, for: indexPath) as! PrimeryCollectionViewCell
        
        
        if viewModel.data?.data?.results!.count ?? 0 >= indexPath.item {
            
            cell.config(data: (viewModel.data?.data?.results?[indexPath.item])!)
            
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.dataCount - 15 {
            viewModel.apiRequeset(dateString: selectedDate)
        }
    }
    
    
    
    
}



//API
extension ComicViewController:ComicAPIModelHandler {
    
    func onSuccess(_ data: ComicModel.Comics) {            DispatchQueue.main.async {
        self.collectionView.reloadData()
    }
    }
    
    func onFailure(_ error: String) {
        //Handle any error message
    }
    
    
}

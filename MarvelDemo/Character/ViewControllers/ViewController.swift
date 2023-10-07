//
//  ViewController.swift
//  MarvelDemo
//
//  Created by Admin on 07/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    
    let viewModel = CharacterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        viewModel.delegate = self
        viewModel.apiRequeset()
    }
    
    private func registerNibs(){
        
        self.collectionView.register(PrimeryCollectionViewCell.identifier, forCellWithReuseIdentifier: PrimeryCollectionViewCell.name)

    }
}


//CollectionView
extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
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
            guard !viewModel.isSeachbarinProgress else { return }
            viewModel.apiRequeset()
        }
    }
    
    
    
    
}



//API
extension ViewController:CharacterAPIModelHandler {
    
    func onSuccess(_ data: Characters) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func onFailure(_ error: String) {
        //Handle any error message
    }
    
    
}


extension ViewController:UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard searchBar.text ?? "" != "" else {
            viewModel.resetModel()
            viewModel.apiRequeset()
            return
        }
        
        
        viewModel.resetModel()
        viewModel.apiRequeset(nameStartsWith: searchBar.text ?? "")
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        viewModel.isSeachbarinProgress = true
        return true
    }
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        viewModel.isSeachbarinProgress = false
        return true
    }
    
}




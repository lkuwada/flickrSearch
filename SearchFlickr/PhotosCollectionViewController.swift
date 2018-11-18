//
//  PhotosCollectionViewController.swift
//  SearchFlickr
//
//  Created by Lynden Kuwada on 11/18/18.
//  Copyright © 2018 Lynden Kuwada. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoCell"

class PhotosCollectionViewController: UICollectionViewController {

    var searchResults = [FlickrPhoto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
    
        // Configure the cell
        cell.backgroundColor = UIColor.black
        return cell
    }

}

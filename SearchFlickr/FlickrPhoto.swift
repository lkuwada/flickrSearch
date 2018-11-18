//
//  FlickrPhoto.swift
//  SearchFlickr
//
//  Created by Lynden Kuwada on 11/18/18.
//  Copyright © 2018 Lynden Kuwada. All rights reserved.
//

import UIKit

class FlickrPhoto: Equatable {
    let farmID: Int
    let serverID: String
    let photoID: String
    let secret: String
    
    var thumbnail: UIImage?
    var fullsize: UIImage?
    
    init(farm: Int, server: String, id: String, secret: String) {
        self.farmID = farm
        self.serverID = server
        self.photoID = id
        self.secret = secret
    }
    
    func photoURL(_ size: String = "m") -> URL? { // default to small size
        guard let url = URL(string: "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret)_\(size).jpg") else {
            print("Error: couldn't get photo url")
            return nil
        }
        return url
    }
    
    func loadThumbnail() {
        guard let photoURL = self.photoURL() else {
            return
        }
        guard let photoData = try? Data(contentsOf: photoURL as URL) else {
            print("Error: couldn't get image from url")
            return
        }
        
        if let newPhotoThumbnail = UIImage(data: photoData) {
            self.thumbnail = newPhotoThumbnail
        }
    }
    
    static func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
        return lhs.photoID == rhs.photoID
    }
}

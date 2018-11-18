//
//  FlickrSearch.swift
//  SearchFlickr
//
//  Created by Lynden Kuwada on 11/18/18.
//  Copyright © 2018 Lynden Kuwada. All rights reserved.
//

import UIKit

class FlickrSearch {
    
    let apiKey = "ed5d252f4fccb5ae7a640c69a1616091" // might be invalid bc using a temp one...
    fileprivate var page = 1
    
    func searchForTerm(term: String, page: Int, completion: @escaping (_ foundPhotos: [FlickrPhoto]?) -> Void) {
        guard let url = flickrSearchURL(query: term) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            if let _ = error {
                print("Error: request failed")
                completion(nil)
                return
            }
            
            guard let requestData = data else {
                print("Error: no data")
                completion(nil)
                return
            }
            
            guard let _ = response else {
                print("Error: no response")
                completion(nil)
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: requestData, options: .allowFragments) as? [String : AnyObject] else {
                    print("Error: unable to parse JSON")
                    completion(nil)
                    return
                }
                
                guard let photosDict = json["photos"] as? [String : AnyObject], let photos = photosDict["photo"] as? [[String : AnyObject]] else {
                    print("Error: unable to get photos")
                    completion(nil)
                    return
                }
                
                var foundPhotos = [FlickrPhoto]()
                for photo in photos {
                    if let farm = photo["farm"] as? Int,
                        let server = photo["server"] as? String,
                        let id = photo["id"] as? String,
                        let secret = photo["secret"] as? String {
                        
                        let newPhoto = FlickrPhoto(farm: farm, server: server, id: id, secret: secret)
                        
                        guard let newPhotoURL = newPhoto.photoURL() else {
                            break
                        }
                        guard let newPhotoData = try? Data(contentsOf: newPhotoURL as URL) else {
                            print("Error: couldn't get image from url")
                            break
                        }
                        if let newPhotoThumbnail = UIImage(data: newPhotoData) {
                            newPhoto.thumbnail = newPhotoThumbnail
                            foundPhotos.append(newPhoto)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(foundPhotos)
                    }
                }
                
            } catch {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
        })
        task.resume()
    }
    
    private func flickrSearchURL(query: String) -> URL? {
        guard let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(query)&extras=url_s&page=\(page)&format=json&nojsoncallback=1") else {
            print("Unable to get flickr search url")
            return nil
        }
        return url
    }
}

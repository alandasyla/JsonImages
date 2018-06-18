//
//  ViewController.swift
//  JsonImages
//
//  Created by Alanda Syla on 11/5/17.
//  Copyright © 2017 Alanda Syla. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var images =  [ImageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewInit()
        fetchImages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionViewInit() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let nib = UINib(nibName: "PictureCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "PictureCollectionViewCell")
        
        
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let image = images[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCollectionViewCell", for: indexPath) as! PictureCollectionViewCell
        
        cell.image = image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width - 16) / 4
        
        let height = width * 1.2
        
        return CGSize(width: width, height: height)
    }
}

extension ViewController {
    
    func fetchImages() {
        
        //start activity Indicator
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        Alamofire.request(Constants.baseUrl, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                
                //stop activity Indicator
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                //to get status code
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        if let result = response.result.value {
                            let json = JSON(result)
                            
                            if let imagesJson = json["images"].array {
                                
                                for imageJson in imagesJson {
                                    
                                    if let imageModel = ImageModel.create(from: imageJson) {
                                        self.images.append(imageModel)
                                    }
                                }
                            }
                            //loadImages asynchronously
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                        
                    default:
                        self.showErrorAlert()
                        print("error with response status: \(status)")
                    }
                }
                else {
                    self.showErrorAlert()
                }
        }
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Could not load images", message: "Please try again!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Reload", style: .default, handler: { (_) in
            self.fetchImages()
        }))
         
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

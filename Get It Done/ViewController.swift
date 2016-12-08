//
//  ViewController.swift
//  Get It Done
//
//  Created by Ty Victorson on 11/15/16.
//  Copyright © 2016 Xision. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var canEdit = false
    
    var people = [Cell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        // pulls data from disk
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            people = NSKeyedUnarchiver.unarchiveObject(with: savedPeople) as! [Cell]
            // converts data back to an object
        }
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 2
        flowLayout.itemSize = CGSize(width: screenWidth/2.01, height: screenWidth/2.01)
    }
    
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        switch(sender.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: sender.location(in: self.collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            collectionView.updateInteractiveMovementTargetPosition(sender.location(in: sender.view!))
        case UIGestureRecognizerState.ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MainCellController
        
        let person = people[indexPath.item]
        
        cell.myCellLabel.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.myCellImage.image = UIImage(contentsOfFile: path.path)
        
        let rndmNum = Int(arc4random_uniform(4))
        
        if (rndmNum == 0) {
            cell.backgroundColor = UIColor.cyan
        }
        if (rndmNum == 1) {
            cell.backgroundColor = UIColor.yellow
        }
        if (rndmNum == 2) {
            cell.backgroundColor = UIColor.red
        }
        if (rndmNum == 3) {
            cell.backgroundColor = UIColor.green
        }
        
        return cell
    }
    
    func deleteUser(i: Int) {
        people.remove(at: i)
        collectionView.reloadData()
        save()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = UIImageJPEGRepresentation(image, 80) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Cell(name: "0", image: imageName)
        people.append(person)
        collectionView.reloadData()
        self.save()
        dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // move your data order
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        if (canEdit == true) {
            let ac = UIAlertController(title: "Delete Cell?", message: nil, preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            ac.addAction(UIAlertAction(title: "Delete Cell", style: .destructive) { _ in
                self.deleteUser(i: indexPath.item)
            })
            
            present(ac, animated: true)
        } else {
            if let resultController = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
                self.present(resultController, animated: true, completion: nil)
                //self.performSegueWithIdentifier("StartVC", sender: nil)
            }
        }
    }
    
    func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func useCam() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func save() {
        // NSKeyedArchiver convert our array into a data object
        let savedData = NSKeyedArchiver.archivedData(withRootObject: people)
        
        let defaults = UserDefaults.standard
        
        defaults.set(savedData, forKey: "people")
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Add Image From", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.addNewPerson()
        })
        
        present(ac, animated: true)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        print(canEdit)
        if (canEdit == true) {
            canEdit = false
            self.title = ""
            return
        }
        canEdit = true
        self.title = "EDITING"
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}


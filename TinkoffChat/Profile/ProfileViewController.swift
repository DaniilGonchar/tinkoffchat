//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by comandante on 2/25/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController, UINavigationControllerDelegate {
  
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var addPicButton: UIButton!
  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    // задание 4.2 , следующая строка выдает ошибку
    // print("***init: \tframe of editButton: ", editButton.frame)
    // т.к натыкаемся на nil при разворачивании optional value
  }
  
  
  @IBAction func editAction(_ sender: Any) {
    print("editButton pressed")
  }
  
  
  @IBAction func editPicAction(_ sender: Any) {
    
    print("Выбери изображение профиля")
    
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    
    let actionSheetAlertController = UIAlertController(title: "Выбор изображения", message:
      "Выберите существующее изображение из галереи или сделайте новое", preferredStyle: .actionSheet )
    
    actionSheetAlertController.addAction(UIAlertAction(title: "Камера", style: .default, handler: { (action:UIAlertAction) in
      // handling camera option
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
      } else {
        print("Camera is not available")
      }
    }))
    
    actionSheetAlertController.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { (action:UIAlertAction) in
      // handling select from gallery option
      imagePickerController.sourceType = .photoLibrary
      self.present(imagePickerController, animated: true, completion: nil)
    }))
    
    actionSheetAlertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
    
    self.present(actionSheetAlertController, animated: true, completion: nil)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("***ViewDidLoad: \tframe of editButton: ", editButton.frame)
    
    // Do any additional setup after loading the view, typically from a nib.
    
    editButton.layer.borderWidth = 2
    editButton.layer.cornerRadius = 15
    
    userImage.layer.cornerRadius = addPicButton.frame.size.width / 2
    self.userImage.layer.masksToBounds = true
    
    addPicButton.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
    addPicButton.layer.cornerRadius = addPicButton.frame.size.width / 2
    
    self.navigationItem.title = "Profile"
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(closeProfileVC))
  }
  
  @objc func closeProfileVC() {
    self.dismiss(animated: true)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    print("***ViewDidAppear: \tframe of editButton: ", editButton.frame)
    // данные отличаются от viewDidLoad из-за различия размеров экранов (в случае iPhone 8
    // в сториборде и iPhone 8plus на симуляторе получаем увеличенную "width" и бОльшую координату "y" из-за constraints:
    // "Align Bottom to safe area = 30" и отступов по 16 от левого и правого краев экрана )
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}


// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    // setting image in the UIImageView
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    userImage.image = image
    picker.dismiss(animated: true, completion: nil)
  }
  
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    // dismissing UIImagePickerController
    picker.dismiss(animated: true, completion: nil)
  }
}


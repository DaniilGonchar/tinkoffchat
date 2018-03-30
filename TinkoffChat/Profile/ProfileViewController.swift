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
  @IBOutlet var gcdButton: UIButton!
  @IBOutlet var operationButton: UIButton!
  @IBOutlet weak var addPicButton: UIButton!
  
  @IBOutlet weak var userImage: UIImageView!
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet var provideBioLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet var nameTextField: UITextField!
  @IBOutlet var bioTextField: UITextField!
  
  @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
  
  var editingMode: Bool = false {
    didSet {
      self.setEditingState(editing: editingMode)
    }
  }
  
  private var profile : Profile?
  var dataManager: DataManagerProtocol? = GCDDataManager()
  
  private var saveChanges: ( () -> Void )?
  
  private var dataWasChanged: Bool {
    get{
      return self.profile?.nameChanged ?? false || self.profile?.bioChanged ?? false || self.profile?.imageChanged ?? false
    }
  }
  
  
  @IBAction func editPicAction(_ sender: Any) {
    print("Выбери изображение профиля")
    
    if !self.editingMode {
      print("User tried to change image not in editing mode!")
      addPicButton.shakeButton()
      return;
    }
    
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
    
    // Do any additional setup after loading the view, typically from a nib.
    editButton.layer.borderWidth = 2
    editButton.layer.cornerRadius = 15
    gcdButton.layer.borderWidth = 2
    gcdButton.layer.cornerRadius = 15
    operationButton.layer.borderWidth = 2
    operationButton.layer.cornerRadius = 15
    
    bioTextField.delegate = self
    nameTextField.delegate = self
    
    descriptionLabel.lineBreakMode = .byWordWrapping
    descriptionLabel.numberOfLines = 0;
    
    userImage.layer.cornerRadius = addPicButton.frame.size.width / 2
    self.userImage.layer.masksToBounds = true
    
    addPicButton.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
    addPicButton.layer.cornerRadius = addPicButton.frame.size.width / 2
    
    self.navigationItem.title = "Profile"
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(closeProfileVC))
    
    // hw5:
    nameTextField.autocorrectionType = UITextAutocorrectionType.no
    bioTextField.autocorrectionType = UITextAutocorrectionType.no
    
    self.editingMode = false
    self.loadFromFile()
  
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    // adding keyboard observers
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
  }
  
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    // removing keyboard observers
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  
  @objc func keyboardWillShow(_ notification: NSNotification) {
    if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardHeight = keyboardFrame.cgRectValue.height
      self.view.frame.origin.y = -keyboardHeight + 66
      print("keyboard height is:" , keyboardHeight)
    }
  }
  
  
  @objc func keyboardWillHide(sender: NSNotification) {
    self.view.frame.origin.y = 64 
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // hides keyboard when tapped outside keyboard
    self.view.endEditing(true)
  }
  
  
  @objc func closeProfileVC() {
    self.dismiss(animated: true)
  }
  
  
  @IBAction func editButtonPressed(_ sender: Any) {
    print("edit profile button pressed")
    
    self.editingMode = true
    self.setEnabledState(enabled: false)
    
  }
  
  
  private func loadFromFile() {
    self.dataManager?.loadProfile(completion: { (profile) in
      if let unwrappedProfile = profile {
        self.profile = unwrappedProfile
      }
      
      self.userImage.image = profile?.image ?? UIImage.init(named: "placeholder-user")
      self.nameLabel.text = profile?.name ?? "Введите имя"
      self.descriptionLabel.text = profile?.bio ?? "Расскажите о себе"
      
      
      self.profile = Profile(name: self.nameLabel.text, bio: self.descriptionLabel.text, image: self.userImage.image)

    })
    
    
  }
  
  
  @IBAction func saveButtonsPressed(_ sender: UIButton) {
    self.nameTextField.resignFirstResponder()
    self.bioTextField.resignFirstResponder()
    
    self.saveChanges = {
      
      self.activityIndicator.startAnimating()
      self.setEnabledState(enabled: false)
      
      self.profile?.name = self.nameTextField.text
      self.profile?.bio = self.bioTextField.text
      self.profile?.image = self.userImage.image
      
      let titleOfButton = sender.titleLabel?.text
      
      if titleOfButton == "Operation" {
        self.dataManager = OperationDataManager()
      } else {
        self.dataManager = GCDDataManager()
      }
      
      
      self.dataManager?.saveProfile(profile: self.profile!, completion: { (saveSucceeded : Bool) in
        
        self.activityIndicator.stopAnimating()
        
        if saveSucceeded {
          self.showSuccessAlert()
          self.loadFromFile()
        } else {
          self.showErrorAlert()
        }
        
        self.setEnabledState(enabled: true)
        self.editingMode = !saveSucceeded
      })
    }
    
    self.saveChanges?();
  }
  
  
  @IBAction func usernameChangedByEditing(_ sender: UITextField) {
    if let newName = sender.text {
      self.profile?.nameChanged = (newName != (self.profile?.name ?? ""))
      self.setEnabledState(enabled: self.dataWasChanged)
    }
  }
  
  
  @IBAction func bioChangedByEditing(_ sender: UITextField) {
    if let newBio = sender.text {
      self.profile?.bioChanged = (newBio != (self.profile?.bio ?? ""))
      self.setEnabledState(enabled: self.dataWasChanged)
    }
  }
  
  
  private func setEditingState(editing: Bool) {
    if(editing) {
      self.nameLabel.text = "Введите имя"
    }
    
    self.editButton.isHidden = editing
    self.gcdButton.isHidden = !editing
    self.operationButton.isHidden = !editing
    
    self.descriptionLabel.isHidden = editing
    self.nameTextField.isHidden = !editing
    
    self.bioTextField.isHidden = !editing
    self.provideBioLabel.isHidden = !editing
  
  }
  
  
  private func setEnabledState(enabled: Bool) {
    self.gcdButton.isEnabled = enabled
    self.operationButton.isEnabled = enabled
  }
  
  
  private func showSuccessAlert() {
    let alertController = UIAlertController(title: "Changes saved!", message: nil, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }
  
  
  private func showErrorAlert() {
    let alertController = UIAlertController(title: "Error", message: "could not save data", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
    alertController.addAction(UIAlertAction(title: "Retry", style: .default) { action in
      self.saveChanges?();
    })
    self.present(alertController, animated: true, completion: nil)
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
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      self.userImage.image = image
      
      if let savedImage = self.profile?.image {
        let newImage = UIImagePNGRepresentation(image)!
        let oldImage = UIImagePNGRepresentation(savedImage)!
        self.profile?.imageChanged = !newImage.elementsEqual(oldImage)
      } else {
        self.profile?.imageChanged = true
      }
      
      self.setEnabledState(enabled: self.dataWasChanged)
    } else {
      // error occured
      print("Error picking image")
    }
    
    picker.dismiss(animated: true, completion: nil)
  }
  
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    // dismissing UIImagePickerController
    picker.dismiss(animated: true, completion: nil)
  }
}



// MARK: - UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
  // hide the keyboard after pressing return key
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true;
  }
  
  
  // making "twitter length" for textfield
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    let newLength = text.count + string.count - range.length
    return newLength <= 100
  }
  
}










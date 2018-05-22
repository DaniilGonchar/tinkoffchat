//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by comandante on 2/25/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController, UINavigationControllerDelegate {
  
  private var emitter: Emitter!
  
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var saveButton: UIButton!
  
  @IBOutlet weak var addPicButton: UIButton!
  
  @IBOutlet weak var userImage: UIImageView!
  
  @IBOutlet var nameTextField: UITextField! {
    didSet {
      nameTextField.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
  }
  
  @IBOutlet var bioTextView: UITextView! {
    didSet {
      bioTextView.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    }
  }
  
  @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
  
  private var dataWasChanged: Bool {
    get{
      return model.name != nameTextField.text || model.about != bioTextView.text || model.picture != userImage.image
    }
  }
  
  private var userIsInEditingMode: Bool = false
  
  // MARK: - Dependencies
  private var model: IAppUserModel
  private let presentationAssembly: IPresentationAssembly
  
  // MARK: - Initializers
  init(model: IAppUserModel, presentationAssembly: IPresentationAssembly) {
    self.model = model
    self.presentationAssembly = presentationAssembly
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  @IBAction func editPicAction(_ sender: Any) {
    
    if !userIsInEditingMode {
      print("User tried to change image not in editing mode!")
      addPicButton.shakeButton()
      return;
    }
    
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
    
    actionSheetAlertController.addAction(UIAlertAction(title: "Загрузить", style: .default, handler: {(action:UIAlertAction) in
      // handling load images from network api option
      let controller = self.presentationAssembly.picturesViewController()
      
      controller.collectionPickerDelegate = self
      
      let navigationController = UINavigationController()
      navigationController.viewControllers = [controller]
      
      self.emitter = Emitter(view: navigationController.view)
      
      self.present(navigationController, animated: true)
      
    }))
    
    actionSheetAlertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
    
    self.present(actionSheetAlertController, animated: true, completion: nil)
    
  }
  
  
  func setupStyle(){
    activityIndicator.layer.cornerRadius = activityIndicator.frame.size.width / 2
    saveButton.isHidden = true
    
    userImage.layer.cornerRadius = addPicButton.frame.size.width / 2
    self.userImage.layer.masksToBounds = true
    
    addPicButton.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
    addPicButton.layer.cornerRadius = addPicButton.frame.size.width / 2
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(closeProfileVC))
        
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view, typically from a nib.
    
    activityIndicator.startAnimating()
    self.setupStyle()
    self.setupNavbar()
    
    nameTextField.delegate = self
    nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    
    bioTextView.delegate = self
    
    handleSaveButtonStyle(canSave: dataWasChanged)
    
    model.load { [unowned self] profile in
      guard let profile = profile else {
        self.activityIndicator.stopAnimating()
        return
      }
      
      self.model.set(on: profile)
      
      if let name = profile.name {
        self.nameTextField.text = name
      }
      
      if let about = profile.about {
        self.bioTextView.text = about
      }
      
      if let picture = profile.picture {
        self.userImage.image = picture
      }
      
      self.activityIndicator.stopAnimating()
    }
    
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    // adding keyboard observers
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(inputModeDidChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    
  }
  
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)
    
    // removing keyboard observers
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    
  }
  
  
  private func setupNavbar() {
    self.navigationItem.title = "Профиль"
    
    let leftItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(closeProfileVC))
    navigationItem.setLeftBarButton(leftItem, animated: true)
  }
  
  
  // MARK : - Keyboard
  func isEmojiKeyboard() -> Bool {
    return textInputMode?.primaryLanguage == "emoji" || textInputMode?.primaryLanguage == nil
  }


  @objc func inputModeDidChange(sender: NSNotification) {

    if isEmojiKeyboard(){
      print("is emoji")
      view.frame.origin.y += 216.0
    }

  }


  @objc func keyboardWillShow(sender: NSNotification) {
    if view.frame.origin.y < 0.0 {
      view.frame.origin.y += 42.0
      return
    }

    if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      view.frame.origin.y -= keyboardSize.height
    }
  }


  @objc func keyboardWillHide(sender: NSNotification) {
    if isEmojiKeyboard(){
      view.frame.origin.y += 42.0
      return
    }

    if view.frame.origin.y >= 0.0 {
      return
    }

    if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      view.frame.origin.y += keyboardSize.height
    }
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // hides keyboard when tapped outside keyboard
    self.view.endEditing(true)
  }
  
  
  @objc func closeProfileVC() {
    self.dismiss(animated: true)
  }
  
  
  func handleSaveButtonStyle(canSave: Bool) {
    if ( canSave ) {
      saveButton.alpha = 1
    } else {
      saveButton.alpha = 0.3
    }
    saveButton.isEnabled = canSave
  }
  
  
  @IBAction func editButtonPressed(_ sender: Any) {
    print("edit profile button pressed")
    
    userIsInEditingMode = true
    handleSaveButtonStyle(canSave: false)
    
    editButton.isHidden = true
    saveButton.isHidden = false
    
    nameTextField.isUserInteractionEnabled = true
    nameTextField.layer.borderColor = #colorLiteral(red: 0.623427469, green: 0.623427469, blue: 0.623427469, alpha: 1)
    
    bioTextView.isEditable = true
    bioTextView.layer.borderColor = #colorLiteral(red: 0.623427469, green: 0.623427469, blue: 0.623427469, alpha: 1)
    
  }
  
  
  @IBAction func saveButtonPressed(_ sender: Any) {
    activityIndicator.startAnimating()
    
    view.endEditing(true)
    
    handleSaveButtonStyle(canSave: false)
    
    if nameTextField.text != model.name {
      model.name = nameTextField.text
    }
    
    if bioTextView.text != model.about {
      model.about = bioTextView.text
    }
    
    if userImage.image != model.picture {
      model.picture = userImage.image
    }
    
    model.save() { [weak self] error in
      if !error {
        self?.showSuccessAlert()
      } else {
        self?.showErrorAlert()
      }
      
    self?.activityIndicator.stopAnimating()
    
    self?.saveButton.isHidden = true
    self?.editButton.isHidden = false
    
    self?.nameTextField.isUserInteractionEnabled = false
    
    
    self?.bioTextView.isEditable = false
    
    self?.nameTextField.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    self?.bioTextView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
  }
  
  userIsInEditingMode = false
}


private func showSuccessAlert() {
  let alertController = UIAlertController(title: "Изменения сохранены!", message: nil, preferredStyle: .alert)
  alertController.view.tintColor = UIColor.black
  alertController.addAction(UIAlertAction(title: "Готово", style: .default, handler: nil))
  self.present(alertController, animated: true, completion: nil)
}


private func showErrorAlert() {
  let alertController = UIAlertController(title: "Ошибка", message: "при сохранении", preferredStyle: .alert)
  alertController.view.tintColor = UIColor.black
  alertController.addAction(UIAlertAction(title: "Готово", style: .cancel, handler: nil))
  alertController.addAction(UIAlertAction(title: "Еще раз", style: .default) { action in
    self.saveButtonPressed(self);
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
      handleSaveButtonStyle(canSave: dataWasChanged)
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
  
  
  // user edited text field
  @objc func textFieldDidChange(_ textField: UITextField) {
    handleSaveButtonStyle(canSave: dataWasChanged)
  }
  
}



// MARK: - UITextViewDelegate
extension ProfileViewController: UITextViewDelegate {
  // user edited text view
  @objc func textViewDidChange(_ textView: UITextView) {
    handleSaveButtonStyle(canSave: dataWasChanged)
  }
  
}



// MARK: - IPicturesViewControllerDelegate
extension ProfileViewController: IPicturesViewControllerDelegate {
  // passing the selected web image
  func collectionPickerController(_ picker: ICollectionPickerController, didFinishPickingImage image: UIImage) {
    userImage.image = image
    handleSaveButtonStyle(canSave: true)
    picker.close()
  }
  
}




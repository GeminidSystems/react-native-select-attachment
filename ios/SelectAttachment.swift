//
//  AttachButton.swift
//  ReactPOC
//
//  Created by Geoffrey Xue on 8/17/20.
//

import Foundation
import MobileCoreServices

@objc(SelectAttachment)
class SelectAttachment : RCTEventEmitter {
  
  var maxFileSize: Int?
  var fileTypes: [NSString]?
  var disableCameraPhotos = false
  var disableCameraVideos = false
  var disablePhotos = false
  var disableVideos = false
  var disableDocuments = false
  var cameraLabel = "Camera"
  var albumLabel = "Album"
  var filesLabel = "Files"

  
  enum AttachmentSource: String {
    case photo
    case video
    case document
  }

  override static func requiresMainQueueSetup() -> Bool {
      return true
  }
  
  override func supportedEvents() -> [String]! {
    return ["onReceivedAttachment"]
  }

  @objc(configureSettings:fileTypes:disableCameraPhotos:disableCameraVideos:disablePhotos:disableVideos:disableDocuments:cameraLabel:albumLabel:filesLabel:)
  func configureSettings(maxFileSize: NSNumber, fileTypes: NSArray, disableCameraPhotos: Bool, disableCameraVideos: Bool, disablePhotos: Bool, disableVideos: Bool, disableDocuments: Bool, cameraLabel: NSString, albumLabel: NSString, filesLabel: NSString) {
    self.maxFileSize = Int(truncating: maxFileSize)
    self.fileTypes = fileTypes as? [NSString]
    self.disableCameraPhotos = disableCameraPhotos
    self.disableCameraVideos = disableCameraVideos
    self.disablePhotos = disablePhotos
    self.disableVideos = disableVideos
    self.disableDocuments = disableDocuments
  }
  
  @objc
  func showActionPopup() {
    DispatchQueue.main.async {
      print("showing action popup")
      let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

      let textField = UITextField()
      textField.text = "Choose method to attach file"
      
      //alertController.addTextField(configurationHandler: textField)
      if (!self.disableCameraPhotos && !self.disableCameraVideos) {
        alertController.addAction(UIAlertAction(title: "Camera", style: .default) { UIAlertActiion in
          self.showImagePickerController(type: .camera)
        })
      }
      if (!self.disablePhotos && !self.disableVideos) {
        alertController.addAction(UIAlertAction(title: "Album", style: .default) { UIAlertActiion in
          self.showImagePickerController(type: .photoLibrary)
        })
      }
      if (!self.disableDocuments) {
        alertController.addAction(UIAlertAction(title: "Files", style: .default) { UIAlertActiion in
             self.showDocumentPickerController()
           })
      }
      alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      
      RCTPresentedViewController()?.present(alertController, animated: true) {
        print("presented alertController from RCTViewController")
      }
    }
  }
  
  func processAttachmentURL(url: URL, source: AttachmentSource) {
    let fileName = url.lastPathComponent
    let fileType = url.pathExtension
    print(url)
    do {
      let fileData = try Data(contentsOf: url)
      self.sendEvent(withName: "onReceivedAttachment", body: ["source": source.rawValue, "fileName": fileName, "fileType": fileType, "base64": fileData.base64EncodedString()])
      RCTPresentedViewController()?.dismiss(animated: true, completion: nil)
    }
    catch {
      print("unknown file selected")
      self.sendEvent(withName: "onReceivedAttachment", body: ["error": "failed to convert file into data"])
      RCTPresentedViewController()?.dismiss(animated: true, completion: nil)
    }
  }
}


extension SelectAttachment: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func showImagePickerController(type: UIImagePickerController.SourceType) {
    let imagePickerController = UIImagePickerController()
    var mediaTypes = [String]()
    if (type == .camera) {
      if (!self.disableCameraPhotos) {
        mediaTypes.append(String(kUTTypeImage))
      }
      if (!self.disableCameraVideos) {
        mediaTypes.append(String(kUTTypeVideo))
        mediaTypes.append(String(kUTTypeMovie))
      }
    }
    else
      if (type == .photoLibrary) {
        if (!self.disablePhotos) {
          mediaTypes.append(String(kUTTypeImage))
        }
        if (!self.disableVideos) {
          mediaTypes.append(String(kUTTypeVideo))
          mediaTypes.append(String(kUTTypeMovie))
        }
    }
    print(mediaTypes)
    if (!mediaTypes.isEmpty) {
      imagePickerController.mediaTypes = mediaTypes
    }
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    imagePickerController.sourceType = type
    RCTPresentedViewController()?.present(imagePickerController, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    // Image selected from saved photos / videos
    if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
      processAttachmentURL(url: url, source: .photo)
      return
    }
    
    // Videeo selected from saved photos / videos or taken from camera
    if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
      processAttachmentURL(url: url, source: .video)
      return
    }
    
    // No url found for photo, picture came from camera
    if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      print("Successfully returned edited camera picture")
    
      let base64 = editedImage.pngData()?.base64EncodedString(options: .lineLength64Characters)
      self.sendEvent(withName: "onReceivedAttachment", body: ["source": "cameraPhoto", "base64": base64])
      
    }
    else
    if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        print("Successfully returned original camera picture")
      let base64 = originalImage.pngData()?.base64EncodedString(options: .lineLength64Characters)
      self.sendEvent(withName: "onReceivedAttachment", body: ["source": "cameraPhoto", "base64": base64])
    }
    
    RCTPresentedViewController()?.dismiss(animated: true, completion: nil)
  }
}

extension SelectAttachment: UIDocumentPickerDelegate {
  func showDocumentPickerController() {
    let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypeItem)], in: .import)
    documentPickerController.delegate = self
    documentPickerController.allowsMultipleSelection = false
    RCTPresentedViewController()?.present(documentPickerController, animated: true)
  }
  
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    processAttachmentURL(url: urls[0], source: .document)
  }
}


import Foundation
import MobileCoreServices
@objc(SelectAttachment)
class SelectAttachment : RCTEventEmitter {

    var maxFileSize: Int?
    var fileTypes: [NSString] = ["all"]
    var disableCameraPhotos = false
    var enableImageScaling = false
    var maxImageWidth: CGFloat?
    var imageScale: CGFloat?
    var disableCameraVideos = false
    var disablePhotos = false
    var disableVideos = false
    var disableFiles = false
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

    @objc(showPicker:fileTypes:disableCameraPhotos:disableCameraVideos:disablePhotos:disableVideos:disableFiles:cameraLabel:albumLabel:filesLabel:enableImageScaling:maxImageWidth:imageScale:)
    func showPicker(maxFileSize: NSNumber, fileTypes: NSArray, disableCameraPhotos: Bool, disableCameraVideos: Bool, disablePhotos: Bool, disableVideos: Bool, disableFiles: Bool, cameraLabel: NSString, albumLabel: NSString, filesLabel: NSString, enableImageScaling: Bool, maxImageWidth: CGFloat, imageScale : CGFloat) {

        self.maxFileSize = Int(truncating: maxFileSize)
        self.fileTypes = fileTypes as! [NSString]
        self.disableCameraPhotos = disableCameraPhotos
        self.disableCameraVideos = disableCameraVideos
        self.disablePhotos = disablePhotos
        self.disableVideos = disableVideos
        self.disableFiles = disableFiles

        self.enableImageScaling = enableImageScaling
        self.maxImageWidth = maxImageWidth
        self.imageScale = imageScale

        var alertStyle = UIAlertController.Style.actionSheet
        if (UIDevice.current.userInterfaceIdiom == .pad) {
          alertStyle = UIAlertController.Style.alert
        }

        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: alertStyle)
            let textField = UITextField()
            textField.text = "Choose method to attach file"

            if (!self.disableCameraPhotos && !self.disableCameraVideos) {
                alertController.addAction(UIAlertAction(title: "Camera", style: .default) {
                    UIAlertActiion in
                    self.showImagePickerController(type: .camera)
                })
            }
            if (!self.disablePhotos && !self.disableVideos) {
                alertController.addAction(UIAlertAction(title: "Album", style: .default) {
                    UIAlertActiion in
                    self.showImagePickerController(type: .photoLibrary)
                })
            }
            if (!self.disableFiles) {
                alertController.addAction(UIAlertAction(title: "Files", style: .default) {
                    UIAlertActiion in
                    self.showDocumentPickerController()
                })
            }

            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            RCTPresentedViewController()?.present(alertController, animated: true) {
            }
        }
    }

    func processAttachmentURL(url: URL, source: AttachmentSource) {

        let fileName = url.lastPathComponent
        let fileType = getMIMEType(fileExtension: url.pathExtension)

        do {
            let fileData = try Data(contentsOf: url)

            var base64String = fileData.base64EncodedString()

            if source == .photo {
                let image = UIImage(data: fileData)
                base64String = (getScaledImage(image: image!).pngData()?.base64EncodedString(options: .lineLength64Characters))!
            }

            self.sendEvent(withName: "onReceivedAttachment", body: ["source": source.rawValue, "fileName": fileName, "fileType": fileType, "base64": base64String])
            RCTPresentedViewController()?.dismiss(animated: true, completion: nil)
        }
        catch {
            self.sendEvent(withName: "onReceivedAttachment", body: ["error": "failed to convert file into data"])
            RCTPresentedViewController()?.dismiss(animated: true, completion: nil)
        }

    }

    func getScaledImage(image: UIImage) -> UIImage {

        var scaledImage = image

        if self.enableImageScaling {
            scaledImage = (scaledImage.resized(withPercentage: self.imageScale!))!
        }

        if self.maxImageWidth != nil && self.maxImageWidth! > 0 {
            scaledImage = (scaledImage.resized(toWidth: self.maxImageWidth!))!
        }

        return scaledImage
    }

}
func getMIMEType(fileExtension: String) -> String {
    guard
    let extUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension as CFString, nil)?.takeUnretainedValue()
    else {
        return fileExtension
    }

    guard
    let mimeUTI = UTTypeCopyPreferredTagWithClass(extUTI, kUTTagClassMIMEType)
    else {
        return fileExtension
    }

    return mimeUTI.takeRetainedValue() as String
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

            let scaledImage = getScaledImage(image: editedImage)
            let base64 = scaledImage.pngData()?.base64EncodedString(options: .lineLength64Characters)
            self.sendEvent(withName: "onReceivedAttachment", body: ["source": "cameraPhoto", "base64": base64])

        }
        else
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            let scaledImage = getScaledImage(image: originalImage)
            let base64 = scaledImage.pngData()?.base64EncodedString(options: .lineLength64Characters)
            self.sendEvent(withName: "onReceivedAttachment", body: ["source": "cameraPhoto", "base64": base64])

        }
        RCTPresentedViewController()?.dismiss(animated: true, completion: nil)
    }
}
extension SelectAttachment: UIDocumentPickerDelegate {

    func getUTTypesFromStringList() -> [String] {

        var types = [String]()

        if self.fileTypes.isEmpty == false {
            for ft in self.fileTypes {
                let kt = getUTTypeFromString(typeName: ft)
                if kt != "" {
                    types.append(kt)
                }

            }
        }

        return types
    }

    func getUTTypeFromString(typeName: NSString) -> String {

        let typeMap = [
            "jpeg" : String(kUTTypeJPEG),
            "png" : String(kUTTypePNG),
            "pdf" : String(kUTTypePDF),
            "xls" : String(kUTTypeSpreadsheet),
            "csv" : String(kUTTypeSpreadsheet),
            "all" : String(kUTTypeItem)
        ]

        return typeMap[typeName as String] ?? ""

    }

    func showDocumentPickerController() {
        let documentPickerController = UIDocumentPickerViewController(documentTypes:getUTTypesFromStringList(), in: .import)
        documentPickerController.delegate = self
        documentPickerController.allowsMultipleSelection = false
        RCTPresentedViewController()?.present(documentPickerController, animated: true)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        processAttachmentURL(url: urls[0], source: .document)
    }

}

extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

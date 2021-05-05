import UIKit
import PhotoRoomKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainActivitityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mainButton.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        mainActivitityIndicator.isHidden = true
        mainActivitityIndicator.startAnimating()
    }

    func pickImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true)
    }

    func onImagePicked(_ image: UIImage?) {
        guard let image = image else {
            // Show an error message
            return
        }
        mainImage.image = nil
        mainActivitityIndicator.isHidden = false
        removeBackground(image)
    }

    func removeBackground(_ originalImage: UIImage) {
        let resultViewController = PhotoRoomViewController(image: originalImage,
                                                           apiKey: K.photoRoomAPIKey) { [weak self] image in
            self?.onImageEdited(image)

        }
        present(resultViewController, animated: true)
    }

    func onImageEdited(_ editedImage: UIImage?) {
        mainActivitityIndicator.isHidden = true
        mainImage.image = editedImage
    }

    @IBAction func showImagePicker(_ sender: UIButton) {
        pickImage()
    }

}

extension ViewController: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return self.onImagePicked(nil)
        }
        self.onImagePicked(image)
    }
}




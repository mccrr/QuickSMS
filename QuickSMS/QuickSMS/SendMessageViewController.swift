import UIKit
import ContactsUI
import MessageUI

class SendMessageViewController: UIViewController, CNContactPickerDelegate, MFMessageComposeViewControllerDelegate {
    var template: MessageTemplate?
    var selectedPhone: String?
    var selectedName: String? // <-- add this

    @IBOutlet weak var contactLabel: UILabel! // Optional UI label to display name and number


    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var messageTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Send Message"
        configureNavigationBar()

        // Populate template content
        titleTextView.text = template?.title ?? ""
        messageTextView.text = template?.body ?? ""

        // Make the text views non-editable
        titleTextView.isEditable = false
        messageTextView.isEditable = false
        titleTextView.isScrollEnabled = false
        messageTextView.isScrollEnabled = true
    }

    private func configureNavigationBar() {
        let customColor = UIColor(red: 255/255, green: 238/255, blue: 188/255, alpha: 1.0)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemBlue
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = customColor
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    @IBAction func pickContactTapped(_ sender: UIButton) {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        picker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        present(picker, animated: true)
    }

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        
            let customColor2 = UIColor(red: 51/255, green: 167/255, blue: 40/255, alpha: 1.0)
        if let phoneNumber = contactProperty.value as? CNPhoneNumber {
            selectedPhone = phoneNumber.stringValue
            let contact = contactProperty.contact
            selectedName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"

            // Optional: display on UI
            contactLabel.text = "Selected Contact: \(selectedName ?? "")\n\(selectedPhone ?? "")"
            contactLabel.textColor = customColor2
        }
    }


    @IBAction func sendTapped(_ sender: UIButton) {
        guard MFMessageComposeViewController.canSendText() else {
            showAlert(title: "Error", message: "SMS is not supported on this device.")
            return
        }

        guard let phone = selectedPhone else {
            showAlert(title: "No Contact", message: "Please select a contact first.")
            return
        }

        guard let body = messageTextView.text, !body.isEmpty else {
            showAlert(title: "No Message", message: "Message body is empty.")
            return
        }

        let composeVC = MFMessageComposeViewController()
        composeVC.recipients = [phone]
        composeVC.body = body
        composeVC.messageComposeDelegate = self
        present(composeVC, animated: true)
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

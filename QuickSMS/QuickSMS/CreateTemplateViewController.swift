import UIKit

class CreateTemplateViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView! // <-- Now using UITextView

    // Action to save the new template
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let title = titleTextField.text,
              let body = bodyTextView.text,
              !title.isEmpty, !body.isEmpty else { return }

        let template = MessageTemplate(title: title, body: body)
        TemplateManager.shared.addTemplate(template)
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Template"

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemBlue
        
            let customColor = UIColor(red: 255/255, green: 238/255, blue: 188/255, alpha: 1.0)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = customColor
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Optional styling for the UITextView
        bodyTextView.layer.borderColor = UIColor.systemGray4.cgColor
        bodyTextView.layer.borderWidth = 1.0
        bodyTextView.layer.cornerRadius = 8.0
    }
}

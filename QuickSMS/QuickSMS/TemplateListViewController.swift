import UIKit

class TemplateListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var templates: [MessageTemplate] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        templates = TemplateManager.shared.getTemplates()
        tableView.reloadData()

        if templates.isEmpty {
            let emptyLabel = UILabel(frame: tableView.bounds)
            emptyLabel.text = "No templates available."
            emptyLabel.textAlignment = .center
            emptyLabel.textColor = .secondaryLabel
            tableView.backgroundView = emptyLabel
        } else {
            tableView.backgroundView = nil
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "Templates"
        
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
    }

    // Table view methods to display the templates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templates.count
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove from data source
            templates.remove(at: indexPath.row)
            
            // Update stored templates
            TemplateManager.shared.saveTemplates(templates)
            
            // Delete the row from the table
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TemplateCell", for: indexPath)
        cell.textLabel?.text = templates[indexPath.row].title
        return cell
    }

    // Segue to the SendMessageViewController on template selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SendMessageViewController") as! SendMessageViewController
        vc.template = templates[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    // Action to add a new template
    @IBAction func addTemplateTapped(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateTemplateViewController") as! CreateTemplateViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

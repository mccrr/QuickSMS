import Foundation

class TemplateManager {
    static let shared = TemplateManager()
    private let key = "templates"

    // Retrieve templates from UserDefaults
    func getTemplates() -> [MessageTemplate] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let templates = try? JSONDecoder().decode([MessageTemplate].self, from: data) else {
            return []
        }
        return templates
    }

    // Add a new template to UserDefaults
    func addTemplate(_ template: MessageTemplate) {
        var current = getTemplates()
        current.append(template)
        if let data = try? JSONEncoder().encode(current) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func saveTemplates(_ templates: [MessageTemplate]) {
        if let data = try? JSONEncoder().encode(templates) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

}

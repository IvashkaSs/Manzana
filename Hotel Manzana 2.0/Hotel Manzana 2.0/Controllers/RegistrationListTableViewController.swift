import UIKit

class RegistrationListTableViewController: UITableViewController {
    
    var registrations: [Registration] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registrations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "registrationCell", for: indexPath)
        let registration = registrations[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = registration.firstName
        content.secondaryText = registration.lastName
        cell.contentConfiguration = content
        cell.showsReorderControl = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            registrations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedRegistration = registrations.remove(at: sourceIndexPath.row)
        registrations.insert(movedRegistration, at: destinationIndexPath.row)
    }
    //MARK: - addEditRegistration
    @IBSegueAction func addEditRegistration(_ coder: NSCoder, sender: Any?) -> AddRegistrationTableViewController? {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let registrationFoEdit = registrations[indexPath.row]
            
            return AddRegistrationTableViewController(coder: coder, registrations: registrationFoEdit)
        } else {
            return AddRegistrationTableViewController(coder: coder, registrations: nil)
        }
    }
    //MARK: - unwindToRegistrationTableViewController
    @IBAction func unwindToRegistrationTableViewController(unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "saveUnwind",
              let sourceTableViewController = unwindSegue.source as? AddRegistrationTableViewController,
              let registration = sourceTableViewController.registrations else { return }
        
        if let selectedIndexPathRow = tableView.indexPathForSelectedRow {
            registrations[selectedIndexPathRow.row] = registration
            tableView.reloadRows(at: [selectedIndexPathRow], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: registrations.count, section: 0)
            registrations.append(registration)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}

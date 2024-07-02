//
//  DefectsListViewController.swift
//  AirIndiaHangar
//
//  Created by E5000848 on 01/07/24.
//
import Foundation
import UIKit
import CoreData
import Firebase
import FirebaseAuth

class DefectsListViewController: UIViewController {

    @IBOutlet weak var defectsTableView: UITableView!

    var defectDataArray: [CellContent] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let headImage = UIImage(named: "Logo")
//        let generalHeadButton = UIBarButtonItem(image: headImage, style: .plain, target: self, action: nil)
        
        
        let label = UILabel()
        label.text = "Air India"
        let headLabel = UIBarButtonItem(title: label.text, style: .done, target: self, action: nil)
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = headLabel
        defectsTableView.dataSource = self
        defectsTableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defectDataArray.removeAll()
        prepareData()
        defectsTableView.reloadData()
    }
    
    func prepareData() {
        let request: NSFetchRequest<Defect> = Defect.fetchRequest()
        do {
            let allDefects = try context.fetch(request)
            for defect in allDefects {
                guard let image = UIImage(data: defect.img!) else {
                    print("Unable to convert image from binary")
                    return
                }
                let tempObject = DefectDataModel(defectName: defect.name ?? "No name data", image: image)
                defectDataArray.append(tempObject)
            }
        } catch {
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func addFaultButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "moveToFaultDetector", sender: self)
    }
    
}


//MARK: - Table view datasource methods
extension DefectsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        defectDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = defectDataArray[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrimaryCell.cellIdentifier, for: indexPath) as? PrimaryCell else {
            return UITableViewCell(frame: .zero)
        }
        
        cell.setDataInCell(cellContent: model as! DefectDataModel)
        return cell
    }
}


//MARK: - Table view delegate methods
extension DefectsListViewController: UITableViewDelegate {
    
}

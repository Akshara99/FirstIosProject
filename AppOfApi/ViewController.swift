//
//  ViewController.swift
//  AppOfApi
//
//  Created by Akshara Vangala on 14/06/22.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var textField: UITextField!
    let params = ["first_name": "Akshara", "last_name": "Vangala", "email": "akshara@gmail.com", "id": "1", "page": "1"]
    var fname: String?
    var lname: String?
    var mail: String?
    var id: String?
    var page: String?
    var image1 = UIImage()
    let imageU = UIImage.init(named: "myImage")
   
//    @IBOutlet weak var l5: UILabel!
//    @IBOutlet weak var l4: UILabel!
//    @IBOutlet weak var l3: UILabel!
//    @IBOutlet weak var l2: UILabel!
//    @IBOutlet weak var l1: UILabel!
    
   @IBOutlet weak var tableView: UITableView!
    var dataManager = DataManager()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        dataManager.delegate = self
        tableView.dataSource = self
       tableView.delegate = self
        
    }
    


    @IBAction func dataDidUpload(_ sender: UIButton) {
        guard let url = URL(string: "https://reqres.in/api/users?page=1") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

        let session = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let error = error {
                print("The error was: \(error.localizedDescription)")
            }
            else {
                let jsonRes = try? JSONSerialization.jsonObject(with: data!, options: [])
                print("Response json is: \(jsonRes)")
            }
        }.resume()

    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if textField.text != ""{
            dataManager.fetchData(id: Int(textField.text!)!)
        }
        else{
            textField.placeholder = "Type Something"
            }
        textField.endEditing(true)
        
    }
    
}

extension ViewController: DataManagerDelegate {
 
    func didDataUpdate(_ dataManager: DataManager , model: ViewModel) {
        
        let url = URL(string: model.VmAvatar)
        if let data = try? Data(contentsOf: url!)
        {
            image1 = UIImage(data: data)!
        }
        
        fname = model.VmFirstname
        lname = model.VmLastName
        mail  = model.emailId
        id = "\(model.Vmid)"
        page = "\(model.pages)"
    
        
     DispatchQueue.main.async {
            self.tableView.reloadData()
//            self.l1.text = model.VmFirstname
//            self.l2.text = model.VmLastName
//            self.l3.text = model.emailId
//            self.l4.text = "\(model.Vmid)"
//            self.l5.text = "\(model.pages)"
//            self.profile.image = self.image1
       }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    
}
extension ViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell
            cell?.l1.text = self.fname
            cell?.l2.text = self.lname
            cell?.l3.text = self.mail
            cell?.l4.text = self.id
            cell?.l5.text = self.page
            cell?.profile.image = self.image1
    
       

        return cell ?? UITableViewCell()
    }
}
    


//
//  DataManager.swift
//  AppOfApi
//
//  Created by Akshara Vangala on 14/06/22.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol DataManagerDelegate {
    func didDataUpdate(_ dataManager : DataManager, model: ViewModel)
    func didFailWithError(_ error : Error)
}

struct DataManager {
    
    func fetchData(id: Int){
       //let urlString = "\(dataURL)=\(id)"
        let urlString = "https://reqres.in/api/users?page=1"
       performRequest(with: urlString, id: id)
       // loadJsonData(id: id)
    }
    
    var delegate : DataManagerDelegate?
    
        //Alamofire
    
//    func loadJsonData(id: Int)
//    {
//        let request = AF.request("https://reqres.in/api/users?page=1")
//
//            request.responseDecodable(of: Model.self){ (response) in
//                guard let decodedData = response.value else{return}
//                let fName = decodedData.data[id-1].first_name
//                let lName = decodedData.data[id-1].last_name
//                let email = decodedData.data[id-1].email
//                let id = decodedData.data[id-1].id
//                let page = decodedData.page
//                let avataar = decodedData.data[id-1].avatar
//                let weather = ViewModel(pages: page, Vmid: id , VmFirstname: fName, VmLastName: lName, VmAvatar: avataar, emailId: email)
//
//                delegate?.didDataUpdate(self, model: weather)
//            }
//        }
//    }


//URLSession
    func performRequest(with urlString: String , id: Int){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data{
                    if let dataa = self.parseJSON(safeData, id: id){
                        print(dataa)

                        delegate?.didDataUpdate(self, model: dataa)
                    }
                }
            }
            task.resume()
        }

    }

    
    //parsing json for urlsession

    func parseJSON(_ internalData: Data , id: Int)-> ViewModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(Model.self, from: internalData)
            let fName = decodedData.data[id-1].first_name
            let lName = decodedData.data[id-1].last_name
            let email = decodedData.data[id-1].email
            let id = decodedData.data[id-1].id
            let page = decodedData.page
            let avataar = decodedData.data[id-1].avatar
            let weather = ViewModel(pages: page, Vmid: id , VmFirstname: fName, VmLastName: lName, VmAvatar: avataar, emailId: email)
            return weather
        }
        catch{
            print(error)
            delegate?.didFailWithError(error)
            return nil
        }
    }
}


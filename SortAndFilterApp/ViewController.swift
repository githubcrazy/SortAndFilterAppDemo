//
//  ViewController.swift
//  SortAndFilterApp
//
//  Created by ISHAN ARUN PANT on 23/5/20.
//  Copyright © 2020 ISHAN ARUN PANT. All rights reserved.
//
import UIKit

struct jsonstruct: Codable {
    var name:String
    var capital:String
    var number: Int
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var arrdata = [jsonstruct]()
    var arr1: [String] = []
    var arr2: [String] = []
    var arr3: [String] = []
    
    var p: Int!
    var searchCountry = [String]()
    var searching = false
    var sorting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        p = 0
        searchBar.delegate = self
        getDataFromJson()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if searching {
            return searchCountry.count
         } else if sorting {
            return arr1.count
           // return arr2.count
         } else {
            return self.arrdata.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
         if searching {
                cell.lblCapital.text = "Serial Number:"+(arr3[indexPath.row])
                cell.lblName.text =  "Name:"+(searchCountry[indexPath.row])
         } else if sorting {
                cell.lblCapital.text = "Serial Number:"+(arr2[indexPath.row])
                cell.lblName.text =  "Name:"+(arr1[indexPath.row])
         } else {
                cell.lblCapital.text = "Serial Number:"+(String(arrdata[indexPath.row].number))
                cell.lblName.text =  "Name:"+(arrdata[indexPath.row].name)
         }
            
        return cell
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCountry = self.arr1.filter({$0.prefix(searchText.count) == searchText})
        
        var a = 0
        for a in 0..<searchCountry.count {
         for b in 0..<self.arrdata.count {
            if (searchCountry[a] == self.arrdata[b].name) {
                arr3.insert(String(self.arrdata[b].number), at: a)
                }
            }
        }
    
        searching = true
        
        if searchText == "" {
            searching = false
        }
        
        self.tableview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        //sorting = false
        //searchBar.text = ""
        self.tableview.reloadData()
    }
    
    
    @IBAction func switchSegment(_ sender: UISegmentedControl) {
        
        p = sender.selectedSegmentIndex
        if(p == 1) {
           sorting = true
           searching = false
           arr1.sort(by: {$0 < $1})
            for i in 0..<arr1.count {
                for j in 0..<arr1.count {
                    if (arr1[i] == self.arrdata[j].name) {
                        arr2.append(String(self.arrdata[j].number))
                    }
                }
            }

            self.tableview.reloadData()
        }
        if (p == 0) {
            sorting = false
            searching = false
            self.tableview.reloadData()
        }
    }
    
     func getDataFromJson() {
        
            guard let fileLocation = Bundle.main.url(forResource: "userdata", withExtension: "json") else {
                print("File Not Found")
                return
            }
            
            do{
                let docDirectory = try FileManager.default.url(for:.documentDirectory, in:.userDomainMask, appropriateFor:nil, create:true)
                let newLocation = docDirectory.appendingPathComponent("userdata.json")
                loadFile(mainPath: fileLocation, subPath: newLocation)
            } catch {
                print(error)
            }
               
                
        }
        
        func loadFile(mainPath: URL, subPath: URL) {
            if FileManager.default.fileExists(atPath: subPath.path){
                loadDataInTableView(pathName: subPath)
                
                if self.arrdata.isEmpty{
                    loadDataInTableView(pathName: mainPath)
                }
            }else{
                //print("File Is Not Present")
                loadDataInTableView(pathName: mainPath)
            }
            self.tableview.reloadData()
        }
            
            
        func loadDataInTableView(pathName: URL) {
            do{
            let jsondata = try Data(contentsOf: pathName)
                self.arrdata = try JSONDecoder().decode([jsonstruct].self, from: jsondata)
                
                for mainarr in self.arrdata {
                    arr1.append(mainarr.name)
                }
                print(self.arr1)
        } catch {
                print(error)
        }
    }
}



//
//  SeguimientoViewController.swift
//  prueba1
//
//  Created by Juan Carlos on 12/24/16.
//  Copyright © 2016 Juan Carlos. All rights reserved.
//

import UIKit

class SeguimientoViewController: UITableViewController {
    var TableData:Array< String > = Array < String >()

    override func viewDidLoad() {
        super.viewDidLoad()
        get_data_from_url("https://cescolar.cucea.udg.mx/servicios/listado.php")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = TableData[indexPath.row]
        cell.textLabel?.lineBreakMode = NSLineBreakMode(rawValue: 2)!
        cell.textLabel?.numberOfLines = 3
        let imageName = "brief-50.png"
        let image = UIImage(named: imageName)
        
        cell.imageView!.image = image
        return cell
    }
    

    
    func get_data_from_url(_ link:String)
    {
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }
            self.extract_json(data!)
        })
        task.resume()
    }
    
    func extract_json(_ data: Data)
    {
        let json: Any?
        
        do
        {
            json = try JSONSerialization.jsonObject(with: data, options: [])
        }
        catch
        {
            return
        }
        
        guard let data_list = json as? NSArray else
        {
            return
        }
        
        if let countries_list = json as? NSArray
        {
            for i in 0 ..< data_list.count
            {
                //print(data_list[i])
                if let country_obj = countries_list[i] as? NSDictionary
                {
                    if let country_name = country_obj["folio"] as? String
                    {
                        if let country_code = country_obj["status"] as? String
                        {
                            TableData.append("Folio: " + country_name + " Status:  " + country_code )
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.async(execute: {self.do_table_refresh()})
    }
    
    func do_table_refresh()
    {
        self.tableView.reloadData()
        
    }

}

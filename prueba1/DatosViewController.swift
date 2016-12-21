//
//  DatosViewController.swift
//  prueba1
//
//  Created by Juan Carlos on 11/22/16.
//  Copyright © 2016 Juan Carlos. All rights reserved.
//

//import UIKit
import Eureka
import JWT

class DatosViewController: FormViewController {

    @IBOutlet weak var txtCodigo: UITextField!
    @IBOutlet weak var txtNombre: UITextField!
    
    @IBOutlet weak var txtCurp: UITextField!
    @IBOutlet weak var txtFechaNac: UITextField!
    @IBOutlet var txtCarrera: UIView!
    
    
    
    let datos = AlumnoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form = Section("Datos")
            <<< LabelRow(){ row in
                row.title = "Código"
                row.value = "Ingresa texto aqui"
        }
            <<< LabelRow(){ row in
                row.title = "Nombre"
                row.value = "Ingresa texto aqui"
            }
            
            <<< EmailRow(){
                $0.title = "Correo Electrónico"
                $0.placeholder = "Introduce tu Email"
            }
            <<< PhoneRow(){
                $0.title = "Telefono"
                $0.placeholder = "Ingresa tu numero aquí"
        }
            <<< DateRow(){
                $0.title = "Fecha de Nacimiento"
                $0.value = NSDate(timeIntervalSinceReferenceDate: 0) as Date
            }
    +++ Section("Datos Académicos")
            <<< LabelRow(){
                $0.title = "Carrera"
                $0.value = "LIC TURISMO (TURA)"
        }
        
        
        let payload = try JWT.encode(["token": "CONTROL-ESCOLAR-CUCEA","codigo": "216355666"], algorithm: .hs256("secret".data(using: .utf8)!))
        
        
        
        do {
            let payload2 = try JWT.decode(payload, algorithm: .hs256("secret".data(using: .utf8)!))
            print(payload2)
        } catch {
            print("Failed to decode JWT: \(error)")
        }
            

        
        let urlPath: String = "http://cescolar.cucea.udg.mx/servicios/service.php?token=\(payload)" //this will be changed to the path where service.php lives
        print(urlPath)
        let url = URL(string: urlPath)
        
        let theRequest = NSMutableURLRequest(url: url! as URL)
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession.shared
        let task = session.dataTask(with: theRequest as URLRequest, completionHandler: {data, response, error -> Void in
            print(data)
        })
        
        task.resume()
    
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

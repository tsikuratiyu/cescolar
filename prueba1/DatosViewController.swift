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
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let payload = try JWT.encode(["token": "CONTROL-ESCOLAR-CUCEA","codigo": "216355666"], algorithm: .hs256("secret".data(using: .utf8)!))
        
        
        let urlPath: String = "http://cescolar.cucea.udg.mx/servicios/service.php?token=\(payload)" //this will be changed to the path where service.php lives
        print(urlPath)
        let url = URL(string: urlPath)
        
        let theRequest = NSMutableURLRequest(url: url! as URL)
        
        let session = URLSession.shared
            
            let task = session.dataTask(with: theRequest as URLRequest) {
                (data, response, error) in
                // check for any errors
                guard error == nil else {
                    print("error calling GET on /todos/1")
                    print(error!)
                    return
                }
                // make sure we got data
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                do {
                    guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                        as? [String: Any] else {
                            print("error trying to convert data to JSON")
                            return
                    }
                    
                    guard let alumno = Alumno(json: todo)
                        else {
                            print("error construyendo objeto")
                            return
                    }
                    
                    let datos = UserDefaults.standard
                    
                    datos.setValue(alumno.codigo, forKey: "codigo")
                    datos.setValue(alumno.nombre, forKey: "nombre")
                    datos.setValue(alumno.ap, forKey: "ap")
                    datos.setValue(alumno.am, forKey: "am")
                    datos.setValue(alumno.carrera, forKey: "carrera")
                    datos.setValue(alumno.estatus, forKey: "estatus")
                    datos.setValue(alumno.idc, forKey: "clave")
                    datos.setValue(alumno.correo, forKey: "correo")
                    datos.setValue(alumno.telefono, forKey: "telefono")
                    datos.setValue(alumno.fecha_nac, forKey: "fecha_nac")
                    
                    
                
                    
                } catch  {
                    print("error trying to convert data to JSON")
                    return
                }
            }
        
        task.resume()
        
        let datos = UserDefaults.standard
        print(datos)

        form = Section("Datos")
            <<< LabelRow(){ row in
                row.title = "Código"
                row.value = datos.value(forKey: "codigo") as! String?
            }
            <<< LabelRow(){ row in
                row.title = "Nombre"
                row.value = datos.value(forKey: "nombre") as! String?
            }
            
            <<< EmailRow(){
                $0.title = "Correo Electrónico"
                $0.placeholder = datos.value(forKey: "correo") as! String?
            }
            <<< PhoneRow(){
                $0.title = "Telefono"
                $0.placeholder = datos.value(forKey: "telefono") as! String?
            }
            <<< LabelRow(){
                $0.title = "Fecha de Nacimiento"
                $0.value = datos.value(forKey: "fecha_nac") as! String?
            }
            +++ Section("Datos Académicos")
            <<< LabelRow(){
                $0.title = "Carrera"
                $0.value = UserDefaults.standard.value(forKey: "carrera") as! String?
        }
        

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

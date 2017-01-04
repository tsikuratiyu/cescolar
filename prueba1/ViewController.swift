//
//  ViewController.swift
//  prueba1
//
//  Created by Juan Carlos on 11/18/16.
//  Copyright © 2016 Juan Carlos. All rights reserved.
//

import UIKit
import SWXMLHash

class ViewController: UIViewController {


    @IBOutlet weak var txtCodigo: UITextField!
    @IBOutlet weak var txtNip: UITextField!
    @IBOutlet weak var imagen: UIImageView!
    
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtCodigo.placeholder = "Código"
        txtNip.placeholder = "Nip"
        
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "codigo") != nil{
            
            print("ya existen datos")
            self.logear()
            
        }
        

                       // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func logear()
    {
        let defaults = UserDefaults.standard
        
        if defaults.value(forKey: "codigo") != nil{
        
        print("ya existen datos")
        
        }else
        {
            print("No hay datos de usuario")
            defaults.setValue(txtNip.text, forKey: "nip")
            defaults.setValue(txtCodigo.text	, forKey: "codigo")
        }
        
        let codigo = defaults.value(forKey: "codigo")
        let nip = defaults.value(forKey: "nip")
        
        
        //if((codigo?.isEmpty)! || (nip?.isEmpty)!){
        //print(codigo)
        //print(nip)
        //  print("datos no introducidos")
        //}
        
        
        
        
        let soapMessage = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:tns=\"http://webservice/Logon.wsdl\" xmlns:ns1=\"http://webservice/IWebServiceLogon.xsd\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"><SOAP-ENV:Body><mns:valida xmlns:mns=\"WebServiceLogon\" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><usuario xsi:type=\"xsd:string\">\(codigo!)</usuario><password xsi:type=\"xsd:string\">\(nip!)</password><key xsi:type=\"xsd:string\">UdGSIIAUWebServiceValidaUsuario</key></mns:valida></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        
        
        let urlString = "http://tas09.siiau.udg.mx/WebServiceLogon/WebServiceLogon?WSDL"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url! as URL)
        
        let msgLength = String(soapMessage.characters.count)
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: theRequest as URLRequest, completionHandler: {data, response, error -> Void in
        let xml = SWXMLHash.parse(data!)
        
        let resp = xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:validaResponse"]["return"].element?.text
        if resp == "0"
        {
        print("datos erroneos")
        }
        else{
        //let datos = resp?.components(separatedBy: ",")
        
        /*
        var tipo: String = datos![0]
        var codigo: String = datos![1]
        var nombre: String = datos![2]
        var opt: String = datos![3]
        var centro: String = datos![4]
        
        print(nombre)
        */
        
        OperationQueue.main.addOperation {
        self.performSegue(withIdentifier: "logeo", sender: self)}
        }
        
        })
        
        task.resume()
    
    }

    @IBAction func actionConvert(_ sender: Any) {
        
        self.logear()
        
    }


}


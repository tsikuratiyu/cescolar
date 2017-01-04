//
//  funciones.swift
//  prueba1
//
//  Created by Juan Carlos on 12/24/16.
//  Copyright © 2016 Juan Carlos. All rights reserved.
//

import Foundation


func obtener_desde_url(_ link:String, completion: @escaping (_ result: NSArray) -> Void)
{
    let url:URL = URL(string: link)!
    let session = URLSession.shared
    
    let request = NSMutableURLRequest(url: url)
    request.httpMethod = "GET"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
    
    let task = session.dataTask(with: request as URLRequest, completionHandler: {
        (data, response, error) in
        
        guard let _:Data = data, let _:URLResponse = response  , error == nil else {
            
            return
        }
        let datos = extraer_json(data!)
        completion(datos)
    })
    task.resume()
}

func extraer_json(_ data: Data) -> NSArray
{
    let json: Any?
    let error: NSArray? = []
    
    do
    {
        json = try JSONSerialization.jsonObject(with: data, options: [])
    }
    catch
    {
        return error as! NSArray
    }
    
    guard let datos = json as? NSArray else
    {
        return error!
    }
    //print(datos)
    return datos
    
}

func getDataSynchronously(request: NSURLRequest) -> NSData? {
    var returnData: NSData?
    let semaphore = DispatchSemaphore(value: 0)
    
    _ = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
        returnData = data as NSData?
        semaphore.signal()
    }).resume()
    //dataTask.resume()
    semaphore.wait(timeout: .distantFuture)
    return returnData
}

func MD5(string: String) -> Data? {
    guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
    var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
    
    _ = digestData.withUnsafeMutableBytes {digestBytes in
        messageData.withUnsafeBytes {messageBytes in
            CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
        }
    }
    
    return digestData
}


func crearURL(arrayserv: Array<String>, arraycant: Array<String>,arrayfirma: Array<String>, codigo: String, carrera: String, com: String) -> URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "cescolar.cucea.udg.mx"
    urlComponents.path = "/servicios/request.php"
    
    let joiner = ","
    let serviciostring = arrayserv.joined(separator: joiner)
    let firmastring = arrayfirma.joined(separator: joiner)
    let cantstring = arraycant.joined(separator: joiner)
    
    let firmas = URLQueryItem(name: "firma[]", value: firmastring)
    let servicios = URLQueryItem(name: "opc[]", value: serviciostring)
    let cant = URLQueryItem(name: "cant[]", value: cantstring)
    
    
    let carrera = URLQueryItem(name: "carrera", value: carrera)
    let codigo = URLQueryItem(name: "codigo", value: "216355666")
    let com = URLQueryItem(name: "com", value: "Esto es un comentario")
    
    urlComponents.queryItems = [firmas, servicios, cant, carrera, codigo, com]
    
    return urlComponents.url
}

extension Array  {
    var indexedDictionary: [Int: Element] {
        var result: [Int: Element] = [:]
        enumerated().forEach({ result[$0.offset] = $0.element })
        return result
    }
}

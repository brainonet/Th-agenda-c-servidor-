//
//  addViewController.swift
//  agenda_CoreData
//
//  Created by Mauro Silva on 28/02/2018.
//  Copyright © 2018 Brains On Networks. All rights reserved.
//

import UIKit

class addViewController: UIViewController {
    
    @IBOutlet weak var txt_Id: UITextField!
    @IBOutlet weak var txt_Nome: UITextField!
    @IBOutlet weak var txt_Apelido: UITextField!
    @IBOutlet weak var txt_Contacto: UITextField!
    
    var contacto:[Contacto]? = nil
    let urlAdd = URL(string: "http://192.168.85.128:8888/RestServer-master/example/addContacto")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Quando se adiciona um novo contacto será verificado o ultimo "id" do array e incrementado uma unidade a esse valor.
        // Para que o ultimo "id" do array seja o maior de todos temos de usar a funcao fetchObjectById que ordena os contactos por id e por ordem crescente
        contacto = CoraDataHandler.fetchObjectById()
        
        //print para confirmar se está ordenado pelo id
        print("")
        for i in contacto! {
            print(i.id, i.nome!)
        }
        print("")

    }

    @IBAction func adicionarBtn(_ sender: Any) {
        
        
        if (self.txt_Nome.text == "" || self.txt_Apelido.text == "" || self.txt_Contacto.text == ""){
            
            //apresentação de um alert sheet caso existam campos vazios
            let sheet = UIAlertController(title: "Erro", message: "Preencha todos os campos", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Entendido", style: .default, handler: { (action) in
            })
            sheet.addAction(action)
            self.present(sheet, animated: true, completion: nil)
            
        } else if (!self.isInt(string: self.txt_Contacto.text!)){
            //apresentação de um alert sheet caso o telemovel nao seja um numero
            let sheet = UIAlertController(title: "Erro", message: "O contacto não pode conter letras ou outros caracteres", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Entendido", style: .default, handler: { (action) in })
            sheet.addAction(action)
            self.present(sheet, animated: true, completion: nil)
            
        } else {
            
            let lastObject = (contacto!.count)-1
            let newId = (contacto![lastObject].id)+1
            
            //guarda o novo contacto no core data
            if CoraDataHandler.saveObject(id: newId, nome: txt_Nome.text!, apelido: txt_Apelido.text!, contacto: Int32(txt_Contacto.text!)!) {
                print("Contacto guardado com sucesso\n")
            } else {
                print("Não foi possível guardar o contacto\n")
            }
            
            let cont = Int32(txt_Contacto.text!)
            
            //tentativa de inserir o contacto na base de dados
            var request = URLRequest(url: urlAdd!)
            request.httpMethod = "POST"
            let postString = "nome=\(txt_Nome.text!))&apelido=\(txt_Apelido.text!)&contacto=\(cont!)"
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request)
            task.resume()
        }
    }
    
    //verifica se o valor é um int ou não
    func isInt(string: String) -> Bool {
        return Int(string) != nil
    }
}

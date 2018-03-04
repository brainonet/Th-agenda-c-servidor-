//
//  infoViewController.swift
//  agenda_CoreData
//
//  Created by Mauro Silva on 28/02/2018.
//  Copyright © 2018 Brains On Networks. All rights reserved.
//

import UIKit

class infoViewController: UIViewController {
    
    //ao selecionar uma cell guardamos o id do contacto correspondente nesta var "aux"
    var aux = Int16()
    var contacto:[Contacto]? = nil

    @IBOutlet weak var lbl_nome: UILabel!
    @IBOutlet weak var lbl_apelido: UILabel!
    @IBOutlet weak var lbl_contacto: UILabel!
    
    @IBOutlet weak var btn_editar: UIButton!
    @IBOutlet weak var btn_apagar: UIButton!
    @IBOutlet weak var editar_width: NSLayoutConstraint!
    @IBOutlet weak var apagar_width: NSLayoutConstraint!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        // botoes bonitos - inicio
        let screenSize = UIScreen.main.bounds
        let btn_responsive = screenSize.width/2 - 30
        
        self.editar_width.constant = btn_responsive
        self.apagar_width.constant = btn_responsive
        // botoes bonitos - fim
        
        //filtra os contactos e escolhe apenas aquele que tem o id = à variavel aux
        contacto = CoraDataHandler.filterData(aux: String(self.aux))
        
        for object in contacto! {
            lbl_nome.text = object.nome
            lbl_apelido.text = object.apelido
            lbl_contacto.text = String(object.contacto)
            print("\nContacto:\n", object.id, object.nome!, object.apelido!, object.contacto, "\n")
        }
    }
    
    
    
    @IBAction func editarBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Editar Contacto", message: "Deseja editar o contacto?", preferredStyle: .alert)
        alert.addTextField{(tf) in tf.text = self.lbl_nome.text}
        alert.addTextField{(tf) in tf.text = self.lbl_apelido.text}
        alert.addTextField{(tf) in tf.text = self.lbl_contacto.text}
        
        //ações ao clicar no "Atualizar" do alert"
        let action = UIAlertAction(title: "Atualizar", style: .default){(action: UIAlertAction) in
            
            if (alert.textFields![0].text == "" || alert.textFields![1].text == "" || alert.textFields![2].text == ""){
                
                //apresentação de um alert sheet caso existam campos vazios
                let sheet = UIAlertController(title: "Erro", message: "Preencha todos os campos", preferredStyle: .actionSheet)
                let action = UIAlertAction(title: "Entendido", style: .default, handler: { (action) in
                })
                sheet.addAction(action)
                self.present(sheet, animated: true, completion: nil)
                
            } else if (!self.isInt(string: alert.textFields![2].text!)){
                //apresentação de um alert sheet caso o telemovel nao seja um numero
                let sheet = UIAlertController(title: "Erro", message: "O contacto não pode conter letras ou outros caracteres", preferredStyle: .actionSheet)
                let action = UIAlertAction(title: "Entendido", style: .default, handler: { (action) in })
                sheet.addAction(action)
                self.present(sheet, animated: true, completion: nil)
                
            } else {
                //apaga o contacto do core data
                CoraDataHandler.deleteObject(contacto: self.contacto![0])
                //re-insere um contacto no core data com o mesmo id do que acabou de ser apagado
                CoraDataHandler.saveObject(id: self.aux, nome: alert.textFields![0].text!, apelido: alert.textFields![1].text!, contacto: Int32(alert.textFields![2].text!)!)
                print("\nContacto alterado\n")
                
                self.lbl_nome.text = alert.textFields![0].text!
                self.lbl_apelido.text = alert.textFields![1].text!
                self.lbl_contacto.text = alert.textFields![2].text!
            }
        }
        
        //botão cancelar
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction) in
            print("cancelado");
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated:true, completion: nil)
    }
    
    
    @IBAction func apagarBtn(_ sender: Any) {
        
        //  realizado o fetch request da funçao ".fiilterData()" existirá apenas um objeto  na variavel "contacto" (daí utilizar "contacto![0] para o selecionar e apagar)
        if CoraDataHandler.deleteObject(contacto: contacto![0]) {
            print("Contacto apagado com sucesso")
        } else {
            print("Não foi possível apagar o contacto.")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func isInt(string: String) -> Bool {
        return Int(string) != nil
    }
}

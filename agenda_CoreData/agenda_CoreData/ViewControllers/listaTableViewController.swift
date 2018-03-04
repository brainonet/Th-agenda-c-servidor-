//
//  listaTableViewController.swift
//  agenda_CoreData
//
//  Created by Mauro Silva on 28/02/2018.
//  Copyright © 2018 Brains On Networks. All rights reserved.
//

import UIKit

class listaTableViewController: UITableViewController {
    
    @IBOutlet var myTableView: UITableView!
    var contacto:[Contacto]? = nil
    let urlAdd = URL(string: "http://192.168.85.128:8888/RestServer-master/example/addContacto")
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteData()
        loadData()
        //apenas para verificar os dados todos
        print("")
        for data in contacto! {
            print("ID: \(data.id), Nome: \(data.nome!), Apelido: \(data.apelido!), Telemovel: \(data.contacto)")
        }
        print("")
    }

    //apaga a informação da bases de dados
    func deleteData(){
        //GET
        guard let url = URL(string: "http://192.168.85.128:8888/RestServer-master/example/deleta") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request)
        task.resume()
        
    }
    
    //carrega a informação do core data
    func loadData() {
        contacto = CoraDataHandler.fetchObjectAlphabetically()
        myTableView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        deleteData()
        loadData()
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (contacto?.count)!
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //popula a celula com o nome e telemovel do respectivo contacto
        cell.textLabel?.text = contacto?[indexPath.row].nome
        cell.detailTextLabel?.text = String(contacto![indexPath.row].contacto)
        
        //tentativa de reinserir cada contacto da celula na base de dados
        var request = URLRequest(url: urlAdd!)
        request.httpMethod = "POST"
        let postString = "nome=\(String(describing: contacto?[indexPath.row].nome))&apelido=\(String(describing: contacto?[indexPath.row].apelido))&contacto\(String(describing: contacto?[indexPath.row].contacto))"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request)
        task.resume()
    
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "info_segue", sender: contacto![indexPath.row].id)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? infoViewController {
            if let seg = sender as? Int16 {
                dest.aux = Int16(seg)
            }
        }
    }
    
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */


    /*
    
    */

}

//
//  CoraDataHandler.swift
//  agenda_CoreData
//
//  Created by Mauro Silva on 28/02/2018.
//  Copyright © 2018 Brains On Networks. All rights reserved.
//

import UIKit
import CoreData

class CoraDataHandler: NSObject {
    
    //acede ao coredata. Kind of
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    //guarda novos objectos na entidade Contacto
    class func saveObject(id:Int16, nome:String, apelido:String, contacto:Int32) -> Bool {
        let context = getContext()
        let entidade = NSEntityDescription.entity(forEntityName: "Contacto", in: context)
        let managedObject = NSManagedObject(entity: entidade!, insertInto: context)
        
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(nome, forKey: "nome")
        managedObject.setValue(apelido, forKey: "apelido")
        managedObject.setValue(contacto, forKey: "contacto")
        
        do {
            try context.save()
            print("saveObject(): ")
            return true
        }
        catch {
            print("Failed to save object. Error: ", error)
            return false
        }
    }
    
    //mostra os objectos da entity
    class func fetchObject() -> [Contacto]? {
        let context = getContext()
        var contacto:[Contacto]? = nil
        do {
            contacto = try context.fetch(Contacto.fetchRequest())
            return contacto
        } catch { return contacto }
    }
    
    
    //fetch request com um query especifica para obter o id de um determinado contacto
    class func filterData(aux: String) -> [Contacto]? {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Contacto> = Contacto.fetchRequest()
        var contact:[Contacto]? = nil
        
        let predicate = NSPredicate(format: "id LIKE %@", aux)
        fetchRequest.predicate = predicate
        
        do {
            contact = try context.fetch(fetchRequest)
            return contact
        } catch { return contact }
    }
    
    //fetch request utilizando NSSortDescriptor para ordenar alfabeticamente
    class func fetchObjectAlphabetically() -> [Contacto]? {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Contacto> = Contacto.fetchRequest()
        var contacto:[Contacto]? = nil
        
        let sortDescrip = NSSortDescriptor(key: "nome", ascending: true)
        let sortDescriptors = [sortDescrip]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            contacto = try context.fetch(fetchRequest)
            return contacto
        } catch { return contacto }
    }
    
    
    //fetch request utilizando NSSortDescriptor para ordenar numericamente (id)
    class func fetchObjectById() -> [Contacto]? {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Contacto> = Contacto.fetchRequest()
        var contacto:[Contacto]? = nil
        
        let sortDescrip = NSSortDescriptor(key: "id", ascending: true)
        let sortDescriptors = [sortDescrip]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            contacto = try context.fetch(fetchRequest)
            return contacto
        } catch { return contacto }
    }
    
    
    //apaga 1 entrada da entidade Contacto
    class func deleteObject(contacto: Contacto) -> Bool {
        let context = getContext()
        context.delete(contacto)
        
        do {
            try context.save()
            return true
        } catch {
            print("Failed to save after delete. Error: ", error)
            return false
        }
    }
    
    //apaga tudo o que estiver na entidade Contacto
    class func completeDelete() -> Bool {
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Contacto.fetchRequest())
        
        do {
            try context.execute(delete)
            return true
        } catch {
            print("Failed to completely delete entity info. Error: ", error)
            return false
        }
    }
    
}


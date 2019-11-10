//
//  ViewController.swift
//  Equipos Core Data
//
//  Created by DAMII on 11/10/19.
//  Copyright © 2019 Elías Jurado. All rights reserved.
//
import CoreData
import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var edtCodigo: UITextField!
    @IBOutlet weak var edtNombres: UITextField!
    @IBOutlet weak var edtApellidos: UITextField!
    @IBOutlet weak var tblJugadores: UITableView!
    var ListaJugadores : [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblJugadores.dataSource = self
        tblJugadores.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListaJugadores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oEquipo = ListaJugadores[indexPath.row]
        let oCelda : UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle,reuseIdentifier: "Celda1")
        var strCodigo : String = oEquipo.value(forKey: "codigo") as? String ?? ""
        var strApellidos : String = oEquipo.value(forKey: "apellidos") as? String ?? ""
        var strNombres : String = oEquipo.value(forKey: "nombres") as? String ?? ""
        
        oCelda.textLabel!.text = "\(strCodigo) \(strNombres) \(strApellidos)"
        return oCelda
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Equipo> = Equipo.fetchRequest()
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            ListaJugadores = results as [NSManagedObject]
        }catch let error as NSError {
            print("No ha sido posible cargar \(error), \(error.userInfo)")
        }
        tblJugadores.reloadData()
    }
    @IBAction func btnAgregar_onClick(_ sender: Any) {
        print("Por Grabar")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let objmgObject = appDelegate.persistentContainer.viewContext
        print("paso1")
        let entidad = NSEntityDescription.entity(forEntityName: "Equipo", in: objmgObject)
        print("paso2")
        let oEquipo = NSManagedObject(entity: entidad!, insertInto: objmgObject)
        print("paso3")
        oEquipo.setValue(edtCodigo.text!, forKey: "codigo")
        oEquipo.setValue(edtNombres.text!, forKey: "nombres")
        oEquipo.setValue(edtApellidos.text!, forKey: "apellidos")
        print("paso4")
        do {
            try objmgObject.save()
            print("paso5")
            ListaJugadores.append(oEquipo)
            print("Agregado")
            tblJugadores.reloadData()
        } catch let error01 as NSError {
            print("Error de grabado:")
        }
    }
}


//
//  PokedexViewController.swift
//  PokemonGo
//
//  Created by Josimar Javier Tantahuilca Torres on 17/05/19.
//  Copyright © 2019 Tecsup. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var pokemonsAtrapados: [Pokemon] = []
    var pokemonsNoAtrapados: [Pokemon] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonsAtrapados = obtenerPokemonsAtrapados()
        pokemonsNoAtrapados = obtenerPokemonsNoAtrapados()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return pokemonsAtrapados.count
        } else {
            return pokemonsNoAtrapados.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon: Pokemon
        if indexPath.section == 0 {
            pokemon = pokemonsAtrapados[indexPath.row]
        } else {
            pokemon = pokemonsNoAtrapados[indexPath.row]
        }
        let cell = UITableViewCell()
        cell.textLabel?.text = pokemon.nombre
        cell.imageView?.image = UIImage(named: pokemon.imagenNombre!)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Atrapados"
        } else {
            return "No atrapados"
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let pokemonAtrapado = pokemonsAtrapados[indexPath.row]
            crearPokemon(xnombre: pokemonAtrapado.nombre!, ximagenNombre: pokemonAtrapado.imagenNombre!)
            _=obtenerPokemonsNoAtrapados()
            let delegate  = (UIApplication.shared.delegate as! AppDelegate)
            let context = delegate.persistentContainer.viewContext
            context.delete(pokemonAtrapado)
            delegate.saveContext()
            pokemonsAtrapados = obtenerPokemonsAtrapados()
            //tableView.reloadData()
            dismiss(animated: true, completion: nil)
        }
    }
}

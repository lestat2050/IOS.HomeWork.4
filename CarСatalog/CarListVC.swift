//
//  CarListViewController.swift
//  CarСatalog
//
//  Created by Yaroslav Surovtsev on 11.07.17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import UIKit

//5) Селект ячейки производишь а деселект нет. Почему? Когда я вернулся почему ячейка все еще выделена?
//4) Нет структуры проекта. Обычно ее делают через папачки в которых разносят файлики. А не все одним скопом.
//10) if let indexPath = CarListTableView.indexPathForSelectedRow - костыль.

//У UITableViewDelegate есть метод который ответственен за это

//https://developer.apple.com/documentation/uikit/uitableviewdelegate/1614...

//вот на него и посмотри. И исправь этот ужас.

//14) cars - очень много стало понятно. То что это масси машин - я понял по типу. А вот для чего я его использую так и не понятно по названию. Лучше назвать dataSource.

//15) Вижу как минимум два повторения. Дата форматер. Почему ты его постоянно пересоздаешь? Сделай один приватный на класс. И все.

/*Как бы я это сделал.
private lazy var formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()*/

//16) Подумай как организовать шаринг между контролеров общих ресурсов. На пример DateFormatter. Для вкуривания в тему.

//Что за шаблонный код создания и добавления в массив машин во вьюдтдлоуд.
//Зачем 2 переменные создаешь лишние. Это можно вынести в функцию и просто ее вызывать 2 раза.

/*логику по выставлению данных ячейки можеш занести в метод configure(using data: Care) в классе своей ячейки. Есть еще другой путь но сейчас не будк его показывать*/

/*Andrew Seregin
 22) Ты понимаешь что делаешь в методе textFieldDidBeginEditing? Ты каждый раз пересоздаешь дата пикер и всовываешь в инпут вью. Зачем так делать? Всунь его единожды когда создается аутлет на текстфилд.
 Fri Jul 14, 2017 at 11:10 am
 Profile picture for Andrew Seregin
 Andrew Seregin
 И не забывай повторюсь о привате. Делай все приватом. Что не торчит наружу.
 */

class CarListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet private(set) weak var carListTableView: UITableView! {
        didSet {
            carListTableView.dataSource = self
        }
    }
    
    let dateFormat = DateFormatter()
    let addNewCarSegueID = "createNewCarSegue"
    let editCarSegueID = "editCarSegue"
    var cars: [Car] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let indexPath = carListTableView.indexPathForSelectedRow {
            carListTableView.deselectRow(at: indexPath, animated: true)
        }
        
        dateFormat.dateStyle = .medium
        let teslaModelS = Car(brand: "Tesla", model: "Model S", releaseDate: dateFormat.date(from: "May 17, 2012")!)
        cars.append(teslaModelS)
        let teslaModelX = Car(brand: "Tesla", model: "Model X", releaseDate: dateFormat.date(from: "Jun 14, 2013")!)
        cars.append(teslaModelX)
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //let selectedCell = tableView.cellForRow(at: IndexPath.row)
//        carListTableView.deselectRow(at: selectedCell, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath) as! CarCell
        let car = cars[indexPath.row]
        dateFormat.dateStyle = .medium
        
        cell.brandLabel.text = car.brand
        cell.modelLabel.text = car.model
        cell.releaseDateLabel.text = dateFormat.string(from: car.releaseDate)
        
        return cell
    }
    
    func onCreatedNew(car: Car) {
        cars.append(car)
        carListTableView.reloadData()
    }
    
    func refreshCarList() {
        carListTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addNewCarSegueID {
            let nextVC = segue.destination as! AddNewCarVC
            nextVC.delegate = self
        }
        
        if segue.identifier == editCarSegueID {
            if let indexPath = carListTableView.indexPathForSelectedRow {
                let nextVC = segue.destination as! AddNewCarVC
                nextVC.delegate = self
                nextVC.carForEdit = cars[indexPath.row]
            }
        }
    }
    
}

extension CarListViewController: AddNewCarDelegate {
    
}



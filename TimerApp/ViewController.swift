//
//  ViewController.swift
//  TimerApp
//
//  Created by Admin on 03/02/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var Myview: MyVIew!
    
    @IBOutlet weak var ViewConstraints: NSLayoutConstraint!
    @IBOutlet weak var TimerLabel: UILabel!
    
    @IBOutlet weak var PauseOutlet: MyButtonView!
    
    
    @IBOutlet weak var MyTableViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ViewTableView: MyVIew!
    
    @IBOutlet weak var MyTableView: UITableView!
    
    @IBOutlet weak var MyStartConstrain: NSLayoutConstraint!
    var timer : Timer?
    var seconds = 0
    var NameTextField : UITextField?
    var  tasksMO = [NSManagedObject]()
    var Names = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
   Myview.layer.cornerRadius = 20
        MyTableView.delegate = self
        MyTableView.dataSource = self
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.FetchData), userInfo: nil, repeats: true)
    }
    
    @IBAction func TasksAction(_ sender: Any) {
        ViewConstraints.constant = 0
        UIView.animate(withDuration: 0.1){
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ViewConstraints.constant  = 360
        UIView.animate(withDuration: 0.1){
            self.view.layoutIfNeeded()
        }
    }
    // dh 34an n save eldata 3ltol reload data not for one time
    @objc func FetchData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        do{
            let results = try context.fetch(request)
            tasksMO = results as! [NSManagedObject]
            for tasksm in tasksMO {
                Names.append(tasksm.value(forKey: "name") as! String)
                MyTableView.reloadData()
            }
        }
        catch{
            print ("error")
        }
    }
    
    

      
    
    
    @IBAction func StartButton(_ sender: Any) {
    MyStartConstrain.constant = 0
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
        RunTimer()
    }
    
    func TimeString(time:TimeInterval) -> String{
        
        let hours = Int(time)/3600
        let Minutes = Int(time) / 60 % 60
        let Seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours,Minutes,Seconds)
    }
    
    @objc func UpdateTime(){
        seconds += 1
        TimerLabel.text = TimeString(time: TimeInterval(seconds))
    }
    func RunTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector (ViewController.UpdateTime), userInfo: nil, repeats: true)
    }
    @IBAction func StopButton(_ sender: Any) {
   
    timer?.invalidate()
        seconds = 0
        TimerLabel.text = TimeString(time: TimeInterval(seconds))
        // i made this because when i press stop,start button enabled again to start again
        PauseOutlet.setTitle("Start", for: .normal)
         AlertController()
    }
    
    func AlertController(){
        let alerCon = UIAlertController( title: "write your task", message: "Enter your task name", preferredStyle: .alert)
        alerCon.addTextField { (NameTextField) in
            NameTextField.placeholder = "Name"
            self.NameTextField = NameTextField
            
        
        // to made an alert action called ok
        let AlertAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
            let AlertAction2 = UIAlertAction(title: "Save", style: .default, handler:{(action) in
            self.SaveDataToCoreData()
            })
            alerCon.addAction(AlertAction)
          alerCon.addAction(AlertAction2)
            self.present(alerCon, animated: true, completion: nil)
        }}
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(tasksMO[indexPath.row])
            do{
                try context.save()
                self.Names.remove(at: indexPath.row)
                MyTableView.deleteRows(at: [indexPath], with:UITableViewRowAnimation .fade)
            }catch{
                print("Error")
            }
        }
    }
    func SaveDataToCoreData(){
      let Entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context)
        let task = NSManagedObject(entity:Entity! ,insertInto :context)
          task.setValue(NameTextField?.text!, forKey: "name")
        do {
            try context.save()
            let Alertcon = UIAlertController(title: "Saved", message: "your task \(NameTextField!.text!) was saved", preferredStyle: .alert)
            let AlertAction = UIAlertAction(title: "Ok", style: .default, handler:{(action) in
                self.ViewConstraints.constant = 0
                UIView.animate(withDuration: 0.3,animations:{
                    self.view.layoutIfNeeded()
                })
            })
            Alertcon.addAction(AlertAction)
            self.present(Alertcon, animated: true, completion: nil)
            
        } catch  {
            
            let Alertcon = UIAlertController(title: "Error", message: "didn't save", preferredStyle: .alert)
            let AlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            Alertcon.addAction(AlertAction)
            self.present(Alertcon, animated: true, completion: nil)
            
            
        }
    }
    
    
    
    
    // its very easy but it has trick that i've made a pauseoutlet it makes the things easier
    @IBAction func PauseButton(_ sender: Any) {
        if PauseOutlet.titleLabel?.text == "Pause"{
            
            timer?.invalidate()
            PauseOutlet.setTitle("Start", for: .normal)
        }else if PauseOutlet.titleLabel?.text == "Start"{
       PauseOutlet.setTitle("Pause", for: .normal)
            RunTimer()
        }
    }
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return Names.count
    }
    
    
    
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        cell.textLabel?.text = Names[indexPath.row]
        return cell
    }
}
    




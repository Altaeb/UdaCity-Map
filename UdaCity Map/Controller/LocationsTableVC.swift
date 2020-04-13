//
//  LocationsTableVC.swift
//  UdaCity Map
//
//  Created by Abdalfattah Altaeb on 4/13/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import UIKit

class LocationsTableVC: UITableViewController {

    let delegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Refresh - clears and repopulates the studentLocation list in the AppDelegate
    //- Parameter sender: refresh bar button
    @IBAction func refresh(_ sender: Any) {
        self.delegate.studentLocationList.removeAll()
        NetworkUtil.queryStudentLocations{ (studentLocations, error) in
            guard let error = error else {
                guard let studentLocations = studentLocations else {
                    self.displayAlertMainQueue(MapNetworkError.studenLocations)
                    return
                }
                studentLocations.results.forEach({ (student) in
                    self.delegate.studentLocationList.append(student)
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
            self.displayAlertMainQueue(error)
        }
    }

    @IBAction func logout(_ sender: Any) {
        NetworkUtil.logoff { (deleteSession, error) in
            guard let error = error else {
                self.dismiss(animated: true, completion: nil)
                return
            }
            self.displayAlertMainQueue(error)
            return
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.studentLocationList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MapConstant.locationTableCell, for: indexPath)
        let name = delegate.studentLocationList[indexPath.row].firstName + " " + delegate.studentLocationList[indexPath.row].lastName
        let link = delegate.studentLocationList[indexPath.row].mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = link
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = delegate.studentLocationList[indexPath.row].mediaURL
        let app = UIApplication.shared
        guard let url = URL(string: urlString) else {
            return
        }
        app.open(url, options: [:], completionHandler: nil)
    }
}

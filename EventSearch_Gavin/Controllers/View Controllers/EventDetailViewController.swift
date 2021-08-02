//
//  EventDetailViewController.swift
//  EventSearch_Gavin
//
//  Created by Gavin Woffinden on 7/31/21.
//
import UIKit

class EventDetailViewController: UIViewController {
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        print("button tapped")
        guard let event = event else {return}
        if event.isFavorite == false {
            favoriteButton.setImage(UIImage(named: "redHeart"), for: .normal)
            event.isFavorite = true
            EventController.likeEvent(event: event)
            self.dismiss(animated: true)
        } else {
            event.isFavorite = false
            favoriteButton.setImage(UIImage(named: "emptyHeart"), for: .normal)
            EventController.unlikeEvent(event: event)
            self.dismiss(animated: true)
        }
        EventController.fetchFavEvents()
        DispatchQueue.main.async {
            EventSearchTableViewController.arrayOfEvents = EventSearchTableViewController.favArray
            EventSearchTableViewController.shared.updateViews()
        }
    }
    
    func updateViews() {
        guard let event = event,
              let date = event.date,
              let location = event.location,
              let name = event.name else {return}
        
        EventController.fetchImage(url: event.imageURL ?? "") { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.titleLabel.text = name
                    self.detailLabel.text = "\(location)\n\(self.formatDate(date: date))"
                    self.eventImage.addCornerRadius(15)
                    self.eventImage.image = image
                    if event.isFavorite == true {
                        self.favoriteButton.setImage(UIImage(named: "redHeart"), for: .normal)
                    } else {
                        self.favoriteButton.setImage(UIImage(named: "emptyHeart"), for: .normal)
                    }
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    func formatDate(date: String)-> String {
        var brokeDownDate: [Character] = []
        for i in date {
            brokeDownDate.append(i)
        }
        let year = String(brokeDownDate[0...3])
        var month = String(brokeDownDate[5...6])
        let day = String(brokeDownDate[8...9])
        let time = formatTime(time: String(brokeDownDate[11...15]))
        if month == "01" {
            month = "January"
        }
        if month == "02" {
            month = "February"
        }
        if month == "03" {
            month = "March"
        }
        if month == "04" {
            month = "April"
        }
        if month == "05" {
            month = "May"
        }
        if month == "06" {
            month = "June"
        }
        if month == "07" {
            month = "July"
        }
        if month == "08" {
            month = "August"
        }
        if month == "09" {
            month = "September"
        }
        if month == "10" {
            month = "October"
        }
        if month == "11" {
            month = "November"
        }
        if month == "12" {
            month = "December"
        }
        
        let finalDate = "\(month) \(day), \(year), at \(time)"
        return finalDate
    }
    func formatTime(time: String)-> String {
        var finalTime = ""
        var brokeDownTime: [Character] = []
        for i in time {
            brokeDownTime.append(i)
        }
        if brokeDownTime[0] == "0" {
            finalTime = String(brokeDownTime) + "AM"
        }
        if brokeDownTime[0...1] == ["0", "0"] {
            finalTime = "TBD"
            return finalTime
        }
        if brokeDownTime[0...1] == ["1", "0"] {
            finalTime = String(brokeDownTime) + "AM"
            return finalTime
        }
        if brokeDownTime[0...1] == ["1", "1"] {
            finalTime = String(brokeDownTime) + "AM"
            return finalTime
        }
        if brokeDownTime[0...1] == ["1", "2"] {
            finalTime = String(brokeDownTime) + "AM"
            return finalTime
        }
        if brokeDownTime[0...1] == ["1", "3"] {
            brokeDownTime[0...1] = ["0", "1"]
            finalTime = String(brokeDownTime) + "PM"
            return finalTime
        }
        if brokeDownTime[0...1] == ["1", "4"] {
            brokeDownTime[0...1] = ["0", "2"]
            finalTime = String(brokeDownTime) + "PM"
            return finalTime
        }
        if brokeDownTime[0...1] == ["1", "5"] {
            brokeDownTime[0...1] = ["0", "3"]
            finalTime = String(brokeDownTime) + "PM"
            return finalTime
        }
        if brokeDownTime[0...1] == ["1", "6"] {
            brokeDownTime[0...1] = ["0", "4"]
            finalTime = String(brokeDownTime) + "PM"
            return finalTime
        }
        if brokeDownTime[0...1] == ["1", "7"] {
            brokeDownTime[0...1] = ["0", "5"]
            finalTime = String(brokeDownTime) + "PM"
            return finalTime
        }
        if brokeDownTime[0...1] == ["1", "8"] {
            brokeDownTime[0...1] = ["0", "6"]
            finalTime = String(brokeDownTime) + "PM"
            return finalTime
        }
        if brokeDownTime[0...1] == ["1", "9"] {
            brokeDownTime[0...1] = ["0", "7"]
            finalTime = String(brokeDownTime) + "PM"
            return finalTime
        }
        if brokeDownTime[0...1] == ["2", "0"] {
            brokeDownTime[0...1] = ["0", "8"]
            finalTime = String(brokeDownTime) + "PM"
            return finalTime
        }
        if brokeDownTime[0...1] == ["2", "1"] {
            brokeDownTime[0...1] = ["0", "9"]
            finalTime = String(brokeDownTime) + "PM"
            return finalTime
        }
        if brokeDownTime[0...1] == ["2", "2"] {
            brokeDownTime[0...1] = ["1", "0"]
            finalTime = String(brokeDownTime) + "PM"
            return finalTime
        }
        if brokeDownTime[0...1] == ["2", "3"] {
            brokeDownTime[0...1] = ["1", "1"]
            finalTime = String(brokeDownTime) + "PM"
            return finalTime
        }
        if brokeDownTime[0...1] == ["2", "4"] {
            brokeDownTime[0...1] = ["1", "2"]
            finalTime = String(brokeDownTime) + "PM"
            return finalTime
        }
        return finalTime
    }
}

//
//  EventTableViewCell.swift
//  EventSearch_Gavin
//
//  Created by Gavin Woffinden on 7/31/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
static let shared = EventTableViewCell()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var heartButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventImage.addCornerRadius(15)
    }

    var event: Event? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let event = event else {return}
       
        EventController.fetchImage(url: event.imageURL ?? "") { result in
                switch result {
                case .success(let image):
                    let finalEvent = Event(name: event.name ?? "", date: event.date ?? "", location: event.location ?? "", imageURL: event.imageURL ?? "", isFavorite: event.isFavorite)
                    DispatchQueue.main.async {
                    self.titleLabel.text = finalEvent.name
                    self.locationLabel.text = finalEvent.location
                    self.timeLabel.text = self.formatDate(date: finalEvent.date ?? "")
                    self.eventImage.addCornerRadius(15)
                    self.eventImage.image = image
                        if event.isFavorite == false {
                            self.heartButton.isHidden = true
                        } else {
                            self.heartButton.isHidden = false
                            self.heartButton.addCornerRadius(17)
                            self.heartButton.imageView?.addCornerRadius(17)
                        }
                    }
                case .failure(let error):
                     print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    //2021-07-30T23:10:00
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
extension UIView {
    func addCornerRadius(_ radius: CGFloat = 10) {
            self.layer.cornerRadius = radius
        }
        
        func addRoundedCorner(_ radius: CGFloat = 5) {
            self.layer.cornerRadius = radius
        }
}


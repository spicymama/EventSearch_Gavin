//
//  EventController.swift
//  EventSearch_Gavin
//
//  Created by Gavin Woffinden on 7/31/21.
//


import UIKit
import CoreData

class EventController {
    static let shared = EventController()
    static var searchTerm = ""
    private lazy var fetchRequest: NSFetchRequest<Event> = {
        let request = NSFetchRequest<Event>(entityName: "Event")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    static func fetchEvents(completion: @escaping (Result<[Event], EventError>) -> Void) {
        var term = ""
        for i in EventController.searchTerm {
            if i == " " {
                term.append("+")
            } else {
                term.append(i)
            }
        }
        EventSearchTableViewController.arrayOfEvents = []
        var allEvents: [Event] = []
        let searchTerm = term + "&client_id=MjI3MDg3OTh8MTYyNzU4NTU5OC4wMjA5Mzc"
        let baseURL = URL(string: "https://api.seatgeek.com/2/events?q=" + searchTerm)
        guard let finalURL = baseURL else {return completion(.failure(.invalidURL))}
        print(finalURL)
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            if let response = response as? HTTPURLResponse {
                print("POST STATUS CODE: \(response.statusCode)")
            }
            guard let data = data else {return completion(.failure(.noData))}
            do {
                var nameArr: [String] = []
                var dateArr: [String] = []
                var locationArr: [String] = []
                var imageArr: [String] = []
                
                let topLevelObject = try JSONDecoder().decode(NameAndDate.self, from: data)
                let secondLevelObject = topLevelObject.events
                for nameDate in secondLevelObject {
                    let name = nameDate.name
                    nameArr.append(name)
                    
                    let date = nameDate.date
                    dateArr.append(date)
                    
                    let placeObject = try JSONDecoder().decode(Place.self, from: data)
                    let placeSecondObject = placeObject.events
                    let loc = placeSecondObject.first
                    let place = loc?.venue
                    guard let location = place?.location else {return}
                    locationArr.append(location)
                    
                    let image = try JSONDecoder().decode(Image.self, from: data)
                    let imageTopLevel = image.events
                    for pic in imageTopLevel{
                        let picURL = pic.performers
                        for i in picURL {
                            imageArr.append(i.image)
                        }
                    }
                    var count = 0
                    for _ in nameArr {
                        if count <= nameArr.count - 1 {
                            let event = Event(name: nameArr[count], date: dateArr[count], location: locationArr[count], imageURL: imageArr[count], isFavorite: true)
                            if !EventSearchTableViewController.favArray.contains(event) {
                                event.isFavorite = false
                            }
                            count += 1
                            if allEvents.count == 0 {
                                allEvents.insert(event, at: 0)
                            } else {
                                var nCount = 0
                                for i in allEvents {
                                    guard let name = event.name,
                                          let otherName = i.name,
                                          let date = event.date,
                                          let otherDate = i.date else {return}
                                    if name == otherName && date == otherDate {
                                        nCount += 1
                                    }
                                }
                                if nCount == 0 {
                                    allEvents.append(event)
                                }
                            }
                        }
                    }
                }
                completion(.success(allEvents))
                print("There are \(allEvents.count) events")
                EventSearchTableViewController.arrayOfEvents = allEvents
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchImage(url: String, completion: @escaping (Result<UIImage, EventError>)-> Void) {
        
        guard let imageURL = URL(string: url ) else {return completion(.failure(.invalidURL))}
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            if let response = response as? HTTPURLResponse {
                print("IMAGE STATUS CODE: \(response.statusCode)")
            }
            guard let data = data else {return completion(.failure(.noData))}
            guard let image = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            
            completion(.success(image))
        }.resume()
    }
    
    static func likeEvent(event: Event) {
        event.isFavorite = true
        EventSearchTableViewController.favArray.append(event)
        CoreDataStack.saveContext()
    }
    
    static func unlikeEvent(event: Event) {
        if EventSearchTableViewController.favArray.count == 1 {
            let events = (try? CoreDataStack.context.fetch(EventController.shared.fetchRequest)) ?? []
            print(events.count)
            for event in events {
                CoreDataStack.context.delete(event)
            }
        }
        for i in EventSearchTableViewController.favArray {
            if i.name == event.name {
                let events = (try? CoreDataStack.context.fetch(EventController.shared.fetchRequest)) ?? []
                print(events.count)
                for event in events {
                    if event.name == i.name {
                        CoreDataStack.context.delete(event)
                    }
                }
            }
        }
    }
    
    static func fetchFavEvents() {
        EventSearchTableViewController.favArray = []
        let events = (try? CoreDataStack.context.fetch(EventController.shared.fetchRequest)) ?? []
        print(events.count)
        for event in events {
            var nameArr: [String] = []
            var newArr: [Event] = []
            guard let name = event.name else {return}
            if !nameArr.contains(name) {
                nameArr.append(name)
                newArr.append(event)
            } else {
                CoreDataStack.context.delete(event)
                CoreDataStack.saveContext()
            }
            if event.isFavorite == true {
                EventSearchTableViewController.favArray.append(event)
            }
        }
    }
    
    func funkDuplicates() {
        var nameArr: [String] = []
        var newArr: [Event] = []
        for event in EventSearchTableViewController.arrayOfEvents {
            guard let name = event.name else {return}
            if !nameArr.contains(name) {
                nameArr.append(name)
                newArr.append(event)
            } else {
                CoreDataStack.context.delete(event)
                CoreDataStack.saveContext()
            }
        }
        EventSearchTableViewController.arrayOfEvents = newArr
    }
}


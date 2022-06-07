//
//  CoreDataManager.swift
//  WeatherProject
//
//  Created by Иван Селюк on 14.04.22.
//

import CoreData
typealias WeatherDate = (welcome: Welcome, date: Date)
class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "WeatherDataBase")
        print(NSPersistentContainer.defaultDirectoryURL())                 // путь к базе
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func addWeatherToBaseData(by weather: Welcome, source: SourceValue.RawValue, date: Date) {
        let weatherDB = WeatherDB(context: context)
        weatherDB.setValues(by: weather, source: source, date: date)
        context.insert(weatherDB)
        saveContext()
    }
   
    func getSourceFromDB(by source: String) -> [WeatherDate] {
        let request = WeatherDB.fetchRequest(with: source)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        guard let parametersWeather = try? context.fetch(request) else { return []}
        return parametersWeather.map { $0.getMappedWeather()}
    }
    
    func removeRowFromDB(by date: Date) {
        let row = WeatherDB.fetchRequestToDelete(with: date)
        guard let rowDB = try? context.fetch(row).first else { return }
        context.delete(rowDB)
        saveContext()
    }
    
    func clearDataBase() {
        let weathers = WeatherDB.fetchRequest()
        do {
            let weathersDB = try context.fetch(weathers)
            weathersDB.forEach {
                context.delete($0)
            }
           saveContext()
        } catch (let e) {
            print(e.localizedDescription)
        }
    }
    
    func saveContext () {
        let context = context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

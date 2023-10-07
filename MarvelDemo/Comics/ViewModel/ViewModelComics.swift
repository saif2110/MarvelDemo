//
//  ViewModelComics.swift
//  MarvelDemo
//
//  Created by Admin on 07/10/23.
//

import Foundation



protocol ComicAPIModelHandler {
    func onSuccess(_ data: ComicModel.Comics)
    func onFailure(_ error: String)
}

class ComicViewModel {
    var delegate:ComicAPIModelHandler?
    var data:ComicModel.Comics?
    
    private var limit = 50
    var offset = 0
    var dataCount = 0
    
    func apiRequeset(dateString:String) {
        APIRequest().callAPI(URLstring: APIURLS().comicsAPI, model: ComicModel.Comics.self,queryParameters: ["limit" : String(limit) ,"offset" : String(offset),"dateRange":dateString]) { success, data in
            
            if success {
                if let data = data {
                    
                    if self.data == nil {
                        self.data = data
                    } else {
                        self.data?.data?.results?.append(contentsOf: data.data?.results ?? [])
                    }
                    
                    self.dataCount += (data.data?.results?.count ?? 0)
                    self.delegate?.onSuccess(data)
                    self.offset += self.limit
                }else{
                    self.delegate?.onFailure(APIFAILED().APIERRORCODE2)
                }
            }else{
                self.delegate?.onFailure(APIFAILED().APIERRORCODE1)
            }
        }
    }
    
    func resetModel(){
        data = nil
        dataCount = 0
        offset = 0
    }
    
    func calculateCurrentWeekDates() -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        
        if let startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) {
            let endDate = calendar.date(byAdding: .day, value: 6, to: startDate)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            let formattedStartDate = dateFormatter.string(from: startDate)
            let formattedEndDate = dateFormatter.string(from: endDate)
            
            return formattedStartDate+","+formattedEndDate
        } else {
            // Handle error if unable to calculate dates
            return ""
        }
    }
    
    
    func calculateNextWeekDates() -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        
        if let startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) {
            let nextWeekStartDate = calendar.date(byAdding: .weekOfYear, value: 1, to: startDate)!
            let nextWeekEndDate = calendar.date(byAdding: .day, value: 6, to: nextWeekStartDate)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            let formattedStartDate = dateFormatter.string(from: nextWeekStartDate)
            let formattedEndDate = dateFormatter.string(from: nextWeekEndDate)
            
            return formattedStartDate + "," + formattedEndDate
        } else {
            // Handle error if unable to calculate dates
            return ""
        }
    }
    
    
    
    func calculateLastWeekDates() -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        
        if let startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) {
            let lastWeekStartDate = calendar.date(byAdding: .weekOfYear, value: -1, to: startDate)!
            let lastWeekEndDate = calendar.date(byAdding: .day, value: 6, to: lastWeekStartDate)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            let formattedStartDate = dateFormatter.string(from: lastWeekStartDate)
            let formattedEndDate = dateFormatter.string(from: lastWeekEndDate)
            
            return formattedStartDate + "," + formattedEndDate
        } else {
            // Handle error if unable to calculate dates
            return ""
        }
    }
    
    
    
    func calculateCurrentMonthDates() -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        guard let startOfMonth = calendar.date(from: components),
              let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) else {
            // Handle error if unable to calculate dates
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let formattedStartDate = dateFormatter.string(from: startOfMonth)
        let formattedEndDate = dateFormatter.string(from: endOfMonth)
        
        return formattedStartDate + "," + formattedEndDate
    }
    
    
    
}

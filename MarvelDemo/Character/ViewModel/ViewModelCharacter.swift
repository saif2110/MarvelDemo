//
//  ViewModel.swift
//  MarvelDemo
//
//  Created by Admin on 07/10/23.
//

import Foundation


protocol CharacterAPIModelHandler {
    func onSuccess(_ data: Characters)
    func onFailure(_ error: String)
}

class CharacterViewModel {
    var delegate:CharacterAPIModelHandler?
    var data:Characters?
    
    private var limit = 50
    var offset = 0
    var dataCount = 0
    var isSeachbarinProgress = false
    
    func apiRequeset(nameStartsWith:String = "") {
        APIRequest().callAPI(URLstring: APIURLS().charcterAPI, model: Characters.self,queryParameters: ["limit" : String(limit) ,"offset" : String(offset)],nameStartsWith: nameStartsWith) { success, data in
            
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
    
}

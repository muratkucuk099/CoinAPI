//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate : CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "3749588B-3EB4-434A-9970-1FB828A91723"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR","TRY"]
    
   
    
    func getCoinPrice(for currency : String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        let coinPrice = String(format: "%.2f", coin)
                        self.delegate?.didUpdateCoin(price: coinPrice, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            let coinTitle = decodedData.asset_id_quote
            print(lastPrice)
            
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func performRequest(urlString : String) {
        
       
    }
}


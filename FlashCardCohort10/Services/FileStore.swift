//
//  FileStore.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

import Foundation

// This our ERROR
enum FileStoreError: Error {
    case invalidDocumentDirectory
}

struct FileStore {

    // File Name
    private var fileName: String

    // Assign the file name "decks.json" to out fileName
    init(fileName: String = "decks.json") {
        self.fileName = fileName
    }

    //This functions return the URL or Location of the file that we are looking for
    private func fileURL() throws -> URL {

        // Documents/FlashcardCohort10/[missing file name at this point]
        guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileStoreError.invalidDocumentDirectory
        }
        // /Documents/FlashcardCohort10/decks.json
        return docs.appendingPathComponent(fileName)

    }

    // write data
    func save<T: Encodable>(_ value: T) throws {

        // /Documents/FlashcardCohort10/decks.json
        let url = try fileURL()
        // Grab the "value" -> Our DECKS -> and parse it into RAWDATA
        // json file
        let data = try JSONEncoder().encode(value)

        // try to save the data to the location above
        try data.write(to: url, options: .atomic)

    }

    // Generic Type = <T:Decodable> -> I dont have a specific type
    // Positional Argument = _ -> just send the data here
    // Arrow -> = Returns that type of value
    // Throws = If there is an error we handle that error by throwing something
    func load<T: Decodable>(_ type: T.Type) throws -> T {

        // /Documents/FlashcardCohort10/decks.json
        let url = try fileURL()

        // /Documents/FlashcardCohort10/decks.json
        let data = try Data(contentsOf: url)

        return try JSONDecoder().decode(T.self, from: data)

    }

}

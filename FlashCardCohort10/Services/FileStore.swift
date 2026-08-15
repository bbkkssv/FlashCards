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
        let url = try fileURL()
        let data = try JSONEncoder().encode(value)
        try data.write(to: url, options: .atomic)
    }

    func load<T: Decodable>(_ type: T.Type) throws -> T {
        let url = try fileURL()
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }

}

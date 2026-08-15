//
//  FileStore.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

// Foundation gives us FileManager, URL, Data, JSONEncoder, JSONDecoder
import Foundation

// MARK: - Error type

// A custom Error enum for FileStore.
// When something goes wrong we throw one of these cases instead of crashing.
// 'invalidDocumentDirectory' means the device couldn't find its Documents folder
// (very rare, but we handle it gracefully).
enum FileStoreError: Error {
    case invalidDocumentDirectory
}

// MARK: - FileStore

// FileStore is a lightweight service responsible for ONE thing:
// reading and writing any Codable value to a JSON file on disk.
// It is generic — it works for [Deck], [Flashcard], or any other Codable type.
struct FileStore {

    // The name of the file we will read/write inside the Documents folder
    // e.g. "decks.json"
    private var fileName: String

    // Initializer — defaults to "decks.json" so most callers don't need to pass anything
    init(fileName: String = "decks.json") {
        self.fileName = fileName
    }

    // MARK: - Private helper

    // fileURL() builds the full path to our file on disk.
    // Path looks like: /var/mobile/.../Documents/decks.json
    // It throws FileStoreError.invalidDocumentDirectory if the
    // Documents folder can't be located (defensive coding).
    private func fileURL() throws -> URL {

        // FileManager.default.urls returns an array of matching directories.
        // .documentDirectory = the app's private Documents folder on the device
        // .userDomainMask    = limit the search to the current user's space
        // .first             = grab the first (and usually only) result
        // If the array is empty, we throw our custom error
        guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileStoreError.invalidDocumentDirectory
        }

        // Append the file name to get the full path, e.g.:
        // /var/mobile/.../Documents/decks.json
        return docs.appendingPathComponent(fileName)
    }

    // MARK: - Save

    // save() takes ANY Encodable value (our [Deck] array, for example),
    // converts it to raw JSON bytes, and writes those bytes to disk.
    // <T: Encodable> means "T can be any type as long as it is Encodable"
    func save<T: Encodable>(_ value: T) throws {

        // Step 1 — get the file path to write to
        let url = try fileURL()

        // Step 2 — convert our Swift value into raw JSON bytes (Data)
        // JSONEncoder().encode() does the Encodable -> JSON conversion
        let data = try JSONEncoder().encode(value)

        // Step 3 — write the bytes to disk
        // .atomic means the OS writes to a temp file first, then swaps it in —
        // this prevents a corrupt file if the app crashes mid-write
        try data.write(to: url, options: .atomic)
    }

    // MARK: - Load

    // load() reads raw JSON bytes from disk and converts them back into a Swift value.
    // <T: Decodable> = T can be any type as long as it is Decodable
    // (_ type: T.Type) = caller tells us what type to decode INTO, e.g. [Deck].self
    // throws -> T = returns the decoded value or throws an error
    func load<T: Decodable>(_ type: T.Type) throws -> T {

        // Step 1 — get the file path to read from
        let url = try fileURL()

        // Step 2 — read the raw JSON bytes from disk
        // Data(contentsOf:) throws if the file doesn't exist yet (first launch)
        let data = try Data(contentsOf: url)

        // Step 3 — convert the raw bytes back into our Swift type
        // JSONDecoder().decode() does the JSON -> Decodable conversion
        return try JSONDecoder().decode(T.self, from: data)
    }

}

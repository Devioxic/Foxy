//
//  DataBase.swift
//  Foxy
//
//  Created by Tilly Persson on 2025-03-17.
//

import Foundation
import SQLite3


class DataBase {
    static let shared = DataBase()
    
    private var db: OpaquePointer?
    
    private init() {
        db = openDatabase()
        
        createArtistsTable()
        createAlbumsTable()
        createTracksTable()
    }
    
    private func openDatabase() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("database.sqlite")
        
        var db: OpaquePointer?
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("Error opening DB")
            return nil
        } else {
            return db
        }
    }
    
    private func createTable(createTableString: String) {
        var createTableStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Table Created")
            } else {
                print("Table could not be created")
            }
        }
        
        sqlite3_finalize(createTableStatement)
    }
    
    private func query(queryString: String, handler: ([String: Any]) -> Void) {
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                var row = [String: Any]()
                for columnIndex in 0..<sqlite3_column_count(queryStatement) {
                    let columnName = String(cString: sqlite3_column_name(queryStatement, columnIndex))
                    switch sqlite3_column_type(queryStatement, columnIndex) {
                    case SQLITE_INTEGER:
                        row[columnName] = sqlite3_column_int(queryStatement, columnIndex)
                    case SQLITE_FLOAT:
                        row[columnName] = sqlite3_column_double(queryStatement, columnIndex)
                    case SQLITE_TEXT:
                        row[columnName] = String(cString: sqlite3_column_text(queryStatement, columnIndex))
                    case SQLITE_BLOB:
                        row[columnName] = sqlite3_column_blob(queryStatement, columnIndex)
                    case SQLITE_NULL:
                        row[columnName] = nil
                    default:
                        row[columnName] = nil
                    }
                }
                handler(row)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
    }
    
    private func createArtistsTable() {
        let createString = """
        CREATE TABLE `Artists` (
            `id` VARCHAR(255) NOT NULL,
            `name` VARCHAR(255) NOT NULL,
            `blurHash` VARCHAR(255),
            PRIMARY KEY (`id`)
        );
        """
     
        createTable(createTableString: createString)
    }
    
    private func createAlbumsTable() {
        let createString = """
        CREATE TABLE `Albums` (
            `id` VARCHAR(255) NOT NULL,
            `title` VARCHAR(255) NOT NULL,
            `imageBlurHash` VARCHAR(255),
            `year` INT NOT NULL,
            `premiereDate` DATE NOT NULL,
            `artist` VARCHAR(255) NOT NULL,
            `artistId` VARCHAR(255) NOT NULL,
            PRIMARY KEY (`id`),
            FOREIGN KEY (`artistId`) REFERENCES `Artists`(`id`)
        );
        """
        
        createTable(createTableString: createString)
    }
    
    private func createTracksTable() {
        let createString = """
        CREATE TABLE `Tracks` (
            `id` VARCHAR(255) NOT NULL,
            `title` VARCHAR(255) NOT NULL,
            `artist` VARCHAR(255) NOT NULL,
            `artistId` VARCHAR(255) NOT NULL,
            `albumId` VARCHAR(255) NOT NULL,
            `hasLyrics` BOOLEAN NOT NULL,
            `isDownloaded` BOOLEAN NOT NULL,
            `duration` INT NOT NULL,
            `favourite` BOOLEAN NOT NULL,
            PRIMARY KEY (`id`),
            FOREIGN KEY (`albumId`) REFERENCES `Albums`(`id`),
            FOREIGN KEY (`artistId`) REFERENCES `Artists`(`id`)
        );
        """
        
        createTable(createTableString: createString)
    }
    
    func getArtistById(id: String) -> Artist? {
        var artist: Artist? = nil
        var albumIds: [String] = []
        
        query(queryString: "SELECT * FROM Albums WHERE artistId = '\(id)'") { row in
            guard var id = row["id"] as? String else { return }
            albumIds.append(id)
        }
        
        query(queryString: "SELECT * FROM Artists WHERE id = '\(id)' LIMIT 1';") { row in
            guard let id = row["id"] as? String, let name = row["name"] as? String else { return }
            let blurHash = row["blurHash"] as? String
            
            artist = Artist(id: id, name: name, blurHash: blurHash, albumIds: albumIds)
        }
        
        return artist
    }
    
}

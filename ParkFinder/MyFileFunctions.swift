//
//  MyFileFunctions.swift
//  ParkFinder
//
//  Created by Luke Schwarting on 4/10/17.
//  Copyright © 2017 Luke Schwarting. All rights reserved.
//

import Foundation
import UIKit

//making the funcs a class extensions
extension FileManager
{
    //returns full path of the documents directory that our app is allowed to write files to
    //gets us the path to the documents folder directory
    static var documentsDirectory:URL
    {
        //FileManager.default is a singleton
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
    }

    //gets us the path to the tmp directory
    static var tempDirectory:String
    {
        return NSTemporaryDirectory()
    }

    //get us the path to the Library/Caches directory
    static var cachesDirectory:URL
    {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as URL
    }
    
    //helper methode use this both for reading AND writing to the Documents directory
    static func filePathInDocumentsDirectory(fileName:String)->URL{
        //pass in a file name and get back a full path to that file in the Documents folder
        return FileManager.documentsDirectory.appendingPathComponent(fileName)
    }
    
    static func fileExistsInDocumentsDirectory(fileName:String)->Bool
    {
        let path = filePathInDocumentsDirectory(fileName: fileName).path
        return FileManager.default.fileExists(atPath:path)
    }
    
    static func deleteFileInDocumentsDirectory(fileName:String)
    {
        let path = filePathInDocumentsDirectory(fileName: fileName).path
        do{
            try FileManager.default.removeItem(atPath: path)
            print("FILE: \(path) was deleted!")
        }catch{
            print("ERROR: \(error) - FOR FILE: \(path)")
        }
    }
    
    static func contentsOfDir(url:URL)->[String]
    {
        do{
            if let paths = try FileManager.default.contentsOfDirectory(atPath: url.path) as [String]?
            {
                return paths
            }
            else
            {
                print("none found")
                return [String]() //return empty array of Strings
            }
        } catch{
            print("ERROR: \(error)")
            return [String]() //return empty array of Strings on error
        }
    }
    
    static func clearDocumentsFolder()
    {
        let fileManager = FileManager.default
        let docsFolderPath = FileManager.documentsDirectory.path
        do{
            let filePaths = try fileManager.contentsOfDirectory(atPath: docsFolderPath)
            for filePath in filePaths
            {
                try fileManager.removeItem(atPath: docsFolderPath + "/" + filePath)
            }
            print("Cleared Documents folder")
        } catch{
            print("Could not clear Documents folder: \(error)")
        }
    }
}

//make extensions for UIImage
extension UIImage
{
    //lib function
    //uses UIImagePNGRepresentation to get binary PNG rep of a UIImage and the saves it to disk
    func saveImageAsPNG(url:URL)
    {
        let pngData = UIImagePNGRepresentation(self)
        do{
            try pngData?.write(to: url)
        }catch{
            print("ERROR: saving \(url) - error = \(error)")
        }
    }
}

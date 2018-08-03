//
//  ViewController.swift
//  filemanager
//
//  Created by ibrahimdn on 31.12.2017.
//  Copyright © 2017 ibrahimdn. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase
import FirebaseStorage
import FirebaseDatabase



class ViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
       //list()
        list2()
        //list3()
       // list4()
      
    }
    
    
    @IBAction func copyFile(_ sender: UIButton) {
        // Get app bundle file url
        guard let bundleFileUrl = Bundle.main.url(forResource: "Movie", withExtension: "mov") else { return }
        
        // Create a destination url in document directory for file
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let documentDirectoryFileUrl = documentsDirectory.appendingPathComponent("Movie.mov")
        
        // Copy bundle file to document directory
        if !FileManager.default.fileExists(atPath: documentDirectoryFileUrl.path) {
            do {
                try FileManager.default.copyItem(at: bundleFileUrl, to: documentDirectoryFileUrl)
            } catch {
                print("Could not copy file: \(error)")
            }
        }
    }
    
    @IBAction func displayUrls(_ sender: UIButton) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
            
            // Print the urls of the files contained in the documents directory
            print(directoryContents) // may print [] or [file:///private/var/mobile/Containers/Data/Application/.../Documents/Movie.mov]
        } catch {
            print("Could not search for urls of files in documents directory: \(error)")
        }
    }
    
}
    
    
    func list2 (){
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsUrl)
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            print("dosya pathi")
            print(directoryContents)
            print(directoryContents[0])
            
            let pdfFiles2 = directoryContents.flatMap({$0.lastPathComponent})
            print("\n \n PDF FİLES 2 ")
            print(pdfFiles2)
            
            // if you want to filter the directory contents you can do like this:
            let pdfFiles = directoryContents.filter{ $0.pathExtension == "pdf" }
            print("pdfFiles")
            print(pdfFiles)
            
          //  let urlSt : String = URL! ()
            
         
            let pdfFileNames = pdfFiles.map{ $0.deletingPathExtension().lastPathComponent }
            print("pdf File Name")
            print( pdfFileNames)
            
          //  let filedata : NSData =
            
            let mediaResim = Storage.storage().reference().child("pdf1")
            mediaResim.putFile(from: pdfFiles[0]).observe(.success, handler: { (snap) in
                let downURL = snap.metadata?.downloadURL()?.absoluteString
                let dbref = Database.database().reference().child("pdf1")
                dbref.setValue(downURL)
                
            })
           // mediaResim.putFile(from: pdfFiles[0], metadata: nil)
            
            
        } catch {
            print(error.localizedDescription)
        }
}
        func list3(){
         
            let localFile = URL(string: "file:///Users/ibrahimdn/Library/Developer/CoreSimulator/Devices/CD7D2A3A-5863-4E01-874A-344C9668DD39/data/Containers/Data/Application/83D1F35D-21CC-49E3-86AA-BAF65BA2E6CE/Documents/1.pdf")!
            
            let storageRef = Storage.storage().reference()

            // Create a reference to the file you want to upload
            let riversRef = storageRef.child("pdf")
            
            // Upload the file to the path "images/rivers.jpg"
            let uploadTask = riversRef.putFile(from: localFile, metadata: nil) { metadata, error in
                if let error = error {
                    print("HATA")
                    print(error.localizedDescription)
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    let downloadURL = metadata!.downloadURL()
                }
            }
         

        }
func list4(){
    
    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    do {
        // Get the directory contents urls (including subfolders urls)
        let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
        for item in directoryContents
        {
            let itemString = item.path
            if itemString.hasSuffix("pdf")
            {
                let storageRef = Storage.storage().reference()
                
                // Create a reference to the file you want to upload
                let riversRef = storageRef.child("pdf")
                
                // Upload the file to the path "images/rivers.jpg"
                let uploadTask = riversRef.putFile(from: item.path as! URL, metadata: nil) { metadata, error in
                    if let error = error {
                        print("HATA")
                        print(error.localizedDescription)
                    } else {
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        let downloadURL = metadata!.downloadURL()
                    }
                }

            }
           
            
        }
      

    }catch{
        
    }
    
}




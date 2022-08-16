//
//  DownloadTask.swift
//  filedownload
//
//  Created by admin on 16/08/22.
//

import SwiftUI

class DownloadTask: NSObject, ObservableObject,URLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate {
    @Published var  downLoadURL : URL!
    
     // MARK: - alert
    @Published var  alertMessage = ""
    @Published var  showAlert = false

     // MARK: - store the ref to delete
    
    @Published var downloadtaskSession : URLSessionDownloadTask!
    
    
    @Published var downloadProgress : CGFloat = 0
    
  
     // MARK: - DOWNLOAD FUNCTION
    
    func StartDownload (urlString:String)  {
        
        guard let ValidURL = URL(string: urlString)else{
            self.reportError(error: "Invalid url")
            return
        }
        //valid url
        
        
         // MARK: - download task
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        downloadtaskSession = session.downloadTask(with: ValidURL)
        downloadtaskSession.resume()
    }
    
     // MARK: - report error
    func reportError(error:String) {
        alertMessage = error
        showAlert.toggle()
    }
    
     // MARK: - implimenting url session functions
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        //print(location)
        guard let url = downloadTask.originalRequest?.url else {
            self.reportError(error: "something went wrong please try again later")
            return
        }
        // directory path
        let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // creating one for storing file
        //destination url
        
        let destinationURL = directoryPath.appendingPathComponent(url.lastPathComponent)
     
        
        // if already exists then try remove that
        
        try?FileManager.default.removeItem(at: destinationURL)
        do{
            
            // copy temp file to dir
            
           try FileManager.default.copyItem(at: location, to: destinationURL)
            
            // if success
            print("Success")
            
            
            DispatchQueue.main.async {
                
            
            
            // presenting the file with document intraction controller from UIKIT
            
            let controller = UIDocumentInteractionController(url: destinationURL)
            
            controller.delegate = self
            controller.presentPreview(animated: true)
            }
            
        }catch{
            
            self.reportError(error: "Please try agaiin later")
        }
        
        
        
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
         // MARK: - getting the progress
        
        let progress = CGFloat(totalBytesWritten)/CGFloat(totalBytesExpectedToWrite )
        
        //print(progress)
        
        DispatchQueue.main.async {
            self.downloadProgress = progress
        }
        
    }
    
    
    // sub function for presenting the view
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
    
        return UIApplication.shared.windows.first!.rootViewController!
    
    }
    
}


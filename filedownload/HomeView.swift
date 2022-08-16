//
//  HomeView.swift
//  filedownload
//
//  Created by admin on 16/08/22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var downloadTask = DownloadTask()
    @State var urlText = ""
    
    var body: some View {
        
        NavigationView{
            VStack(spacing:15){
                // // MARK: -   text field
                TextField("URL",text:$urlText)
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: -5, y: -5)
                    .padding()
                
                 // MARK: - button
                Button(action: {
                    downloadTask.StartDownload(urlString: urlText)
                }, label: {
                    Text("Download URL")
                        .fontWeight(.semibold)
                        .padding(.vertical,10)
                        .padding(.horizontal,30)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(Capsule())
                    
                });
            }
             // MARK: - nav bar title
            .navigationTitle("Download Task")
            
        }
        .preferredColorScheme(.light)
        .alert(isPresented: $downloadTask.showAlert, content: {
            
            Alert(title:Text("Messsage"),message: Text(downloadTask.alertMessage),dismissButton:
                    .destructive(Text("Ok"), action: {})
            
            )
        })
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

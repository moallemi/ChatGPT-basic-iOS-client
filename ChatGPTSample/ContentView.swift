//
//  ContentView.swift
//  ChatGPTSample
//
//  Created by Reza Moallemi on 2023-03-30.
//

import SwiftUI

struct ContentView: View {
  @State private var messages: [ChatMessage] = []
  @State private var text: String = ""
  
  var body: some View {
    VStack {
      ScrollView {
        LazyVStack {
          ForEach(messages) { message in
            MessageView(chatMessage: message)
              .contextMenu {
                if let codeSection = extractCodeSection(from: message.text) {
                  Button(action: {
                    UIPasteboard.general.string = codeSection
                  }) {
                    Text("Copy Code Section")
                    Image(systemName: "doc.on.doc")
                  }
                }
              }
          }
        }
      }
      .padding(.top)
      
      HStack {
        TextField("Type your message here...", text: $text)
          .padding()
          .background(Color(white: 0.9))
          .cornerRadius(12)
        
        Button(action: sendMessage) {
          Image(systemName: "arrow.up.circle.fill")
            .font(.system(size: 30))
            .padding(.trailing)
        }
      }
      .padding()
    }
  }
  
  func sendMessage() {
    let message = ChatMessage(text: text, isUser: true)
    messages.append(message)
    
    requestChatResponse(previousMessages: messages, newUserMessage: text) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let response):
          let aiMessage = ChatMessage(text: response.trimmingCharacters(in: .whitespacesAndNewlines), isUser: false)
          messages.append(aiMessage)
        case .failure(let error):
          let errorMessage = ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false)
          messages.append(errorMessage)
        }
      }
    }
    
    text = ""
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




//
//  ChatMessage.swift
//  ChatGPTSample
//
//  Created by Reza Moallemi on 2023-03-30.
//

import Foundation
import SwiftUI

struct ChatMessage: Identifiable, Hashable {
  var id = UUID()
  var text: String
  var isUser: Bool
}

struct MessageView: View {
  var chatMessage: ChatMessage
  
  var body: some View {
    HStack {
      if chatMessage.isUser {
        Spacer()
        Text(chatMessage.text)
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(12)
      } else {
        Text(chatMessage.text)
          .padding()
          .background(Color.gray)
          .foregroundColor(.white)
          .cornerRadius(12)
        Spacer()
      }
    }.padding(.horizontal)
  }
}

//
//  API.swift
//  ChatGPTSample
//
//  Created by Reza Moallemi on 2023-03-30.
//

import Foundation

import Alamofire

func requestChatResponse(previousMessages: [ChatMessage], newUserMessage: String, completion: @escaping (Result<String, Error>) -> Void) {
  let headers: HTTPHeaders = [
    "Authorization": "Bearer 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"
  ]
  
  let systemMessage: [String: Any] = [
    "role": "system",
    "content": "You are talking to an AI trained to provide helpful information and answer questions."
  ]
  
  let userMessages = previousMessages.map { message -> [String: Any] in
    return [
      "role": message.isUser ? "user" : "assistant",
      "content": message.text
    ]
  }
  
  let newUserMessageObject: [String: Any] = [
    "role": "user",
    "content": newUserMessage
  ]
  
  let messages = [systemMessage] + userMessages + [newUserMessageObject]
  
  let parameters: [String: Any] = [
    "model": "gpt-3.5-turbo",
    "messages": messages
  ]
  
  AF.request("https://api.openai.com/v1/chat/completions",
             method: .post,
             parameters: parameters,
             encoding: JSONEncoding.default,
             headers: headers)
  .validate()
  .responseDecodable(of: OpenAIResponse.self) { response in
    switch response.result {
    case .success(let result):
      if let responseText = result.choices.first?.text {
        completion(.success(responseText.trimmingCharacters(in: .whitespacesAndNewlines)))
      } else {
        completion(.failure(NSError(domain: "No response", code: -1, userInfo: nil)))
      }
    case .failure(let error):
      completion(.failure(error))
    }
  }
}

struct OpenAIResponse: Decodable {
  let id: String
  let object: String
  let created: Int
  let model: String
  let usage: OpenAIUsage
  let choices: [OpenAIChoice]
}

struct OpenAIChoice: Decodable {
  let message: OpenAIMessage
  let finish_reason: String
  let index: Int
  
  var text: String {
    return message.content
  }
}

struct OpenAIMessage: Decodable {
  let role: String
  let content: String
}

struct OpenAIUsage: Decodable {
  let prompt_tokens: Int
  let completion_tokens: Int
  let total_tokens: Int
}


func extractCodeSection(from text: String) -> String? {
  if let startRange = text.range(of: "```"),
     let endRange = text.range(of: "```", range: startRange.upperBound..<text.endIndex) {
    return String(text[startRange.upperBound..<endRange.lowerBound])
  }
  return nil
}



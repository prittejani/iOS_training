//
//  emailHelper.swift
//  Demo_1
//
//  Created by iMac on 28/05/24.
//

import Foundation


struct Email: Encodable {
    let personalizations: [Personalization]
    let from: EmailAddress
    let subject: String
    let content: [Content]
}

struct Personalization: Encodable {
    let to: [EmailAddress]
}

struct EmailAddress: Encodable {
    let email: String
    let name: String?
}

struct Content: Encodable {
    let type: String
    let value: String
}

class SendGridService {
    private let apiKey = "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"
    private let sendGridURL = "https://api.sendgrid.com/v3/mail/send"
    
    
    func sendEmail(to recipient: String, subject: String, body: String) {
        let email = Email(
            personalizations: [Personalization(to: [EmailAddress(email: recipient, name: nil)])],
            from: EmailAddress(email: "20191411210360@amrolicollege.com", name: "Prit"),
            subject: subject,
            content: [Content(type: "text/plain", value: body)]
        )
        
        guard let url = URL(string: sendGridURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(email)
            request.httpBody = jsonData
        } catch {
            print("Failed to encode email: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to send email: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                print("Email sent successfully")
            } else {
                if let data = data, let errorResponse = String(data: data, encoding: .utf8) {
                    print("Failed to send email: \(errorResponse)")
                } else {
                    print("Failed to send email with status code: \(httpResponse.statusCode)")
                }
            }
        }
        
        task.resume()
    }
}

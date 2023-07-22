//
//  PasswordResetService.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-21.
//

import Combine
import Foundation
import FirebaseAuth

protocol PasswordResetService {
    func sendPasswordReset(to email: String) -> AnyPublisher<Void, Error>
}

final class PasswordResetServiceImpl : PasswordResetService {
    func sendPasswordReset(to email: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Future {
                promise in
                
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let err = error {
                        promise(.failure(err))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

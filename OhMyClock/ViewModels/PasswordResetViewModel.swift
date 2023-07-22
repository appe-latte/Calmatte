//
//  PasswordResetViewModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-21.
//

import Combine
import Foundation

protocol PasswordResetViewModel {
    func sendPasswordReset()
    var service : PasswordResetService { get }
    var email : String { get }
    init(service: PasswordResetService)
}

final class PasswordResetViewModelImpl : ObservableObject, PasswordResetViewModel {
    @Published var email : String = ""
    
    let service : PasswordResetService
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: PasswordResetService) {
        self.service = service
    }
    
    func sendPasswordReset() {
        service.sendPasswordReset(to: email).sink { res in
            switch res {
            case .failure(let err):
                print("Failed: \(err)")
            default: break
            }
        } receiveValue: {
            print("Password reset request sent")
        }
        .store(in: &subscriptions)
    }
}

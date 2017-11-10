//
//  HomeInteractor.swift
//  Base
//
//  Created by Mark Evans on 3/31/17.
//  Copyright © 2017 3Advance, LLC. All rights reserved.
//

import Foundation

class HomeInteractor: HomeUseCase  {

    weak var output: HomeInteractorOutput!

    func getUser() {
        ClientService.shared.getUser { (success, error) in
            guard let err = error else {
                if let user = success as? User {
                    ClientService.shared.currentUser = user
                    self.output.getUser(user)
                }
                return
            }
            self.output.getUserFailed(err)
        }
    }

    func logoutUser() {
        ClientService.shared.logoutUser { (success) in
            self.output.userLoggedOut()
        }
    }

    func showPermissions() {
        if Constants.shared.permissionsDialogEnabled {
            Constants.shared.permissionsDialogEnabled = false
            self.output.showPermissions(true)
        }
    }

}

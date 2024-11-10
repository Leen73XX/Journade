//
//  authenticateWithFaceID.swift
//  Journade_appstore_copy
//
//  Created by Leen Almejarri on 05/05/1446 AH.
//

//import Foundation
//import LocalAuthentication

//func authenticateWithFaceID(completion: @escaping (Bool) -> Void) {
//    let context = LAContext()
//    var error: NSError?
//
//    // Check if Face ID is available
//    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to view your journal entry") { success, authenticationError in
//            DispatchQueue.main.async {
//                if success {
//                    completion(true)
//                } else {
//                    completion(false)
//                    print("Authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
//                }
//            }
//        }
//    } else {
//        print("Face ID not available: \(error?.localizedDescription ?? "Unknown error")")
//        completion(false)
//    }
//}

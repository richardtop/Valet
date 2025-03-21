//  Created by Dan Federman on 9/18/17.
//  Copyright © 2017 Square, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation


@objc(VALSecureEnclaveAccessControl)
public enum SecureEnclaveAccessControl: Int, CustomStringConvertible, Equatable, Sendable {
    /// Access to keychain elements requires user presence verification via Touch ID, Face ID, or device Passcode. On macOS 10.15 and later, this element may also be accessed via a prompt on a paired watch. Keychain elements are still accessible by Touch ID even if fingers are added or removed. Touch ID does not have to be available or enrolled.
    case userPresence = 1
    
    /// Access to keychain elements requires user presence verification via Face ID, or any finger enrolled in Touch ID. Keychain elements remain accessible via Face ID or Touch ID after faces or fingers are added or removed. Face ID must be enabled with at least one face enrolled, or Touch ID must be available and at least one finger must be enrolled.
    case biometricAny
    
    /// Access to keychain elements requires user presence verification via the face currently enrolled in Face ID, or fingers currently enrolled in Touch ID. Previously written keychain elements become inaccessible when faces or fingers are added or removed. Face ID must be enabled with at least one face enrolled, or Touch ID must be available and at least one finger must be enrolled.
    case biometricCurrentSet
    
    /// Access to keychain elements requires user presence verification via device Passcode.
    case devicePasscode
    
    // MARK: CustomStringConvertible
    
    public var description: String {
        switch self {
        case .userPresence:
            /*
             VALSecureEnclaveValet v1.0-v2.0.7 used UserPresence without a suffix – the concept of a customizable AccessControl was added in v2.1.
             For backwards compatibility, do not append an access control suffix for UserPresence.
             */
            return ""
        case .biometricAny:
            return "_AccessControlTouchIDAnyFingerprint"
        case .biometricCurrentSet:
            return "_AccessControlTouchIDCurrentFingerprintSet"
        case .devicePasscode:
            return "_AccessControlDevicePasscode"
        }
    }
    
    // MARK: Internal Properties
    
    var secAccessControl: SecAccessControlCreateFlags {
        switch self {
        case .userPresence:
            .userPresence
        case .biometricAny:
            if #available(watchOS 4.3, macOS 10.13.4, *) {
                .biometryAny
            } else {
                .touchIDAny
            }
        case .biometricCurrentSet:
            if #available(watchOS 4.3, macOS 10.13.4, *) {
                .biometryCurrentSet
            } else {
                .touchIDCurrentSet
            }
        case .devicePasscode:
            .devicePasscode
        }
    }

    static func allValues() -> [SecureEnclaveAccessControl] {
        [
            .userPresence,
            .devicePasscode,
            .biometricAny,
            .biometricCurrentSet,
        ]
    }
}

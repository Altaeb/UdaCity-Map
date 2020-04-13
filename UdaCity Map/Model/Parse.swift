//
//  Parse.swift
//  UdaCity Map
//
//  Created by Abdalfattah Altaeb on 4/13/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import Foundation

class Parse {
    enum ParseError : Error {
        case nilUserSession
        case nilStudentLocations
        case nilDeleteSession
    }

    class func userSession(_ userSessionData: Data?, completion: (_ userSession: UserSession?, _ error: Error?) -> Void) {

        guard let userSessionData = userSessionData else {
            completion(nil, ParseError.nilUserSession)
            return
        }
        let userSessionDecoder = JSONDecoder()
        do {
            let userSession = try userSessionDecoder.decode(UserSession.self, from: userSessionData)
            completion(userSession, nil)
        } catch {
            completion(nil, error)
        }
    }

    class func deleteUserSession(_ deleteUserData: Data?, completion: (_ session: DeleteSession?, _ error: Error?) -> Void) {
        guard let deleteUserData = deleteUserData else {
            completion(nil, ParseError.nilDeleteSession)
            return
        }
        let sessionDecoder = JSONDecoder()
        do {
            let deleteSession = try sessionDecoder.decode(DeleteSession.self, from: deleteUserData)
            completion(deleteSession, nil)
        } catch {
            completion(nil, error)
        }
    }

    class func studentLocation(_ studentLocationData: Data?, completion: (_ studentLocations: StudentLocations?, _ error: Error?) -> Void) {
        guard let studentLocationData = studentLocationData else {
            completion(nil, ParseError.nilStudentLocations)
            return
        }
        let studentLocationsDecoder = JSONDecoder()
        do {
            let studentLocations = try studentLocationsDecoder.decode(StudentLocations.self, from: studentLocationData)
            completion(studentLocations, nil)
        } catch {
            completion(nil, error)
        }
    }

    class func studentLocationPost (_ locationPosting: Data?, completion: (_ locationPosting: PostLocation?, _ error: Error?) -> Void) {
        guard let locationPosting = locationPosting else {return}

        let locationPostDecoder = JSONDecoder()
        do {
            let locationPosting = try locationPostDecoder.decode(PostLocation.self, from: locationPosting)
            completion(locationPosting, nil)
        } catch {
            completion(nil, error)
        }
    }

    class func userInfo (_ userInfo: Data?, completion: (_ user: User?, _ error: Error?) -> Void) {
        guard let userInfo = userInfo else {return}
        let userDecoder = JSONDecoder()
        do {
            let user = try userDecoder.decode(User.self, from: userInfo)
            completion(user, nil)
        } catch {
            completion(nil, error)
            print("parse error", error)
        }
    }
}

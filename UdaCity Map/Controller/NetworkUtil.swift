//
//  NetworkUtil.swift
//  UdaCity Map
//
//  Created by Abdalfattah Altaeb on 4/13/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import UIKit


enum ResponseTag {
    case login
    case studentLocations
    case addLocation
    case logoff
    case getUserInfo
}

enum MapNetworkError: Error, LocalizedError {
    case invalidUrl
    case studenLocations
    case deleteSessionError
    case postLocationFailure
    public var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return NSLocalizedString("URL is no longer valid", comment: "MapNetworkErrotType")
        case .studenLocations:
            return NSLocalizedString("Student Locations not available", comment: "StudentLocationError")
        case .deleteSessionError:
            return NSLocalizedString("Logoff not acknowledged by server", comment: "LogOffError")
        case .postLocationFailure:
            return NSLocalizedString("Location post failure", comment: "PostLocationError")
        }

    }
}

class NetworkUtil {

    class func buildTask(_ request: URLRequest,
                   _ responseTag: ResponseTag,
                   _ responseType: Any?,
                   completion: @escaping (Any?, Error?) -> Void) {

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)

            switch responseTag {
            case ResponseTag.login:
                Parse.userSession(newData) { (userSession, error) in
                    if let userSession = userSession {
                        completion(userSession, nil)
                    } else {
                        if let error = error {
                            completion(nil, error)
                        }
                    }
                }
            case ResponseTag.studentLocations:
                Parse.studentLocation(data) { (studentLocations, error) in
                    if let studentLocations = studentLocations {
                        completion(studentLocations, nil)

                    } else {
                        if let error = error {
                            completion(nil, error)
                        }
                    }
                }
            case ResponseTag.addLocation:
                Parse.studentLocationPost(data) { (postLocationResult, error) in
                    if let postLocationResult = postLocationResult {
                        completion(postLocationResult, nil)
                    } else {
                        completion(nil, error)
                    }
                }
            case ResponseTag.logoff:
                Parse.deleteUserSession(newData) { (session, error) in
                    if let session = session {
                        completion(session, nil)
                    } else {
                        completion(nil, error)
                    }
                }
            case ResponseTag.getUserInfo:
                Parse.userInfo(newData, completion: { (user, error) in
                    if let user = user {
                        completion(user, nil)
                    } else {
                        completion(nil, error)
                    }
                })
            }

        }
        task.resume()
    }
    class func getName(key: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/" + key)!)
            NetworkUtil.buildTask(request, ResponseTag.getUserInfo, User.self) { (user, error) in
                guard let error = error else {
                    guard let user = user as? User else {
                        completion(nil, MapNetworkError.invalidUrl)
                        return
                    }
                    DispatchQueue.main.async {
                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        delegate.user = User(firstName: user.firstName, lastName: user.lastName)
                    }
                    completion(user, nil)
                    return
                }
                completion(nil, error)
                return
            }
    }

    class func login(credentials: [String: String],
               completion: @escaping (_ userSession: UserSession?, _ error: Error?) -> Void) {
        if let loginUrl = URL(string: MapConstant.Network.sessionURL) {
            var request = URLRequest(url: loginUrl)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let requestEncoder = JSONEncoder()

            let credentials = Credentials(username: credentials["account"] ?? "", password: credentials["password"] ?? "")
            let loginData = LoginData(credentials: credentials)

            do {
                let body = try requestEncoder.encode(loginData)
                request.httpBody = body
                NetworkUtil.buildTask(request, ResponseTag.login, UserSession.self) { (userSession, error) in
                    guard let error = error else {
                    DispatchQueue.main.async {
                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        delegate.currentUserSession = userSession as? UserSession
                    }
                    completion(userSession as? UserSession, nil)
                        return
                }
                    completion(nil, error)
                }
            } catch {
                completion(nil, error)
            }
        }
    }

    class func logoff(completion: @escaping (_ deleteSession: DeleteSession?, _ error: Error?) -> Void) {
        guard let logoffUrl = URL(string: MapConstant.Network.sessionURL) else {return}
        var request = URLRequest(url: logoffUrl)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        NetworkUtil.buildTask(request, ResponseTag.logoff, DeleteSession.self) { (deleteSession, error) in
            guard let error = error else {
                completion(deleteSession as? DeleteSession, nil)
                return
            }
                completion(nil, error)
            }
        }

    class func queryStudentLocations(completion: @escaping (_ studentLocations: StudentLocations?, _ error: Error?) -> Void) {
        guard let url = URL(string: MapConstant.Network.queryStudentLocationsURL) else {
            completion(nil, MapNetworkError.invalidUrl)
            return
        }
        var request = URLRequest(url: url)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        NetworkUtil.buildTask(request, ResponseTag.studentLocations, StudentLocations.self, completion: { (studentLocations, error) in
            completion(studentLocations as? StudentLocations, nil)
        })
    }

    class func addLocation(dictionary: [String:Any], completion: @escaping (_ postLocationResult: PostLocation?, _ error: Error?) -> Void){
        guard let url = URL(string: MapConstant.Network.addLocationURL) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let requestEncoder = JSONEncoder()
        let profile = StudentInformation(dictionary: ["firstName": dictionary["firstName"] ?? "",
                                                      "lastName": dictionary["lastName"] ?? "",
                                                      "mapString": dictionary["mapString"] ?? "",
                                                      "mediaURL": dictionary["mediaUrl"] ?? "",
                                                      "latitude": dictionary["latitude"] ?? 0.0,
                                                      "longitude":dictionary["longitude"] ?? 0.0] )
        do {
            let httpBody = try requestEncoder.encode(profile)
            request.httpBody = httpBody
            NetworkUtil.buildTask(request, ResponseTag.addLocation, StudentInformation.self) { (addLocationResponse, error) in
                completion(addLocationResponse as? PostLocation, error)
            }
        } catch {
            completion(nil, error)
        }
    }
}

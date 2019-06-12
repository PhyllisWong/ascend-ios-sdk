//
//  AscendParticipant.swift
//  example
//
//  Created by phyllis.wong on 6/10/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

protocol BuilderProtocol { static func builder() -> Builder }


public class AscendParticipant : BuilderProtocol {
  private var userId: String
  private let sessionId: String
  private var userAttributes: [String : String]
  
  init(userId: String, sessionId: String, userAttributes: [String: String]) {
    self.userId = userId
    self.sessionId = sessionId
    self.userAttributes = userAttributes
  }
  
  public static func builder() -> Builder {
    let builder = Builder()
    return builder
  }
  
  public func getUserId() -> String { return userId }
  
  public func getSessionId() -> String { return sessionId }
  
  public func getUserAttributes() -> [String: String] { return userAttributes }
 
}


public class Builder {
  private var userId: String
  private var sessionId: String
  private var userAttributes: [String : String]
  
  init(){
    self.userId = UUID().uuidString
    self.sessionId = UUID().uuidString
    self.userAttributes = ["uid" : userId, "sid": sessionId]
  }
  
  /**
   * A unique key representing the participant.
   * @param userId a unique key
   * @return this instance of the participant
   */
  public func setUserId(userId: String) -> Builder {
    self.userId = userId;
    return self
  }
  
  /**
   * A unique key representing the participant's session.
   * @param sessionId a unique key
   * @return this instance of the participant
   */
  public func setSessionId(sessionId: String) -> Builder {
    self.sessionId = sessionId;
    return self
  }
  
  /**
   * Sets the users attributes which can be used to filter users upon.
   * @param userAttributes a map representing specific attributes that
   *                      describe the participant
   * @return this instance of the participant
   */
  public func setUserAttributes(userAttributes: [String : String]) -> Builder {
    self.userAttributes = userAttributes;
    return self;
  }
  
  /**
   * Builds the AscendParticipant instance.
   * @return an AscendParticipant instance.
   */
  public func build() -> AscendParticipant {
    let uid = self.userId
    let sid = self.sessionId
    let ua = self.userAttributes
    let participant = AscendParticipant(userId: uid, sessionId: sid, userAttributes: ua)
    return participant
  }
}

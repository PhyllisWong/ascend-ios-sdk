//
//  EvolvParticipant.swift
//  example
//
//  Created by phyllis.wong on 6/10/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation


public class EvolvParticipant {
  private let sessionId: String // immuntable
  private var userId: String
  private var userAttributes: [String : String]
  
  init(userId: String, sessionId: String, userAttributes: [String: String]) {
    self.userId = userId
    self.sessionId = sessionId
    self.userAttributes = userAttributes
  }
  
  public static func builder() -> ParticipantBuilder {
    let builder = ParticipantBuilder()
    return builder
  }
  
  public func getUserId() -> String { return userId }
  
  public func getSessionId() -> String { return sessionId }
  
  public func getUserAttributes() -> [String: String] { return userAttributes }

}

public class ParticipantBuilder {
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
  public func setUserId(userId: String) -> ParticipantBuilder {
    self.userId = userId;
    return self
  }
  
  /**
   * A unique key representing the participant's session.
   * @param sessionId a unique key
   * @return this instance of the participant
   */
  public func setSessionId(sessionId: String) -> ParticipantBuilder {
    self.sessionId = sessionId;
    return self
  }
  
  /**
   * Sets the users attributes which can be used to filter users upon.
   * @param userAttributes a map representing specific attributes that
   *                      describe the participant
   * @return this instance of the participant
   */
  public func setUserAttributes(userAttributes: [String : String]) -> ParticipantBuilder {
    self.userAttributes = userAttributes;
    return self;
  }
  
  /**
   * Builds the EvolvParticipant instance.
   * @return an EvolvParticipant instance.
   */
  public func build() -> EvolvParticipant {
    let uid = self.userId
    let sid = self.sessionId
    let ua = self.userAttributes
    let participant = EvolvParticipant(userId: uid, sessionId: sid, userAttributes: ua)
    return participant
  }
}

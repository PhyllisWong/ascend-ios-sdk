//
//  EvolvClientFactory.swift
//  example
//
//  Created by phyllis.wong on 6/24/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

public class EvolvClientFactory {
  private static let LOGGER = Log.logger
  
  /**
   * Creates instances of the EvolvClient.
   *
   * @param config general configurations for the SDK
   * @return an instance of EvolvClient
   */
  init(config: EvolvConfig) {
    Log.logger.log(.debug, message: "Initializing Evolv Client.")
    let participant: EvolvParticipant = EvolvParticipant.builder().build()
    // return EvolvClientFactory.createClient(config, participant);
  }
  
  /**
   * Creates instances of the EvolvClient.
   *
   * @param config general configurations for the SDK
   * @param participant the participant for the initialized client
   * @return an instance of EvolvClient
   */
  init(config: EvolvConfig, participant: EvolvParticipant) {
    Log.logger.log(.debug, message: "Initializing Evolv Client.")
    // return EvolvClientFactory.createClient(config, participant);
  }
  
  
  private static func createClient(config: EvolvConfig, participant: EvolvParticipant) -> EvolvClient {
    let store = config.getEvolvAllocationStore()
    let previousAllocations = store.get(uid: participant.getUserId())
 
    let allocator: Allocator = Allocator(config: config, participant: participant)
  
    // fetch and reconcile allocations asynchronously
    let futureAllocations = allocator.fetchAllocations()
    let emitter = EventEmitter(config: config, participant: participant)
    
  }
}

//
//  AscendClientFactory.swift
//  example
//
//  Created by phyllis.wong on 6/24/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

public class AscendClientFactory {
  private static let LOGGER = Log.logger
  
  /**
   * Creates instances of the AscendClient.
   *
   * @param config general configurations for the SDK
   * @return an instance of AscendClient
   */
  init(config: AscendConfig) {
    Log.logger.log(.debug, message: "Initializing Ascend Client.")
    let participant: AscendParticipant = AscendParticipant.builder().build()
    // return AscendClientFactory.createClient(config, participant);
  }
  
  /**
   * Creates instances of the AscendClient.
   *
   * @param config general configurations for the SDK
   * @param participant the participant for the initialized client
   * @return an instance of AscendClient
   */
  init(config: AscendConfig, participant: AscendParticipant) {
    Log.logger.log(.debug, message: "Initializing Ascend Client.")
    // return AscendClientFactory.createClient(config, participant);
  }
  
  
  private static func createClient(config: AscendConfig, participant: AscendParticipant) -> AscendClientImpl {
    let store = config.getAscendAllocationStore()
    let previousAllocations = store.get(participant.getUserId())
    let httpClient = HttpClient()
    let eventEmitter = EventEmitter(httpClient: httpClient, config: config, participant: participant)
    let allocator: Allocator = Allocator(config: config, participant: participant)
  
    // fetch and reconcile allocations asynchronously
    let futureAllocations = allocator.fetchAllocations()
    let ascendClientImpl = AscendClientImpl(config: config,
                                            allocator: allocator,
                                            previousAllocations: Allocator.allocationsNotEmpty(allocations: previousAllocations as! Allocator.JsonArray),
                                            participant: participant, eventEmitter: eventEmitter,
                                            futureAllocations: futureAllocations)
    return ascendClientImpl
  }
}

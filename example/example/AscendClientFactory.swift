//
//  AscendClientFactory.swift
//  example
//
//  Created by phyllis.wong on 6/24/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation
import SwiftyJSON
import PromiseKit

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
  
  
  private static func createClient(config: AscendConfig, participant: AscendParticipant) -> AscendClient {
    let store = config.getAscendAllocationStore()
    let previousAllocations: JsonArray = store.get(participant.getUserId()) ?? []
    let httpClient = HttpClient()
    let eventEmitter = EventEmitter(httpClient: httpClient, config: config, participant: participant)
    let allocator: Allocator = Allocator(config: config, participant: participant, httpClient: httpClient)
    // fetch and reconcile allocations asynchronously
    let allocationsFuture = allocator.fetchAllocations()
    let ascendClientImpl = AscendClientImpl(config: config,
                                            allocator: allocator,
                                            previousAllocations: Allocator.allocationsNotEmpty(allocations: previousAllocations),
                                            participant: participant, eventEmitter: eventEmitter,
                                            futureAllocations: allocationsFuture)
    return ascendClientImpl as! AscendClient
  }
}

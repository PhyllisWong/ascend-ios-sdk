//
//  Allocator.swift
//  example
//
//  Created by phyllis.wong on 6/10/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

public class Allocator {
  
  enum AllocationStatus {
    case FETCHING, RETRIEVED, FAILED
  }
  
  private let executionDispatch: ExecutionDispatch
  private let store: AscendAllocationStore // TODO: in memory store
  private let config: AscendConfig
  private let participant: AscendParticipant
  private let eventEmitter: EventEmitter
  private let httpClient: HttpClient
  
  private var confirmationSandbagged: Bool = false
  private var contaminationSandbagged: Bool = false
  
  private var allocationStatus: AllocationStatus
  
  init(executionDispatch: ExecutionDispatch,
       store: AscendAllocationStore,
       config: AscendConfig,
       participant: AscendParticipant,
       eventEmitter: EventEmitter,
       httpClient: HttpClient
    ) {
    self.executionDispatch = executionDispatch
    self.store = store
    self.config = config
    self.participant = participant
    self.eventEmitter = eventEmitter
    self.httpClient = httpClient
    self.allocationStatus = AllocationStatus.FETCHING
  }
  
  func getAllocationStatus() -> AllocationStatus { return allocationStatus }
  
  func sandbagConfirmation() -> () { confirmationSandbagged = true }
  func sandbagContamination() -> () { contaminationSandbagged = true }
  
  func creatAllocationsUrl() -> String {
    let path: String = ""
    config.getDomain()
    participant.getUserId()
    return path
  }
}

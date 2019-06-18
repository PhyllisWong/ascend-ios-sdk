//
//  AscendConfig.swift
//  example
//
//  Created by phyllis.wong on 6/12/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

public class AscendConfig {
  
  private let httpScheme: String;
  private let domain: String;
  private let version: String;
  private let environmentId: String;
  // private let ascendAllocationStore: AscendAllocationStore;
  private let httpClient: AscendHttpClient;
  // private let executionDispatch: ExecutionDispatch;
  
  init(httpScheme: String, domain: String, version: String,
       environmentId: String, // ascendAllocationStore: AscendAllocationStore,
       httpClient: AscendHttpClient
    ) {
    self.httpScheme = httpScheme
    self.domain = domain
    self.version = version
    self.environmentId = environmentId
    // self.ascendAllocationStore = ascendAllocationStore
    self.httpClient = httpClient
    // self.executionDispatch = ExecutionDispatch()
  }
  
  public func configBuilder(environmentId: String, httpClient: AscendHttpClient) -> ConfigBuilder {
    let configurationBuilder = ConfigBuilder(environmentId: environmentId, httpClient: httpClient)
    return configurationBuilder
  }
  
  public func getHttpScheme() -> String { return httpScheme }
  
  public func getDomain() -> String { return domain }
  
  public func getVersion() -> String { return version }
  
  public func getEnvironmentId() -> String { return environmentId }
  
  // public func getAscendAllocationStore() -> AscendAllocationStore {
    // return ascendAllocationStore
  // }
  
  public func getHttpClient() -> HttpClient {
    return self.httpClient
  }
  
  // public func getExecutionDispatch() -> ExecutionDispatch {
    // return self.executionDispatch
  // }
  
}

public class ConfigBuilder {
  private var allocationStoreSize: Int
  private var httpScheme: String
  private var domain: String
  private var version: String
  private var allocationStore: AscendAllocationStore?
  
  private var environmentId: String
  private var httpClient: HttpClient
  
  private let DEFAULT_HTTP_SCHEME: String = "https"
  private let DEFAULT_DOMAIN: String = "participants-phyllis.evolv.ai"
  private let DEFAULT_API_VERSION: String = "v1"
  private let DEFAULT_ALLOCATION_STORE_SIZE: Int = 1000
  
  
  /**
   * Responsible for creating an instance of AscendClientImpl.
   * <p>
   *     Builds an instance of the AscendClientImpl. The only required parameter is the
   *     customer's environment id.
   * </p>
   * @param environmentId unique id representing a customer's environment
   */
  init(environmentId: String, httpClient: HttpClient? = nil) {
    self.allocationStoreSize = DEFAULT_ALLOCATION_STORE_SIZE
    self.httpScheme = DEFAULT_HTTP_SCHEME
    self.domain = DEFAULT_DOMAIN
    self.version = DEFAULT_API_VERSION
    
    self.environmentId = environmentId
    if (httpClient != nil) {
      self.httpClient = httpClient! // FIXME: perform safe unwrap here
    } else {
      self.httpClient = HttpClient()
    }
  }
  
  /**
   * Sets the domain of the underlying ascendParticipant api.
   * @param domain the domain of the ascendParticipant api
   * @return AscendClientBuilder class
   */
  public func setDomain(domain: String) -> ConfigBuilder {
    self.domain = domain
    return self
  }
  
  /**
   * Version of the underlying ascendParticipant api.
   * @param version representation of the required ascendParticipant api version
   * @return AscendClientBuilder class
   */
  public func setVersion(version: String) -> ConfigBuilder {
    self.version = version
    return self
  }
  
  /**
   * Sets up a custom AscendAllocationStore. Store needs to implement the
   * AscendAllocationStore interface.
   * @param allocationStore a custom built allocation store
   * @return AscendClientBuilder class
   */
  public func setAscendAllocationStore(allocationStore: AscendAllocationStore) -> ConfigBuilder {
    self.allocationStore = allocationStore
    return self
  }
  
  /**
   * Tells the SDK to use either http or https.
   * @param scheme either http or https
   * @return AscendClientBuilder class
   */
  public func setHttpScheme(scheme: String) -> ConfigBuilder {
    self.httpScheme = scheme
    return self
  }
  
  /**
   * Sets the DefaultAllocationStores size.
   * @param size number of entries allowed in the default allocation store
   * @return AscendClientBuilder class
   */
  public func setDefaultAllocationStoreSize(size: Int) -> ConfigBuilder {
    self.allocationStoreSize = size
    return self
  }
  
  /**
   * Builds an instance of AscendClientImpl.
   * @return an AscendClientImpl instance
   */
  public func buildConfig() -> AscendConfig {
    var allocationStore = self.allocationStore
    if (allocationStore == nil) {
      allocationStore = DefaultAllocationStore(size: allocationStoreSize)
    }
    let httpScheme = self.httpScheme
    let domain = self.domain
    let version = self.version
    let environmentId = self.environmentId
    let httpClient = self.httpClient

    let ascendConfig = AscendConfig(httpScheme: httpScheme, domain: domain,
                                    version: version, environmentId: environmentId,
                                    httpClient: httpClient)
    return ascendConfig
  }
}


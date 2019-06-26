//
//  EvolvConfig.swift
//  example
//
//  Created by phyllis.wong on 6/12/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

public class EvolvConfig {
  
  private let httpScheme: String
  private let domain: String
  private let version: String
  private let environmentId: String
  private let evolvAllocationStore: LRUCache
  private let httpClient: HttpProtocol
  // private let executionDispatch: ExecutionDispatch
  
  init(httpScheme: String, domain: String, version: String,
       environmentId: String, evolvAllocationStore: LRUCache,
       httpClient: HttpProtocol
    ) {
    self.httpScheme = httpScheme
    self.domain = domain
    self.version = version
    self.environmentId = environmentId
    self.evolvAllocationStore = evolvAllocationStore
    self.httpClient = httpClient
    // self.executionDispatch = ExecutionDispatch()
  }
  
  public func configBuilder(environmentId: String, httpClient: HttpProtocol) -> ConfigBuilder {
    let configurationBuilder = ConfigBuilder(environmentId: environmentId, httpClient: httpClient)
    return configurationBuilder
  }
  
  public func getHttpScheme() -> String { return httpScheme }
  
  public func getDomain() -> String { return domain }
  
  public func getVersion() -> String { return version }
  
  public func getEnvironmentId() -> String { return environmentId }
  
  public func getEvolvAllocationStore() -> LRUCache {
    let evolvAllocationStore = LRUCache(5)
    return evolvAllocationStore
   }
  
  public func getHttpClient() -> HttpProtocol {
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
  private var allocationStore: EvolvAllocationStore?
  
  private var environmentId: String
  private var httpClient: HttpProtocol
  
  private let DEFAULT_HTTP_SCHEME: String = "https"
  private let DEFAULT_DOMAIN: String = "participants-phyllis.evolv.ai"
  private let DEFAULT_API_VERSION: String = "v1"
  private let DEFAULT_ALLOCATION_STORE_SIZE: Int = 1000
  
  
  /**
   * Responsible for creating an instance of EvolvConfig.
   * <p>
   *     Builds an instance of the EvolvConfig. The only required parameter is the
   *     customer's environment id.
   * </p>
   * @param environmentId unique id representing a customer's environment
   */
  init(environmentId: String, httpClient: HttpProtocol? = nil) {
    self.allocationStoreSize = DEFAULT_ALLOCATION_STORE_SIZE
    self.httpScheme = DEFAULT_HTTP_SCHEME
    self.domain = DEFAULT_DOMAIN
    self.version = DEFAULT_API_VERSION
    
    self.environmentId = environmentId
    if let httpClient = httpClient {
      self.httpClient = httpClient
    } else {
      self.httpClient = HttpClient()
    }
  }
  
  /**
   * Sets the domain of the underlying evolvParticipant api.
   * @param domain the domain of the evolvParticipant api
   * @return EvolvClientBuilder class
   */
  public func setDomain(domain: String) -> ConfigBuilder {
    self.domain = domain
    return self
  }
  
  /**
   * Version of the underlying evolvParticipant api.
   * @param version representation of the required evolvParticipant api version
   * @return EvolvClientBuilder class
   */
  public func setVersion(version: String) -> ConfigBuilder {
    self.version = version
    return self
  }
  
  /**
   * Sets up a custom EvolvAllocationStore. Store needs to implement the
   * EvolvAllocationStore interface.
   * @param allocationStore a custom built allocation store
   * @return EvolvClientBuilder class
   */
  public func setEvolvAllocationStore(allocationStore: EvolvAllocationStore) -> ConfigBuilder {
    self.allocationStore = allocationStore
    return self
  }
  
  /**
   * Tells the SDK to use either http or https.
   * @param scheme either http or https
   * @return EvolvClientBuilder class
   */
  public func setHttpScheme(scheme: String) -> ConfigBuilder {
    self.httpScheme = scheme
    return self
  }
  
  /**
   * Sets the DefaultAllocationStores size.
   * @param size number of entries allowed in the default allocation store
   * @return EvolvClientBuilder class
   */
  public func setDefaultAllocationStoreSize(size: Int) -> ConfigBuilder {
    self.allocationStoreSize = size
    return self
  }
  
  /**
   * Builds an instance of EvolvClientImpl.
   * @return an EvolvClientImpl instance
   */
  public func buildConfig() -> EvolvConfig {
    var allocationStore = self.allocationStore
    if (allocationStore == nil) {
      allocationStore = DefaultAllocationStore(size: allocationStoreSize)
    }
    let httpScheme = self.httpScheme
    let domain = self.domain
    let version = self.version
    let environmentId = self.environmentId
    let httpClient = self.httpClient
    let store = LRUCache(10)

    let evolvConfig = EvolvConfig(httpScheme: httpScheme, domain: domain,
                                    version: version, environmentId: environmentId, evolvAllocationStore: store,
                                    httpClient: httpClient)
    return evolvConfig
  }
}


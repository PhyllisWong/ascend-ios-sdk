//
//  EvolvConfig.swift
//  example
//
//  Created by phyllis.wong on 6/12/19.
//  Copyright © 2019 phyllis.wong. All rights reserved.
//

import Foundation

public class EvolvConfig {
  
  static let DEFAULT_HTTP_SCHEME = "https"
  static let DEFAULT_DOMAIN = "participants-phyllis.evolv.ai"
  static let DEFAULT_API_VERSION = "v1"
  
  private static let DEFAULT_ALLOCATION_STORE_SIZE = 1000
  
  private let httpScheme: String
  private let domain: String
  private let version: String
  private let environmentId: String
  private let evolvAllocationStore: EvolvAllocationProtocol
  private let httpClient: HttpProtocol
  private let executionQueue: ExecutionQueue
  
  init(_ httpScheme: String, _ domain: String, _ version: String,
       _ environmentId: String, _ evolvAllocationStore: EvolvAllocationProtocol,
       _ httpClient: HttpProtocol
    ) {
    self.httpScheme = httpScheme
    self.domain = domain
    self.version = version
    self.environmentId = environmentId
    self.evolvAllocationStore = evolvAllocationStore
    self.httpClient = httpClient
    self.executionQueue = ExecutionQueue()
  }
  
  public func configBuilder(environmentId: String, httpClient: HttpProtocol) -> ConfigBuilder {
    let configurationBuilder = ConfigBuilder(environmentId: environmentId, httpClient: httpClient)
    return configurationBuilder
  }
  
  public func getHttpScheme() -> String { return httpScheme }
  
  public func getDomain() -> String { return domain }
  
  public func getVersion() -> String { return version }
  
  public func getEnvironmentId() -> String { return environmentId }
  
  public func getEvolvAllocationStore() -> EvolvAllocationProtocol {
    return evolvAllocationStore
  }
  
  public func getHttpClient() -> HttpProtocol {
    return self.httpClient
  }
  
  public func getExecutionQueue() -> ExecutionQueue { return executionQueue }
  
  public class ConfigBuilder {
    private var allocationStoreSize: Int = DEFAULT_ALLOCATION_STORE_SIZE
    private var httpScheme: String = DEFAULT_HTTP_SCHEME
    private var domain: String = DEFAULT_DOMAIN
    private var version: String = DEFAULT_API_VERSION
    private var allocationStore: EvolvAllocationProtocol?
    
    private var environmentId: String
    private var httpClient: HttpProtocol
    
    /**
     * Responsible for creating an instance of EvolvConfig.
     * <p>
     *     Builds an instance of the EvolvConfig. The only required parameter is the
     *     customer's environment id.
     * </p>
     * @param environmentId unique id representing a customer's environment
     */
    init(environmentId: String, httpClient: HttpProtocol = HttpClient(),
         allocationStore: EvolvAllocationProtocol = DefaultAllocationStore(size: 1000)) {
      self.environmentId = environmentId
      self.httpClient = httpClient
      self.allocationStore = allocationStore
    }
    
    /**
     * Sets the domain of the underlying evolvParticipant api.
     * @param domain the domain of the evolvParticipant api
     * @return EvolvConfigBuilder class
     */
    public func setDomain(domain: String) -> ConfigBuilder {
      self.domain = domain
      return self
    }
    
    /**
     * Version of the underlying evolvParticipant api.
     * @param version representation of the required evolvParticipant api version
     * @return EvolvConfigBuilder class
     */
    public func setVersion(version: String) -> ConfigBuilder {
      self.version = version
      return self
    }
    
    /**
     * Sets up a custom EvolvAllocationStore. Store needs to implement the
     * EvolvAllocationStore interface.
     * @param allocationStore a custom built allocation store
     * @return EvolvConfigBuilder class
     */
    public func setEvolvAllocationStore(allocationStore: EvolvAllocationProtocol) -> ConfigBuilder {
      self.allocationStore = allocationStore
      return self
    }
    
    /**
     * Tells the SDK to use either http or https.
     * @param scheme either http or https
     * @return EvolvConfigBuilder class
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
     * Builds an instance of EvolConfig
     * @return an EvolvConfig instance
     */
    public func buildConfig() -> EvolvConfig {
      var store : EvolvAllocationProtocol = DefaultAllocationStore(size: allocationStoreSize)
      if let allocStore = self.allocationStore {
        store = allocStore
      }
      return EvolvConfig(self.httpScheme, self.domain, self.version, self.environmentId, store, self.httpClient)
    }
  }
  
}



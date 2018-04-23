module Timewax
  
  require 'time'
  require 'json'
  require_relative "./RequestInterface.rb"

  # Used to authenticate to Timewax API and fetch a Token for following requests 
  class Session < RequestInterface
    
    attr_reader :code, :valid, :validUntil, :token

    def initialize(clientID, username, password, domain)
      ## set domain as class var for later use
      @domain = domain

      ## get authentication token
      body = { 
        :request => {
          :client => clientID,
          :username => username,
          :password => password
        }
      }

      ## start check if there is a valid token in cache (currently file cache)
      if !File.exist?('cache/') 
        Dir.mkdir('cache/')
      end

      if File.exist?('cache/token.cache')
        ## read cache from file 
        cache = File.read('cache/token.cache') 
        ## json to hash 
        response = JSON.parse(cache, :symbolize_names => true)
        ## get cache validation time 
        validTime = Time.parse(response[:response][:validUntil])
        
        if validTime < Time.now() 
          ## get new token
          response = self.getNewToken(body)
          ## convert response to hash
          @code = response.code
          response = self.XMLtoHash(response.body)
          ## store cache token
          File.open('cache/token.cache', 'w') { |f| f << JSON.generate(response) }    
        end
      else
        ## get a new token from api
        response = self.getNewToken(body)
        ## convert response to hash
        @code = response.code
        response = self.XMLtoHash(response.body)
        ## store cache token
        File.open('cache/token.cache', 'w') { |f| f << JSON.generate(response) }
      end

      ## set response in attr
      @valid = response[:response][:valid]
      @token = response[:response][:token]
      @validUntil = Time.parse(response[:response][:validUntil])

    end

    def getNewToken(body) 
      ## convert hash to XML
      req_body = self.HashtoXML(body)
      ## start request to get token
      response = self.post(req_body, @domain, '/authentication/token/get/')
      puts response
      return response
    end

  end
end
module Timewax
  
  require_relative "./ResponseXMLtoHash"

  # To correctly sent HTTP Post request to Timewax API.  
  # Timewax only accepts Post request methods, the path given defines how and what resource will be used.  
  class RequestInterface < ResponseXMLtoHash
    
    # POST request via https to timewax API (timewax only accepts POSTS)
    # @param data [String] request body (XML Timewax body)
    # @param domain [String] Domain to send post to 'api.example.invalid'
    # @param path [String] Resource path for te request 
    # @return [Net::HTTPResponse] Request response 
    def post(data, domain, path) 
        uri = URI("https://#{domain}/#{path}")

        http = Net::HTTP.new(uri.hostname)
        req = Net::HTTP::Post.new(path)
        req.content_type = 'text/xml'
        req.body = data

        # puts "body request: #{data}"
        # puts "- - - - - - - - - - - -"
        
        return http.request(req)
    end
    
  end
end
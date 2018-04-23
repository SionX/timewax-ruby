module Timewax

  require 'time'
  require_relative "./Session"

  # Class for fetching data from the API based on posible calls 
  # @todo Add caching of data set for X time to prefent hammering the API
  class RequestData < Session

    # Fetch resource list or a single resource dataset
    # @param resource [String] Name or Email of a resource to fetch data from if left empty a list will be fetched
    # @return [Hash]
    # @example Get a list of resources
    #   RequestData.getResource()
    #   RequestData.getResource("ResourceName")
    def getResource(resource=nil)
      if !resource.nil? 
        req_body = self.HashtoXML({ :request => { :token => @token, :resource => resource } })
        response = self.post(req_body, @domain, '/resource/get/')
      else
        req_body = self.HashtoXML({ :request => { :token => @token } })
        response = self.post(req_body, @domain, '/resource/list/')
      end
      
      @code = response.code
      # puts "response code: #{@code}"
      return self.XMLtoHash(response.body)
    end

    # Get a list of booked time in timewax.
    # you can filter down with a hash object with right symbols to set certain options in the request to the api
    # @param options [Hash]
    # @return [Hash]
    # @example sample option hash
    #   RequestData.getTimeBookings({
    #     :request => {
    #       :dateFrom => "12-10-2017",
    #       :dateTo => "14-12-2017",
    #       :resource => "steven",
    #       :project => "projectX",
    #       :approvedOnly => "Yes"
    #     }
    #   })
    def getTimeBookings(options=nil)
      ## set default time window to -1 month from today
      startDate = Date.today << 1
      endDate = Date.today

      ## check if options hash is given
      if options.nil?
        ## build default request body
        req_body = self.HashtoXML({ :request => { :token => @token, :dateFrom => startDate.strftime('%Y%m%d'), :dateTo => endDate.strftime('%Y%m%d') } })
        response = self.post(req_body, @domain, '/time/entries/list/')
      else
        ## edit options where needed so it will pass timewax api specs
        options[:request][:token] = @token
        options[:request][:dateFrom] = startDate.strftime('%Y%m%d') if options[:request][:dateFrom].nil?
        options[:request][:dateTo] = endDate.strftime('%Y%m%d') if options[:request][:dateTo].nil?

        # puts options[:request][:dateTo]

        ## parse to xml
        req_body = self.HashtoXML(options)
        response = self.post(req_body, @domain, '/time/entries/list/')
      end
    
      @code = response.code
      return self.XMLtoHash(response.body)
    end

    
    # Get list of project in timewax
    # @param options [Hash] options to filter list that is returned
    # @return [Hash]
    # @example sample options hash
    #   RequestData.getProject({
    #      :request => {
    #        :isParent => "Yes",
    #        :isActive => "Yes",
    #        :portfolio => ""
    #      }
    #    })
    def getProject(options=nil)
      ## check if options hash is given
      if options.nil?
        ## build default request body
        req_body = self.HashtoXML({ :request => { :token => @token } })
        response = self.post(req_body, @domain, '/time/entries/list')
      else
        ## add token to request
        options[:request][:token] = @token
        
        ## parse to xml
        req_body = self.HashtoXML(options)
        response = self.post(req_body, @domain, '/time/entries/list')
      end
    
      @code = response.code
      return self.XMLtoHash(response.body)
    end


  end
end
module Timewax
  
  require 'ox'

  # Class for parsing the XML to Hash Objects and backwards.
  class ResponseXMLtoHash
    
    # Convert XML input to Hash object for easy handeling within the application
    # @param xml [String] The XML formated String you want to convert from
    # @return [Hash] XML input in a Hash object 
    def XMLtoHash(xml)
      hash = Ox.load(xml, mode: :hash)
      return hash
    end

    # Convert Hash to XML for the timewax API, Hash will be converted recusive 
    # @param hash [Hash] Hash object used as input
    # @param parent [Object] Parent element for sub element from hash. (used for recursion)
    # @return [String] XML valid string usable for Timewax API
    def HashtoXML(hash, parent = nil)
      if parent.nil?
        parent = Ox::Document.new(:version => '1.0')
      end

      hash.each do |key, value|
        if value.is_a?(Hash)
          key = Ox::Element.new(key)
          parent << key
          self.HashtoXML(value, key)
        else
          key = Ox::Element.new(key)
          parent << key
          key << value
        end
      end
      
      return Ox.dump(parent)
    end

  end
end

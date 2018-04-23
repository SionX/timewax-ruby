## first ensure all files are loaded ready for require commands.
# Dir.glob('../src/*.rb').each{|file| require file }
require '../src/RequestData'

## get your api access details from timewax admin panels.
clientID = ''
username = ''
password = ''
domain = 'api.timewax.nl'

## create the instance this will also create a session token with its constructor function
timewax = new RequestData(clientID, username, password, domain)

## now to call data from the api
resourceHash = timewax.getResource()
resourceHash = timewax.getResource('nameOfResource')

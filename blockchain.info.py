#!/usr/bin/python
#Importing modules
import json
import urllib2
import sys
 
# Open the url
url = "http://blockchain.info/charts/" + sys.argv[1] + "?format=json"
  
# This takes a python object and dumps it to a string which is a JSON representation of that object
data = json.load(urllib2.urlopen(url))
   
#print the result
print data
#print '%s%s' % ("XBTUSD (bitstamp)".ljust(19), data[u'last'].rjust(11)), #print to screen with formatting

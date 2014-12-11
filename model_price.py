#!/usr/bin/python

import json
import urllib2
from math import log10

def n_tx_to_price(n_tx, totalbc):
    model_price = 1.e8*(10**-0.638)*(n_tx**2.181)/totalbc
    return model_price


def weekly():

# this will return last month of 7-day averaged data
    url = "http://blockchain.info/charts/n-transactions?timespan=30days&daysAverageString=7&format=json"
    data = json.load(urllib2.urlopen(url))

# so pick off the most recent one
    n_tx = data[u'values'][-1][u'y']

# and most recent number of btc
    url = "http://blockchain.info/stats?format=json"
    data = json.load(urllib2.urlopen(url))
    totalbc = data['totalbc']

# and most recent price
    price = data['market_price_usd']

# using both average tx rate and recent totalbc
    model_price = n_tx_to_price(n_tx, totalbc)
    
# how many std deviations this is
    deviations=(log10(price/model_price))/0.2196;

    return (model_price, deviations)



def daily():
    url = "http://blockchain.info/stats?format=json"
    data = json.load(urllib2.urlopen(url))
       
    #print the result
    n_tx = data['n_tx']
    totalbc = data['totalbc']
    model_price = n_tx_to_price(n_tx, totalbc)

    return model_price



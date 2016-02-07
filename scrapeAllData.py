# -*- coding: utf-8 -*-
"""
Created on Fri Nov 27 16:49:51 2015

@author: Devon

DESCRIPTION:

Scrapes data from http://www.bestplaces.net/
for the locations we are considering moving to.
"""

from __future__ import division
from __future__ import unicode_literals
from bs4 import BeautifulSoup as bs
import requests
import pandas as pd
pd.set_option('display.max_columns', 50)

def getTable(url, table_id):
    '''
    url = prefix + suffice
    table_id = id name of the table on the html page
    '''
    r = requests.get(url)
    data = r.text.encode('ascii', 'ignore')
    soup = bs(data)
    
    table = soup.find("table", attrs={"id":table_id})
    table.text.encode('ascii', 'ignore')
    
    datasets = []
    for row in table.find_all("tr"):
        dataset = [td.get_text().encode('ascii', 'ignore') for td in row.find_all("td")]
        datasets.append(dataset)
    
    ds = pd.DataFrame(datasets)
    return(ds)

def getGroupTables(prefix,location_suffixes,table_id):
    
    print('Collecting ' + table_id)    
    
    counter = 0
    
    for i in location_suffixes:
        counter += 1
        url = prefix + i
        ds = getTable(url,table_id)
        if counter == 1:
            storage = ds
        else:
            to_add = ds.loc[:,1]
            storage = pd.concat([storage,to_add], axis=1)
    print('Finished')        
    return(storage)


def main():
    
    location_suffixes = ['california/san_mateo',
                         'california/fremont',
                         'california/palo_alto',
                         'california/san_francisco',
                         'california/sacramento',
                         'new_york/new_york',
                         'rhode_island/providence',
                         'massachusetts/worcester',
                         'new_hampshire/concord',
                         'massachusetts/boston',
                         'vermont/burlington',
                         'florida/tampa',
                         'wisconsin/madison',
                         'ohio/cleveland',
                         'district_of_columbia/washington',
                         'north_carolina/chapel_hill',
                         'pennsylvania/philadelphia']
    
    table_id_list = ['mainContent_dgCostOfLiving',
                     'mainContent_dgClimate',
                     'mainContent_dgEconomy',
                     'mainContent_dgHousing',
                     'mainContent_dgTransportation']
    prefix_list = ['http://www.bestplaces.net/cost_of_living/city/',
                   'http://www.bestplaces.net/climate/city/',
                   'http://www.bestplaces.net/economy/city/',
                   'http://www.bestplaces.net/housing/city/',
                   'http://www.bestplaces.net/transportation/city/']
    save_names = ['data/CostOfLiving.csv',
                 'data/Climate.csv',
                 'data/Economy.csv',
                 'data/Housing.csv',
                 'data/Transportation.csv']
                   
    for table_id, prefix, save_name  \
        in zip(table_id_list,prefix_list,save_names):
            
        ds = getGroupTables(prefix, location_suffixes, table_id)
        ds.to_csv(save_name,
                  index = False, index_label = False)


if __name__ == "__main__":
    main()
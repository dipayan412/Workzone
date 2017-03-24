# -*- coding: utf-8 -*-
"""
Created on Wed Aug 24 20:58:23 2016

@author: Dip
"""

import pymysql
import json_utils
import sys
import logging

def handler():
	db = pymysql.connect(host="pharmacate-core.c4t3bxujamid.us-west-2.rds.amazonaws.com",port=3306,user= "PharmaAdmin",passwd="5?#B5MrNZa`3G{t+vs'~",db="pharmacateDB")
	cursor = db.cursor()
	
	logger = logging.getLogger()
	logger.setLevel(logging.INFO)
	
	userId = '11'
#	if event['jsonB'].has_key('Queries'):
#		userId = event['jsonB']['Queries']['USR_ID']
		
	productId = '1000009891'
#	if event['jsonB'].has_key('Queries'):
#		productId = event['jsonB']['Queries']['PRODUCT_ID']
	
	result = {}
		
	try:
		searchQuery = "SELECT * FROM pharmacateDB.USER_PRODUCTS "
		searchQuery += "WHERE USR_ID = '%s' " %(userId)
		searchQuery += "AND PRODUCT_ID = '%s' " %(productId)
		searchQuery += "AND IS_DELETED = 'NO'"
		cursor.execute(searchQuery)
	except cursor.Error as err:
		print err
		result["STATUS"] = 0
		result["COMMENTS"] = err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	rows = cursor.fetchall()
	if len(rows) > 0:
		result["COMMENTS"] = "TRACKED"
	
	result["STATUS"] = 1
	
	db.commit();
	cursor.close()
	db.close()
	
	return json_utils.EncodeResults(result)
print handler()
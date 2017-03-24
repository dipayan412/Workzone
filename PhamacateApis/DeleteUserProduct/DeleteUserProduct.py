# -*- coding: utf-8 -*-
"""
Created on Wed Aug 24 21:24:46 2016

@author: Dip
"""

import pymysql
import json_utils
import sys
import logging

def handler(event, context):
	db = pymysql.connect(host="pharmacate-core.c4t3bxujamid.us-west-2.rds.amazonaws.com",port=3306,user= "PharmaAdmin",passwd="5?#B5MrNZa`3G{t+vs'~",db="pharmacateDB")
	cursor = db.cursor()
	
	logger = logging.getLogger()
	logger.setLevel(logging.INFO)
	
	userId = ''
	if event['jsonB'].has_key('Queries'):
		userId = event['jsonB']['Queries']['USR_ID']
		
	productId = ''
	if event['jsonB'].has_key('Queries'):
		productId = event['jsonB']['Queries']['PRODUCT_ID']
	
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
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	rows = cursor.fetchall()
	if len(rows) > 0:
		try:
			updateQuery = "UPDATE pharmacateDB.USER_PRODUCTS "
			updateQuery += "SET IS_DELETED = 'YES' "
			updateQuery += "WHERE PRODUCT_ID = '%s' " %(productId)
			updateQuery += "AND USR_ID = '%s'" %(userId)
			cursor.execute(updateQuery)
		except cursor.Error as err:
			print err
			result["STATUS"] = 0
			cursor.close()
			db.close()	
			logger.error("Something went wrong with query: {}".format(err))
			sys.exit()
			
	result["STATUS"] = 1
	
	db.commit();
	cursor.close()
	db.close()
	
	return json_utils.EncodeResults(result)
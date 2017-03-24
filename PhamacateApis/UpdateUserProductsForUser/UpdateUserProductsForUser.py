# -*- coding: utf-8 -*-
"""
Created on Tue Aug  2 18:37:16 2016

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
	
	result = {}
	userId = '11'#event['jsonB']['Queries']['USR_ID']
	productId = '1000009894'#event['jsonB']['Queries']['PRODUCT_ID']
	
	searchQuery = "SELECT * FROM pharmacateDB.USER_PRODUCTS "
	searchQuery += "WHERE USR_ID = '%s' " %(userId)
	searchQuery += "AND PRODUCT_ID = '%s'" %(productId)
	
	try:
		cursor.execute(searchQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	rows = cursor.fetchall()
	print rows
	print len(rows)
#	if len(rows) > 0:
#		updateQuery = "UPDATE pharmacateDB.USER_PRODUCTS "
#		updateQuery += "SET IS_DELETED = 'NO' "
#		updateQuery += "WHERE USR_ID = '%s' " %(userId)
#		updateQuery += "AND PRODUCT_ID = '%s'" %(productId)
#			
#		try:
#			cursor.execute(updateQuery)
#		except cursor.Error as err:
#			result["STATUS"] = 0
#			print err
#			cursor.close()
#			db.close()	
#			logger.error("Something went wrong with query: {}".format(err))
#			sys.exit()
#	elif len(rows) < 1:
#		insertQuery = "INSERT INTO pharmacateDB.USER_PRODUCTS "
#		insertQuery += "(USR_ID, PRODUCT_ID, IS_DELETED)" + " VALUES ('%s', '%s', 'NO')" %(userId, productId)
#	
#		try:
#			cursor.execute(insertQuery)
#		except cursor.Error as err:
#			result["STATUS"] = 0
#			print err
#			cursor.close()
#			db.close()	
#			logger.error("Something went wrong with query: {}".format(err))
#			sys.exit()
		
	result["STATUS"] = 1
	
	db.commit();
	cursor.close()
	db.close()
	
	return json_utils.EncodeResults(result)
print handler()
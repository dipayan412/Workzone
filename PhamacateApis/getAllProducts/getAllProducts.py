# -*- coding: utf-8 -*-
"""
Created on Sat Jul  9 19:02:05 2016

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
	
	timestamp = event['jsonB']['Queries']['PRODUCT_ID']
	limit = event['jsonB']['Queries']['LIMIT']
	
	searchQuery = "SELECT PRODUCT_ID,PROPRIETARY_NAME,NONPROPRIETARY_NAME FROM pharmacateDB.PRODUCTS WHERE PRODUCT_ID >= \"%s\" LIMIT %s" %(timestamp, limit)
	result = {}
	try:
		cursor.execute(searchQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	result["STATUS"] = 1
	result["DATA"] = []
	rows = cursor.fetchall()
	for row in rows:
		tmpDic = {}
		tmpDic["PRODUCT_ID"] = row[0]
		tmpDic["PRODUCT_NAME"] = row[1]
		tmpDic["PRODUCT_INGREDIENT_NAME"] = row[2]
		result["DATA"].append(tmpDic)
	
	db.commit();
	cursor.close()
	db.close()
	
	return json_utils.EncodeResults(result)
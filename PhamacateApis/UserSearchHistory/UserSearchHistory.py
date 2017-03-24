# -*- coding: utf-8 -*-
"""
Created on Wed Jul  6 13:58:41 2016

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
	
	userId = event['jsonB']['Queries']['USR_ID']
	
	searchQuery = "SELECT PRODUCT_ID, CREATED_AT FROM pharmacateDB.USER_SEARCH_HISTORY "
	searchQuery += "WHERE USR_ID = '%s'" %(userId)
	
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
		
	rows = cursor.fetchall()
	result = {}
	result["Data"] = []
	result["Status"] = 1
	
	if len(rows) > 0:
		for row in rows:
			tmpDic = {}
			try:
				cursor.execute("SELECT PROPRIETARY_NAME FROM pharmacateDB.PRODUCTS WHERE PRODUCT_ID = '%s'" %(row[0]));
			except cursor.Error as err:
				print err
				cursor.close()
				db.close()	
				logger.error("Something went wrong with query: {}".format(err))
				sys.exit()
			rows1 = cursor.fetchall()
			tmpDic["PROPRIETARY_NAME"] = rows1[0][0]
			tmpDic["Date"] = row[1]
			tmpDic["PRODUCT_ID"] = row[0]
			result["Data"].append(tmpDic)
	
	db.commit();
	cursor.close()
	db.close()
	
	return json_utils.EncodeResults(result)
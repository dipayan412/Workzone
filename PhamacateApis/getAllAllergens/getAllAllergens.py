# -*- coding: utf-8 -*-
"""
Created on Tue Jul 12 09:15:03 2016

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
	
	allergenId = event['jsonB']['Queries']['ALLERGEN_ID']
	limit = event['jsonB']['Queries']['LIMIT']
	
	searchQuery = "SELECT ALLERGEN_ID, ALLERGEN_NAME FROM pharmacateDB.ALLERGENS WHERE ALLERGEN_ID >= \"%s\" LIMIT %s" %(allergenId, limit)
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
		tmpDic["ALLERGEN_ID"] = row[0]
		tmpDic["ALLERGEN_NAME"] = row[1]
		result["DATA"].append(tmpDic)
	
	db.commit();
	cursor.close()
	db.close()
	
	return json_utils.EncodeResults(result)
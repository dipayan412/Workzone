# -*- coding: utf-8 -*-
"""
Created on Thu Jul  7 15:34:43 2016

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
	
	deleteQuery = "DELETE FROM pharmacateDB.USER_SEARCH_HISTORY "
	deleteQuery += "WHERE USR_ID = '%s'" %(userId)
	
	result = {}
	try:
		cursor.execute(deleteQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	result = {}
	result["Data"] = []
	result["STATUS"] = 1
	
	db.commit();
	cursor.close()
	db.close()
	
	return json_utils.EncodeResults(result)
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 21 08:55:21 2016

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
	
	result = {}
	
	userId = ''
	if event['jsonB']['Queries'].has_key('USR_ID'):
		userId = event['jsonB']['Queries']['USR_ID']
		
	userId = ''
	if event['jsonB']['Queries'].has_key('USR_ID'):
		userId = event['jsonB']['Queries']['USR_ID']
		
	content = ''
	if event['jsonB']['Queries'].has_key('USR_ID'):
		content = event['jsonB']['Queries']['CONTENT']
	
	insertQuery = "INSERT INTO pharmacateDB.USER_FEEDBACK "
	insertQuery += "(CONTENT, USR_ID) "
	insertQuery += "VALUES('%s', '%s')" %(content, userId)
	
	try:
		cursor.execute(insertQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
	
	result["STATUS"] = 1
	
	db.commit();
	cursor.close()
	db.close()
	
	return json_utils.EncodeResults(result)
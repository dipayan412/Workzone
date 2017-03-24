# -*- coding: utf-8 -*-
"""
Created on Mon Jun 27 17:58:59 2016

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
	
	searchQuery = "SELECT USR_ID FROM pharmacateDB.USER "
	searchQuery += "WHERE USER_NAME = '%s'" % (event['jsonB']['Queries']['USER_NAME'])
	try:
		cursor.execute(searchQuery)
	except cursor.Error as err:
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
	
	result = {}
	rows = cursor.fetchall()
	for row in rows:
		result["USR_ID"] = row[0]
		
	db.commit()
		
	db.close()
	cursor.close()
	
	return json_utils.EncodeResults(result)
		
# -*- coding: utf-8 -*-
"""
Created on Tue Aug  9 16:20:20 2016

@author: Dip
"""

import pymysql
import json_utils
import sys
import logging
import jwt
import time
import datetime

def handler(event, context):
	db = pymysql.connect(host="pharmacate-core.c4t3bxujamid.us-west-2.rds.amazonaws.com",port=3306,user= "PharmaAdmin",passwd="5?#B5MrNZa`3G{t+vs'~",db="pharmacateDB")
	cursor = db.cursor()
	
	logger = logging.getLogger()
	logger.setLevel(logging.INFO)
	
	result = {}
	
	try:
		cursor.execute("SELECT * FROM pharmacateDB.SECRET_ATTRIBUTES");
	except cursor.Error as err:
		print err
		result["STATUS"] = 0
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	rows = cursor.fetchall()
	for row in rows:
		secretKey = row[0]
		tokenDuration = row[1]
		
	millis = int(round(time.time() * 1000))
		
	if event['jsonB']['Queries'].has_key('USR_ID'):
		userId = event['jsonB']['Queries']['USR_ID']
		searchQuery = "SELECT USER_NAME,FB_ID,UDID FROM pharmacateDB.USER "
		searchQuery += "WHERE USR_ID = '%s'" % (userId)
	
		try:
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
			if rows[0][0] is not None:
				dictionary = {"USER_NAME":rows[0][0], "TIME_STAMP": millis, 'exp': datetime.datetime.utcnow() + datetime.timedelta(seconds=tokenDuration)}
				token = jwt.encode(dictionary, secretKey, algorithm='HS256')
			elif rows[0][1] is not None:
				dictionary = {"FB_ID":rows[0][1], "TIME_STAMP": millis, 'exp': datetime.datetime.utcnow() + datetime.timedelta(seconds=tokenDuration)}
				token = jwt.encode(dictionary, secretKey, algorithm='HS256')
			elif rows[0][2] is not None:
				dictionary = {"UDID":rows[0][2], "TIME_STAMP": millis, 'exp': datetime.datetime.utcnow() + datetime.timedelta(seconds=tokenDuration)}
				token = jwt.encode(dictionary, secretKey, algorithm='HS256')
				
			updateQuery = "UPDATE pharmacateDB.USER "
			updateQuery += "SET TOKEN = '%s' " %(token)
			updateQuery += "WHERE USR_ID = '%s' " % (userId)			
		
			try:
				cursor.execute(updateQuery)
			except cursor.Error as err:
				print err
				result["STATUS"] = 0
				cursor.close()
				db.close()	
				logger.error("Something went wrong with query: {}".format(err))
				sys.exit()
			result["STATUS"] = 1
			result["TOKEN"] = token
			
	db.commit();
	cursor.close()
	db.close()
	
	return json_utils.EncodeResults(result)
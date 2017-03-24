# -*- coding: utf-8 -*-
"""
Created on Tue Jul  5 14:56:40 2016

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
	
	try:
		cursor.execute("SELECT * FROM pharmacateDB.SECRET_ATTRIBUTES");
	except cursor.Error as err:
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	rows = cursor.fetchall()
	for row in rows:
		secretKey = row[0]
		tokenDuration = row[1]
	
	millis = int(round(time.time() * 1000))
	deviceToken = ""
	result = {}
	
	if event['jsonB']['Queries'].has_key('USER_NAME'):
		userName = event['jsonB']['Queries']['USER_NAME']
		searchQuery = "SELECT USER_NAME FROM pharmacateDB.USER "
		searchQuery += "WHERE USER_NAME = '%s'" % (userName)
		
		dictionary = {"USER_NAME":event['jsonB']['Queries']['USER_NAME'], "TIME_STAMP": millis, 'exp': datetime.datetime.utcnow() + datetime.timedelta(seconds=tokenDuration)}
		token = jwt.encode(dictionary, secretKey, algorithm='HS256')
	
		try:
			cursor.execute(searchQuery)
		except cursor.Error as err:
			print err
			cursor.close()
			db.close()	
			logger.error("Something went wrong with query: {}".format(err))
			sys.exit()
		
		rows = cursor.fetchall()
		if len(rows) > 0:
			updateQuery = "UPDATE pharmacateDB.USER "
			updateQuery += "SET TOKEN = '%s', " %(token)
			updateQuery += "TYPE = 'GOOGLE', "
			updateQuery += "FIRST_NAME = '%s', " %(event['jsonB']['Queries']['FIRST_NAME'])
			updateQuery += "LAST_NAME = '%s', " %(event['jsonB']['Queries']['LAST_NAME'])
			updateQuery += "GOOGLE_ID = '%s', " %(event['jsonB']['Queries']['GOOGLE_ID'])
			updateQuery += "IMAGE_LINK = '%s', " %(event['jsonB']['Queries']['IMAGE_LINK'])
			updateQuery += "DEVICE_TOKEN = '%s' " %(event['jsonB']['Queries']['DEVICE_TOKEN'])
			updateQuery += "WHERE USER_NAME = '%s' " % (userName)
		
			try:
				cursor.execute(updateQuery)
			except cursor.Error as err:
				print err
				cursor.close()
				db.close()	
				logger.error("Something went wrong with query: {}".format(err))
				sys.exit()
			result["STATUS"] = 1
			result["TOKEN"] = token
		else:
			insertQuery = "INSERT INTO pharmacateDB.USER "
			insertQuery += "(USER_NAME, TOKEN, TYPE, FIRST_NAME, LAST_NAME, GOOGLE_ID, IMAGE_LINK, DEVICE_TOKEN)" + " VALUES ('%s', '%s', 'FB', '%s', '%s', '%s', '%s', '%s')" %(userName, token, event['jsonB']['Queries']['FIRST_NAME'], event['jsonB']['Queries']['LAST_NAME'], event['jsonB']['Queries']['GOOGLE_ID'], event['jsonB']['Queries']['IMAGE_LINK'], event['jsonB']['Queries']['DEVICE_TOKEN'])
			
			try:
				cursor.execute(insertQuery)
			except cursor.Error as err:
				print err
				cursor.close()
				db.close()	
				logger.error("Something went wrong with query: {}".format(err))
				sys.exit()
				
			rows = cursor.fetchall()
			result["STATUS"] = 1
			result["TOKEN"] = token
			
	if result["STATUS"] == 1:
		getUserIdQuery = "SELECT USR_ID FROM pharmacateDB.USER WHERE USER_NAME = '%s'" %(userName)
		try:
			cursor.execute(getUserIdQuery)
		except cursor.Error as err:
			print err
			cursor.close()
			db.close()	
			logger.error("Something went wrong with query: {}".format(err))
			sys.exit()
		rows = cursor.fetchall()
		result["USR_ID"] = rows[0][0]
			
	db.commit();
	cursor.close()
	db.close()
	
	return json_utils.EncodeResults(result)
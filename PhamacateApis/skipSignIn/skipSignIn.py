# -*- coding: utf-8 -*-
"""
Created on Fri Jun 24 14:52:26 2016

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
	
#	if event['jsonB'].has_key('Queries'):
#		udid = event['jsonB']['Queries']['UDID']
#		deviceToken = event['jsonB']['Queries']['DEVICE_TOKEN']
	deviceToken = ""
	udid = "1AB86484-AF18-4673-9D0D-C31BAD498DAA"
	dictionary = {"UDID":udid, "TIME_STAMP": millis, 'exp': datetime.datetime.utcnow() + datetime.timedelta(seconds=tokenDuration)}
	token = jwt.encode(dictionary, secretKey, algorithm='HS256')
	
	searchQuery = "SELECT UDID FROM pharmacateDB.USER "
	searchQuery += "WHERE UDID = '%s'" % (udid)
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
	if len(rows) > 0:
		updateQuery = "UPDATE pharmacateDB.USER "
		updateQuery += "SET TOKEN = '%s', " %(token)
		updateQuery += "DEVICE_TOKEN = '%s' " %(deviceToken)
		updateQuery += "WHERE UDID = '%s'" % (udid)
		
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
		insertQuery += "(UDID, TOKEN, DEVICE_TOKEN) VALUES ('%s', '%s', '%s')" % (udid, token, deviceToken)
		try:
			cursor.execute(insertQuery)
		except cursor.Error as err:
			print err
			cursor.close()
			db.close()	
			logger.error("Something went wrong with query: {}".format(err))
			sys.exit()
		result["STATUS"] = 1
		result["TOKEN"] = token
		
	if result["STATUS"] == 1:
		getUserIdQuery = "SELECT USR_ID FROM pharmacateDB.USER WHERE UDID = '%s'" %(udid)
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
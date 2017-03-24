# -*- coding: utf-8 -*-
"""
Created on Thu Jun 23 11:13:38 2016

@author: Dip
"""

import pymysql
import json_utils
import string	
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
	if event['jsonB'].has_key('Queries'):
		userName = event['jsonB']['Queries']['USER_NAME']
		password = event['jsonB']['Queries']['PASS']
	dictionary = {"USER_NAME":userName, "TIME_STAMP": millis, 'exp': datetime.datetime.utcnow() + datetime.timedelta(seconds=tokenDuration)}
	token = jwt.encode(dictionary, secretKey, algorithm='HS256')
	
	searchQuery = "SELECT USER_NAME, PASS FROM pharmacateDB.USER "
	searchQuery += "WHERE USER_NAME = '%s' " % (userName)
	searchQuery += "AND PASS = '%s'" % (password)
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
		updateQuery += "SET TOKEN = '%s'" %(token)
		updateQuery += "WHERE USER_NAME = '%s' " % (userName)
		updateQuery += "AND PASS = '%s'" % (password) 
		
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
		result["STATUS"] = 0
	for row in rows:
		print row
	
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
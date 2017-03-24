# -*- coding: utf-8 -*-
"""
Created on Fri Jun 24 09:56:25 2016

@author: Dip
"""

import pymysql
import json_utils
import sys
import logging
import jwt

def handler(event, context):
	
	logger = logging.getLogger()
	logger.setLevel(logging.INFO)
	
	token = ""
	if event['jsonB'].has_key('Queries'):
		token += event['jsonB']['Queries']['TOKEN']
	
	result = {}
	data = {}
	try:
		data = jwt.decode(token, 'secret')
	except (jwt.ExpiredSignatureError, jwt.DecodeError), e:
		result["STATUS"] = 0
		result["COMMENTS"] = e

	if len(data) > 0 :
		db = pymysql.connect(host="pharmacate-core.c4t3bxujamid.us-west-2.rds.amazonaws.com",port=3306,user= "PharmaAdmin",passwd="5?#B5MrNZa`3G{t+vs'~",db="pharmacateDB")
		cursor = db.cursor()
		searchQuery = "SELECT * FROM pharmacateDB.USER "
		searchQuery += "WHERE TOKEN = '%s'" % (token)
		try:
			cursor.execute(searchQuery)
		except cursor.Error as err:
			print err
			result["STATUS"] = 0;
			result["COMMENTS"] = err
			cursor.close()
			db.close()	
			logger.error("Something went wrong with query: {}".format(err))
			sys.exit()
		result["STATUS"] = 1;
		result["COMMENTS"] = "token valid"
		
		rows = cursor.fetchall()
		
		for row in rows:
			result["USER_NAME"] = row[1]
		db.commit()
		
		db.close()
		cursor.close()
		
		return json_utils.EncodeResults(result)
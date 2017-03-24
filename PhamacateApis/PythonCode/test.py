# -*- coding: utf-8 -*-
"""
Created on Thu Jun 23 10:17:33 2016

@author: Dip
"""

import pymysql
import json_utils
import sys
import logging
import jwt
import time
import datetime

def handler():
	db = pymysql.connect(host="pharmacate-core.c4t3bxujamid.us-west-2.rds.amazonaws.com",port=3306,user= "PharmaAdmin",passwd="5?#B5MrNZa`3G{t+vs'~",db="pharmacateDB")
	cursor = db.cursor()
	
	logger = logging.getLogger()
	logger.setLevel(logging.INFO)
	
	result = {}
	userId = '11'
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
		idStr = ''
		if rows[0][2] is not None:
			print rows[0][2]

handler()


	
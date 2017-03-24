# -*- coding: utf-8 -*-
"""
Created on Wed Jun 22 13:45:06 2016

@author: Dip
"""

import pymysql
import json
import string	
import sys
import logging

def handler(userName, password):
	db = pymysql.connect(host="pharmacate-core.c4t3bxujamid.us-west-2.rds.amazonaws.com",port=3306,user= "PharmaAdmin",passwd="5?#B5MrNZa`3G{t+vs'~",db="pharmacateDB")
	cursor = db.cursor()
	
	logger = logging.getLogger()
	logger.setLevel(logging.INFO)
	
	insertQuery = "INSERT INTO pharmacateDB.USERS "
	insertQuery += "(USER_NAME, PASS) VALUES ('%s', '%s')" % (userName, password)
	print insertQuery
	print type(userName)
	
	try:
		cursor.execute(insertQuery)
	except cursor.Error as err:
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	db.commit()
		
	rows = cursor.fetchall()
	for row in rows:
		print row[0]
		
	cursor.close()
	db.close()
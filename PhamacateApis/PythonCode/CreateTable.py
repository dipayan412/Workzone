# -*- coding: utf-8 -*-
"""
Created on Wed Jun 22 12:06:38 2016

@author: Dip
"""

import pymysql
# Import library to deal with json 
import json
import string	
import sys
import logging
import json_utils

if __name__ == '__main__':
	# Open database connection
	db = pymysql.connect(host="pharmacate-core.c4t3bxujamid.us-west-2.rds.amazonaws.com",port=3306,user= "PharmaAdmin",passwd="5?#B5MrNZa`3G{t+vs'~",db="pharmacateDB")
	# prepare a cursor object using cursor() method
	cursor = db.cursor()
	
	logger = logging.getLogger()
	logger.setLevel(logging.INFO)
	
#	try:
#		cursor.execute("DROP TABLE IF EXISTS pharmacateDB.USER") 
#	except cursor.Error as err:
#		cursor.close()
#		db.close()
#		logger.error("Something went wrong with query: {}".format(err))	
#		sys.exit()

#	create_table_mysql = "CREATE TABLE IF NOT EXISTS pharmacateDB.USER "
#	create_table_mysql += "(USR_ID INT NOT NULL AUTO_INCREMENT,"
#	create_table_mysql += "USER_NAME varchar(100),"
#	create_table_mysql += "PASS varchar(100),"
#	create_table_mysql += "TOKEN varchar(1000),"
#	create_table_mysql += "TYPE varchar(100),"
#	create_table_mysql += "UUID varchar(100),"
#	create_table_mysql += "FIRST_NAME varchar(100),"
#	create_table_mysql += "LAST_NAME varchar(100),"
#	create_table_mysql += "FB_ID varchar(100),"
#	create_table_mysql += "PRIMARY KEY (USR_ID))"

#	create_table_mysql = "CREATE TABLE IF NOT EXISTS pharmacateDB.USER_SEARCH_HISTORY "
#	create_table_mysql += "(SEARCH_ID INT NOT NULL AUTO_INCREMENT,"
#	create_table_mysql += "USR_ID INT NOT NULL, "
#	create_table_mysql += "PRODUCT_ID INT NOT NULL, "
#	create_table_mysql += "CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP, "
#	create_table_mysql += "PRIMARY KEY (SEARCH_ID))"
	
	create_table_mysql = "CREATE TABLE IF NOT EXISTS pharmacateDB.USER_FEEDBACK "
	create_table_mysql += "(FEEDBACK_ID INT NOT NULL AUTO_INCREMENT,"
	create_table_mysql += "CONTENT varchar(500), "
	create_table_mysql += "USR_ID varchar(500), "
	create_table_mysql += "IS_DELETED varchar(1), "
	create_table_mysql += "CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP, "
	create_table_mysql += "UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP, "
	create_table_mysql += "PRIMARY KEY (FEEDBACK_ID))"
	
	try:
		cursor.execute(create_table_mysql)
	except cursor.Error as err:
		print err
		cursor.close()
		db.close()
#		logger.error("Something went wrong with query: {}".format(err))	
		sys.exit()
	
#	secretKey = "secret"
#	tokenDuration = 3600
#	insertQuery = "INSERT INTO pharmacateDB.SECRET_ATTRIBUTES "
#	insertQuery += "(SECRET_KEY, TOKEN_VALID_DURATION) VALUES ('%s', '%s')" % (secretKey, tokenDuration)
#	
#	try:
#		cursor.execute(insertQuery)
#	except cursor.Error as err:
#		print err
#		cursor.close()
#		db.close()
##		logger.error("Something went wrong with query: {}".format(err))	
#		sys.exit()

#	rows = cursor.fetchall()
#	print rows
#	for row in rows:
#		print row[0]
	
#	columns = [desc[0] for desc in cursor.description]
#	result = []
#	for row in rows:
#		row = dict(zip(columns, (row)))
#		result.append(row)
#	field_names = [i[0] for i in cursor.description]
#	for i in rows:
#		print i
	
	result = {}
	result["Status"] = 1
		
	db.commit()
 
	cursor.close()
	db.close()
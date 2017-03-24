# -*- coding: utf-8 -*-
"""
Created on Sun Jun 26 23:21:58 2016

@author: Dip
"""

import jwt
import pymysql
import sys

def checkToken(token):
	db = pymysql.connect(host="pharmacate-core.c4t3bxujamid.us-west-2.rds.amazonaws.com",port=3306,user= "PharmaAdmin",passwd="5?#B5MrNZa`3G{t+vs'~",db="pharmacateDB")
	cursor = db.cursor()
	
	try:
		cursor.execute("SELECT * FROM pharmacateDB.SECRET_ATTRIBUTES");
	except cursor.Error as err:
		print err
		cursor.close()
		db.close()	
		sys.exit()
		
	rows = cursor.fetchall()
	for row in rows:
		secretKey = row[0]
	
	success = True
	try:
		data = jwt.decode(token, secretKey)
		print data
	except (jwt.ExpiredSignatureError, jwt.DecodeError), e :
		print e
		success = False
		
	return success


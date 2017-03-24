# -*- coding: utf-8 -*-
"""
Created on Wed Jun 22 13:39:06 2016

@author: Dip
"""

import pymysql
import json
#import string	
import sys
import logging
import datetime
import time
import jwt
#token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJUSU1FX1NUQU1QIjoxNDY3NzQ1ODcxNjk3LCJVU0VSX05BTUUiOiJnaWxiYXJ0dG8uZGUucGllbnRvQGdtYWlsLmNvbSIsImV4cCI6MTQ2Nzc0OTQ3MX0.pPRdfGmVsTM3jbapBmd28OJoqmq9PYNlXK5-cMFu4es"
if __name__ == '__main__':
	logger = logging.getLogger()
	logger.setLevel(logging.INFO)	
#	userName = "abc"	
#	password = "123"
#	millis = int(round(time.time() * 1000))
#	db = pymysql.connect(host="pharmacate-core.c4t3bxujamid.us-west-2.rds.amazonaws.com",port=3306,user= "PharmaAdmin",passwd="5?#B5MrNZa`3G{t+vs'~",db="pharmacateDB")
	db = pymysql.connect(host="pharmacate-core.c4t3bxujamid.us-west-2.rds.amazonaws.com",port=3306,user= "PharmaAdmin",passwd="5?#B5MrNZa`3G{t+vs'~",db="staging_News_ReviewsDB")
	cursor = db.cursor()
#	token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhYmMiOjE0NjY3MDI0ODU5MzB9.gWlJ9uj1UhUOuwsa2bJFH-CKKD07FWgtez"
#	searchQuery = "SELECT USR_ID FROM pharmacateDB.USER WHERE TOKEN = '%s'" %(token)
#	dictionary = {"USER_NAME":userName, "TIME_STAMP": millis, 'exp': datetime.datetime.utcnow() + datetime.timedelta(seconds=3600)}
#	token = jwt.encode(dictionary, "secret", algorithm='HS256')
	
#	insertQuery = "INSERT INTO pharmacateDB.USER "
#	insertQuery += "(USER_NAME, PASS, TOKEN) VALUES ('%s', '%s', '%s')" % (userName, password, token)	
	
#	searchString = "e"
#	limit = str(5)
#	searchQuery = "SELECT PRODUCT_ID,PROPRIETARY_NAME,NONPROPRIETARY_NAME FROM pharmacateDB.PRODUCTS WHERE PROPRIETARY_NAME LIKE '%" + "%s" %(searchString) + "%' OR NONPROPRIETARY_NAME LIKE '%" + "%s" %(searchString) + "%' LIMIT " + limit
	try:
#		cursor.execute(searchQuery)
#		cursor.execute("UPDATE pharmacateDB.USER SET USER_NAME = 'asd' WHERE USER_NAME = '%s' AND PASS = '%s'" % (userName, password))
#		cursor.execute("DROP TABLE pharmacateDB.BING_NEWS")
#		cursor.execute("SELECT * FROM pharmacateDB.BING_NEWS")
#		cursor.execute("SELECT IS_ACTIVE FROM pharmacateDB.LABEL_MAIN_PRODUCTS WHERE MAIN_PRODUCT_ID = '1000000007'")
#		cursor.execute("SELECT MAIN_PRODUCT_ID FROM pharmacateDB.LABEL_MAIN_PRODUCTS WHERE IS_ACTIVE = 'Y' LIMIT 10")
#		cursor.execute("INSERT INTO pharmacateDB.ALTERNATIVES (PRODUCT_ID, ALTERNATIVE_ID, ACTIVE_INGREDIENTS_SIMILARITY) VALUES ('1000000006', '1000034173', '0.9')")
#		cursor.execute("SELECT DISTINCT (PRODUCT_TYPE) FROM pharmacateDB.PRODUCTS")
#		cursor.execute("show tables")
#		cursor.execute("SELECT * FROM pharmacateDB.PRODUCT_IMAGES LIMIT 1")
#		cursor.execute("SELECT ALLERGEN_ID,ALLERGEN_NAME FROM pharmacateDB.ALLERGENS WHERE ALLERGEN_NAME LIKE '%e%' LIMIT 5")
#		cursor.execute("SELECT USER_REVIEW_ID FROM staging_News_ReviewsDB.PRODUCT_REVIEWS_RELATIONS WHERE PRODUCT_ID = '1000000006' LIMIT 10")
#		cursor.execute("SELECT * FROM staging_News_ReviewsDB.REVIEWS WHERE LIMIT 1")
#		cursor.execute("SELECT PRODUCT_ID,PROPRIETARY_NAME,NONPROPRIETARY_NAME FROM pharmacateDB.PRODUCTS WHERE PRODUCT_ID = '1000009891' LIMIT 10")
#		cursor.execute("SELECT * FROM pharmacateDB.SIDE_EFFECTS LIMIT 10")
#		cursor.execute("SELECT * FROM pharmacateDB.USER_PRODUCTS WHERE USR_ID = 11")
#		cursor.execute("SELECT * FROM staging_News_ReviewsDB.REVIEWS WHERE CONTENT = 'Test1991'")
#		cursor.execute("SELECT PROPRIETARY_NAME FROM pharmacateDB.PRODUCTS WHERE PRODUCT_ID = 1000000001")
#		cursor.execute("SELECT * FROM pharmacateDB.PRODUCTS WHERE PRODUCT_ID = 1000049718")
#		cursor.execute("SELECT GENERIC_NAME FROM pharmacateDB.TOP_DRUGS")
#		cursor.execute("SELECT * FROM pharmacateDB.DISEASES LIMIT 1")
#		cursor.execute("SELECT DISEASE_ID,DISEASE_NAME FROM pharmacateDB.DISEASES WHERE DISEASE_NAME LIKE '%fever%'")
#		cursor.execute("SELECT PRODUCT_ID,PROPRIETARY_NAME,NONPROPRIETARY_NAME FROM pharmacateDB.PRODUCTS")
#		cursor.execute("SELECT * FROM pharmacateDB.DISEASES LIMIT 1")
#		cursor.execute("SELECT * FROM pharmacateDB.USER_SEARCH_HISTORY");
#		cursor.execute("SELECT USR_ID FROM pharmacateDB.USER WHERE USR_ID = '%s'");
#		cursor.execute("ALTER TABLE pharmacateDB.USER ADD COLUMN GOOGLE_ID VARCHAR(100)")
#		cursor.execute("SELECT * FROM pharmacateDB.USER")
#		cursor.execute("ALTER TABLE pharmacateDB.USER change UUID UDID VARCHAR(100)")
#		cursor.execute("SELECT PRODUCT_ID, CREATED_AT FROM pharmacateDB.USER_SEARCH_HISTORY WHERE USR_ID = 11");
#		cursor.execute("SELECT * FROM pharmacateDB.USER_SEARCH_HISTORY")
#		cursor.execute("SELECT USR_ID FROM pharmacateDB.USER WHERE USER_NAME = '%s'" %(userName))
#		cursor.execute(insertQuery)
#		cursor.execute("ALTER TABLE pharmacateDB.USER ADD COLUMN DEVICE_TOKEN VARCHAR(1000)")
#		cursor.execute("SELECT * FROM pharmacateDB.USER LIMIT 1")
#		cursor.execute("SELECT * FROM staging_News_ReviewsDB.PRODUCT_REVIEWS_RELATIONS WHERE USER_REVIEW_ID = '405669' LIMIT 1");
#		cursor.execute("UPDATE staging_News_ReviewsDB.PRODUCT_REVIEWS_RELATIONS SET IS_DELETED = 'N' WHERE USER_REVIEW_ID = '405669'");
		cursor.execute("SELECT COUNT(*) FROM staging_News_ReviewsDB.REVIEW_SCORES  LIMIT 10");
#		cursor.execute("SELECT * FROM staging_News_ReviewsDB.PRODUCT_REVIEWS_RELATIONS LIMIT 10");
#		cursor.execute("UPDATE staging_News_ReviewsDB.PRODUCT_REVIEWS_RELATIONS SET IS_DELETED = 'N'");
	except cursor.Error as err:
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
#	print searchQuery
	rows = cursor.fetchall()
#	result = {}
#	result["USER_REVIEW_ID"] = []
	print rows
	print type(rows[0][0])
	counter = 0
#	print len(rows)
#	for row in rows:
#		string = row[0].split("/")
#		print string[0]
#		print row[0]
#		result["USER_REVIEW_ID"].append(row[0])
#		counter += 1
#		print row
#	REVIEW_SCORE
		
#	print result["USER_REVIEW_ID"]
#	print cursor.description
#	print counter
#	result = {}
#	result["Data"] = []
#	for row in rows:
#		tmpDic = {}
#		tmpDic["PRODUCT_ID"] = row[0]
#		tmpDic["PRODUCT_NAME"] = row[1]
#		tmpDic["PRODUCT_INGREDIENT_NAME"] = row[2]
#		tmpDic["DATE_CREATED"] = row[3]
#		result["Data"].append(tmpDic)
	
#	for row in rows:
#		tmpDic = {}
#		try:
#			cursor.execute("SELECT PROPRIETARY_NAME FROM pharmacateDB.PRODUCTS WHERE PRODUCT_ID = '%s'" %(row[0]));
#		except:
#			print err
#		rows1 = cursor.fetchall()
#		tmpDic["PROPRIETARY_NAME"] = rows1[0][0]
#		tmpDic["Date"] = row[1]
#		result["Data"].append(tmpDic)
#	print result
#	print cursor.description		
	db.commit();
	cursor.close()
	db.close()
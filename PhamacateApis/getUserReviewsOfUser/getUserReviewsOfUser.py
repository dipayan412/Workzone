# -*- coding: utf-8 -*-
"""
Created on Thu Jul 28 06:17:52 2016

@author: Dip
"""

import pymysql
import json_utils
import sys
import logging

def handler(event, context):
	db = pymysql.connect(host="pharmacate-core.c4t3bxujamid.us-west-2.rds.amazonaws.com",port=3306,user= "PharmaAdmin",passwd="5?#B5MrNZa`3G{t+vs'~",db="staging_News_ReviewsDB")
	cursor = db.cursor()
	db2 = pymysql.connect(host="pharmacate-core.c4t3bxujamid.us-west-2.rds.amazonaws.com",port=3306,user= "PharmaAdmin",passwd="5?#B5MrNZa`3G{t+vs'~",db="pharmacateDB")
	cursor2 = db2.cursor()
	
	logger = logging.getLogger()
	logger.setLevel(logging.INFO)
	
	result = {}
	result["REVIEW_LIST"] = []
	userId = event['jsonB']['Queries']['USR_ID']
	
	searchQuery = "SELECT CONTENT,REVIEW_DATE,TREATEMENT_DURATION,USER_REVIEW_ID,ORIGINAL_USER_RATING,USER_INFO,IS_INTERNAL_REVIEW,ORIGINAL_ID FROM staging_News_ReviewsDB.REVIEWS "
	searchQuery += "WHERE ORIGINAL_ID = '%s' " %(userId)
	searchQuery += "AND IS_DELETED = 'N'"
	
	try:
		cursor.execute(searchQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
			
	reviewObject = cursor.fetchall()
	print reviewObject
	
	for review in reviewObject:
		tmpDic = {}
		searchQuery = "SELECT PRODUCT_ID FROM staging_News_ReviewsDB.PRODUCT_REVIEWS_RELATIONS "
		searchQuery += "WHERE USER_REVIEW_ID = '%s' " %(review[3])
		searchQuery += "AND IS_DELETED = 'N'"
		
		try:
			cursor.execute(searchQuery)
		except cursor.Error as err:
			result["STATUS"] = 0
			print err
			cursor.close()
			db.close()	
			logger.error("Something went wrong with query: {}".format(err))
			sys.exit()
		
		productId = cursor.fetchall();

        searchQuery = "SELECT PROPRIETARY_NAME FROM pharmacateDB.PRODUCTS "
        searchQuery += "WHERE PRODUCT_ID = '%s'" %(productId[0][0])
            
        try:
		cursor2.execute(searchQuery)
        except cursor2.Error as err:
		result["STATUS"] = 0
		print err
		cursor2.close()
		db2.close()
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
                
        productName = cursor2.fetchall();
        tmpDic["CONTENT"] = review[0]
        tmpDic["REVIEW_DATE"] = review[1]
        tmpDic["USER_REVIEW_ID"] = review[3]
        tmpDic["ORIGINAL_USER_RATING"] = review[4]
        tmpDic["PRODUCT_ID"] = productId[0][0]
        tmpDic["PROPRIETARY_NAME"] = productName[0][0]
		
        result["REVIEW_LIST"].append(tmpDic)
		
	result["STATUS"] = 1
	
	db.commit();
	cursor.close()
	db.close()
	
	return json_utils.EncodeResults(result)
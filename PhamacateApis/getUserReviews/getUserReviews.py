# -*- coding: utf-8 -*-
"""
Created on Mon Jul 18 23:37:10 2016

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
	productId = event['jsonB']['Queries']['PRODUCT_ID']
	
	searchQuery = "SELECT USER_REVIEW_ID FROM staging_News_ReviewsDB.PRODUCT_REVIEWS_RELATIONS "
	searchQuery += "WHERE PRODUCT_ID = '%s' " %(productId)
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
		
	reviewIdList = cursor.fetchall()
#	print len(reviewIdList)
	for reviewId in reviewIdList:
		tmpDic = {}
		searchQuery = "SELECT CONTENT,REVIEW_DATE,TREATEMENT_DURATION,USER_REVIEW_ID,ORIGINAL_USER_RATING,USER_INFO,IS_INTERNAL_REVIEW,ORIGINAL_ID,DATA_SOURCE_ID FROM staging_News_ReviewsDB.REVIEWS "
		searchQuery += "WHERE USER_REVIEW_ID = '%s' " %(reviewId[0])
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
		
		tmpDic["CONTENT"] = unicode(reviewObject[0][0], errors='ignore')
		tmpDic["REVIEW_DATE"] = reviewObject[0][1]
		tmpDic["TREATEMENT_DURATION"] = reviewObject[0][2]
		tmpDic["USER_REVIEW_ID"] = reviewObject[0][3]
		tmpDic["ORIGINAL_USER_RATING"] = reviewObject[0][4]
		tmpDic["USER_INFO"] = reviewObject[0][5]
		tmpDic["IS_INTERNAL_REVIEW"] = reviewObject[0][6]
		tmpDic["ORIGINAL_ID"] = reviewObject[0][7]
		tmpDic["DATA_SOURCE_ID"] = reviewObject[0][8]
		if tmpDic["ORIGINAL_ID"] is not None:
			searchQuery = "SELECT FIRST_NAME,IMAGE_LINK FROM pharmacateDB.USER "
			searchQuery += "WHERE USR_ID = '%s'" %(tmpDic["ORIGINAL_ID"])
			try:
				cursor2.execute(searchQuery)
			except cursor2.Error as err:
				result["STATUS"] = 0
				print err
				cursor2.close()
				db2.close()	
				logger.error("Something went wrong with query: {}".format(err))
				sys.exit()
			user = cursor2.fetchall()
			if len(user) > 0:
				if user[0][0] is not None:
					tmpDic["FIRST_NAME"] = user[0][0]
				if user[0][1] is not None:
					tmpDic["IMAGE_LINK"] = user[0][1]
		if tmpDic["DATA_SOURCE_ID"] is not None:
			searchQuery = "SELECT DATA_SOURCE FROM pharmacateDB.DATA_SOURCES "
			searchQuery += "WHERE DATA_SOURCE_ID = '%s'" %(tmpDic["DATA_SOURCE_ID"])
			try:
				cursor2.execute(searchQuery)
			except cursor2.Error as err:
				result["STATUS"] = 0
				print err
				cursor2.close()
				db2.close()	
				logger.error("Something went wrong with query: {}".format(err))
				sys.exit()
			ds = cursor2.fetchall()
			if len(ds) > 0:
				if ds[0][0] is not None:
					tmpDic["DATA_SOURCE_NAME"] = ds[0][0]
		result["REVIEW_LIST"].append(tmpDic)
	
	result["STATUS"] = 1
	
	db.commit();
	cursor.close()
	db.close()
	
	db2.commit();
	cursor2.close()
	db2.close()
	
	return json_utils.EncodeResults(result)
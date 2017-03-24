# -*- coding: utf-8 -*-
"""
Created on Sat Jul 30 18:04:28 2016

@author: Dip
"""

import pymysql
import json_utils
import sys
import logging

def handler(event, context):
	db = pymysql.connect(host="pharmacate-core.c4t3bxujamid.us-west-2.rds.amazonaws.com",port=3306,user= "PharmaAdmin",passwd="5?#B5MrNZa`3G{t+vs'~",db="staging_News_ReviewsDB")
	cursor = db.cursor()
	
	logger = logging.getLogger()
	logger.setLevel(logging.INFO)
	
	result = {}
	reviewId = event['jsonB']['Queries']['USER_REVIEW_ID']

	updateQuery = "UPDATE staging_News_ReviewsDB.PRODUCT_REVIEWS_RELATIONS SET IS_DELETED = 'Y' WHERE USER_REVIEW_ID = '%s'" %(reviewId)
	print reviewId
	try:
		cursor.execute(updateQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	updateQuery = "UPDATE staging_News_ReviewsDB.REVIEWS SET IS_DELETED = 'Y' WHERE USER_REVIEW_ID = '%s'" %(reviewId)
	
	try:
		cursor.execute(updateQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	result["STATUS"] = 1
	print result["STATUS"]
	
	db.commit();
	cursor.close()
	db.close()
	
	return json_utils.EncodeResults(result)
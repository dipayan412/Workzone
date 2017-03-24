# -*- coding: utf-8 -*-
"""
Created on Tue Jul 19 09:00:40 2016

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
	
	dataSourceid = '1001'

	treatmentDuration = ''
	if event['jsonB']['Queries'].has_key('TREATEMENT_DURATION'):
		treatmentDuration = event['jsonB']['Queries']['TREATEMENT_DURATION']
	
	conditionInfo = ''
	if event['jsonB']['Queries'].has_key('CONDITION_INFO'):
		conditionInfo = event['jsonB']['Queries']['CONDITION_INFO']
		
	originalUserRating = ''
	if event['jsonB']['Queries'].has_key('ORIGINAL_USER_RATING'):
		originalUserRating = event['jsonB']['Queries']['ORIGINAL_USER_RATING']
		
	content = ''
	if event['jsonB']['Queries'].has_key('CONTENT'):
		content = event['jsonB']['Queries']['CONTENT']
		
	userId = ''
	if event['jsonB']['Queries'].has_key('USR_ID'):
		userId = event['jsonB']['Queries']['USR_ID']
		
	reviewDate = ''
	if event['jsonB']['Queries'].has_key('REVIEW_DATE'):
		reviewDate = event['jsonB']['Queries']['REVIEW_DATE']
		
	productId = ''
	if event['jsonB']['Queries'].has_key('PRODUCT_ID'):
		productId = event['jsonB']['Queries']['PRODUCT_ID']
		
	isInterNalReview = 'Y'
	isDeleted = 'N'
		
	insertQuery = "INSERT INTO staging_News_ReviewsDB.REVIEWS "
	insertQuery += "(CONTENT, REVIEW_DATE, TREATEMENT_DURATION, ORIGINAL_USER_RATING, ORIGINAL_ID, CONDITION_INFO, IS_DELETED, DATA_SOURCE_ID, IS_INTERNAL_REVIEW) "
	insertQuery += "VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')" %(content, reviewDate, treatmentDuration, originalUserRating, userId, conditionInfo, isDeleted, dataSourceid, isInterNalReview)
	try:
		cursor.execute(insertQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	getMaxIdQuery = "SELECT max(USER_REVIEW_ID) FROM staging_News_ReviewsDB.REVIEWS"
	try:
		cursor.execute(getMaxIdQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
	
	rows = cursor.fetchall();
	currentReviewId = rows[0][0]
	insertQuery = "INSERT INTO staging_News_ReviewsDB.PRODUCT_REVIEWS_RELATIONS "
	insertQuery += "(PRODUCT_ID, USER_REVIEW_ID, DATA_SOURCE_ID, IS_DELETED) "
	insertQuery += "VALUES('%s', '%s', '%s', '%s')" %(productId, currentReviewId, dataSourceid, isDeleted)
	try:
		cursor.execute(insertQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
	
	result["STATUS"] = 1
	
	db.commit();
	cursor.close()
	db.close()
	
	return json_utils.EncodeResults(result)
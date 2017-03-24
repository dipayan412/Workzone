# -*- coding: utf-8 -*-
"""
Created on Tue Jul 19 19:49:40 2016

@author: Dip
"""

import pymysql
import json_utils
import sys
import logging

def handler(event, context):
	db = pymysql.connect(host="pharmacate-core.c4t3bxujamid.us-west-2.rds.amazonaws.com",port=3306,user= "PharmaAdmin",passwd="5?#B5MrNZa`3G{t+vs'~",db="pharmacateDB")
	cursor = db.cursor()
	
	logger = logging.getLogger()
	logger.setLevel(logging.INFO)
	
	result = {}
	result["NEWS_LIST"] = []
	
	searchString = "SELECT TITLE,IMAGE_LINK,URL,NEWS_ID,CREATED_AT FROM pharmacateDB.BING_NEWS WHERE IS_DELETED = 'N'"
	try:
		cursor.execute(searchString)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	result["STATUS"] = 1
	rows = cursor.fetchall()
	for newsObject in rows:
		tmpDic = {}
		tmpDic["TITLE"] = newsObject[0]
		tmpDic["IMAGE_LINK"] = newsObject[1]
		tmpDic["URL"] = newsObject[2]
		tmpDic["NEWS_ID"] = newsObject[3]
		tmpDic["CREATED_AT"] = newsObject[4]
		
		result["NEWS_LIST"].append(tmpDic)
		
	db.commit();
	cursor.close()
	db.close()
	
	return json_utils.EncodeResults(result)
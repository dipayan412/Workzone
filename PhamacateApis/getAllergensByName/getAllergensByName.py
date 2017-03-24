# -*- coding: utf-8 -*-
"""
Created on Mon Jul 18 00:04:00 2016

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
	
	searchString = event['jsonB']['Queries']['ALLERGEN_NAME']
	limit = event['jsonB']['Queries']['LIMIT']
	result = {}
	
	searchQuery = "SELECT ALLERGEN_ID,ALLERGEN_NAME FROM pharmacateDB.ALLERGENS WHERE ALLERGEN_NAME LIKE '%" + "%s" %(searchString) + "%' LIMIT " + str(limit)
	try:
		cursor.execute(searchQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	result["ALLERGEN_LIST"] = []
	rows = cursor.fetchall()
	for row in rows:
		tmpDic = {}
		tmpDic["ENTITY"] = "ALLERGEN"
		tmpDic["ENTITY_ID"] = row[0]
		tmpDic["ENTITY_NAME"] = row[1]
		
		result["ALLERGEN_LIST"].append(tmpDic)
	result["ALLERGEN_COUNT"] = len(rows)
		
	searchQuery = "SELECT PRODUCT_ID,PROPRIETARY_NAME,NONPROPRIETARY_NAME FROM pharmacateDB.PRODUCTS WHERE PROPRIETARY_NAME LIKE '%" + "%s" %(searchString) + "%' OR NONPROPRIETARY_NAME LIKE '%" + "%s" %(searchString) + "%' LIMIT " + str(limit)
	try:
		cursor.execute(searchQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	rows = cursor.fetchall()
	for row in rows:
		tmpDic = {}
		tmpDic["ENTITY"] = "PRODUCT"
		tmpDic["ENTITY_ID"] = row[0]
		tmpDic["ENTITY_NAME"] = row[1]
		tmpDic["NONPROPRIETARY_NAME"] = row[2]
		
		result["ALLERGEN_LIST"].append(tmpDic)
	result["PRODUCT_COUNT"] = len(rows)
		
	
	result["STATUS"] = 1
	
	db.commit();
	cursor.close()
	db.close()
	
	return json_utils.EncodeResults(result)
	
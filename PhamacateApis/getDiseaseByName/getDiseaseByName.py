# -*- coding: utf-8 -*-
"""
Created on Sun Jul 17 22:26:11 2016

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
	
	searchString = event['jsonB']['Queries']['DISEASE_NAME']
	result = {}
	
	searchQuery = "SELECT DISEASE_ID,DISEASE_NAME FROM pharmacateDB.DISEASES WHERE DISEASE_NAME LIKE '%" + "%s" %(searchString) + "%'"
	
	try:
		cursor.execute(searchQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
	
	result["DISEASE_LIST"] = []	
	rows = cursor.fetchall()
	for row in rows:
		tmpDic = {}
		tmpDic["DISEASE_ID"] = row[0]
		tmpDic["DISEASE_NAME"] = row[1]
		
		result["DISEASE_LIST"].append(tmpDic)
		
	result["STATUS"] = 1
	
	db.commit();
	cursor.close()
	db.close()
	
	return json_utils.EncodeResults(result)
# -*- coding: utf-8 -*-
"""
Created on Sun Jul 10 17:59:30 2016

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
	userId = event['jsonB']['Queries']['USR_ID']
	
	searchQuery = "SELECT PRODUCT_ID FROM pharmacateDB.USER_PRODUCTS "
	searchQuery += "WHERE USR_ID = '%s' " %(userId)
	searchQuery += "AND IS_DELETED = 'NO'"
	
	try:
		cursor.execute(searchQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	result["PRODUCT_LIST"] = []
	rows = cursor.fetchall()
	print "rows " + str(len(rows))
	print rows
	for row in rows:
		tmpDic = {}
		searchQuery = "SELECT PROPRIETARY_NAME,NONPROPRIETARY_NAME  FROM pharmacateDB.PRODUCTS "
		searchQuery += "WHERE PRODUCT_ID = '%s'" %(row[0])
		try:
			cursor.execute(searchQuery)
		except cursor.Error as err:
			result["STATUS"] = 0
			print err
			cursor.close()
			db.close()	
			logger.error("Something went wrong with query: {}".format(err))
			sys.exit()
		rows1 = cursor.fetchall()
		if len(rows1) > 0:
			tmpDic["PROPRIETARY_NAME"] = rows1[0][0]
			tmpDic["NONPROPRIETARY_NAME"] = rows1[0][1]
			tmpDic["PRODUCT_ID"] = row[0]
			result["PRODUCT_LIST"].append(tmpDic)
		
#	print "Number of products " + str(len(result["PRODUCT_LIST"]))
		
	searchQuery = "SELECT DISEASE_ID FROM pharmacateDB.USER_CONDITIONS "
	searchQuery += "WHERE USR_ID = '%s' " %(userId)
	searchQuery += "AND IS_DELETED = 'NO'"	
	
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
		searchQuery = "SELECT DISEASE_NAME  FROM pharmacateDB.DISEASES "
		searchQuery += "WHERE DISEASE_ID = '%s'" %(row[0])
		try:
			cursor.execute(searchQuery)
		except cursor.Error as err:
			result["STATUS"] = 0
			print err
			cursor.close()
			db.close()	
			logger.error("Something went wrong with query: {}".format(err))
			sys.exit()
		rows1 = cursor.fetchall()
		if len(rows1) > 0:
			tmpDic["DISEASE_NAME"] = rows1[0][0]
			tmpDic["DISEASE_ID"] = row[0]
			result["DISEASE_LIST"].append(tmpDic)
		
#	print "Number of disease " + str(len(result["DISEASE_LIST"]))
		
	searchQuery = "SELECT ENTITY_ID FROM pharmacateDB.USER_ALLERGIES "
	searchQuery += "WHERE USR_ID = '%s' " %(userId)
	searchQuery += "AND IS_DELETED = 'NO' "	
	searchQuery += "AND ENTITY_NAME = 'ALLERGENS'"
	
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
		searchQuery = "SELECT ALLERGEN_NAME  FROM pharmacateDB.ALLERGENS "
		searchQuery += "WHERE ALLERGEN_ID = '%s'" %(row[0])
		try:
			cursor.execute(searchQuery)
		except cursor.Error as err:
			result["STATUS"] = 0
			print err
			cursor.close()
			db.close()	
			logger.error("Something went wrong with query: {}".format(err))
			sys.exit()
		rows1 = cursor.fetchall()
		if len(rows1) > 1:
			tmpDic["ENTITY_NAME"] = rows1[0][0]
			tmpDic["ENTITY_ID"] = row[0]
			tmpDic["ENTITY"] = "ALLERGEN"
			result["ALLERGEN_LIST"].append(tmpDic)
	
#	print "Number of allergen " + str(len(result["ALLERGEN_LIST"]))
		
	searchQuery = "SELECT ENTITY_ID FROM pharmacateDB.USER_ALLERGIES "
	searchQuery += "WHERE USR_ID = '%s' " %(userId)
	searchQuery += "AND IS_DELETED = 'NO' "	
	searchQuery += "AND ENTITY_NAME = 'PRODUCTS'"
	
	try:
		cursor.execute(searchQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	result["ALLERGIC_PRODUCT_LIST"] = []
	rows = cursor.fetchall()
	for row in rows:
		tmpDic = {}
		searchQuery = "SELECT PROPRIETARY_NAME,NONPROPRIETARY_NAME  FROM pharmacateDB.PRODUCTS "
		searchQuery += "WHERE PRODUCT_ID = '%s'" %(row[0])
		try:
			cursor.execute(searchQuery)
		except cursor.Error as err:
			result["STATUS"] = 0
			print err
			cursor.close()
			db.close()	
			logger.error("Something went wrong with query: {}".format(err))
			sys.exit()
		rows1 = cursor.fetchall()
		if len(rows1) > 0:
			tmpDic["ENTITY_NAME"] = rows1[0][0]
			tmpDic["NONPROPRIETARY_NAME"] = rows1[0][1]
			tmpDic["ENTITY_ID"] = row[0]
			tmpDic["ENTITY"] = "PRODUCT"
			result["ALLERGIC_PRODUCT_LIST"].append(tmpDic)
	
#	print "Number of allergicProducts " + str(len(result["ALLERGIC_PRODUCT_LIST"]))
	
	result["STATUS"] = 1
	
	db.commit();
	cursor.close()
	db.close()
	
	return json_utils.EncodeResults(result)
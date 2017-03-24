# -*- coding: utf-8 -*-
"""
Created on Sun Jul 10 16:38:26 2016

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
	
	userId = event['jsonB']['Queries']['USR_ID']
	productIdArray = event['jsonB']['Queries']['PRODUCT_ID_LIST']
	diseaseIdArray = event['jsonB']['Queries']['DISEASE_ID_LIST'] 
	allergensIdArray = event['jsonB']['Queries']['ALLERGEN_ID_LIST'] 
	allergicProductIdArray = event['jsonB']['Queries']['ALLERGIC_PRODUCT_ID_LIST']
	
	result = {}
	
	deleteQuery = "UPDATE pharmacateDB.USER_PRODUCTS "
	deleteQuery += "SET IS_DELETED = 'YES' "
	deleteQuery += "WHERE USR_ID = '%s'" %(userId)
	
	try:
		cursor.execute(deleteQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	for productId in productIdArray:
		searchQuery = "SELECT * FROM pharmacateDB.USER_PRODUCTS "
		searchQuery += "WHERE USR_ID = '%s' " %(userId)
		searchQuery += "AND PRODUCT_ID = '%s'" %(productId)
		
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
		if len(rows) > 0:
			updateQuery = "UPDATE pharmacateDB.USER_PRODUCTS "
			updateQuery += "SET IS_DELETED = 'NO' "
			updateQuery += "WHERE USR_ID = '%s' " %(userId)
			updateQuery += "AND PRODUCT_ID = '%s'" %(productId)
			
			try:
				cursor.execute(updateQuery)
			except cursor.Error as err:
				result["STATUS"] = 0
				print err
				cursor.close()
				db.close()	
				logger.error("Something went wrong with query: {}".format(err))
				sys.exit()
		else:
			insertQuery = "INSERT INTO pharmacateDB.USER_PRODUCTS "
			insertQuery += "(USR_ID, PRODUCT_ID, IS_DELETED)" + " VALUES ('%s', '%s', 'NO')" %(userId, productId)
			
			try:
				cursor.execute(insertQuery)
			except cursor.Error as err:
				result["STATUS"] = 0
				print err
				cursor.close()
				db.close()	
				logger.error("Something went wrong with query: {}".format(err))
				sys.exit()
				
	deleteQuery = "UPDATE pharmacateDB.USER_CONDITIONS "
	deleteQuery += "SET IS_DELETED = 'YES' "
	deleteQuery += "WHERE USR_ID = '%s'" %(userId)
	
	try:
		cursor.execute(deleteQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	for diseaseId in diseaseIdArray:
		searchQuery = "SELECT * FROM pharmacateDB.USER_CONDITIONS "
		searchQuery += "WHERE USR_ID = '%s' " %(userId)
		searchQuery += "AND DISEASE_ID = '%s'" %(diseaseId)
		
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
		if len(rows) > 0:
			updateQuery = "UPDATE pharmacateDB.USER_CONDITIONS "
			updateQuery += "SET IS_DELETED = 'NO' "
			updateQuery += "WHERE USR_ID = '%s' " %(userId)
			updateQuery += "AND DISEASE_ID = '%s'" %(diseaseId)
			
			try:
				cursor.execute(updateQuery)
			except cursor.Error as err:
				result["STATUS"] = 0
				print err
				cursor.close()
				db.close()	
				logger.error("Something went wrong with query: {}".format(err))
				sys.exit()
		else:
			insertQuery = "INSERT INTO pharmacateDB.USER_CONDITIONS "
			insertQuery += "(USR_ID, DISEASE_ID, IS_DELETED)" + " VALUES ('%s', '%s', 'NO')" %(userId, diseaseId)
			
			try:
				cursor.execute(insertQuery)
			except cursor.Error as err:
				result["STATUS"] = 0
				print err
				cursor.close()
				db.close()	
				logger.error("Something went wrong with query: {}".format(err))
				sys.exit()
				
	deleteQuery = "UPDATE pharmacateDB.USER_ALLERGIES "
	deleteQuery += "SET IS_DELETED = 'YES' "
	deleteQuery += "WHERE USR_ID = '%s'" %(userId)
	
	try:
		cursor.execute(deleteQuery)
	except cursor.Error as err:
		result["STATUS"] = 0
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	for allergenId in allergensIdArray:
		searchQuery = "SELECT * FROM pharmacateDB.USER_ALLERGIES "
		searchQuery += "WHERE USR_ID = '%s' " %(userId)
		searchQuery += "AND ENTITY_ID = '%s'" %(allergenId)
		
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
		if len(rows) > 0:
			updateQuery = "UPDATE pharmacateDB.USER_ALLERGIES "
			updateQuery += "SET IS_DELETED = 'NO' "
			updateQuery += "WHERE USR_ID = '%s' " %(userId)
			updateQuery += "AND ENTITY_ID = '%s'" %(allergenId)
			
			try:
				cursor.execute(updateQuery)
			except cursor.Error as err:
				result["STATUS"] = 0
				print err
				cursor.close()
				db.close()	
				logger.error("Something went wrong with query: {}".format(err))
				sys.exit()
		else:
			insertQuery = "INSERT INTO pharmacateDB.USER_ALLERGIES "
			insertQuery += "(USR_ID, ENTITY_NAME, ENTITY_ID, IS_DELETED)" + " VALUES ('%s', 'ALLERGENS', '%s', 'NO')" %(userId, allergenId)
			
			try:
				cursor.execute(insertQuery)
			except cursor.Error as err:
				result["STATUS"] = 0
				print err
				cursor.close()
				db.close()	
				logger.error("Something went wrong with query: {}".format(err))
				sys.exit()
				
	for allergenProductId in allergicProductIdArray:
		searchQuery = "SELECT * FROM pharmacateDB.USER_ALLERGIES "
		searchQuery += "WHERE USR_ID = '%s' " %(userId)
		searchQuery += "AND ENTITY_ID = '%s'" %(allergenProductId)
		
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
		if len(rows) > 0:
			updateQuery = "UPDATE pharmacateDB.USER_ALLERGIES "
			updateQuery += "SET IS_DELETED = 'NO' "
			updateQuery += "WHERE USR_ID = '%s' " %(userId)
			updateQuery += "AND ENTITY_ID = '%s'" %(allergenProductId)
			
			try:
				cursor.execute(updateQuery)
			except cursor.Error as err:
				result["STATUS"] = 0
				print err
				cursor.close()
				db.close()	
				logger.error("Something went wrong with query: {}".format(err))
				sys.exit()
		else:
			insertQuery = "INSERT INTO pharmacateDB.USER_ALLERGIES "
			insertQuery += "(USR_ID, ENTITY_NAME, ENTITY_ID, IS_DELETED)" + " VALUES ('%s', 'PRODUCTS', '%s', 'NO')" %(userId, allergenProductId)
			
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
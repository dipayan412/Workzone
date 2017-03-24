# -*- coding: utf-8 -*-
"""
Created on Mon Jun 27 18:33:16 2016

@author: Dip
"""

import pymysql
import json_utils
import sys
import logging
import jwt

def handler(event, context):
	db = pymysql.connect(host="pharmacate-core.c4t3bxujamid.us-west-2.rds.amazonaws.com", port = 3306, user= "PharmaAdmin", passwd="5?#B5MrNZa`3G{t+vs'~", db="pharmacateDB")
	cursor = db.cursor()
	
	logger = logging.getLogger()
	logger.setLevel(logging.INFO)
	
	try:
		cursor.execute("SELECT * FROM pharmacateDB.SECRET_ATTRIBUTES");
	except cursor.Error as err:
		print err
		cursor.close()
		db.close()	
		logger.error("Something went wrong with query: {}".format(err))
		sys.exit()
		
	rows = cursor.fetchall()
	for row in rows:
		secretKey = row[0]
	
	token = event["authorizationToken"]
	status = {}
	data = {}
	try:
		data = jwt.decode(token, secretKey)
		status["CODE"] = 1
		status["EFFECT"] = "ALLOW"
	except (jwt.ExpiredSignatureError, jwt.DecodeError) :
		status["CODE"] = 0
		status["EFFECT"] = "DENY"	
		
	policy = {}
	if(status["CODE"] == 1):
		if data.has_key("USER_NAME"):
			policy["principalId"] = data["USER_NAME"].encode('ascii','ignore')
		elif data.has_key("FB_ID"):
			policy["principalId"] = data["FB_ID"].encode('ascii','ignore')
		elif data.has_key("UDID"):
			policy["principalId"] = data["UDID"].encode('ascii','ignore')
		policyDocumant = {}
		policyDocumant["Version"] = "2012-10-17"
		statement = []
		tmpDic = {}
		tmpDic["Action"] = "execute-api:Invoke"
		tmpDic["Effect"] = "Allow"
		tmpDic["Resource"] = event["methodArn"]
		statement.append(tmpDic)
		policyDocumant["Statement"] = statement
		policy["policyDocument"] = policyDocumant
	elif(status["CODE"] == 0):
		policy["principalId"] = ""
		policyDocumant = {}
		policyDocumant["Version"] = "2012-10-17"
		statement = []
		tmpDic = {}
		tmpDic["Action"] = "execute-api:Invoke"
		tmpDic["Effect"] = "Deny"
		tmpDic["Resource"] = event["methodArn"]
		statement.append(tmpDic)
		policyDocumant["Statement"] = statement
		policy["policyDocument"] = policyDocumant
		
	return policy
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 19 11:38:20 2016

@author: Dip
"""

import json_utils
#import urllib2
import pymysql
import unicodedata
import requests

def handler(event, context):
#	try:
#		import urllib2
#	except ImportError, e:
#		print e
		
#	try:
#		import requests
#	except ImportError, e:
#		print e
#	print "started"
#	url = "https://api.cognitive.microsoft.com/bing/v5.0/news/search?entities=true&q=FDA&count=1000&offset=0&mkt=en-us&safeSearch=Moderate"
#	url = "http://echo.jsontest.com/key/value/one/two"
#	request = urllib2.Request(url, headers={"Ocp-Apim-Subscription-Key" : "c695e7724bea462da8781d81cc24aff9"})
#	request = urllib2.Request(url)
#	opener = urllib2.build_opener()
#	print 1
#	f = opener.open(request)
#	print 2
#	json = json_utils.json.loads(f.read())	
#	print json
	
	url = "https://api.cognitive.microsoft.com/bing/v5.0/news/search?entities=true&q=FDA&count=1000&offset=0&mkt=en-us&safeSearch=Moderate"
#	try:
#	url = "http://echo.jsontest.com/key/value/one/two"
	request = requests.get(url, headers={"Ocp-Apim-Subscription-Key" : "c695e7724bea462da8781d81cc24aff9"})
#	request = requests.get(url)
#	print request.content
#	except requests.exceptions.RequestException as e:
#		print e
	print 1
	json = json_utils.json.loads(request.content)
#	print json
#	contents = json_utils.json.load(urllib2.urlopen(request))
	contents = json
	print json
#	print 4
	contents = contents["value"]
	print "next " + str(len(contents))
	titles = []
	links = []
	imgLinks = []
	for obj in contents:
		titles.append(obj["name"])
		links.append(obj["url"])
		if obj.has_key("image"):		
			imgLinks.append(obj["image"]["thumbnail"]["contentUrl"])
		else:
			imgLinks.append("http://www.fda.gov/ucm/groups/fdagov-public/documents/image/ucm218078.png")
		
	db = pymysql.connect(host="pharmacate-core.c4t3bxujamid.us-west-2.rds.amazonaws.com",port=3306,user= "PharmaAdmin",passwd="5?#B5MrNZa`3G{t+vs'~",db="pharmacateDB")
	cursor = db.cursor()
	
	deleteQuery = "UPDATE pharmacateDB.BING_NEWS SET IS_DELETED = 'Y'"
	
	try:
		cursor.execute(deleteQuery)
	except cursor.Error as err:
		print "hello"
		print err
		cursor.close()
		db.close()
	
	for i in xrange(len(titles)):
		title = unicodedata.normalize('NFKD', titles[i]).encode('ascii','replace')
		title = title.replace("'", "")
		insertQuery = "INSERT INTO pharmacateDB.BING_NEWS "
		insertQuery += "(TITLE, IMAGE_LINK, URL, IS_DELETED) "
		insertQuery += "VALUES('%s', '%s', '%s', 'N')" %(title, imgLinks[i], links[i])
		
		try:
			cursor.execute(insertQuery)
		except cursor.Error as err:
			print err
			cursor.close()
			db.close()
	
	db.commit();
	cursor.close()
	db.close()
import pymysql
import logging
import sys


def ConnectToMysql():
	logger = logging.getLogger()
	#rds settings
	rds_host  = "pharmacate-core.c4t3bxujamid.us-west-2.rds.amazonaws.com"
	name = "PharmaAdmin"
	password = "5?#B5MrNZa`3G{t+vs'~"
	db_name = "pharmacateDB"
	port = 3306

	#connect to db
	server_address = (rds_host, port)
	try:
		conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=10)
	except:
		logger.error("ERROR: Unexpected error: Could not connect to MySql instance.")
		sys.exit()

	logger.info("SUCCESS: Connection to RDS mysql instance succeeded")
	return conn
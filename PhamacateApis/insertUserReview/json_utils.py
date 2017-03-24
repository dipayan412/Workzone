import json
import datetime
import time
import json

#from datetime as date
class ComplexEncoder(json.JSONEncoder):
	def default(self, obj):
		try:
			return super(ComplexEncoder, obj).default(obj)
		except TypeError:
			return str(obj)


#encodes using customer encoder to fix dates
#then decodes so that amazon encodes correctly by itself
#there seems to be no way around that
def EncodeResults(result):
	encoded = json.dumps(result,cls=ComplexEncoder, encoding="utf-8", separators=(',', ': '))
	return json.loads(encoded, encoding="utf-8")

def dumpclean(obj):
	if type(obj) == dict:
		for k, v in obj.items():
			if hasattr(v, '__iter__'):
				print k
				dumpclean(v)
			else:
				print '%s : %s' % (k, v)
	elif type(obj) == list:
		for v in obj:
			if hasattr(v, '__iter__'):
				dumpclean(v)
			else:
				print v
	else:
		print obj


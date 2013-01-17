# -*- coding: utf-8 -*-

def git_branch(format='test'):
	from datetime import datetime
	return datetime.now().strftime(format)



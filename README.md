MyDNSui
=======

MyDNSui is a sinatra driven webinterface for MyDNS

Info
----

Currently its only tested and supported for MyDNS with Postgresql
Also you need to make sure your tables are called "rrs" for records and "soas" for zones.
This is due to the table naming by DataMapper
You can rename your tables in postgres and adjust the following two lines in your mydns.conf

	soa-table = soas
	rr-table = rrs

Install
-------

	git clone git://github.com/marvin/MyDNSui.git

Then change into the MyDNSui folder and run bundle to install all required packages

	cd MyDNSui && bundle


Configuration
-------------

Open up the app.rb and adjust the following settings

	DB_HOST = "localhost" 	# host name
	DB_USER = "postgres"	# username to login
	DB_PASS = ""		# user password
	DB_NAME = "mydns"	# the database name 

Run
---

To run the webinterface use

	ruby app.rb

TODO
----

* finish the full UI
* add some validations
* add user management and authentication
* add mysql support
* find a solution to not rename or adjust the rr and soa table name
* integrate unicorn

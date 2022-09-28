import mysql.connector

#establishing the connection
conn = mysql.connector.connect(user='root', password='passwd', host='127.0.0.1')

#Creating a cursor object using the cursor() method
cursor = conn.cursor()

#Preparing query to create a database
ddl = open('human_resources_mysql.sql', 'r')

#Creating a database
cursor.execute(ddl.read())

#Closing the connection
conn.close()
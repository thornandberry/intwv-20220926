import psycopg2

conn = psycopg2.connect(
   user='postgres', password='passwd', host='127.0.0.1', port= '5432'
)
conn.autocommit = True
cursor = conn.cursor()

#Preparing query to create a database
sql1 = '''DROP database IF EXISTS chinook;'''
sql2 = '''CREATE database chinook;'''

cursor.execute(sql1)
cursor.execute(sql2)

conn.close()


conn_db = psycopg2.connect(
   user='postgres', password='passwd', host='127.0.0.1', port= '5432', database='chinook'
)
conn_db.autocommit = True
cursor_db = conn_db.cursor()

#Preparing query to create tables
sql3 = open('chinook_pg.sql', 'r')
cursor_db.execute(sql3.read())

conn_db.close()
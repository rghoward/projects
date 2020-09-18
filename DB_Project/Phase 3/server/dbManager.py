# -*- coding: utf-8 -*-
#!/usr/bin/env python
#Date:2019/03/08 01:34:42
#Desc:
# -*- coding: utf-8 -*-

import psycopg2
import psycopg2.extras
import simplejson as json
from prettytable import from_db_cursor
from flask import jsonify
import dbMessages
from dbQueries import DBQueries
import decimal


class DBManager:

    def __init__(self):
        try:
            self.conn = psycopg2.connect("dbname='se_tech' user='team075' host='192.168.1.15' password='team075'")
        except:
            print "Failed to connect to database"
            return jsonify(dbMessages.error_db_failure_to_connect)
        self.cur = self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor) # This line allows dictionary access.
        self.queries = DBQueries()

    def get_manager(self,output='json', email=None):
        if email:
            SQL=self.queries.query_returner('get_manager').format(email=email)
            self.cur.execute(SQL)
            if self.cur.rowcount == 0:
                return jsonify(dbMessages.error_manager_not_found_msg)
            if output == 'html':
                return self.render_results('html')
            if output == 'json':
                return self.render_results('json')
        else:
                return jsonify(dbMessages.error_manager_invalid_parm_msg)


    def get_active_managers(self,output='json', store_id=None):
        print store_id
        if store_id:
            print"Sotre provided.."
            SQL=self.queries.query_returner('active_managers_for_store').format(store_id=store_id)
            self.cur.execute(SQL)
            if self.cur.rowcount == 0:
                return jsonify(dbMessages.error_manager_no_active_managers_for_store)
            return self.render_results('json')
        else:
            SQL=self.queries.query_returner('active_managers')
            self.cur.execute(SQL)
            if self.cur.rowcount == 0:
                return jsonify(dbMessages.error_manager_no_active_managers)
            return self.render_results('json')

    def get_report(self, report, output='json'):
        SQL = self.queries.query_returner(report)
        self.cur.execute(SQL)
        if output == 'html':
            return self.render_results('html')
        if output == 'json':
            return self.render_results('json')

    def get_report6(self, report,year, month, output='json'):
        print report
        SQL = self.queries.query_returner(report).format(_year_=year,_month_=month)
        self.cur.execute(SQL)
        if output == 'html':
            return self.render_results('html')
        if output == 'json':
            return self.render_results('json')

    def get_report1(self, manufacturer_id=None, output='json'):
        if manufacturer_id:
            SQL = self.queries.query_returner('report1_filter').format(manufacturer_id=manufacturer_id)
        else:
            SQL = self.queries.query_returner('report1')
        self.cur.execute(SQL)
        if output == 'html':
            return self.render_results('html')
        if output == 'json':
            return self.render_results('json')

    def get_report1_drill_down(self, report, manufacturer_id, output='json',methods=['POST']):
        print manufacturer_id,report
        SQL = self.queries.query_returner(report)
        print SQL
        SQL = self.queries.query_returner(report).format(manufacturer_id=manufacturer_id)
        print SQL
        self.cur.execute(SQL)
        if output == 'html':
            return self.render_results('html')
        if output == 'json':
            return self.render_results('json')

    def render_results(self, output='json'):
        if output == 'html':
            mytable= from_db_cursor(self.cur)
            return mytable.get_html_string()
        if output == 'json':
            rows = self.cur.fetchall()
            the_results = []
            for r in range(len(rows)):
                the_results.append(dict(rows[r]))
            print the_results
            #jsonout= json.dumps(the_results, default=self.decimal_default, indent=4, sort_keys=True)
            jsonout= json.dumps(the_results, use_decimal=True)
            return jsonify({'status' : 'success' , 'results' : the_results })

    def decimal_default(self,obj):
        if isinstance(obj, decimal.Decimal):
            return float(obj)
        raise TypeError

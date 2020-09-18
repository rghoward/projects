# -*- coding: utf-8 -*-

from flask import Flask
from flask import request
from dbManager import DBManager
from flask_cors import CORS


application = Flask(__name__)
CORS(application)

@application.route("/")
def index():
    m = DBManager()
    return m.get_report("main_menu_statistics")

@application.route("/manager", methods=['GET'])
def manager():
    m = DBManager()
    email = request.args.get('email')
    return m.get_manager(email=email)

@application.route("/managers")
def active_managers():
    m = DBManager()
    store_id = request.args.get('store_id',type = int)
    #print store_id
    response = m.get_active_managers(store_id=store_id)
    return response

@application.route("/main_menu_statistics")
def main_menu_statistics():
    m = DBManager()
    return m.get_report("main_menu_statistics")

@application.route("/report1")
def report1():
    manufacturer_id = request.args.get('manufacturer_id',type = int)
    m = DBManager()
    return m.get_report1(manufacturer_id=manufacturer_id)

@application.route("/report1_drill_down")
def report1_drill_down():
    m = DBManager()
    manufacturer_id = request.args.get('manufacturer_id',type = int)
    print manufacturer_id
    print manufacturer_id
    return m.get_report1_drill_down(report="report1_drill_down",manufacturer_id=manufacturer_id)


@application.route("/report2")
def report2():
    m = DBManager()
    return m.get_report("report2")

@application.route("/report3")
def report3():
    m = DBManager()
    return m.get_report("report3")

@application.route("/report4")
def report4():
    m = DBManager()
    return m.get_report("report4")

@application.route("/report5")
def report5():
    m = DBManager()
    return m.get_report("report5")


@application.route("/report6")
def report6():
    m = DBManager()
    year,month = request.args.get('id',type = str).split('-')
    print year,month
    return m.get_report6(report="report6",year=year,month=month)

@application.route("/report6_dates")
def report6_dates():
    m = DBManager()
    if request.method =='POST':
        data = request.get_json()
        return m.get_report("report6")
    if request.method == 'GET':
        return m.get_report("get_dates")


@application.route("/subreport6")
def subreport6():
    m = DBManager()
    return m.get_report("subreport6")

@application.route("/city_population")
def city_population():
    m = DBManager()
    return m.get_report("city_population")



@application.route("/report7")
def report7():
    m = DBManager()
    return m.get_report("report7")


if __name__ == "__main__":
    CORS(application)
    application.run()

#!/usr/bin/env python
#Date:2019/03/15 21:13:38
#Desc: Messages for DBManager to pass back to front-end


error_db_failure_to_connect = {'message' : 'Something went wrong connecting to database', 'status': 'failure'}
error_manager_not_found_msg = { 'message': 'Error: Manager Email not found.' , 'status' : 'error'}
error_manager_no_active_managers_for_store = { 'message': 'Error: Store does not have any active managers.' , 'status' : 'error'}
error_manager_no_active_managers = { 'message': 'Error: No active managerss.' , 'status' : 'error'}
error_manager_still_assigned_to_store = { 'message': 'Error: Manager Can not be removed, he is still assigned to a store not.' , 'status' : 'error'}
error_manager_invalid_parm_msg = { 'message': 'Error: Email address not provided' , 'status' : 'error'}
error_city_population_not_updated = { 'message': 'Error: City Population not updated.' , 'status' : 'error'}

success_manager_added = { 'message': 'Success: Manager has been added to the database.' , 'status' : 'success'}
success_manager_removed = { 'message': 'Success: Manager has been removed from the database.' , 'status' : 'success'}
success_city_population_updated = { 'message': 'Success: City Population updated.' , 'status' : 'success'}



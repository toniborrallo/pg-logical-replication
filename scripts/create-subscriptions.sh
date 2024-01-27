#!/bin/bash

source ./scripts/common

REPLICA_CONNECTION_STRING="${1:-postgres://postgres:password@localhost:25432/postgres}"

MASTER_CONNECTION_STRING="${2:-postgres://postgres:password@localhost:15432/postgres}"

if ! type psql >/dev/null 2>&1; then
  echo "psql not found on PATH, exiting"
  exit 1
fi

echo 
echo "testing current rows on employees and employee_statuses before subscription ..."

psql "$REPLICA_CONNECTION_STRING" << EOF

select * from employees;
select * from employee_statuses;

EOF

echo 
echo "creating subcriptions on master..."

psql "$REPLICA_CONNECTION_STRING" << EOF

create subscription sub_employees
connection 'host=host.docker.internal port=15432 user=postgres password=password'
publication pub_employees;

create subscription sub_employee_statuses
connection 'host=host.docker.internal port=15432 user=postgres password=password'
publication pub_employee_statuses;

EOF

echo 
echo "testing current rows on employees and employee_statuses after subscription ..."

wait_dial 10

psql "$REPLICA_CONNECTION_STRING" << EOF

select * from employees;
select * from employee_statuses;

EOF

echo 
echo "We're going to disable temporary subscription to employees for testing stop/start replication process..."

psql "$REPLICA_CONNECTION_STRING" << EOF

alter subscription sub_employees disable;

EOF

echo 
echo "Adding rows to employees in MASTER..."

psql "$MASTER_CONNECTION_STRING" << EOF

insert into public.employees(name, xid) values ('julia', 'yellow'); 

select * from employees;

EOF

# delay for replica completion
wait_dial 5

echo 
echo "Current replication, employeesis disabled. Showing current rows from employees the last added is missing in REPLICA..."

psql "$REPLICA_CONNECTION_STRING" << EOF

select * from employees;

EOF

echo 
echo "Enabling subscription to employees again..."

psql "$REPLICA_CONNECTION_STRING" << EOF

alter subscription sub_employees enable;

EOF

# delay
wait_dial 5

echo 
echo "Showing current rows to employees in REPLICA, after enable subscription again it should be updated with lasts missing transsactions..."

psql "$REPLICA_CONNECTION_STRING" << EOF

select * from employees;

EOF

echo "subscriptions for employees and employee_statuses created!"
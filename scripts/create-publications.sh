#!/bin/bash

source ./scripts/common

CONNECTION_STRING="${1:-postgres://postgres:password@localhost:15432/postgres}"

if ! type psql >/dev/null 2>&1; then
  echo "psql not found on PATH, exiting"
  exit 1
fi

echo "creating publications on master..."

psql "$CONNECTION_STRING" << EOF

-- CREATE PUBLICATIONS EACH TABLE SEPARATED FOR TESTING PURPOSES, 
-- BUT WE CAN ADD SEVERAL TABLES IN ONE PUBLICATION, SEPARATED BY COMMA

create publication pub_employees for table only public.employees;

create publication pub_employee_statuses for table only public.employee_statuses ;

EOF

echo "publications for employees and employee_statuses created!"
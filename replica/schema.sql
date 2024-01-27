-- init script 

drop sequence if exists public.default_id CASCADE;
create sequence if not exists public.default_id
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1;


drop table if exists public.employees cascade;
create table public.employees (
    id numeric(20,0) DEFAULT nextval('public.default_id'::regclass) NOT null primary key ,
    created_at timestamp not null default current_timestamp,
    name character varying(255) not null,
    xid text DEFAULT null
);
create unique index idx_employee_name on public.employees using btree (name);
create index idx_employee_xid on public.employees using btree (xid);


drop table if exists public.employee_statuses cascade;
create table public.employee_statuses (
    id numeric(20,0) DEFAULT nextval('public.default_id'::regclass) NOT null primary key ,
    employee_id numeric(20,0) not null,
    created_at timestamp not null default current_timestamp,
    status character varying(255) default null,
    xid text DEFAULT NULL,
    CONSTRAINT emp_status_emp_fk FOREIGN KEY (employee_id) REFERENCES public.employees(id)
);

create index idx_emp_statuses_id on public.employee_statuses using btree (employee_id);
create index idx_emp_statuses_xid on public.employee_statuses using btree (xid);
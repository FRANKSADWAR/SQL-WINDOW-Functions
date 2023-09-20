# SQL-Window-Functions: What are window functions and what are they used for ?
> A window function performs a calculation across a set of table rows that are somehow related to the current row. This is comparable to the type of calculation that can be done with an aggregate function.
> But unlike regular aggregate functions, use of window functions does not cause the rows to become grouped into a single row, the rows retain their separate identities.

For example, we can get compare the salary of each employee with the average salary in that employee's department: 
`SELECT depname, empno, salary, AVG(salary) OVER(PARTITION BY depname) FROM empsalary;`

The AVG results of this query represents an average taken across all the table rows that have the same depname value as the current row.


## Data upload
> First we have to create our schema and then create a table using DDL in PostgreSQL. I am using the Dbeaver Tool to create the schema visualy on the database `postgtres`
> Using the psql tool, the data do the data upload into a PostgreSQL table.


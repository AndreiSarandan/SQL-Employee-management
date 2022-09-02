It is considered an application for keeping track of computers and software licenses in a company.

For any employee, the following information must be saved in an Oracle database:
- name
- first name
- no. badge
- computer description
- no. Inventory (for PC)
- information about software licenses: 
  -> type of license (OEM, retail, OPEN, Rental, free, other)
  -> Product
  -> Manufacturer
  -> Purchase value
  -> Purchase document
  
Knowing that the 'name' does not exceed 15 characters, the 'first name' does not exceed 20 characters, the 'identification number' has exactly 6 characters, the description of a product does not exceed 40 characters, an employee can have a maximum of 5 computers and that on one computer there can be installed any software, it is required:

2. To write the SQL commands for the tables designed in the previous point.

3. Write the SQL commands for populating the database with the following information:

4. Write a procedure to assign a computer to an employee. (the procedure will be called with 2 parameters: ID no. and inventory no.).

5. To generate a report that includes the producer, the number of licenses, their total value depending on the producer.

6. To generate a detailed report that includes the manufacturer, the type of license,
the number of licenses, their total value, depending on the manufacturer and type of license,
ordered breeder by producer and license type.

7. Write a trigger that, when deleting a computer from the database, removes all of them
the OEM licenses that have been assigned to that computer.

8. Write a function that receives as a parameter the name of the product and its
return its total value.

9. To display the computers and their users that have not been assigned the products
Windows or Office, specifying: no. inventory, name, surname, ID number and
product.

10. To display the user who uses licenses with the highest total value of
purchase (regardless of the number of computers included).

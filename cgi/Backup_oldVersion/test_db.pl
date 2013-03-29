#!perl

use db_access 'valid_Login','exist_User','insert_User','get_Hash','set_Hash', 'insert_Ticket';

print exist_User('matthias\@keros.org'),"\n";
print insert_Ticket('matthias\@keros.org','Testbetreff',1,1);
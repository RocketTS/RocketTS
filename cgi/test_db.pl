#!perl

use db_access 'valid_Login','exist_User';


print "Ausgabe exist_User('test\@test.test');\n";

print exist_User('test\@test.test');
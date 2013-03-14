#!perl

use db_access 'valid_Login','exist_User','insert_User','get_Hash','set_Hash';


#print "Ausgabe exist_User('test\@test.test');\n";

#print exist_User('hallo\@hal.lo');
#print insert_User('Hallo','Hallo','hallo\@hjal.lo','hallohallo');
print get_Hash('test\@test.test'),"\n";
print set_Hash('test\@test.test','12341234123412342134'),"\n";
print get_Hash('test\@test.test');
#!perl

use db_access 'valid_Login','exist_User','insert_User','get_Hash','set_Hash', 'get_AccessRights';

print get_AccessRights('matthias\@kerosn.org'),"\n";

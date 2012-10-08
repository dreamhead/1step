grammar Foo;

@parser::header { package com.foo.parser; }
@lexer::header { package com.foo.parser; }

expr:   INT PLUS INT; 
 
PLUS  : '+' ; 
INT   : ('0'..'9')+ ; 

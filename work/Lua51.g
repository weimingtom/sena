/*
see
http://www.antlr.org/grammar/1178608849736/Lua.g (old)  
http://www.antlr3.org/grammar/1178608849736/Lua.g

http://www.antlr3.org/grammar/list.html
Lua 5.1
Nicolai Mainiero Tue May 8, 2007 00:20
A grammar for the Lua programming language version 5.1 for ANTLR 3
*/

grammar Lua51;

options {
  k = 3;
}

@header {
}

@members {
}

startup	
: chunk EOF
;

chunk
: (stat (';')? )* (laststat (';')? )?
;

block : chunk;

stat
: varlist1 '=' explist1 
| functioncall
| 'do' block 'end'
| 'while' exp 'do' block 'end'
| 'repeat' block 'until' exp
| 'if' exp 'then' block ('elseif' exp 'then' block)* ('else' block)? 'end'
| 'for' NAME '=' exp ',' exp (',' exp)? 'do' block 'end'
| 'for' namelist 'in' (explist1 | functioncall) 'do' block 'end' //FIXME:
| 'function' funcname funcbody
| 'local' 'function' NAME funcbody
| 'local' namelist ('=' explist1)?
| NEWLINE 
;

laststat 
: 'return' (explist1)? 
| 'break' 
| NEWLINE 
;

funcname 
: NAME ('.' NAME)* (':' NAME)? 
;

varlist1
: var (',' var)*
;

namelist 
: NAME (',' NAME)*
;

//FIXME: move * to (',' exp)*
explist1
: exp (',' exp)*
//XXX: not very good
| function 
;

//FIXME:
exp 
: exp2 (binop exp2)* 
;

//FIXME: add function!
exp2	
: atom 
| '...' 
//XXX:move to rule explist1
//| function
| prefixexp 
| tableconstructor
| unop exp2
;

//XXX: not very good!
atom	
: 'nil' 
| 'false' 
| 'true' 
| number 
| string
;

//FIXME:
var
//: ( NAME | '(' exp ')' varSuffix ) varSuffix*
: NAME | '(' exp ')' varSuffix+
;
//: NAME | '(' exp ')' varSuffix+

//FIXME:
prefixexp
/*varOrExp nameAndArgs* */
: NAME
//| NAME args /*FIXME:*/
;

//FIXME:
functioncall
: NAME args
//'(' var ')'
//:varOrExp nameAndArgs+
;

/*
varOrExp
: var  
| '(' exp ')'
;
*/

nameAndArgs
: (':' NAME)? args
;

varSuffix
: nameAndArgs* ( '[' exp ']' | '.' NAME)
;

//FIXME:
args 
:  '(' (explist1)? ')' 
//| tableconstructor 
| string 
;

//closure
function 
: 'function' funcbody
;

funcbody 
: '(' (parlist1)? ')' block 'end'
;

parlist1 
: namelist (',' '...')? 
| '...'
;

tableconstructor 
: '{' (fieldlist)? '}'
;

//FIXME:
fieldlist 
//: field (fieldsep field)* (fieldsep)?
: NAME
;

field 
: '[' exp ']' '=' exp 
| NAME '=' exp 
| exp
;

fieldsep 
: ',' 
| ';'
;

binop 
: '+' 
| '-' 
| '*' 
| '/' 
| '^' 
| '%' 
| '..' 
| '<' 
| '<=' 
| '>' 
| '>=' 
| '==' 
| '~=' 
| 'and' 
| 'or'
;

unop 
: '-' 
| 'not' 
| '#'
;

number 
: INT 
| FLOAT 
| EXP 
| HEX
;

string	
: NORMALSTRING 
| CHARSTRING 
| LONGSTRING
;

// LEXER

NAME: ('a'..'z'|'A'..'Z'|'_') (options{greedy=true;}: 'a'..'z'|'A'..'Z'|'_'|'0'..'9')* ;
INT: ('0'..'9')+;
FLOAT: INT '.' INT ;
EXP: (INT| FLOAT) ('E'|'e') ('-')? INT;
HEX: '0x' ('0'..'9'| 'a'..'f')+ ;
NORMALSTRING: '"' ( EscapeSequence | ~('\\'|'"') )* '"' ;
CHARSTRING: '\'' ( EscapeSequence | ~('\''|'\\') )* '\'';
LONGSTRING: '['('=')*'[' ( EscapeSequence | ~('\\'|']') )* ']'('=')*']';
fragment
EscapeSequence
: '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
| UnicodeEscape
| OctalEscape
;
fragment
OctalEscape
: '\\' ('0'..'3') ('0'..'7') ('0'..'7')
| '\\' ('0'..'7') ('0'..'7')
| '\\' ('0'..'7')
;
fragment
UnicodeEscape: '\\' 'u' HexDigit HexDigit HexDigit HexDigit;
fragment
HexDigit: ('0'..'9'|'a'..'f'|'A'..'F');
COMMENT: '--[[' ( options {greedy=false;} : . )* ']]' {skip();};
LINE_COMMENT: '--' ~('\n'|'\r')* '\r'? '\n' {skip();};
WS: (' '|'\t'|'\u000C') {$channel=HIDDEN;} /*{skip();}*/ ;  
NEWLINE: ('\r')? '\n' /*{skip();}*/ ;

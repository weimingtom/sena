grammar Lua10;

//options {
//  k = 3;
//}

@header {
}

@members {
}

functionlist	
: 
(stat sc | 
function |
setdebug)*
;

function
: 'function' NAME '(' parlist ')' block 'end' 
;

statlist 
: (stat sc)*
;

stat
: stat1
;

sc	 
: (';')? 
;

stat1 
: 'if' expr1 'then' PrepJump block PrepJump elsepart 'end'
| 'while' expr1 'do' PrepJump block PrepJump 'end'
| 'repeat' block 'until' expr1 PrepJump
| varlist1 '=' exprlist1
| functioncall
| 'local' declist
;

parlist
: FLOAT
;

setdebug
: EXP
;

block
: HEX
;

PrepJump
: 'PrepJump'
;

expr1
: 'expr1'
;

elsepart
: 'elsepart'
;

varlist1
: 'varlist1'
;

exprlist1
: 'exprlist1'
;

functioncall
: 'functioncall'
;

declist
: 'declist'
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

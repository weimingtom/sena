grammar Lua10;

//options {
//  k = 1;
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
| var ((',' var)* /*varlist1*/ '=' exprlist1 | '(' exprlist ')' /*functioncall*/)
| 'local' declist
;

elsepart 
: /* empty */
| 'else' block
| 'elseif' expr1 'then' PrepJump block PrepJump elsepart
;

block    
: statlist ret 
;

ret	
: /* empty */
| 'return' exprlist sc
;

PrepJump
:
;

expr1	 
: expr
;

expr 
: '(' expr ')'
| expr_2 (('=' | '<' | '>' | '~=' | '<=' | '>=' | '+' | '-' | '*' | '/' | '..' | 'and' PrepJump | 'or' PrepJump) expr_2)*
;

expr_2
: var ('(' exprlist ')')? /*functioncall*/ | NUMBER | STRING | 'nil' | '@' objectname fieldlist | '@' '(' dimension ')' | ('+' | '-' | 'not') expr_2
;

dimension    
: /* empty */
| expr1
;

functioncall 
: functionvalue '(' exprlist ')'
;

functionvalue 
: var
;

exprlist  
: /* empty */
| exprlist1
;

exprlist1 
: expr (',' expr)*
;

parlist  
: /* empty */
| parlist1
;

parlist1 
: NAME (',' NAME)*
;

objectname 
: /* empty */
| NAME
;

fieldlist  
: '{' ffieldlist '}'  
| '[' lfieldlist ']'  
;

ffieldlist 
: /* empty */
| ffieldlist1
;

ffieldlist1 
: ffield (',' ffield)*
;

ffield      
: NAME '=' expr1 
;

lfieldlist 
: /* empty */
| lfieldlist1
;

lfieldlist1 
: /* empty */ lfield (',' lfield)*
;

lfield 
: expr1
;

varlist1 
: var (',' var)*
;

var	  
: NAME ('.' NAME | '[' expr ']')*
;

declist 
: NAME init (',' NAME init)*
;

init	  
: /* empty */
| '=' exprlist1
;

setdebug  
: '$debug'
;








// LEXER

NAME: ('a'..'z'|'A'..'Z'|'_') (options{greedy=true;}: 'a'..'z'|'A'..'Z'|'_'|'0'..'9')* ;
NUMBER 	: ('0'..'9')+ ('.' ('0'..'9')+ )?;
STRING	: '"' ( EscapeSequence | ~('\\'|'"') )* '"' | '\'' ( EscapeSequence | ~('\''|'\\') )* '\''; 
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
WS: (' '|'\t'|'\u000C'){$channel=HIDDEN;}; /*{skip();}*/  
NEWLINE: (('\r')? '\n') {$channel=HIDDEN;}; /*{skip();}*/

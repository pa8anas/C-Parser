%{

#include <stdio.h>
#include <string.h>
#include "y.tab.h"

void showError();


%}

%option noyywrap yylineno

%x comments

NUMBERS ([0-9])+
NAME ([a-zA-Z0-9_])+
COMMENT "%".*
OP [-+/*]

%%


"/*" BEGIN(comments);

<comments>{
     [^*\n]*   
     "*"+[^*/\n]*
     \n
     "*/" BEGIN(INITIAL);
}

"INTEGER"                               { return (INTEGER); }
"VARS"                                  { return (VARS); }
"PROGRAM"                               { return (PROGRAM); }
"FUNCTION"                              { return (FUNCTION); }
"END_FUNCTION"                          { return (END_FUNCTION); }
"STARTMAIN"                             { return (STARTMAIN); }
"ENDMAIN"                               { return (ENDMAIN); }
"class"                                 { return (CLASS); }
"RETURN"                                { return (RETURN); }
"()"                                    { return (ARGS); }
":"                                     { return (DELI); }
"."                                     { return (DOT); }
"IF"                                    { return (IF); }
"ELSE"                                  { return (ELSE); }
"ENDIF"                                 { return (ENDIF); }
"IF"|"ELSEIF"|"ELSE"|"ENDIF"            { return (TEST); }
"THEN"                                  { return (THEN);}
"SWITCH"|"CASE"|"DEFAULT"|"ENDSWITCH"   { return (TEST2);}
"<"|">"|"=="|"!="                       { return (TESTOP); }
"FOR"|"ENDFOR"                          { return (FOR); }
"WHILE"                                 { return (WHILE); }
"ENDWHILE"                              { return (ENDWHILE); }
"||"                                    { return (OR); }
"&&"                                    { return (AND); }
"("                                     { return (LEFT_PAR); }
")"                                     { return (RIGHT_PAR); }
"{"                                     { return (LEFT_C_BRA); }
"}"                                     { return (RIGHT_C_BRA); }
"["                                     { return (LEFT_BRA); }
"]"                                     { return (RIGHT_BRA); }
";"                                     { return (SEM); }
","                                     { return (COMMA); }
"CHAR"                                  { return (CHAR); }
"BREAK"                                 { return (BREAK); }
{NUMBERS}                               { yylval.i = atoi(yytext); return INT; }
{COMMENT}                               { return (TYPE_COMMENT); }
{NAME}                                  { yylval.a = yytext; return NAME; }
{OP}                                    { return (OP); }
{CHARACTER}                             { return (CHARACTER); }
"\n"|"\r\n"                             { return (NEWLINE); }
"\t"|"  "|"    "                        { return (INDENT); }
"="                                     { return (ASSIGNOP); }
L?\"(\\.|[^\\"])*\"	                    { return(STRING_LITERAL); }
"++"                                    { return(INC_OP); }
"--"                                    { return(DEC_OP); }
.                                       { showError(); }


%%

void showError() {
    // printf("Unrecognized token\n");
}
%{

#include <stdio.h>

int yylex();
int yyerror(char *s);

extern FILE *yyin;
extern FILE **yyout;
extern char* yytext;
extern int yylineno;
extern int lineno;

%}

%token VARS PROGRAM FUNCTION END_FUNCTION STARTMAIN ENDMAIN RETURN ARGS DELI DOT TEST
%token TESTOP FOR WHILE OR AND LEFT_PAR RIGHT_PAR LEFT_C_BRA RIGHT_C_BRA LEFT_BRA RIGHT_BRA 
%token THEN TEST2 INT NAME TYPE_COMMENT ASSIGNOP SEM COMMA CHAR BREAK OP NEWLINE INDENT
%token INTEGER IF ELSE ENDIF ENDWHILE CHARACTER STRING_LITERAL SUMOP MULOP TO ENDFOR STEP ELSEIF
%token SWITCH CASE DEFAULT ENDSWITCH PRINT MARKS STRUCT ENDSTRUCT TYPEDEF

%type <a> NAME
%type <i> INT

%union {
    char *a;
    int i;
}

%%

program:        PROGRAM NAME newline declList spaces mainDecl;
declList:       structDecl spaces decl | declList spaces decl | decl | structDecl | /* empty */;
decl:           funDecl;
funDecl:        FUNCTION NAME LEFT_PAR parms RIGHT_PAR NEWLINE stmtList spaces RETURN complExp SEM NEWLINE END_FUNCTION { printf("Function definition\n"); };
mainDecl:       STARTMAIN spaces stmtList spaces ENDMAIN { printf("Main definition\n"); };
structDecl:     structDecl spaces struct | struct;
struct:         STRUCT NAME NEWLINE varRepeat spaces ENDSTRUCT { printf("Struct definition\n"); }
                | TYPEDEF STRUCT NAME NEWLINE varRepeat spaces NAME ENDSTRUCT { printf("Struct definition\n"); }
                ;
stmtList:       stmtList spaces stmt | stmt | /* empty */;
stmt:           varDecl | expStmt | iterStmt | selectStmt | switch | print | break | TYPE_COMMENT { printf("Comment\n"); };
iterStmt:       WHILE LEFT_PAR NAME condition complExp RIGHT_PAR NEWLINE stmtList NEWLINE ENDWHILE { printf("While statement\n"); }
                | FOR NAME ASSIGNOP INT TO INT STEP INT NEWLINE stmtList NEWLINE ENDFOR { printf("For statement\n"); }
                ;
selectStmt:     IF LEFT_PAR NAME condition complExp RIGHT_PAR THEN NEWLINE stmtList NEWLINE ENDIF { printf("If statement\n"); }
                | IF LEFT_PAR NAME condition complExp RIGHT_PAR THEN NEWLINE stmtList NEWLINE elseif NEWLINE ELSE NEWLINE stmtList NEWLINE ENDIF { printf("If statement\n"); }
                | IF LEFT_PAR NAME condition complExp RIGHT_PAR THEN NEWLINE stmtList NEWLINE ELSE stmtList NEWLINE ENDIF { printf("If statement\n"); }
                ;
elseif:         elseif NEWLINE ELSEIF NEWLINE stmt
                | ELSEIF NEWLINE stmt
                ;  
switch:         SWITCH LEFT_PAR NAME RIGHT_PAR NEWLINE case NEWLINE stmtList ENDSWITCH { printf("Switch statement\n"); }
                | SWITCH LEFT_PAR NAME RIGHT_PAR NEWLINE case NEWLINE DEFAULT DELI NEWLINE stmtList NEWLINE ENDSWITCH { printf("Switch statement\n"); }
                ;
case:           case NEWLINE CASE LEFT_PAR complExp RIGHT_PAR DELI NEWLINE stmt
                | CASE LEFT_PAR complExp RIGHT_PAR DELI NEWLINE stmt
                ;   
print:          PRINT LEFT_PAR MARKS text MARKS RIGHT_PAR SEM { printf("Print expression\n"); }
                | PRINT LEFT_PAR MARKS text MARKS LEFT_BRA COMMA NAME RIGHT_BRA RIGHT_PAR SEM { printf("Print expression\n"); }
                ;
varRepeat:      varRepeat varDecl | varDecl | /* empty */;              
spaces:         spaces newline | spaces space | newline | space;   
newline:        newline NEWLINE | NEWLINE;                
space:          space spac | spac;
spac:           /* empty */;
text:           text NAME | NAME;
break:          BREAK SEM { printf("Break statement\n"); };          
condition:      TESTOP | AND | OR;
expStmt:        exp;
exp:            resExp | mutable ASSIGNOP exp;
resExp:         call | complExp;
complExp:       INT | NAME | SUMOP | MULOP | LEFT_PAR | RIGHT_PAR | complExp SEM;
mutable:        NAME | NAME LEFT_PAR INT RIGHT_PAR;
call:           NAME LEFT_PAR args RIGHT_PAR SEM { printf("Calling %s\n", $1);};
args:           argList;
argList:        argList COMMA NAME | NAME;
parms:          parmList;
parmList:       parmList COMMA parmTypeList | parmTypeList;
parmTypeList:   typeSpec NAME;
varDecl:        VARS typeSpec varDeclList SEM { printf("Var definition\n"); };
typeSpec:       INTEGER | CHAR;
varDeclList:    varDeclList COMMA varDeclInit | varDeclInit;
varDeclInit:    varDeclId;
varDeclId:      NAME | NAME LEFT_BRA INT RIGHT_BRA;




%% 

int yyerror(char *s) {
    fprintf(stderr, "%s in line %d\n", s, yylineno);
    return 0;
}

int main(int argc, char **argv) {
    printf("C Set Parser\n\n");
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }
    yyparse();
    return 0;
}
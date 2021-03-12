%{
  #include <stdio.h>
  #include <string.h>
  #include <stdbool.h>
  int variables = 0, literal = 0, bracket=0;
  char* last=NULL;
  bool isOperator=false,start=true,isBracket_0pen=false,isBracket_close=false,isVar=false,isLit=false;
  
%}
OPER "+"|"*"|"-"
VAR [_a-zA-Z]+[_a-zA-Z0-9]+
DIGIT [0-9]
NUMBER {DIGIT}+|{DIGIT}+"."+{DIGIT}+
%%
" "
"(" {			bracket++;
				if(isOperator==false&&start==false){
					printf("MISSING OPERATOR ==> %s %s\n",last,yytext);
					exit(1);}
				isBracket_0pen=true;
				isBracket_close=false;				
				start=false;	
				last=strdup(yytext);
				}
")" {			bracket--;
				if(isOperator==true||start==true){
					printf("MISSING OPERAND ==> %s %s\n",last,yytext);
					exit(1);}
				if(bracket!=0){
						printf("UNBALANCED PARENTHESES\n");exit(1);
				}
				isBracket_0pen=false;
				isBracket_close=true;
				start=false;	
				last=strdup(yytext);}
{OPER} {
				if(isOperator==true||start==true||isBracket_0pen==true)
				{printf("MISSING OPERAND ==> %s %s\n",last,yytext);
					exit(1);}
				isOperator=true;
				isVar=false;
				isLit=false;
				//isBracket_0pen==false;
				isBracket_close=false;
				//start=false;
				last=strdup(yytext);
}
{VAR} {
				variables++;
				if(start==true||(isOperator==false&&isBracket_0pen==false)||isBracket_close==true)
				{printf("MISSING OPERATOR ==> %s %s\n",last,yytext);
				exit(1);}
				isBracket_0pen=false;
				isOperator=false;
				isVar=true;
				isLit=false;
				last=strdup(yytext);
}
{NUMBER} {
				literal++;
				if(start==true||isOperator==false||isBracket_close==true)
				{printf("MISSING OPERATOR ==> %s %s\n",last,yytext);
				exit(1);}
				isBracket_0pen=false;
				isOperator=false;
				isVar=false;
				isLit=true;
				last=strdup(yytext);
}
"\n" {			
				if(bracket!=0)
				{
					printf("UNBALANCED PARENTHESES\n");
													exit(1);
				}
				printf("OK ==> %d variables, %d literals\n",variables,literal);
				exit(1);}
. {
				printf("INVALID TOKEN ==> %s\n",yytext);exit(1);}
%%
int main()
{
	yylex();
	return 0;
 }			
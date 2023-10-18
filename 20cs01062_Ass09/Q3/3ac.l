%{ 
  #include "y.tab.h"
%}


id 			[a-z]
digits		[0-9]+
operators 	[\+\*\-\/]
parantheses [()]

%% 
{id} 			{ 
					yylval.Value = yytext[0];
					return ID; 
		 		}
{digits}			{
					yylval.Value=yytext[0];//no atoi needed as handled as character in yacc file
					return NUM;
} 
{operators} 	{ return yytext[0]; } 
{parantheses} 	{ return yytext[0]; }
[\t\n ]     	{ return 0; }
.				{ printf("Invalid Operator\n %s", yytext); 
                  exit(0); }
%% 

int yywrap() 
{ 
	return 1; 
}
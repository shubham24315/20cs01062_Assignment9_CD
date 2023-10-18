%{ 
  #include <stdio.h>
  #include <stdlib.h>
  #include<string.h>

 
  #include "lex.yy.c"

  void yyerror();
  void print();
  char addInMatrix(char a, char b, char op);

  int idx=0;
  int flag=0;
  char m[100][4]; //valid max for 100 lines of code
                //4 cols as in format LHS,op1,op2,operator

%}

//defining derived structures
%union {
  char Value;
}

%type<Value> G E T F

%token<Value> ID NUM


/* Precedence  */
%left '+' '-'
%left '*' '/' 
%left '(' ')'


%start G

/* Rule */
%%
G: E  { 
        $$ = $1;
        print();
        return 0; 
      };

E: E'+'T{ 
            $$=addInMatrix($1,$3,'+');

        }
|  E'-'T {
            $$=addInMatrix($1,$3,'-');

        }
|  T     { $$ = $1; };

T: T'*'F { 
            $$=addInMatrix($1,$3,'*');

        }
|  T'/'F { 
            $$=addInMatrix($1,$3,'/');

        }
|   F    { $$ = $1; }; 

F: ID   { $$=$1;}
|  NUM  { $$=$1;}
| '('E')'   { $$ = $2; }
%%


// driver code
void main()
{
    printf("Enter expression with +,-,*,/ \n");
    yyparse();
    if (flag == 0)
    {
        printf("\n given expression is valid\n");
    }
}

void print()
{
    printf("\nThe resulting 3-address code for given expression\n");
    printf("\n");
    
    for(int i=0;i<idx;i++){
        char *row=m[i];
        if(row[3]=='+') printf("%d. %c <- ADD(%c,%c) \n", i+1, row[0], row[1],row[2]);
        else if(row[3]=='-') printf("%d. %c <- SUB(%c,%c) \n", i+1, row[0], row[1],row[2]);
        else if(row[3]=='*') printf("%d. %c <- MUL(%c,%c) \n", i+1, row[0], row[1],row[2]);
        else if(row[3]=='-') printf("%d. %c <- DIV(%c,%c) \n", i+1, row[0], row[1],row[2]);
    }
    printf("\n");
}


char addInMatrix(char a, char b, char op){
    char left='A'+idx;
    char *row=m[idx];
    row[0]=left; row[1]=a; row[2]=b; row[3]=op;

    idx++;
    return left;
}


void yyerror()
{
    printf("\n given expression is invalid\n");
    flag = 1;
}

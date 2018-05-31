%{
#include <stdio.h>

#include <stdlib.h>

#include <ctype.h>
#include "hashtable_insert.h"
#define MAX_LINE_LENG 256

#define LIST     		strcat(buf,yytext)
#define token(t)		{LIST; printf("<'%s'>\n",t);}
#define caps(t) 		{for(int i = 0; i < strlen(t); i++){t[i] = toupper(t[i]);};printf("<%s>\n", t); }
#define keyword(t) 		{LIST; caps(t)}
#define tokenInteger	{LIST; printf("<%s:%s>\n","integer",yytext);}
#define tokenReal 		{LIST; printf("<%s:%s>\n","real", yytext);}
#define tokenBoolean 	{LIST; printf("<%s:%s>\n","boolean",yytext);}
#define tokenId			{insert(yytext);LIST; printf("<%s:%s>\n","id",yytext);}
#define tokenString(t,s){LIST; printf("<%s:%s>\n","string",s);}


int linecount = 1;
char buf[MAX_LINE_LENG];
char str[2048];
// symbol table 
// create we need hashtable to cteate the contain for symbol


int symbolnum = 0;

void insert(char* tokenIdVa){
	
	// int symbolIndexStr = 66;
	// char *strss;
		// printf("<'%s'>\n",tokenIdVa);
	// printf("<'%d'>\n\n\n",symbolIndexStr);
	// printf("<'%s'>\n",strss);
	// printf("<'%d'>\n\n\n",symbolIndexStr);


	// // sprintf(strChar, "%d", symbolnum);
	// sprintf(strss, "%d", symbolIndexStr);
	// hash_table_insert(tokenIdVa,strChar);
	const char *key1 = "aaammd";
	// printf("<'%s'>\n",tokenIdVa);
	hash_table_insert(tokenIdVa, symbolnum);
	symbolnum ++;
}
	void lookup(const char* skey){
		HashNode* reason_lookup = hash_table_lookup(skey);
		printf("%s  %d\n",  reason_lookup->sKey,reason_lookup->nValue);
	}
//insert
//lookup
//dump
//symbol table
%}

%x	String
%x 	Comm
%x  Coms
digital      [0-9]
integer      {digital}+
real         -?(([0-9]+)([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)
letter       [a-zA-Z]
identifier   {letter}+
whitespace   [ \t]+

%%
"("     {token("(");}
")"     {token(")");}
","     {token(",");}
":"     {token(":");}
";"     {token(";");}
"["     {token("[");}
"]"     {token("]");}
"{"     {token("{");}
"}"     {token("}");}

"+"     {token("+");}
"-"     {token("-");}
"*"     {token("*");}
"/"     {token("/");}
"++"    {token("++");}
"--"    {token("__");}
"%"     {token("%");}
"<"     {token("<");}
"<="    {token("<=");}
">="    {token(">=");}
">"     {token(">");}
"=="    {token("==");}
"!="    {token("!=");}
"&&"    {token("&&");}
"||"    {token("||");}
"!"     {token("!");}
"="     {token("=");}
"+="    {token("+=");}
"-="    {token("-=");}
"*="    {token("*=");}
"/="    {token("/="	);}


"bool"   	  {keyword(yytext);}
"true"		  {keyword(yytext);}
"false"		  {keyword(yytext);}
"break"   	  {keyword(yytext);}
"char"    	  {keyword(yytext);}
"continue"    {keyword(yytext);}
"do"   		  {keyword(yytext);}
"else"    	  {keyword(yytext);}
"enum"    	  {keyword(yytext);}
"extern"      {keyword(yytext);}
"float"    	  {keyword(yytext);}
"for"    	  {keyword(yytext);}
"fn"   		  {keyword(yytext);}
"if"   		  {keyword(yytext);}
"in"   		  {keyword(yytext);}
"int"   	  {keyword(yytext);}
"let"    	  {keyword(yytext);}
"loop"    	  {keyword(yytext);}
"match"    	  {keyword(yytext);}
"mut"         {keyword(yytext);}
"print"       {keyword(yytext);}
"println"     {keyword(yytext);}
"pub"    	  {keyword(yytext);}
"return"      {keyword(yytext);}
"self"    	  {keyword(yytext);}
"static"      {keyword(yytext);}
"str"    	  {keyword(yytext);}
"struct"      {keyword(yytext);}
"where"    	  {keyword(yytext);}
"while"    	  {keyword(yytext);}
{identifier}  		{tokenId;}
{integer}     		{tokenInteger;}
{real}        		{tokenReal;}
"//"          		{
               		LIST;
                	BEGIN Coms;
            		}
<Coms>\n 	{
                      LIST;
                      printf("%d: %s", linecount++, buf);
                      buf[0] = '\0';
                      BEGIN 0;
                    }
<Coms>.    {
                      LIST;
                    }
"/*"               {
                      LIST;
                      BEGIN Comm;
                    }
<Comm>\n {
                      LIST;
                      printf("%d: %s", linecount++, buf);
                      buf[0] = '\0';
                     	}
<Comm>"*/"	{
                      		LIST;
                      		BEGIN 0;
                    	}
<Comm>.     {
                      		LIST;
                    	}
\"          		{
              			LIST;
              			BEGIN String;
              		}

<String>\" 	{
                    	char c = input();
                    	if(c=='\"')
                    {
                    	LIST;
                    	strcat(buf,"\"");
                    	strcat(str,yytext);
                    }
                    	else
                    {
                    	tokenString("string",str);
                    	unput(c);
                    	str[0] = '\0';
                    	BEGIN 0;
                    }
                  	}
<String>.     {
                      LIST;
                      strcat(str,yytext);
                    }
[ \t]*  			{LIST;}
\n 			  		{
        			LIST;
        			printf("%d: %s", linecount++, buf);
        			buf[0] = '\0';
        			}

%%
int main(){
	hash_table_init();
	yylex();

	hash_table_print();
	// lookup("add");
}

	int yywrap(){
		return 1;
	}
// printf("%d:%s\n", linecount, buf);
// printf("bad character:’%s’\n",yytext);
// exit(-1);

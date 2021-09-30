%{
	#include "conteudo_lexico.h"
	#include "arvore/arvore_n_aria.h"
	#include "parser.tab.h"
	int get_line_number();
	void value_parser(int tipo_token, char* token);
%}
space [ \n\r]+
content_open \<content\>
text_open \<text\>
content_close \<\/content\>
text_close \<\/text\>
screen_open \<screen\>
screen_close \<\/screen\>
body_open \<body\>
body_close \<\/body\>
subscreens_open \<subscreens\>
subscreens_close \<\/subscreens\>
subscreen_open \<subscreen\>
subscreen_close \<\/subscreen\>
query_open \<mobilang\>
query_close \<\/mobilang\>
title_open \<title\>
title_close \<\/title\>
style_open \<style\>
style_close \<\/style\>

button_open \<button\>
button_close \<\/button\>
actions_open \<actions\>
actions_close \<\/actions\>
onpress_open \<onpress\>
onpress_close \<\/onpress\>
alert_open \<alert\>
alert_close \<\/alert\>

string [^<>\n\r]+

%option yylineno
%%
{space} { }
{screen_open} 		{ value_parser(TK_SCREEN_OPEN, "<screen>"); return TK_SCREEN_OPEN; }
{screen_close} 		{ value_parser(TK_SCREEN_CLOSE, "</screen>"); return TK_SCREEN_CLOSE; }
{body_open} 		{ value_parser(TK_BODY_OPEN, "<body>"); return TK_BODY_OPEN; }
{body_close} 		{ value_parser(TK_BODY_CLOSE, "</body>"); return TK_BODY_CLOSE; }
{subscreens_open} 	{ value_parser(TK_SUBSCREENS_OPEN, "<subscreens>"); return TK_SUBSCREENS_OPEN; }
{subscreens_close} 	{ value_parser(TK_SUBSCREENS_CLOSE, "</subscreens>"); return TK_SUBSCREENS_CLOSE; }
{subscreen_open} 	{ value_parser(TK_SUBSCREEN_OPEN, "<subscreen>"); return TK_SUBSCREEN_OPEN; }
{subscreen_close} 	{ value_parser(TK_SUBSCREEN_CLOSE, "</subscreen>"); return TK_SUBSCREEN_CLOSE; }
{content_open} 		{ value_parser(TK_CONTENT_OPEN, "<content>"); return TK_CONTENT_OPEN; }
{content_close} 		{ value_parser(TK_CONTENT_CLOSE, "</content>"); return TK_CONTENT_CLOSE; }
{text_open} 		{ value_parser(TK_TEXT_OPEN, "<text>"); return TK_TEXT_OPEN; }
{text_close} 		{ value_parser(TK_TEXT_CLOSE, "</text>"); return TK_TEXT_CLOSE; }
{query_open} 		{ value_parser(TK_QUERY_OPEN, "<mobilang>"); return TK_QUERY_OPEN; }
{query_close} 		{ value_parser(TK_QUERY_CLOSE, "</mobilang>"); return TK_QUERY_CLOSE; }
{title_open}		{ value_parser(TK_TITLE_OPEN, "<title>"); return TK_TITLE_OPEN; }
{title_close}		{ value_parser(TK_TITLE_CLOSE, "</title>"); return TK_TITLE_CLOSE; }
{style_open}		{ value_parser(TK_STYLE_OPEN, "<style>"); return TK_STYLE_OPEN; }
{style_close}		{ value_parser(TK_STYLE_CLOSE, "</style>"); return TK_STYLE_CLOSE; }

{button_open}		{ value_parser(TK_BUTTON_OPEN, "<button>"); return TK_BUTTON_OPEN; }
{button_close}		{ value_parser(TK_BUTTON_CLOSE, "</button>"); return TK_BUTTON_CLOSE; }
{actions_open}		{ value_parser(TK_ACTIONS_OPEN, "<actions>"); return TK_ACTIONS_OPEN; }
{actions_close}		{ value_parser(TK_ACTIONS_CLOSE, "</actions>"); return TK_ACTIONS_CLOSE; }
{onpress_open}		{ value_parser(TK_ONPRESS_OPEN, "<onpress>"); return TK_ONPRESS_OPEN; }
{onpress_close} 	{ value_parser(TK_ONPRESS_CLOSE, "</onpress>"); return TK_ONPRESS_CLOSE; }
{alert_open}		{ value_parser(TK_ALERT_OPEN, "<alert>"); return TK_ALERT_OPEN; }
{alert_close}		{ value_parser(TK_ALERT_CLOSE, "</alert>"); return TK_ALERT_CLOSE; }

{string} 			{ value_parser(TK_STRING, strdup(yytext)); return TK_STRING; }

%%
int get_line_number() {
	return yylineno;
}

void value_parser(int tipo_token, char* label)
{
	yylval.valor_lexico.tipo_token = tipo_token;
	yylval.valor_lexico.numero_linha = get_line_number();
	yylval.valor_lexico.label = label;
}

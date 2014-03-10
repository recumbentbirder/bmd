/* description: Parses bmd -- birders markdown -- bird listing files. */

/* lexical grammar */
%lex

%options case-insensitive

%%


"überfliegend"|"passing"|
"rufend"|"Ruf"|"calling"|"call"|
"singend"|"Gesang"|"singing"|"song"|
"balzend"|"Balz"|"courting"|"courtship"|
"display"|"displaying"                                              return 'BEHAVIOUR'

\ +                                                                 /* skip whitespace */
[\f\n\n]+                                                           return 'NEWLINE'
(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])      return 'DATE'
((0?[1-9])|(1[0-2]))(":"[0-5][0-9])                                 return 'TIME'
[0-9]+("."[0-9]+)?\b                                                return 'NUMBER'
[A-Za-z\'ßÄÖÜäöüÅåØø\/\.]+                                          return 'WORD'
\?                                                                  return '?'
\!                                                                  return '!'
\,                                                                  return ','
\-                                                                  return '-'
\:                                                                  return ':'
\|                                                                  return '|'
<<EOF>>                                                             return 'EOF'
.                                                                   return 'INVALID'

/lex

%{
  var spIntent = "    ";
  var headerIntent = "  ";
%}

%start bmd

%% /* language grammar */

bmd
    : blocks
        { var bmd = "[\n"+$1+"\n]"; typeof console !== 'undefined' ? console.log(bmd) : print(bmd); return bmd }
    ;

obslines
    : obsblock -> $1+"\n"
    | obsblocks obslines -> $1+",\n"+$2
    ;

block
    : dateline obslines -> $1+"    \"observations\": [\n"+$2+"    ]\n"
    ;

blocks
    : block -> "  {\n"+$1+"  }"
    | blocks block -> $1+",\n  {\n"+$2+"  }"
    ;

lineending
    : EOF
    | NEWLINE
    | NEWLINE EOF
    ;

word
    : WORD
      { $$ = yytext; }
    ;

words
    : word -> $1
    | words word -> $1+" "+$2
    ;

date
    : DATE
      { $$ = yytext; }
    ;

time
    : TIME
      { $$ = yytext; }
    ;

dateline
    : date words lineending
      { $$ = "    \"date\": \""+$date+"\",\n    \"location\": \""+$words+"\",\n"; }
    | date time words lineending
      { $$ = "    \"date\": \""+$date+"\",\n    \"time\": \""+$time+"\",\n    \"location\": \""+$words+"\",\n"; }
    ;

birdname
    : words
    ;

behaviour
    : BEHAVIOUR
      { $$ = "\"behav\": \""+yytext+"\""; }
    ;

number
    : NUMBER
      { $$ == yytext; }
    ;

counts
    : number
      { $$ = "\"unsexed\": "+Number($number); }
    | number ',' number
      { $$ = "\"male\": "+Number($number1)+",\n        \"female\": "+Number($number2); }
    ;

specs
    : behaviour -> "        "+$1
    | specs behaviour -> $1+",\n        "+$2
    | counts -> "        "+$1
    | specs counts -> $1+",\n        "+$2
    ;

obsline
    : birdname lineending
      { $$ = "      {\"species\": \""+$birdname+"\"}"; }
    | birdname specs lineending
      { $$ = "      {\n        \"species\": \""+$birdname+"\",\n"+$specs+"\n      }"; }
  ;

obsblock
    : obsline -> $1
    ;

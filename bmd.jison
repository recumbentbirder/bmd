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

[\f\r\n]+                                                           return 'NEWLINE'
\ +                                                                 /* skip whitespace */
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
  var tripCount = -1;
  var bmd = [];
%}

%start bmd

%% /* language grammar */

bmd
    :
      trips EOF
        { console.log(bmd); }
    ;

trips
    :
      trip
    | trip trips
    ;

trip
    :
      tripheader tripentries
    ;

tripheader
    :
      DATE words NEWLINE
        {
          bmd[++tripCount] = {};

          bmd[tripCount].date = $1;
          bmd[tripCount].location = $2;
        }
    ;

tripentries
    :
      tripentry
        { $$ = $1; }
    | tripentry tripentries
        { $$ = $1 + " " + $2; }
    ;

tripentry
    :
      speciesname NEWLINE
        { $$ = $1; }
    | speciesname adds NEWLINE
        { $$ = $1 + " " + $2; }
    ;

speciesname
    :
      words
        { $$ = $1; }
    ;

words
    :
      WORD
        { $$ = $1; }
    | WORD words
        { $$ = $1 + " " + $2; }
    ;

adds
    :
      add
        { $$ = $1; }
    | add adds
        { $$ = $1 + " " + $2; }
    ;

add
    :
      count
        { $$ = $1; }
    ;

count
    :
      NUMBER
        { $$ = $1; }
    | NUMBER ',' NUMBER 
        { $$ = $1 + "," + $3; }
    ;

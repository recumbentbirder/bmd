/* description: Parses bmd -- birders markdown -- bird listing files. */

/* lexical grammar */
%lex

%options case-insensitive

%x notes

%%
^"|"\s*                                                           this.begin('notes');
<notes>[\f\r\n]                                                     this.begin('INITIAL');
<notes>.*[^\f\r\n]                                                  return 'NOTE';

"überfliegend"|"passing"|
"rufend"|"Ruf"|"calling"|"call"|
"singend"|"Gesang"|"singing"|"song"|
"balzend"|"Balz"|"courting"|"courtship"|
"display"|"displaying"                                              return 'BEHAVIOUR';

"ca."                                                               return 'CIRCA';
[\f\r\n]+                                                           return 'NEWLINE';
\ +                                                                 /* skip whitespace */
(19|20)\d\d[-](0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01])            return 'DATE';
([0-1]?[0-9]|2[0-3])\:[0-5][0-9]                                     return 'TIME';
[0-9]+("."[0-9]+)?\b                                                return 'NUMBER';
[A-Za-z\'ßÄÖÜäöüÅåØø\/\.]+                                          return 'WORD';
\?                                                                  return '?';
\!                                                                  return '!';
\,                                                                  return ',';
\-                                                                  return '-';
\:                                                                  return ':';
\|                                                                  return '|';
\=                                                                  return '=';
<<EOF>>                                                             return 'EOF';
.                                                                   return 'INVALID';

/lex

%{
  var observationCount = -1;
  var tripCount = -1;
%}

%start bmd

%% /* language grammar */

bmd
    :
      trips EOF
        {
          console.log(JSON.stringify($1));
        }
    ;

trips
    :
      trip
        {
          $$ = [$1];
        }
    | trip trips
        {
          $$ = [$1].concat($2);
        }
    ;

trip
    :
      tripheader observations
      {
        $$ = { trip: $1, observations: $2 };
      }
    |
      tripheader observers observations
      {
        var trip = $1;
        trip.observers = $2;
        $$ = { trip: trip, observations: $3 };
      }
    ;

tripheader
    :
      DATE words NEWLINE
        {
          $$ = { date: $1, location: $2 };
        }
    | DATE TIME words NEWLINE
        {
          $$ = { date: $1, time: $2, location: $3 };
        }
    | DATE TIME '-' TIME words NEWLINE
        {
          $$ = { date: $1, time: $2, endtime: $4, location: $5 };
        }
    ;

observers
    :
      '=' commaSeparatedString NEWLINE
        {
          $$ = $2.split(',');
        }
    ;

commaSeparatedString
    :
      words
        {
          $$ = $1;
        }
    |
      words ',' commaSeparatedString
        {
          $$ = $1 + "," + $3;
        }
    ;

observations
    :
      observation
        {
          $$ = [$1];
        }
    | observation observations
        {
          $$ = [$1].concat($2);
        }
    ;

observation
    :
      speciesname NEWLINE
        {
          $$ = { species: $1 };
        }
    | speciesname adds NEWLINE
        {
          $$ = { species: $1, adds: $2 };
        }
    | speciesname NEWLINE notes
        {
          $$ = { species: $1, notes: $3};
        }
    | speciesname adds NEWLINE notes
        {
          $$ = { species: $1, adds: $2, notes: $4 };
        }
    ;

notes
    :
      note
        {
          $$ = $1;
        }
    |
      note notes
        {
          $$ = $1 + " " + $2;
        }
    ;

note
    :
      NOTE
        {
          $$ = yytext;
        }
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
        {
          $$ = [$1];
        }
    | add adds
        {
          $$ = [$1].concat($2);
        }
    ;

add
    :
      count
        {
          $$ =  $1;
        }
    ;

count
    :
      NUMBER
        {
          $$ = { unsexed: $1 };
        }
    | NUMBER ',' NUMBER 
        {
          $$ = { male: $1, female: $3 };
        }
    | CIRCA NUMBER
        {
          $$ = { circa: $2 };
        }
    ;
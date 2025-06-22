%%

%class html
%unicode
%standalone
%line
%column

%{
    StringBuilder buffer = new StringBuilder();
%}

%state ABSTRACT, CLAIMS, TITLE

// Macros
NUM_PATENTE = [0-9]+,[0-9]+,[0-9]+
DATA = [a-zA-Z]+ \s [0-9]"," \s [0-9]{4}
WS = [ \t\r\n]+
TAG = <[^>]+>

%%

// Número da patente
"<TD ALIGN=\"RIGHT\" WIDTH=\"50%\"><B>"{NUM_PATENTE}"</B></TD>" {
    String texto = yytext();
    String numero = texto.replaceAll("<[^>]*>", "").trim();
    System.out.println("Número da patente: " + numero);
}

// Data de publicação
"<TD ALIGN=\"RIGHT\" WIDTH=\"50%\"> <B>"{DATA}"</B></TD></TR></TABLE>" {
    String texto = yytext();
    String data = texto.replaceAll("<[^>]*>", "").trim();
    System.out.println("Data de publicação: " + data);
}

// Início do título
"<font size=\"+1\">" {
    buffer.setLength(0);
    yybegin(TITLE);
}

// Captura título
<TITLE>{
  [^<]+    { buffer.append(yytext().trim()).append(" "); }
  "</font>" {
    System.out.println("Título: " + buffer.toString().trim());
    yybegin(YYINITIAL);
  }
  {TAG}    { }
  \n       { }
}

// Abstract
"<CENTER><B>Abstract</B></CENTER>" {
    buffer.setLength(0);
    yybegin(ABSTRACT);
}

<ABSTRACT>{
  "<P>"     { }
  "</P>"    {
    System.out.println("Resumo: " + buffer.toString().replaceAll("<[^>]*>", "").trim());
    yybegin(YYINITIAL);
  }
  [^<]+     { buffer.append(yytext().trim()).append(" "); }
  {TAG}     { }
  \n        { }
}

// Claims
"What is claimed is:" {
    buffer.setLength(0);
    yybegin(CLAIMS);
}

<CLAIMS>{
  "<HR>" {
    System.out.println("Reivindicações: " + buffer.toString().replaceAll("<[^>]*>", "").trim());
    yybegin(YYINITIAL);
  }
  [^<]+     { buffer.append(yytext().trim()).append(" "); }
  {TAG}     { }
  \n        { }
}

// Espaços em branco
{WS} { }

// Ignora o resto
.|\n { }
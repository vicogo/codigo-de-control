create or replace PACKAGE            "PCK_BASE64" AS 
/*
Autor:Victor Hugo Gonzales
Fecha: 10/10/2018
DescripciÃ³n: Procedimientos relacionados a la generacion de codigos de control de una factura
*/
  TYPE CARACTERES IS VARRAY(64) OF VARCHAR2(1);
  DICCIONARIO CARACTERES := CARACTERES( '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '+', '/' );
  
  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
  FUNCTION OBTENER_BASE64(PI_NUMERO IN PLS_INTEGER) RETURN VARCHAR2;

END PCK_BASE64;
/

create or replace PACKAGE BODY            "PCK_BASE64" AS
/*
Autor:Victor Hugo Gonzales
Fecha: 10/10/2018
DescripciÃ³n: Procedimientos relacionados a la generacion de codigos de control de una factura
*/
  FUNCTION OBTENER_BASE64(PI_NUMERO IN PLS_INTEGER) RETURN VARCHAR2 AS
  v_cociente  PLS_INTEGER := 1;
  V_PALABRA VARCHAR2(32000) := '';
  V_RESTO    PLS_INTEGER;
  v_numero  PLS_INTEGER := pi_numero;
  BEGIN
    WHILE (v_cociente > 0)
    LOOP
      V_COCIENTE := TRUNC(V_NUMERO  / 64);
      V_RESTO := MOD(V_NUMERO , 64);
      V_PALABRA := PCK_BASE64.DICCIONARIO(V_RESTO+1) || V_PALABRA;
      V_NUMERO := V_COCIENTE;
    END LOOP;
    
    RETURN V_PALABRA;
  END OBTENER_BASE64;

END PCK_BASE64;
/
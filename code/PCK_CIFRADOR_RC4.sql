create or replace PACKAGE            "PCK_CIFRADOR_RC4" AS 
/*
Autor:Victor Hugo Gonzales
Fecha: 10/10/2018
DescripciÃ³n: Procedimientos relacionados a la generacion de codigos de control de una factura
*/

  FUNCTION CIFRAR_RC4(PI_MENSAJE VARCHAR2, PI_KEY VARCHAR2) RETURN VARCHAR2;
  
  
END PCK_CIFRADOR_RC4;
/

create or replace PACKAGE BODY            "PCK_CIFRADOR_RC4" 
AS

/*
Autor:Victor Hugo Gonzales
Fecha: 10/10/2018
DescripciÃ³n: Procedimientos relacionados a la generacion de codigos de control de una factura
*/

FUNCTION CIFRAR_RC4(
    PI_MENSAJE VARCHAR2,
    PI_KEY     VARCHAR2)
  RETURN VARCHAR2
AS
TYPE NUMEROS_ENTEROS IS VARRAY(256) OF PLS_INTEGER;
V_STATE NUMEROS_ENTEROS := NUMEROS_ENTEROS();
--
X PLS_INTEGER      := 0;
Y PLS_INTEGER      := 0;
INDEX1 PLS_INTEGER := 0;
INDEX2 PLS_INTEGER := 0;
--
V_MENSAJE_CIFRADO VARCHAR2(32000) := '';
V_AUX PLS_INTEGER;
--
V_KEY_LENGTH PLS_INTEGER     := LENGTH(PI_KEY);
V_MENSAJE_LENGTH PLS_INTEGER := LENGTH(PI_MENSAJE);
V_CARACTER_ASCII PLS_INTEGER;
V_XOR_INDEX PLS_INTEGER;
V_NMEN PLS_INTEGER;
V_HEXA VARCHAR2(10);
PROCEDURE INTERCAMBIAR(
    PI_POS1 IN PLS_INTEGER,
    PI_POS2 IN PLS_INTEGER)
IS
BEGIN
  V_AUX                       := V_STATE(PI_POS1+1);
  V_STATE(PI_POS1         +1) := V_STATE(PI_POS2 +1);
  v_state(pi_pos2         +1) := v_aux;
END;
BEGIN
  /* TAREA Se necesita implementaciÃ³n */
  V_STATE.extend(256);
  FOR C IN 0..255
  LOOP
    V_STATE(C+1) := C;
  END LOOP;

  FOR P IN 0..255
  LOOP
   -- DBMS_OUTPUT.PUT('MOD('||ASCII(SUBSTR(pi_key,INDEX1+1,1))||'+'||V_STATE(P+1)||'+'||INDEX2||',256)=');
    INDEX2 := MOD((ASCII(SUBSTR(PI_KEY,INDEX1+1,1)) + V_STATE(P+1) + INDEX2), 256);
    --DBMS_OUTPUT.PUT(INDEX2||'|');
    INTERCAMBIAR(P, INDEX2);
    INDEX1 := MOD((INDEX1 + 1), V_KEY_LENGTH);
  END LOOP;
  --DBMS_OUTPUT.PUT_LINE('PI_MENSAJE: '||PI_MENSAJE);
  
  FOR I IN 1.. V_MENSAJE_LENGTH
  LOOP
    X := MOD(X         +1,256);
    Y := MOD((V_STATE(X+1) + Y), 256);
    --DBMS_OUTPUT.PUT_LINE('|V_STATE(X+1)='||V_STATE(X+1));
    INTERCAMBIAR (X, Y);
    V_CARACTER_ASCII := ASCII(SUBSTR(PI_MENSAJE, I,1));
    V_XOR_INDEX      := MOD(V_STATE(X+1) + V_STATE(Y+1), 256);
    V_NMEN             := UTL_RAW.CAST_TO_BINARY_INTEGER(UTL_RAW.BIT_XOR(UTL_RAW.CAST_FROM_BINARY_INTEGER(V_CARACTER_ASCII), UTL_RAW.CAST_FROM_BINARY_INTEGER(V_STATE(V_XOR_INDEX+1))));
    V_HEXA             := TRIM(TO_CHAR(V_NMEN, 'XXXXXXXXXX'));
    IF (LENGTH(V_HEXA) != 2) THEN
      v_hexa           := '0' || v_hexa;
    END IF;
    V_MENSAJE_CIFRADO := V_MENSAJE_CIFRADO || V_HEXA;
   -- DBMS_OUTPUT.PUT_LINE('X,Y,V_CARACTER_ASCII,V_XOR_INDEX,V_NMEN, V_HEXA: '||X||'|'||Y||'|'||V_CARACTER_ASCII ||'|'||V_XOR_INDEX||'|'||V_NMEN||'|'||V_HEXA);
    --DBMS_OUTPUT.PUT('|V_STATE(X+1)='||V_STATE(X+1));
    --DBMS_OUTPUT.PUT('|V_STATE(Y+1)='||V_STATE(Y+1));
  END LOOP;
  RETURN v_mensaje_Cifrado;
END CIFRAR_RC4;
END PCK_CIFRADOR_RC4;
/
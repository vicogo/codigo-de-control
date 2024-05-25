create or replace PACKAGE            "PCK_VERHOEFF" AS 
/*
Autor:Victor Hugo Gonzales
Fecha: 10/10/2018
DescripciÃ³n: Procedimientos relacionados a la generacion de codigos de control de una factura
*/

  TYPE digitos IS VARRAY(10) OF INTEGER;
  TYPE listas_digitos IS VARRAY(10) OF digitos;
  mul listas_digitos := listas_digitos( digitos(0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ),
                                        digitos( 1, 2, 3, 4, 0, 6, 7, 8, 9, 5 ), 
                                        digitos( 2, 3, 4, 0, 1, 7, 8, 9, 5, 6 ), 
                                        digitos( 3, 4, 0, 1, 2, 8, 9, 5, 6, 7 ), 
                                        digitos( 4, 0, 1, 2, 3, 9, 5, 6, 7, 8 ), 
                                        digitos( 5, 9, 8, 7, 6, 0, 4, 3, 2, 1 ), 
                                        digitos( 6, 5, 9, 8, 7, 1, 0, 4, 3, 2 ), 
                                        digitos( 7, 6, 5, 9, 8, 2, 1, 0, 4, 3 ), 
                                        digitos( 8, 7, 6, 5, 9, 3, 2, 1, 0, 4 ), 
                                        digitos( 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 ) );



  per listas_digitos := listas_digitos( digitos( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ), 
                                        digitos( 1, 5, 7, 6, 2, 8, 3, 0, 9, 4 ), 
                                        digitos( 5, 8, 0, 3, 7, 9, 6, 1, 4, 2 ), 
                                        digitos( 8, 9, 1, 6, 0, 4, 3, 5, 2, 7 ), 
                                        digitos( 9, 4, 5, 3, 1, 2, 6, 8, 7, 0 ), 
                                        digitos( 4, 2, 8, 6, 5, 7, 3, 9, 0, 1 ), 
                                        digitos( 2, 7, 9, 3, 8, 0, 6, 4, 1, 5 ), 
                                        digitos( 7, 0, 4, 6, 9, 1, 3, 2, 5, 8 ) );
                                        
  inv digitos :=  digitos( 0, 4, 3, 2, 1, 5, 6, 7, 8, 9 );



  function invertir_numero(pi_numero IN VARCHAR2) return VARCHAR2;
  
  function obtener_Verhoeff(pi_numero IN VARCHAR2) return INTEGER;

END PCK_VERHOEFF;
/

create or replace PACKAGE BODY            "PCK_VERHOEFF" AS
/*
Autor:Victor Hugo Gonzales
Fecha: 10/10/2018
DescripciÃ³n: Procedimientos relacionados a la generacion de codigos de control de una factura
*/
  function invertir_numero(pi_numero IN VARCHAR2) return VARCHAR2 AS
  v_result VARCHAR2(32000);
  BEGIN
    select REVERSE(pi_numero) 
    into v_result from dual;
    RETURN v_result ;
  END invertir_numero;


  function obtener_Verhoeff(pi_numero IN VARCHAR2) return INTEGER AS
    v_check INTEGER := 0;
    v_numero_Invertido VARCHAR2(32000);
    v_digito INTEGER;
    v_permutacion INTEGER;
  begin
  
    select REVERSE(pi_numero) 
    into v_numero_Invertido 
    from dual;
    
    --dbms_output.put_line(V_NUMERO_INVERTIDO);
    --v_numero_Invertido := invertir_numero(pi_numero);
    FOR I IN 0.. LENGTH(V_NUMERO_INVERTIDO)-1 LOOP
      V_DIGITO      := TO_NUMBER(SUBSTR(V_NUMERO_INVERTIDO,I+1,1));
      V_PERMUTACION := PCK_VERHOEFF.PER(MOD((I + 1), 8)+1)( V_DIGITO +1);
      v_check := pck_verhoeff.mul(v_check+1)(v_permutacion +1);
    END LOOP;
    return  pck_verhoeff.inv(v_check+1);
  end obtener_Verhoeff;

END PCK_VERHOEFF;
/
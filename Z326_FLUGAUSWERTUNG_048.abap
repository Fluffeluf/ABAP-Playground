*&---------------------------------------------------------------------*
*& Report Z326_FLUGAUSWERTUNG_048
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z326_FLUGAUSWERTUNG_048.


*Es können beide Werte aus der Tabelle spfli ausgelesen werden
TABLES spfli.
SELECT-OPTIONS: s_carr FOR spfli-carrid.
SELECT-OPTIONS: s_conn FOR spfli-connid.

PARAMETERS: p_vonD   TYPE sflight-fldate,
            p_bisD   TYPE sflight-fldate,
            p_pListe AS CHECKBOX.

DATA: g_carrId TYPE scarr-carrid,       "Fluggesellschaft Kürzel
      g_carrN  TYPE scarr-carrname,     "Fluggesellschaft Name
      g_connId TYPE spfli-connid,       "Flugverbindung-Nr
      g_citFr  TYPE spfli-cityfrom,     "Abflugstadt
      g_citTo  TYPE spfli-cityto,       "Zielstadt
      g_planeT TYPE sflight-planetype,  "Flugzeugtyp
      g_flDate TYPE sflight-fldate,     "Flugdatum
      g_anzCus TYPE i,                  "Anzahl Passagiere
      g_pasNam TYPE scustom-name,       "Passagier Name
      g_pasOrt TYPE scustom-city.       "Wohnort Passagier


START-OF-SELECTION.
* Auswahl 1. Ebene Fluggesellschaft
  SELECT carrid, carrname
    FROM scarr
    INTO (@g_carrId, @g_carrN)
    WHERE carrid IN @s_carr.
*.. Ausgabe 1. Ebene
    WRITE: / 'Fluggesellschaft: ', g_carrId, g_carrN.

*... Auswahl 2. Ebene Flugverbindung
    SELECT spfli~connid, spfli~cityfrom, spfli~cityto, sflight~planetype, sflight~fldate, COUNT( DISTINCT sbook~customid )
      INTO (@g_connId, @g_citFr, @g_citTo, @g_planeT, @g_flDate, @g_anzCus)
      FROM spfli
      INNER JOIN sflight ON spfli~carrid = sflight~carrid
      INNER JOIN sbook ON sflight~connid = sbook~connid
      AND sflight~fldate = sbook~fldate
      WHERE spfli~connid IN @s_conn
      AND sflight~fldate BETWEEN @p_vonD AND @p_bisD
      GROUP BY spfli~connid, spfli~cityfrom, spfli~cityto, sflight~planetype, sflight~fldate.
*.... Ausgabe 2.Ebene Flugverbindung mit Passagieranzahl
      WRITE: / 'Verbindung: ', g_connId, g_citFr, g_citTo, g_planeT, g_flDate, g_anzCus.

*.... Prüfung, ob die Checkbox ausgewählt wurde
      IF p_pListe = 'X'.
*.... Auswahl 3. Ebene Passagierliste
        SELECT name, city
          INTO (@g_pasNam, @g_pasOrt)
          FROM scustom
          INNER JOIN sbook ON scustom~id = sbook~customid.
*...... Ausgabe 3. Ebene Passagierliste
          WRITE: / g_pasNam, g_pasOrt.
        ENDSELECT.
      ENDIF.
    ENDSELECT.
  ENDSELECT.

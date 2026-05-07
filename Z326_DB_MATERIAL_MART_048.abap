*&---------------------------------------------------------------------*
*& Report Z326_DB_MATERIAL_MART_048
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z326_db_material_mart_048.
* Auswertung welche Artikel zu einer bestimmten Materialart (Rohstoffe,etc.) gehören. Materialart von Benutzer
* Für jeden Artikel Materialnummer, Name Erstellers, Warengruppe, Bruttogewicht ausgeben

PARAMETERS: p_mtart TYPE mara-mtart.

DATA: g_matnr    TYPE mara-matnr,
      g_ernam    TYPE mara-ernam,
      g_matkl    TYPE mara-matkl,
      g_brgew    TYPE mara-brgew,
      g_anzahl   TYPE i,
      g_brgesgew TYPE mara-brgew,
      g_matkurtx TYPE makt-maktx.

START-OF-SELECTION.
* Prüfung ob der eingegebene Wert 0, null, oder einfach gesagt leer ist.
  IF p_mtart IS INITIAL.
    WRITE: / 'Bitte eine Materialart eingeben!'.
  ELSE.
* Wenn nicht dann werden erst die Anzahl Artikel und die Summe des Bruttogesamtgewichts selected
    SELECT SINGLE COUNT(*), SUM( brgew ) " Entweder immer * oder DISTINCT
      INTO (@g_anzahl, @g_brgesgew)
      FROM mara
      WHERE mtart = @p_mtart.
* Wenn die Anzahl nicht der Initialwert ist dann wird etwas ausgegeben
      IF g_anzahl IS NOT INITIAL.
        FORMAT COLOR COL_POSITIVE.
        WRITE: / 'Es wurden ', g_anzahl,
         'Artikel in der Datenbank von der Materialart', p_mtart, 'gefunden'.
        WRITE: / 'Das Bruttogesamtgewicht beträgt: ', g_brgesgew.
      ELSE.
* Wenn die Anzahl jedoch der Initialwert ist dann gibt es keine Einträge für die Materialart
        FORMAT COLOR COL_NEGATIVE.
        WRITE: / 'Materialart leer.'.
      ENDIF.
* Select-Schleife für die Daten + Ausgabe der Daten
    SELECT m~matnr, m~ernam, m~matkl, m~brgew, mkt~maktx
      INTO (@g_matnr, @g_ernam, @g_matkl, @g_brgew, @g_matkurtx)
      FROM mara AS m
      LEFT JOIN makt AS mkt ON m~matnr = mkt~matnr AND mkt~spras = @sy-langu
      WHERE mtart = @p_mtart.
      FORMAT COLOR COL_BACKGROUND. " Weil von IF is not initial sonst das auch färbt
      WRITE: /10 g_matnr, 30 g_ernam.
      IF g_matkl is INITIAL.
        WRITE: 40 'Warengruppe leer'.
      ELSE.
        WRITE: 40 g_matkl.
      ENDIF.
      WRITE: 60 g_brgew.
      IF g_matkurtx is INITIAL.
        WRITE: 70 'Nicht gepflegt'.
      ELSE.
        WRITE: 70 g_matkurtx.
      ENDIF.
    ENDSELECT.
  ENDIF.

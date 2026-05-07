* Mein super Taschenrechner
REPORT z326_trechner_048.
* Eingabemaske deklarieren
PARAMETERS: g_zahl1 TYPE i,
            g_zahl2 TYPE i,
            g_opt   TYPE char1.

* Variablen deklarieren
DATA: g_ergebnis TYPE i.

* Verarbeitung starten
START-OF-SELECTION.
  CASE g_opt.
    WHEN '+'.
      g_ergebnis = g_zahl1 + g_zahl2.
    WHEN '-'.
      g_ergebnis = g_zahl1 - g_zahl2.
    WHEN '*'.
      g_ergebnis = g_zahl1 * g_zahl2.
    WHEN '/'.
      IF g_zahl1 = 0 OR g_zahl2 = 0.
        WRITE: 'Du kannst nicht mit 0 dividieren'.
      ELSE.
        g_ergebnis = g_zahl1 / g_zahl2.
      ENDIF.
    WHEN OTHERS.
      WRITE: 'Ungültiger Rechenoperator'.
      RETURN. "Verlässt die Verarbeitung
  ENDCASE.

* Ausgabe
  WRITE: AT /20 g_zahl1, AT /20 g_zahl2.
  ULINE.
  WRITE: /'{' COLOR 5,'{@}' COLOR 6, '}' COLOR 5, 'Ergebnis: ', AT 20 g_ergebnis COLOR 5, '{' COLOR 5,'{@}' COLOR 6, '}' COLOR 5.

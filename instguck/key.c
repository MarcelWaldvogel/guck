/********************************************************************\
* KEY.C - Tastenverarbeitung und Menüsimulation                      *
*                                                                    *
* (c) 1990 Marcel Waldvogel, Hägetstalstr. 37, CH-8610 Uster         *
* Durchsuchen des Menübaumes mit freundlicher Hilfe von Urs Müller.  *
* Benötigt KEY.H und UPPERTAB.C/UPPERTAB.O                           *
\********************************************************************/

#include <stddef.h>		/* NULL */
#include <tos.h>		/* KEYTAB, Keytbl() */
#include <aes.h>		/* OBJECT, menu_tnormal(), appl_write() */

#include "key.h"

/****** Typen und Variablen *****************************************/

#define AVAIL(obj) !(obj->ob_state & DISABLED || obj->ob_flags & HIDETREE)

typedef enum {FALSE, TRUE} bool;

static const char *unshift, *shift, *capslock;
static       int  msg_out[8] = {MN_SELECTED, -1, 0, -1, -1, 0, 0, 0};
static       bool visible;

/********************************************************************\
* Initialisiert einige globale Variablen			     *
\********************************************************************/
void key_init(int ap_id, int menu_visible)
{
  void *minus1 = (void *) -1;
  KEYTAB *keytab;

  msg_out[1] = ap_id;		/* Application-ID eintragen */
  visible  = menu_visible;

  keytab   = Keytbl(minus1, minus1, minus1);
  unshift  = keytab->unshift;	/* Tastaturtabellen merken */
  shift    = keytab->shift;
  capslock = keytab->capslock;
}


/********************************************************************\
* Wandelt nach Grossbuchstaben (beachtet Umlaute)		     *
\********************************************************************/
char key_upper(char c)
{
  static const char uppertab[] =
  {
    'Ç', 'Ü', 'É', 'â', 'Ä', '╢', 'Å', 'Ç',	/* 0200..0207 */
    'ê', 'ë', 'è', 'ï', 'î', 'ì', 'Ä', 'Å',	/* 0210..0217 */
    'É', 'æ', 'Æ', 'ô', 'Ö', 'ò', 'û', 'ù',	/* 0220..0227 */
    'ÿ', 'Ö', 'Ü', '¢', '£', '¥', '₧', 'ƒ',	/* 0230..0237 */
    'á', 'í', 'ó', 'ú', 'Ñ', 'Ñ', 'ª', 'º',	/* 0240..0247 */
    '¿', '⌐', '¬', '½', '¼', '¡', '«', '»',	/* 0250..0257 */
    '╖', '╕', '▓', '▓', '╡', '╡', '╢', '╖',	/* 0260..0267 */
    '╕', '╣', '║', '╗', '╝', '╜', '╛', '┐',	/* 0270..0271 */
    '┴', '┴'
  };

  if (c >= 'a' && c <= 'z')
    return c - 'a' + 'A';
  if (c >= '\200' && c <= '\271')
    return uppertab[c - '\200'];
  else
    return c;
}


/********************************************************************\
* Testet, ob der String key ganz hinten in menu vorkommt (Leer-      *
* zeichen dürfen noch dahinter stehen). Direkt davor muss noch ein   *
* Leerzeichen stehen. Lokale Funktion.				     *
\********************************************************************/
static bool key_right(const char *menu, const char *key)
{
  const char *menuptr = menu,
             *keyptr  = key;

  while (*menuptr != '\0')
    menuptr++;			/* menuptr an den Schluss des Strings */
  while (*(--menuptr) == ' ');	/* von rechts erstes Zeichen suchen */

  while (*keyptr != '\0')		/* Stringende suchen */
    keyptr++;
  keyptr--;			/* Wieder aufs letzte Zeichen */

  /*
  ** - Sind noch Zeichen zu vergleichen (keyptr >= key)?
  ** - Ist nachher noch mindestens ein Zeichen im Menütext,
  **   da davor ein Leerzeichen stehen muss (menuptr > menu)?
  ** - Sind die beiden Zeichen gleich (*keyptr == *menuptr--)?
  **
  ** menuptr wird immer zurückgezählt, da es nach Vergleichsende auf
  ** dem Leerzeichen vor dem Tastenstring stehen sollte.
  ** keyptr wird nur zurückgezählt, wenn der Vergleich erfolgreich war,
  ** daran ist das erfolgreiche Ende zu erkennen.
  */
  while (keyptr >= key && menuptr > menu && *keyptr == *menuptr--)
    keyptr--;

  /*
  ** Alles überprüft, und steht vor dem Tastentext im Menü noch ein Space?
  */
  if (keyptr < key && *menuptr == ' ')
    return TRUE;
  else
    return FALSE;
}


/********************************************************************\
* Durchsucht den Menübaum menu nach dem String key. key muss in      *
* einem Dropdown-Eintrag ganz rechts stehen (siehe key_right).       *
* Als Menübaum ist auch NULL erlaubt. Dann passiert einfach nichts.  *
* Kann auch vom Hauptprogramm her aufgerufen werden, falls weitere   *
* Tasten behandelt werden sollen (z.B. key_search(menu, "HELP");)    *
* Sollte nur bei aktivem wind_update(BEG_UPDATE) aufgerufen werden.  *
\********************************************************************/
void key_search(OBJECT *menu, char *key)
{
  bool desk = TRUE;
  int  menubar, menutitle, dropdown, entry;
  OBJECT *obj;

  if (menu == NULL || key == NULL)	/* Was soll denn das? */
    return;

  menubar   = menu[menu->ob_head].ob_head; /* Obj: Menüzeile */
  menutitle = menu[menubar].ob_head;       /* Obj: Titel in Menüzeile */
  dropdown  = menu[menu->ob_tail].ob_head; /* Obj: Ein Dropdown */
  entry     = menu[dropdown].ob_head;      /* Obj: Eintrag im Dropdown */

  do{					/* Für alle Titeln */
    obj = &menu[menutitle];
    if (AVAIL(obj) && entry != -1)	/* Titel ok? Hat es Einträge? */
    {
      do{
        obj = &menu[entry];
        if (AVAIL(obj)
            && (obj->ob_type == G_STRING || obj->ob_type == G_BUTTON)
            && key_right(obj->ob_spec.free_string, key))
        {
          if (visible)
            menu_tnormal(menu, menutitle, FALSE);
          msg_out[3] = menutitle;	/* Menutitel */
          msg_out[4] = entry;		/* Menueintrag */
          appl_write(msg_out[1], 16, msg_out); /* Message verschicken */
          return;			/* Aufgabe erfüllt */
        }
        entry = obj->ob_next;		/* Zum nächsten Eintrag */
        /*
        ** Bis alle Einträge durch sind, aber im ersten Menü ("DESK")
        ** nur den ersten Eintrag überprüfen, also ohne ACCs.
        */
      }while (entry != dropdown && !desk);
      desk = FALSE;
      menutitle = menu[menutitle].ob_next;	/* Zum nächsten Titel */
      dropdown  = menu[dropdown].ob_next;
      entry     = menu[dropdown].ob_head;
    }
  }while (menutitle != menubar);	/* Alle Menütitel getestet? */
}


/********************************************************************\
* Parameter: Keycode (Highbyte: Scan, Lowbyte: ASCII)		     *
*	     Menübaum (kann auch NULL sein, wenn kein Menü durch-    *
*	     sucht werden soll.					     *
*								     *
* Rückgabe:							     *
* -1:	  "Unvorhergesehener Fall", sollte nicht passieren, ausser   *
*	  es wurde eine völlig neuartige Tastenkombination gedrückt. *
* 0:	  Nichts zu verarbeiten. Entweder wurde der Tastencode       *
*	  als Menüpunkt interpretiert, oder eine normale Taste mit   *
*	  ASCII-Code 0 wurde gedrückt. (Aufrufer muss nichts tun)    *
* 1..255: ASCII-Code						     *
* >=256:  Im Lowbyte ist der Scancode der Taste, zusätzlich sind     *
*	  noch (wenn nötig) die Werte KEY_CONTROL und/oder KEY_SHIFT *
*	  hineingeODERt. KEY_SPECIAL ist hier immer gesetzt	     *
*	  (das bringt den Wert über 255 hinaus).		     *
\********************************************************************/
int key_code(OBJECT *menu, unsigned int keycode)
{
  unsigned char buf[5], c;
  unsigned char *text   = buf;
  unsigned int  scan    = keycode >> 8;
  unsigned char ascii   = keycode & 0xff;

#if KOMISCH
  switch (keycode)
  {
  case 0x0300:
  case 0x6e00: key_search(menu, "^2"); return 0;
  case 0x071e:
  case 0x6c1e: key_search(menu, "^6"); return 0;
  case 0x351f:
  case 0x4a1f: key_search(menu, "^-"); return 0;
  }
#endif

  /*
  ** Falls Scancode == 0 (z.B. durch Makrorekorder oder
  ** Alt-Zehnerblock), dann ASCII-Code zurückgeben (der in diesem
  ** Fall mit dem keycode identisch ist).
  */
  if (scan == 0)
    return ascii;

  /*
  ** Einige weiteren üblichen Tasten
  */
  switch (scan)
  {
#if WANDLECONTROL
  case CTRLHOME:
  		if (ascii == 0)
  		  return CLRHOME | KEY_SPECIAL | KEY_CONTROL;
  		else
  		  return CLRHOME | KEY_SPECIAL | KEY_CONTROL | KEY_SHIFT;
  case CTRLLINKS:
  		if (ascii == 0)
  		  return LINKS | KEY_SPECIAL | KEY_CONTROL;
  		else
  		  return LINKS | KEY_SPECIAL | KEY_CONTROL | KEY_SHIFT;
  case CTRLRECHTS:
  		if (ascii == 0)
  		  return RECHTS | KEY_SPECIAL | KEY_CONTROL;
  		else
  		  return RECHTS | KEY_SPECIAL | KEY_CONTROL | KEY_SHIFT;
#else /* !WANDLECONTROL */
  case CTRLHOME:
  case CTRLLINKS:
  case CTRLRECHTS:
#endif
  case HELP:
  case UNDO:
  case INSERT:
  case CLRHOME:
  case AUF:
  case LINKS:
  case RECHTS:
  case AB:	if (ascii == 0)
		  return scan | KEY_SPECIAL;
		if (ascii > ' ')
		  return scan | KEY_SPECIAL | KEY_SHIFT;
		else
		  return scan | KEY_SPECIAL | KEY_SHIFT | KEY_CONTROL;
  case BACKSPACE:
  case ESC:
  case TAB:
  		return scan | KEY_SPECIAL;
  case DELETE:	if (ascii == DEL)
  		  return scan | KEY_SPECIAL;
  		else
  		  return scan | KEY_SPECIAL | KEY_CONTROL;
  case RETURN:
  case ENTER:	if (ascii == CR)
  		  return scan | KEY_SPECIAL;
  		else
  		  return scan | KEY_SPECIAL | KEY_CONTROL;
  }

  /*
  ** Funktionstasten und Shift-Funktionstasten.
  ** Falls SF-Taste, zuerst Shift-Symbol eintragen und dann
  ** Scancode in den F-Tastenbereich bringen.
  */
  if (scan >= SF1 && scan <= SF10)
  {
    *text++ = SHIFTCHAR;
    scan = scan - SF1 + F1;
  }
  if (scan >= F1 && scan <= F10)
  {
    *text++ = 'F';
    if (scan == F10)
    {
      *text++ = '1';			/* "10" anhängen */
      *text++ = '0';
    }
    else
      *text++ = scan - F1 + '1';	/* F-Tastennummer eintragen */
    *text++ = '\0';			/* String abschliessen */
    key_search(menu, buf); 		/* Ganzen Buffer übergeben */
    return 0;				/* Aufrufer muss nichts tun */
  }

  /*
  ** Oberste Reihe des Alphablockes mit Alternate:
  ** [Alt-1] bis [Alt-9], [Alt-0], [Alt-₧], [Alt-']
  ** (Die Tasten können auf anderen Tastaturen anders benannt sein)
  ** Der Scancode von ALTAPOSTROPH ist grösser als 128!
  */
  if (scan >= ALT1 && scan <= ALTAPOSTROPH)
  {
    *text++ = '\007';			/* Alternate-Symbol */
    *text++ = capslock[scan - ALT1 + 2];
    *text++ = '\0';
    key_search(menu, buf);
    return 0;
  }

  /*
  ** Sonstige Taste/Tastenkombination:
  ** - mit Alt
  ** - mit Ctrl
  ** - mit Ctrl-Shift (nicht bei A-Z)
  ** - ganz normal (auch Tasten mit Spezialzeichen < ' ', wie LED)
  */
  if (ascii >= ' ')			/* Trivialer Fall */
    return ascii;			/* Zeichen übernehmen */
  if (scan >= 128)			/* Index out of Range */
    return -1;				/* Keine Ahnung... */
  if (ascii != '\0' && (unshift[scan] == ascii ||
      shift[scan] == ascii || capslock[scan] == ascii))
    return ascii;			/* Spezialzeichen auf Tastatur */
  buf[0] = SHIFTCHAR;			/* Shift-Ctrl-Char-EOS */
  buf[1] = CTRLCHAR;
  buf[2] = key_upper(unshift[scan]);
  buf[3] = '\0';
  if (buf[2] == 0)			/* Irgendwas komisches */
    return -1;
  if (ascii == (unshift[scan] & 0x1f))	/* ^unshift? */
  {
    key_search(menu, &buf[1]);
    return 0;
  }
  if (ascii == (shift[scan] & 0x1f))	/* ^shift? */
  {
    c = key_upper(shift[scan]);
    if (((c ^ buf[2]) & 0x1f) != 0)	/* c&0x1f == buf[2]&0x1f? */
    {
      buf[2] = c;
      key_search(menu, &buf[1]);
    }
    else
      key_search(menu, buf);
    return 0;
  }
  if (ascii == (capslock[scan] & 0x1f))	/* ^capslock? */
  {
    key_search(menu, &buf[1]);
    return 0;
  }
  if (ascii == 0)
  {
    buf[1] = ALTCHAR;
    key_search(menu, &buf[1]);
    return 0;
  }
  else
  {
    buf[2] = ascii | '@';
    key_search(menu, &buf[1]);
    return 0;
  }
}


/********************************************************************\
* Headerdatei für KEY.C                                              *
\********************************************************************/

/*
** Prototypen
**
** - key_init() muss vor Verwendung der weiteren Funktionen aufgerufen
**   werden. Die ap_id wird für das Versenden der Message benötigt.
**   key_init() darf beliebig oft aufgerufen werden.
**   Im Parameter menu_visible sollte übergeben werden, ob das Menü
**   sichtbar ist. Falls menu_visible == FALSE ist, wird der Menü-
**   titel nicht invertiert (nützlich, falls als ACC gestartet).
** - key_upper() verwandelt das übergeben Zeichen unter Beachtung der
**   Umlaute in einen Grossbuchstaben.
** - key_search() durchsucht den Menübaum nach einem bestimmten String
**   und versendet eine entsprechende MN_SELECTED-Message.
** - key_code() wird mit dem von evnt_multi()/evnt_keybd() erhaltenen
**   Tastencode gefüttert.
**   - Falls der Tastencode direkt ein gültiges ASCII-Zeichen
**     (z.B. für einen Editor) ist, wird dieser zurückgeliefert.
**   - Falls der Tastencode eine Taste des Cursorblocks, ESC, TAB,
**     DELETE, BACKSPACE, ENTER oder RETURN ist, wird deren Scancode,
**     verODERt mit KEY_SPECIAL und allfälligerweise KEY_CONTROL
**     und/oder KEY_SHIFT zurückgeliefert.
**   - Sonst (bei Funktionstasten, [Alt]-, [Ctrl]- und [Ctrl-Shift]-
**     Kombinationen mit den übrigen Tasten) wird key_search() mit
**     dem gebildeten String aufgerufen. Diese Suche kann wird nur
**     durchgeführt, wenn der Parameter menu != NULL ist.
**
** key_search() und key_code() sollten nur bei aktivem wind_update()
** (Zustand BEG_UPDATE) aufgerufen werden.
*/
void key_init(int ap_id, int menu_visible);
char key_upper(char key);
void key_search(OBJECT *menu, char *key);
int  key_code(OBJECT *menu, unsigned int keycode);

/*
** Das nachfolgende Flag entscheidet, ob ^2, ^6 und ^- speziell
** behandelt werden sollen. Sie werden (zumindest vom deutschen TOS)
** mit den völlig unverständlichen und unsystematischen ASCII-Codes
** 0, 30, 31 (respektive) versehen. (Auch im Zehnerblock)
*/
#define KOMISCH		1

/*
** Das nachfolgende Flag entscheidet, ob CTRLLINKS, CTRLRECHTS und
** CTRLHOME so bleiben sollen (0) oder in z.B. LINKS | KEY_CONTROL
** gewandelt werden sollen (1).
*/
#define WANDLECONTROL	1

/*
** Einige wichtige Scancodes
**
** Nettes Detail: Bei INSERT und AUF (nicht jedoch bei AB) gibt es
** zusätzlich zu SHIFT auch noch SHIFT-CONTROL, nicht jedoch CONTROL.
*/
#define ESC		0x01
#define BACKSPACE	0x0e
#define TAB		0x0f
#define RETURN		0x1c	/* ASCII != 13	-> mit CTRL	*/
#define CLRHOME		0x47	/* ASCII != 0	-> CLR		*/
#define AUF		0x48	/* ASCII != 0	-> mit SHIFT	*/
				/* ASCII < ' '	-> auch mit CTRL*/
#define LINKS		0x4b	/* ASCII != 0	-> mit SHIFT	*/
#define RECHTS		0x4d	/* ASCII != 0	-> mit SHIFT	*/
#define AB		0x50	/* ASCII != 0	-> mit SHIFT	*/
#define INSERT		0x52	/* ASCII != 0	-> mit SHIFT	*/
				/* ASCII < ' '	-> auch mit CTRL*/
#define DELETE		0x53	/* ASCII != 127	-> mit CTRL	*/
#define UNDO		0x61
#define HELP		0x62
#define ENTER		0x72	/* ASCII != 13	-> mit CTRL	*/
#define CTRLLINKS	0x73
#define CTRLRECHTS	0x74
#define CTRLHOME	0x77	/* ASCII != 0	-> mit SHIFT	*/

/*
** Einige hinzugeoderte Bits
*/
#define KEY_SPECIAL	0x100
#define KEY_SHIFT	0x200
#define KEY_CONTROL	0x400

/*
** Die intern benötigten Scancodes
*/
#define F1		0x3b
#define F10		0x44
#define SF1		0x54
#define SF10		0x5d
#define ALT1		0x78	/* Spezialbehandlung für diese */
#define ALTAPOSTROPH	0x83	/* Tastenreihe */

#define ALTCHAR		'\007'	/* Alternate-Symbol als char */
#define ALTSTR		"\007"	/* Alternate-Symbol als String */
#define SHIFTCHAR	'\001'	/* Shift-Symbol */
#define SHIFTSTR	"\001"
#define CTRLCHAR	'^'	/* Ctrl-Symbol */
#define CTRLSTR		"^"

#define CR		13
#define DEL		127


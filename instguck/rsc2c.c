/*
    RSC2C - Resourcewandler für INSTGUCK.PRG (Turbo C)
*/


/* includes ********************************************************/

#include <aes.h>
#include <tos.h>
#include <string.h>
#include <stdio.h>


/* defines *********************************************************/

#define BUFSIZE 16000 /* Nicht mehr als 32 KB */

/* externals *******************************************************/

extern int _app;


/* typedefs ********************************************************/

typedef enum {FALSE, TRUE} boolean;

typedef struct{
  char path[80];
  char file[15];
  char both[95];
} FSEL;


typedef struct{
  long         mname; /* Magic Name ('AgK0'/A_MAGIC) */
  unsigned int thedrive;
} AUSGUCK;


/* globals *********************************************************/

FSEL si, so;
boolean initialized = FALSE;

int buf[BUFSIZE];

/* prototypes ******************************************************/


/* remainder *******************************************************/


void calc_fsel(FSEL *fsel)
/************************/
{
  char *name, *backslash, *concat;
  char cont;

  name = backslash = fsel->path;
  concat = fsel->both;

  /* Kopieren ganzen Pfad und sich jede Backslash-Position merken */
  do{
    if ((cont = *concat++ = *name++)=='\\')
      backslash = concat;
  }while (cont);
  /* backslash zeigt jetzt eins nach den letzten Backslash */

  /* Filenamen anhnängen */
  name = fsel->file;
  while ((*backslash++ = *name++) != '\0');
}


void init_fsel(FSEL *fsel, const char *fname, const char *ext)
/************************************************************/
{
  strcpy(fsel->file, fname);
  fsel->path[0] = Dgetdrv()+'A';
  fsel->path[1] = ':';
  Dgetpath(&(fsel->path[2]), 0);
  strcat(fsel->path, ext);
  calc_fsel(fsel);
}


void arrow(void)
/**************/
{
  graf_mouse(ARROW, 0L);
}


void busy(void)
/*************/
{
  graf_mouse(HOURGLASS, 0L);
}


int get_fsel(FSEL *par)
/*********************/
{
  int button, ok;
  FSEL my_fsel;

  my_fsel = *par; /* Structure Assignment */
  ok = fsel_input(my_fsel.path, my_fsel.file, &button);
  if (button && ok)
  {
    *par = my_fsel;
    calc_fsel(par);
    return(TRUE);
  }
  return(FALSE);
}


int show_err(const char *s1, const char *s2, const char *s3)
/**********************************************************/
{
  char s[150];

  strcpy(s, s1);
  strcat(s, s2);
  strcat(s, s3);
  arrow();
  return form_alert(1, s);
}


void force_ext(char *name, char *ext)
/*****************************************/
{
/* Beispiele:
 * force_ext("HALLO.C", ".ASM")         -> "HALLO.ASM"
 * force_ext("HALLO.C", "RSC.TXT")      -> "HALLORSC.TXT"
 * force_ext("FILENAME.C", "RSC.TXT")   -> "FILENRSC.TXT"
 * force_ext("F:\HALLO\C.RSC", "RSC.S") -> "F:\HALLO\CRSC.S"
*/
  char *backslash;
  char *dot;
  long fnl; /* File Name Length */
  long nel; /* Non-Extension Filename Length */
           /* Länge des nicht-Extension-Teiles von ext */

  dot = ext;
  while (*dot && *dot != '.')
    dot++;
  nel = dot-ext; /* Länge */

  if (*name && name[1]==':') name += 2; /* Laufwerksdoppelpunkt? */
  backslash = name; /* Falls kein Backslash */

  /* Liefere in backslash den Zeiger auf den Dateinamen: */
  while (*name)
  {
    if (*name++ == '\\')
      backslash = name;
  }

  /* Finde '.' oder '\0': */
  dot = backslash;
  while (*dot && *dot != '.')
    dot++;
  fnl = dot-backslash;

  if (fnl+nel > 8) /* Zusammen länger als 8 Zeichen */
  {
    dot -= fnl+nel-8;
  }

  /* Kopiere neue Extension: */
  while ((*dot++ = *ext++) != 0);
}


void err_read(const char *fn)
/***************************/
{
  show_err("[1][|Kann Datei|>>", fn, "<<|nicht lesen!|(Existiert sie nicht?)][Abbruch]");
}


void err_write(const char *fn)
/****************************/
{
  show_err("[1][|Kann Datei|>>", fn, "<<|nicht schreiben!|(Disk voll/schreibgeschützt?)][Abbruch]");
}


int toascii(FILE *i, FILE *o)
/****************************/
{
  int rd,wr;
  int idx;

  rd = (int) fread(buf, sizeof(int), BUFSIZE, i);
  fprintf(o, "/*\n"
             "  \035Resourcedatei\035\n"
             "*/\n"
             "\n"
             "unsigned int rsc_datei[] = {\n");

  for (idx=0; idx < (rd-16); idx += 16)
    wr = vfprintf(o, "%uU,%uU,%uU,%uU,%uU,%uU,%uU,%uU,%uU,%uU,%uU,%uU,%uU,%uU,%uU,%uU,\n",
                  &buf[idx]);
  for(; idx < (rd-1); idx++)
    wr = fprintf(o, "%uU,", buf[idx]);
  wr = fprintf(o, "%uU\n};\n\n", buf[idx]);
  return(0);
}


void rsc2c(void)
/**************/
{
  FILE *fi, *fo;
  
  arrow();
  if (!initialized)
    init_fsel(&si, "INSTGUCK.RSC", "\\*.RSC");
  if (!get_fsel(&si)) return;
  /* Berechne Ausgabedatei */
  strcpy(so.path, si.path); force_ext(so.path, ".C");
  strcpy(so.file, si.file); force_ext(so.file, "RSC.C");
  calc_fsel(&so);
  if (!get_fsel(&so)) return;

  fi = fopen(si.both, "rb");
  if (fi)
  {
    fo = fopen(so.both, "w");
    if (fo)
    {
      busy();
      toascii(fi, fo);
      fclose(fo);
    }
    else
      err_write(so.both);
    fclose(fi);
  }
  else
    err_read(si.both);
  arrow();
}


int main(void)
/************/
{
  int msg[8]; /* Dummy */

  _GemParBlk.global[2] = _GemParBlk.intout[0] = -1;
  /* Für appl_init(): Hat AES geantwortet (nicht aus AUTO-Ordner)? */

  if (appl_init()<0)
    return(-99);
  else /* appl_init geglückt */
  {
    if (_app) /* Applikation? */
      rsc2c();
    else /* Nein, Accessory! */
      while (TRUE)
      {
        evnt_mesag(msg);
        if (msg[0] == AC_OPEN)
          rsc2c();
      }
    appl_exit();
  }
  return(0);
}

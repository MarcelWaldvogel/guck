/*
    INSTGUCK - Installationsprogramm für GUCK.TTP (Turbo C)

    ACHTUNG! Muss meine fsel_exinput()-Routine benutzen!
             (es geht auch eine andere, die bei AES vor
             V1.4 ganze einfach fsel_input() aufruft)
*/


/* includes ********************************************************/

#include <aes.h>
#include <tos.h>
#include <stddef.h>
#include <string.h>
#include "instguck.h"
#include "key.h"


/* defines *********************************************************/

#define G_MAGIC  'Guk0'		/* Magic für AusGUCK */
#define G_MAGIC2 'Guk9'
#define C_MAGIC  0x601a		/* Magic für Programme */

#define CTRLZ	26
#define MGS	15000 /* MaxGuckSize */
#define DRIVEC	2


/* externals *******************************************************/

extern int rsc_datei[];


/* typedefs ********************************************************/

typedef enum{
  FALSE, TRUE
} bool;

typedef enum{
  dat, par, tos, gem
} FEXT;


typedef enum{
  new, exec, notexec
} FTYPE;


typedef struct{
  int  c_magic;			/* magic number (0x601A/C_MAGIC)*/
  long c_text;			/* size of text segment		*/
  long c_data;			/* size of initialized data	*/
  long c_bss;			/* size of uninitialized data	*/
  long c_syms;			/* size of symbol table		*/
  long c_entry;			/* reserved, always zero	*/
  long c_res;			/* reserved, always zero	*/
  int  c_reloc;			/* reserved, always zero	*/
} HEADER;


typedef struct{
  char   path[108];
  char   file[14];
  char   both[122];
  char   title[40];
  FEXT   ext;
  FTYPE  type;
  HEADER hdr;
} FSEL;


typedef struct{
  long	 mname;		/* Magic Name ('Guk0'/A_MAGIC) */
  char   textpath[32];
  char   grafpath[32];
  char   cfgpath[32];
} GUCK;


/* globals *********************************************************/

static char guckmem[MGS+1000];

static FSEL guck[2]; /* [0]=in, [1]=out */
static int locguck;

static FSEL infofile;

static bool autor = FALSE;
static bool pfeil = FALSE;
static int gl_apid;


/* prototypes ******************************************************/

void mrsrc_load(int rsc_buffer[], int fontw, int fonth);
void mrsrc_gaddr(int rsc[], int type, int index, void *ptr);


/* remainder *******************************************************/

long timer(void)
/**************/
{
  long time, stack;

  stack = Super(NULL);		/* change to supervisor mode	*/
  time = *((long *) 0x4ba);	/* read _hz_200			*/
  Super((void *) stack);	/* change back to user mode	*/
  return time;
}


int bootdev(void)
/***************/
{
  int bootdev;
  long stack;

  stack = Super(NULL);
  bootdev = *((int *) 0x446);	/* read _bootdev		*/
  Super((void *) stack);
  return bootdev;
}


void calc_fsel(FSEL *fsel)
/************************/
{
  char *name, *backslash, *concat;
  char cont;
  int len;
  int handle;

  name = backslash = fsel->path;
  concat = fsel->both;

  /* Kopiere ganzen Pfad und merke jede Backslash-Position */
  do{
    if ((cont = *concat++ = *name++) == '\\')
      backslash = concat;
  }while (cont);
  /* backslash zeigt jetzt eins nach den letzten Backslash */

  /* Filenamen anhnängen */
  name = fsel->file;
  while ((*backslash++ = *name++) != '\0');

  /* Und jetzt noch die Extension */
  fsel->ext = dat;
  len = (int)strlen(fsel->file);
  if (len >= 4)
  {
    name = &(fsel->file[len-4]);
    if (strcmp(name, ".APP")==0) fsel->ext = gem;
    if (strcmp(name, ".PRG")==0) fsel->ext = gem;
    if (strcmp(name, ".TOS")==0) fsel->ext = tos;
    if (strcmp(name, ".TTP")==0) fsel->ext = par;
  }

  /* Und noch der Dateityp */
  handle = Fopen(fsel->both, 0);
  if (handle >= 0)
  {
    if (Fread(handle, (long)sizeof(HEADER), &(fsel->hdr)) == sizeof(HEADER))
      if (fsel->hdr.c_magic == C_MAGIC)
        fsel->type = exec;
      else
        fsel->type = notexec;
    else
      fsel->type = notexec;
    Fclose(handle);
  }
  else
    fsel->type = new;
}


void init_files(void)
/*******************/
{
  int drive = bootdev();	/* Bootlaufwerk */

  strcpy(guck[0].file, "GUCK.TTP");
  guck[0].path[0] = Dgetdrv()+'A';
  guck[0].path[1] = ':';
  Dgetpath(&(guck[0].path[2]), 0);
  strcat(guck[0].path, "\\*.*");
  strcpy(guck[0].title, "SUCHE GUCK");
  calc_fsel(&guck[0]);

  strcpy(guck[1].file, guck[0].file);
  strcpy(guck[1].path, "A:\\*.*");
  guck[1].path[0] += drive;
  strcpy(guck[1].title, "KOPIERE GUCK");
  calc_fsel(&guck[1]);
  locguck = 0;

  infofile.path[0] = 'A' + drive;
  strcpy(&infofile.path[1], ":\\*.INF");
  if (_GemParBlk.global[0] < 0x300)
    strcpy(infofile.file, "DESKTOP.INF");
  else
    strcpy(infofile.file, "NEWDESK.INF");
  strcpy(infofile.title, "SUCKE DESKTOP.INF");
  calc_fsel(&infofile);
}


void arrow(void)
/**************/
{
  if (!pfeil)
  {
    graf_mouse(ARROW, NULL);
    pfeil = TRUE;
  }
}


void busy(void)
/*************/
{
  if (pfeil)
  {
    graf_mouse(HOURGLASS, NULL);
    pfeil = FALSE;
  }
}


int do_dialog(const int index)
/****************************/
{
  OBJECT *baum;  /* Stack */
  OBJECT *rbaum; /* Register */
  int x, y, w, h;
  int button;

  mrsrc_gaddr(rsc_datei, R_TREE, index, &baum);
  rbaum = baum;
  form_center(rbaum, &x, &y, &w, &h);
  form_dial(FMD_START, x,y,w,h, x,y,w,h);
  objc_draw(rbaum, ROOT, MAX_DEPTH, x,y,w,h);
  button = form_do(rbaum, 0);
  form_dial(FMD_FINISH, x,y,w,h, x,y,w,h);
  button &= 0x7fff; /* Bit 15 (Doppelklickflag) ausmaskieren */
  rbaum[button].ob_state &= ~SELECTED;
  return button;
}


void copy_fsel(const FSEL *src, FSEL *dst)
/****************************************/
{
  *dst = *src; /* Structure Assignment */
}


int do_fsel(FSEL *par)
/********************/
{
  int button, ok;
  FSEL my_fsel;

  copy_fsel(par, &my_fsel);
  ok = fsel_exinput(my_fsel.path, my_fsel.file,
                    &button, my_fsel.title);
  if (button && ok)
  {
    copy_fsel(&my_fsel, par);
    calc_fsel(par);
    return TRUE;
  }
  return FALSE;
}


void file2file(char *path, char *ext, char *title, int len)
/*********************************************************/
{
  FSEL fsel;
  char *name, *backslashdst, *backslashsrc, *concat;
  char cont;

  strcpy(fsel.title, title);

  if (path[0] == '\0')
  {	/* Noch kein Name */
    fsel.path[0] = Dgetdrv()+'A';
    fsel.path[1] = ':';
    Dgetpath(&(fsel.path[2]), 0);
    strcat(fsel.path, "\\");
    strcat(fsel.path, ext);
  }
  else
  {
    name   = backslashsrc = path;
    concat = backslashdst = fsel.path;

    /* Kopiere ganzen Pfad und merke jede Backslash-Position */
    do{
      if ((cont = *concat++ = *name++) == '\\')
      {
        backslashdst = concat;
        backslashsrc = name;
      }
    }while (cont);
    /* backslash zeigt jetzt eins nach den letzten Backslash */

    strcpy(fsel.file, backslashsrc);	/* Hole Dateinamen */
    strcpy(backslashdst, ext);		/* Mache Pfad */
  }

  if (do_fsel(&fsel))			/* Geglückt? */
  {
    if (strlen(fsel.both) > len)
      form_alert(1, "[1][|Pfad zu lang!][Abbruch]");
    else
      strncpy(path, fsel.both, len);	/* Kopieren und ausnullen */
  }
}


long bload(const char *name, void *adr, const long maxsize)
/*********************************************************/
{
  int handle;
  long aktsize;

  handle = Fopen(name, 0);
  if (handle < 0)
    return -1L;
  aktsize = Fread(handle, maxsize, adr);
  Fclose(handle);
  return aktsize;
}


long bsave(const char *name, const void *adr, const long maxsize)
/***************************************************************/
{
  int handle;
  long aktsize;

  handle = Fcreate(name, 0);
  if (handle < 0)
    return -1L;
  aktsize = Fwrite(handle, maxsize, adr);
  Fclose(handle);
  return aktsize;
}


int show_err(const char *s1, const char *s2, const char *s3)
/**********************************************************/
{
  char s[200];

  strcpy(s, s1);
  strcat(s, s2);
  strcat(s, s3);
  arrow();
  return form_alert(1, s);
}


int get_exec(FSEL *fs)
/********************/
{
  int button = 1;

  while (button != 2 && (fs->type != exec || fs->ext == dat))
  {
    button = show_err("[1][|", fs->file, "|ist nicht ausführbar! ][ Wählen |Abbruch]");
    if (button == 2)
      return FALSE; /* Abbruch */
    else
    {
      if (!do_fsel(fs))
        return FALSE; /* Abbruch */
    }
  }
  return TRUE; /* Datei gültig! (Endlich!) */
}


void err_notexec(const char *fn)
/******************************/
{
  show_err("[1][|", fn, "|ist nicht ausführbar! ][Abbruch]");
}


void err_read(const char *fn)
/***************************/
{
  show_err("[1][|Kann ", fn, "|nicht lesen!|(Existiert sie nicht?) ][Abbruch]");
}


void err_write(const char *fn)
/****************************/
{
  show_err("[1][|Kann ", fn, "|nicht schreiben!|(Disk voll/schreibgeschützt?) ][Abbruch]");
}


void err_size(const char *fn)
/***************************/
{
  show_err("[1][|", fn, " ist zu gross! ][Abbruch]");
}


void err_filsiz(const char *fn)
/*****************************/
{
  show_err("[1][|", fn, "|hat sich verändert! ][Abbruch]");
}


void err_badmagic(void)
/*********************/
{
  arrow();
  form_alert(1, "[1][|Diese Funktion läuft nur|mit einem Original-AusGUCK! ][Abbruch]");
}


void err_internal(void)
/*********************/
{
  arrow();
  form_alert(1, "[1][|Falsches Format von |DESKTOP.INF!!][Abbruch]");
}


void scratchbuf(char *bot, char *top, const int addspc)
/*****************************************************/
{
  if (addspc > 0)
  {
    while (top > bot)
    {
      top--;
      top[addspc] = *top;
    }
  }
  else
    if (addspc < 0)
    {
      bot -= addspc;
      while (bot < top)
      {
        bot[addspc] = *bot;
        bot++;
      }
    }
}


void replace(const char *src, char *dst)
/**************************************/
{
  while (*src) /* Nullbyte darf nicht angehängt werden! */
    *dst++ = *src++;
}


char *seeklf(char *ptr)
/*********************/
{
  while (*ptr != '\n' && *ptr != '\0' && *ptr != CTRLZ)
    ptr++;

  if (*ptr == '\n')
    return ptr + 1;
  return NULL;
}


int change_guck(char *dti) /* DeskTop.Inf */
/************************/
{
  int size, len;
  int ols; /* old line size */
  char *gp; /* Guck Pointer */
  char *work = dti;
  char linebuf[100];

  while (*work != CTRLZ && *work != '\0')
    work++;
  *work++ = CTRLZ;
  *work++ = '\0';
  size = (int) (work - dti);

  work = dti;
  gp = NULL;
  do{
    if (work[0] == '#'
        && (work[1] == 'P' || work[1] == 'F' || work[1] == 'G'))
      gp = work;
    work = seeklf(work);
  }while(!gp && work);

  if (!gp)
    return 0;
  ols = (int) (work - gp);
  strcpy(linebuf, "#F 03 04   ");
  if (guck[locguck].ext == gem)
    linebuf[1] = 'G';
  if (guck[locguck].ext == par)
    linebuf[1] = 'P';
  strcat(linebuf, guck[locguck].both);
  strcat(linebuf, "@ *.*@ \r\n");		/* CR/LF */
  len = (int) strlen(linebuf);
  scratchbuf(gp, dti + size, len - ols);
  size += len - ols;
  replace(linebuf, gp);
  return size;
}


void about(void)
/**************/
{
  int button;

  button = do_dialog(ABOUTDIA);
  switch (button)
  {
    case AAUTOR:  do_dialog(AUTOR);
                  autor = TRUE;
                  break;
    case ACREDITS:do_dialog(CREDITS);
                  break;
    case AHILFE:  do_dialog(HILFE);
                  do_dialog(HILFE2);
                  break;
  }
}


void suche(FSEL *in, int *loc)
/****************************/
{
  FSEL bak;

  copy_fsel(in, &bak);
  if (do_fsel(in))
  {
    if (in->type != exec || in->ext == dat)
    {
      err_notexec(in->file);
      copy_fsel(&bak, in); /* Alte Werte wiederherstellen */
    }
    else
      *loc = 0;
  }
}


int set_pathes(void)
/******************/
{
  GUCK    *magicptr;
  HEADER  *hdr;
  char    version[40];
  int     i, j, button;
  OBJECT  *tree;

  if (strncmp(guckmem + sizeof(HEADER) + 2, "$header: GUCK, ", 15) != 0)
    form_alert(1, "[1][|Dies ist kein GUCK!][Abbruch]");
  else
  {
    /* Kopiere Versionsnummer */
    for (i = (int) sizeof(HEADER) + 2 + 15, j = 0;
         i < (int) sizeof(HEADER) + 2 + 15 + 5 && guckmem[i] != ','; i++, j++)
      version[j] = guckmem[i];
    strcpy(version + j, " vom");
    j += 4;
    /* Datum anhängen */
    strncpy(version + j, guckmem + i + 1, 11);
    version[j + 11] = '\0';

    hdr = (HEADER *) guckmem;
    magicptr = (GUCK *) (guckmem + sizeof(HEADER) + hdr->c_text);
    if (magicptr->mname == G_MAGIC)
    {	/* Ok, das richtige erwischt! */
      mrsrc_gaddr(rsc_datei, R_TREE, PFADE, &tree);
      tree[PVERSION].ob_spec.free_string = version;
      tree[PTEXT].ob_spec.tedinfo->te_ptext = magicptr->textpath;
      tree[PGRAF].ob_spec.tedinfo->te_ptext = magicptr->grafpath;
      tree[PCFG].ob_spec.tedinfo->te_ptext = magicptr->cfgpath;
      arrow();
      do{
        button = do_dialog(PFADE);
        switch (button)
        {
        case PTEXT: file2file(magicptr->textpath, "*.PRG", "SUCHE TEXTEDITOR", 31);
                    break;
        case PGRAF: file2file(magicptr->grafpath, "*.PRG", "SUCHE GRAFIKEDITOR", 31);
                    break;
        case PCFG:  file2file(magicptr->cfgpath, "*.CFG", "SUCHE DRUCKERTREIBER", 31);
                    break;
        }
      }while (button != POK && button != PCANCEL);
      if (button == POK)
        return 1;		/* Neues GUCK sichern */
    }
    else
      if (magicptr->mname > G_MAGIC && magicptr->mname <= G_MAGIC2)
        form_alert(1, "[1][|Für dieses GUCK brauchen Sie|ein neueres INSTGUCK!][Abbruch]");
      else
        show_err("[1][|Dieses GUCK|(", version, ")|kennt noch keine Pfade!][Abbruch]");
  }
  return 0;
}


void kopiere(FSEL *in, FSEL *out, int *loc, void (*func)(int))
/************************************************************/
{
  long size;

  if (!get_exec(in))
    return;
  out = in;
  busy();
  size = bload(in->both, guckmem, (long) MGS);
  if (size <= 0)
  {
    err_read(in->file);
    return;
  }
  if (size >= MGS)
  {
    err_size(in->file);
    return;
  }
  if (set_pathes())
  {
    if (bsave(out->both, guckmem, size) != size)
    {
      err_write(out->file);
      return;
    }
    arrow();
    out->type = exec; /* Jetzt ausführbar (sonst nicht kopiert)!! */
    out->ext  = in->ext;
    out->hdr  = in->hdr;
    *loc = 1;
    if (func != NULL)
      (*func)(-1);
  }
}


void speicher(void)
/*****************/
{
  int size;

  if (!get_exec(&guck[locguck]))
    return;
  busy();
  shel_get(guckmem, MGS);
  size = change_guck(guckmem);
  if (size)
  {
    shel_put(guckmem, size);
    arrow();
    form_alert(1, "[0][|GUCK im Speicher  |  installiert!][   OK   ]");
  }
  else
    err_internal();
}


void disk(void)
/*************/
{
  int size;
  int ok;

  if (!get_exec(&guck[locguck]))
    return;
  busy();
  size = (int) bload(infofile.both, guckmem, (long) MGS);
  if (size > 0 && size < MGS)
  {
    guckmem[size]='\0'; /* Damit Datei auch wirklich ein Ende hat */
    size = change_guck(guckmem);
    if (size)
    {
      size--; /* Das Nullbyte brauchen wir in der Datei nicht! */
      ok = (bsave(infofile.both, guckmem, (long) size) == size);
      arrow();
      if (ok)
        show_err("[0][|GUCK in ", infofile.file, "  |    installiert!][   OK   ]");
      else
        err_write(infofile.both);
    }
    else
      err_internal();
  }
  else
    err_read(infofile.both);
}


void entferne(void)
/*****************/
{
  int size;
  int ok;
  int button;
  FSEL bak;

  button = show_err("[2][|Wollen Sie GUCK wirklich aus|", infofile.file,
                    " und dem Speicher|entfernen?][OK|Abbruch]");
  if (button == 2)
    return;

  copy_fsel(&guck[locguck], &bak);
  guck[locguck].both[0] = '\0'; /* Kein Name */
  guck[locguck].ext = tos;

  /* Speicher */
  shel_get(guckmem, MGS);
  size = change_guck(guckmem);
  if (size)
  {
    shel_put(guckmem, size);
    form_alert(1, "[0][|GUCK aus dem Speicher  |       entfernt!][   OK   ]");
  }
  else
    err_internal();

  /* Disk */
  busy();
  if (bload(infofile.both, guckmem, (long) MGS) >= 0)
  {
    size = change_guck(guckmem);
    if (size)
    {
      size--; /* Das Nullbyte brauchen wir in der Datei nicht! */
      ok = (bsave(infofile.both, guckmem, (long) size) == size);
      arrow();
      if (ok)
        show_err("[0][|GUCK aus ", infofile.file,
                 "  |      entfernt!][   OK   ]");
      else
        err_write(infofile.both);
    }
    else
      err_internal();
  }
  else
    err_read(infofile.both);

  copy_fsel(&bak, &guck[locguck]);
}


void wellcopied()
/***************/
{ /* Die Funktionsparameter werden beim Aufruf definiert... */
  form_alert(1, "[0][|So, das war's!   |][   OK   ]");
}


void do_it(void)
/**************/
{
  OBJECT *menu;
  char *myname;
  int msg[8];
  int ende = FALSE;
  int what;
  int dummy, key;
  int mnidx = 0;
  long lasttime;

  mrsrc_gaddr(rsc_datei, R_TREE, AUTOR, &menu); /* Bloss Zwischenspeicher... */
  myname = menu[MYNAME].ob_spec.free_string;
  mrsrc_gaddr(rsc_datei, R_TREE, MENU, &menu);
  menu_bar(menu, TRUE);
  key_init(gl_apid, TRUE);
  while (!ende)
  {
    lasttime = timer();
    what = evnt_multi(MU_KEYBD | MU_MESAG | MU_TIMER,
                      0, 0, 0,
                      0, 0, 0, 0, 0,
                      0, 0, 0, 0, 0,
                      msg,
                      20000, 0, /* 20 s */
                      &dummy, &dummy, &dummy, &dummy, &key, &dummy);

    wind_update(BEG_UPDATE);

    if ((what & MU_MESAG) && (msg[0] == MN_SELECTED))
    {
      switch (msg[4])
      {
        case ABOUT:   about();
                      break;
        case SUCHE:   suche(&guck[0], &locguck);
                      break;
        case KOPIERE: kopiere(&guck[0], &guck[1], &locguck,
                              wellcopied);
                      break;
        case SUCHED:  do_fsel(&infofile);
                      break;
        case ENDE:    ende = TRUE;
                      break;
        case SPEICHER:speicher();
                      break;
        case SUD:     speicher(); /* Achtung, fällt durch!! */
        case DISK:    disk();
                      break;
        case ENTFERNE:entferne();
                      break;
      }
      if (!ende)
      {
        menu_tnormal(menu, msg[3], TRUE);
        arrow();
      }
    }

    if (what & MU_KEYBD)
    {
      key = key_code(menu, key);
      if (key > 0 && key < 256)
      {
        if (key == myname[mnidx])
        {
          mnidx++;
          if (myname[mnidx] == '\0')
          {
            do_dialog(AUTOR);
            autor = TRUE;
            mnidx = 0;
          }
        }
        else
          mnidx = 0;
      }
      else
        if (key == (HELP | KEY_SPECIAL))
        {
          do_dialog(HILFE);
          do_dialog(HILFE2);
        }
    }

    if ((what == MU_TIMER) && !autor && (timer()-lasttime > 15*200))
    { /* Eigener Test, ob mindestens 15 Sekunden vergangen sind */
      /* und darf nur kommen, falls dieser event alleine kommt. */
      do_dialog(AUTOR);
      autor = TRUE;
    }

    wind_update(END_UPDATE);
  } /* while (!ende) */
  menu_bar(menu, FALSE);
}


int main(void)
/************/
{
  int msg[8]; /* Dummy */
  int fontw, fonth, dummy;

  gl_apid = appl_init();
  if (_GemParBlk.global[0] == 0 || gl_apid < 0) /* Kein GEM? */
    return -99;
  else /* appl_init geglückt */
  {
    if (_app) /* Applikation? */
    {
      graf_handle(&fontw, &fonth, &dummy, &dummy);
      mrsrc_load(rsc_datei, fontw, fonth);
      init_files();
      arrow();
      do_it();
    }
    else /* Nein, Accessory! (Was soll das?) */
    {
      arrow();
      form_alert(1, "[3][|INSTGUCK ist|kein Accessory! ][Abbruch]");
      while (TRUE)
        evnt_mesag(msg); /* Dummy-Endlosschlaufe */
    }
    appl_exit();
  }
  return 0;
}


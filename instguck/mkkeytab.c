#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

int main(void)
{
  int i;
  FILE *f;
  char buf[4];

  if ((f = fopen("uppertab.c", "w")) != NULL)
  {
    for (i = 0; i < 256; i++)
    {
      if (i % 8 == 0)
        fprintf(f, "\n");
      if (i < 32)
        fprintf(f, " '\\0%s',", itoa(i, buf, 8));
      else
        fprintf(f, " '%c',", toupper(i));
    }
    fclose(f);
  }

  if ((f = fopen("lowertab.c", "w")) != NULL)
  {
    for (i = 0; i < 256; i++)
    {
      if (i % 8 == 0)
        fprintf(f, "\n");
      if (i < 32)
        fprintf(f, " '\\0%s',", itoa(i, buf, 8));
      else
        fprintf(f, " '%c',", tolower(i));
    }
    fclose(f);
  }

  return 0;
}

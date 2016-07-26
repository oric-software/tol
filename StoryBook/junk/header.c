#include <stdio.h>
#define RAM_ORIC 65536

#define VERSION "0.4"
#define LAST_CHANGES "13/04/2003"

main(int argc,char *argv[])
{
FILE *fic_objet;
FILE *fic_euphoric;
char car[RAM_ORIC];
int nb_octet=0;
int nb_lus;
int iadr;
int nbhexa=0;
char hexa[10];
char hexahaut[10];
char hexabas[10];
char adr[10];
char byte_autostart=7;
// Addrage 600 par d�faut

char header[]={0x16,0x16,0x16,0x24,0x00,0x00,0x80,0x00,0x06,0x00,0x06,0x00,0x00,0x00};
int i=0;
printf("Prototype : header fichiersrc destfichier [--quiet-autostart]/[--quiet]/[--date]/[--version]\n");
header[8]=0x05;
header[10]=0x05;
header[11]=0x0;
header[9]=0x0;
while (argc>i)
	{
	if (strcmp(argv[i],"--version")==0)
		{
		printf("Version %s\n",VERSION);
		return;
		}
	if (strcmp(argv[i],"--date")==0)
		{
		printf("%s\n",LAST_CHANGES);
		return;
		}
	if (strcmp(argv[i],"--quiet-autostart")==0)
		{
		header[byte_autostart]=0xc7;
		}
	i++;
	}


//if (argc<3) {printf("Error ! 2 parameters\nPrototype : header fichiersrc destfichier [--quiet-autostart]/[--quiet]/[--date]/[--version]\n");return;}
if (argc<3) {printf("Error ! 2 parameters\nPrototype : header fichiersrc destfichier\n");return;}

/*

if (strcmp(argv[3],"--quiet")!=0 && strcmp(argv[3],"--quiet-autostart")!=0)
	printf("Add a TAP Header for adress #600\nVersion %s\nJede 2001\njede@oric.org\n",VERSION);
*/
/*
if (strcmp(argv[3],"--quiet-autostart")==0)
	{
	header[byte_autostart]=0xc7;
	}
*/
header[byte_autostart]=0xc7;

// --quiet
/*
if  (argc==3)
if (strcmp(argv[2],"--quiet")!=0)
printf("Ajout de Header pour fichier .tap Oric Adresse #600\nVersion %s\nJede 2001\njede@ifrance.com\n",VERSION);
*/
iadr=atoi(adr);

//sprintf(hexa,"%x",iadr);
while (iadr>0x0f)
        {
        header[8]++;
        header[10]++;
        iadr=iadr-0x0f;
        }
        header[9]=iadr;
        header[11]=iadr;

        if (i!=-1)
        {

        fic_objet=fopen(argv[1],"rb");
	if (fic_objet==NULL) {printf("Can't open %s\n",argv[1]);exit(0);}
	i=0;

        while((nb_lus=fread(car,sizeof(char),RAM_ORIC,fic_objet))!=0) i=i+nb_lus;
        fclose(fic_objet);
        nb_octet=i;
        fic_euphoric=fopen(argv[2],"wb");
	if (fic_euphoric==NULL) {printf("Can't open %s\n",argv[2]);exit(0);}
        while (i>0xff)
	        {
        	i=i-0xff;
	        header[8]=header[8]+1;
        	}
        header[9]=i;
        fwrite(header,14,1,fic_euphoric);
        i=0;
        while (i!=nb_octet)
        	{
        	fputc(car[i],fic_euphoric);
        	i++;
       		}
        }
 }

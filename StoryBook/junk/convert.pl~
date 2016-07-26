#!/usr/bin/perl

#Convert by Jede May 2001

$file="LEMMINGS.prj";

open(SETUP,$file);
$nb_octets = read(SETUP, $buffer, 9999999);
#On remplace les ;       p ar rien
$buffer=~s/;/""/ge;
#On remplace les :      p ar rien
$buffer=~s/:/""/ge;
#On remplace les :      p ar rien
$buffer=~s/'/";"/ge;
$buffer=~s/~END/""/ge;
@tab=split("\n",$buffer);
foreach $i (@tab)
        {
	#c'est ces tables
        if ($i =~/[^\[$\]]/)
                {
                $i=~s/\[/""/ge;
                $i=~s/\]/""/ge;
                #on gère les [#00*$06]
                if   ($i =~/^#/)
                       {
                       $i=~s/#/""/ge;
                       $i=~s/\$/""/ge;
                      @dsb=split('\*',$i);
                      $i= ".dsb ".@dsb[1].",".@dsb[0]."\n";
                      #print $i."\n";
                      }
                else
                        {
                        if   ($i =~/^L/ || $i =~/^H/ )
                                {
                                print $i."\n";
                                #print "\n";
                                }
                        else
                                {
                                if   ($i =~/\"/ )
                                        {
	                        @chaine=split("\"",$i);
	                        $i=".asc \"".@chaine[1]."\"\n";
	                        }

	                else
                                        {
	                        $ch=".byt ";
                                        for ($t=0;$t<length($i);$t+=2)
                                                {
                                                if ($t ne length($i)-2 )
                                                        {
                                                        $ch.="\$".substr($i,$t,2).",";
                                                        }
                                                else
                                                        {
                                                        $ch.="\$".substr($i,$t,2)."\n";
                                                        }
                                                }
                                $i=$ch;
                              #  print $i."\n";
				}
	                }
                        }

                }
#Fin de for
$i=~s/\&/""/ge;
$i=~s/\#/"#\$"/ge;

$i=~s/\$\$/""/ge;
$i=~s/\#\$\%/"#%"/ge;



if   ($i =~/.byt/ || $i =~/.dsb/ || $i =~/.asc/ )
{
#Bidon
$x=0;
}
else
	{
	@dsb=split(" ",$i);
	if   (@dsb[1] =~/^[0-9]/ )
        	{
	        $i=@dsb[0]." \$".@dsb[1];
        	}

	if   (@dsb[2] =~/^[0-9]/ )
        	{
	        $i=@dsb[0]." ".@dsb[1]." \$".@dsb[2];
        	}



if   (@dsb[1] =~/^\([0-9]/ )
        {
        @dsb[1]=~s/\(/""/ge;
        $i=@dsb[0]." (\$".@dsb[1];
        }





if   (@dsb[2] =~/^\([0-9]/ )
        {
        @dsb[2]=~s/\(/""/ge;
        $i=@dsb[0]." ".@dsb[1]." (\$".@dsb[2];
        }

if   (@dsb[1] =~/(^[0-F][0-F][0-F][0-F])/ )
        {
        $i=@dsb[0]." \$".@dsb[1];
        }

#if   (@dsb[1] =~/(^([0-F][0-F]))/ )
#        {
#        $i=@dsb[0]." \$".@dsb[1];
#        }


if   (@dsb[2] =~/^[0-F][0-F][0-F][0-F]/ )
        {
        $i=@dsb[0]." ".@dsb[1]." \$".@dsb[2];
        }


  }


print $i."\n";
}

close(SETUP);

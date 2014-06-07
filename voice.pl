#! /usr/bin/perl -w
#reads lines from unicode.txt
#
use strict;
#system "sfplay sentence.wav";

sub main{

	my (@letterArray, @wordArray); 
	my ($line,$word,$letter);
	my ($cmdSentenceCat,$cmdWordCat,$cmdPlay); 
	my $question=0;
# while dealing with any word if wh_word=1 then target expression for that word is question type. 
        my $wh_word=0;
     my $wh_letter_present;
	 my $wh_present=0;
	 my $exclamation=0;
	 my $ex_word=0;
	open (FD,"uni.txt"); 
	open (FD1,">>uni1.txt");
	#$cmdPlay="sfplay sentence.wav  "; 
		$cmdSentenceCat="";
	while(<FD>){
		chomp;
                    $wh_letter_present=0;
		  $cmdSentenceCat="";
	        #print "\nNEW LINE\n";	
                   
		$line=$_; 
		if(index($line,"?")!=-1)
		{
		       $question=1;
		       print "\nQUESTION HO\n";	
		      
		       
		}
		elsif(index($line,"!")!=-1)
		{
		       $exclamation=1;
		       print "\nexclamation HO\n";	
		      
		       
		}
		else
		{
		       	print "\nNOT QUESTION \n";
		}
		@wordArray=split(">",$line); #word array contains words
		if($question==1)
		{
			 pop(@wordArray); #remove question mark from the end; 
		}
		if($exclamation==1)
		{
			 pop(@wordArray); #remove exclamation mark from the end; 
		}
		my $wordArraySize= scalar @wordArray;
		#print "\n\n\n\n\nBIKRAM $wordArraySize of this array: @wordArray \n\n\n\n\n\n\n";
                 my $wordIndex=0;

 		
	  #travarsing vi each word of sentence
 		 foreach $word (@wordArray){
		       $wordIndex=$wordIndex+1;
			   $word=handel_chandra_bindu($word);
			   $word=handel_halanta($word,$wordArraySize,$wordIndex);
                        # print "\n\n TRANSFORMED WORD IS $word";
  			if($question==1)
				{ #print "\n testing if wh letter present for $word";
                                         #   getc();
			            if(presentWH($word))
                                         {  #print "\n WH WORD";
                                            $wh_word=1;
											$wh_present=1;
											$word=change_to_question($word);
											#print "\n\n CHANGED AS $word";
                                          }
                                     elsif(($wordIndex>=$wordArraySize)&&($wh_present!=1)) #check if last word
                                          {
						#print "\n ###### this  is last word and word is $word";
                                            $wh_word=1;
                                           }
								else
								{
								$wh_word=0;
								}
                                
				}#end of if
				elsif($exclamation==1)
				{
				  if(($wordIndex>=$wordArraySize)) #check if last word
                                          {
						#print "\n ###### this  is last word and word is $word";
                                            $ex_word=1;
                                           }
					 else
								{
								$ex_word=0;
								}
				}
		     else
			 {
			 $wh_word=0; $ex_word=0;
			 }
			#print "\n splitting word $word and wh_word is $wh_word\n";
                   	@letterArray=letterFromWord($word); #letter array contains letter
                         my $letterCount=0;
                         my $arraySize=@letterArray;  
						 $cmdWordCat="";                      
			foreach $letter (@letterArray){  	
			                  $letterCount++;
							  #print "\nchecking $letter array size=$arraySize lettercnt=$letterCount wh=$wh_word";
                              if($wh_word==1)
                               {   
                                     
                                     if(($arraySize<=$letterCount)&&($wh_present!=1))#check id last letter of word
                                      { 
                                       $cmdWordCat=" ".$cmdWordCat." speechdb/question/".$letter.".wav ";
                                      # print "\n $cmdWordCat";
									   }
									    else #if this is  wh word but not wh letter or last letter
                                      {
				$cmdWordCat=" ".$cmdWordCat." speechdb/".$letter.".wav ";
                                       }#end of else
                                }#end of if
							elsif($ex_word==1)
                               {  
							      if(($arraySize<=$letterCount))#check id last letter of word
                                      { 
                                       $cmdWordCat=" ".$cmdWordCat." speechdb/exclamation/".$letter.".wav ";
                                       #print "\n $cmdWordCat";
									   } 
							   }	
                               else #if this is not wh word
                                      {
				$cmdWordCat=" ".$cmdWordCat." speechdb/".$letter.".wav ";
                                       }#end of else
			       
			}#end of for each of letter level
			    if(($wh_word==1)&&($wh_present==1))
				 {
				 $cmdWordCat=convert_to_question($cmdWordCat);
				 }
			#print "\n Finally we got the word: $cmdWordCat "; 
			$cmdSentenceCat=$cmdSentenceCat . $cmdWordCat."speechdb/space.wav ";
			#print "\n out put word is output$wordIndex.wav ";
			#system $cmdWordCat;
			#system $cmdPlay;
			#system "rm output.wav";	
			#$cmdSentenceCat=" ".$cmdSentenceCat." output$wordIndex.wav"; 
			#sleep 1;
	#print "\n cmdSentenceCat";
		}# a word ends ie outer word  level for each; 
		
		#print "\nFINALLY SENTENCE IS : $cmdSentenceCat";
		print FD1 $cmdSentenceCat;
		#system "sfcat -o output1.wav $cmdSentenceCat ";
            system "sfprograms\\sfplay -c  $cmdSentenceCat ";

		
	}# sentence ends ie end of taking sentence ie while

	#play the sentence;
	#
	#print "\nFinal sentence cmdSentenceCat";
	#system  $cmdSentenceCat;
	#system $cmdPlay; 
}#main ends
main();

sub letterFromWord {
	chomp;
 my @word=split(' ',$_[0]);
 my $alphaIndex;
 my $letterIndex=0; 
 my @letter; 
 
# @word=(2360,2350,2381,2346,2344,2381,2344,2340,2366);
 
 for($alphaIndex=0;$alphaIndex<@word;$alphaIndex++)
 {
	
	 
    
     if(isConsonant($word[$alphaIndex]) && isSign($word[$alphaIndex+1])){
		$letter[$letterIndex]=$word[$alphaIndex].$word[$alphaIndex+1]; 
		$alphaIndex++; 
		$letterIndex++;
	#print "6";
	}
		elsif(isVowel($word[$alphaIndex]) && isSign($word[$alphaIndex+1])){
		$letter[$letterIndex]=$word[$alphaIndex].$word[$alphaIndex+1]; 
		$alphaIndex++; 
		$letterIndex++;
	#print " 7 ";
	}
	elsif(isVowel($word[$alphaIndex])){
		$letter[$letterIndex]=$word[$alphaIndex]; 
		$letterIndex++;
		#print "1";
	        	
	}
	elsif(isConsonant($word[$alphaIndex]) && isConsonant($word[$alphaIndex+1])){
		$letter[$letterIndex]=$word[$alphaIndex]; 
		$letterIndex++;
		#print "2"; 
	 
	}
	elsif(isConsonant($word[$alphaIndex]) && isVowel($word[$alphaIndex+1])){
		$letter[$letterIndex]=$word[$alphaIndex]; 
		$letterIndex++; 
	#print "3";
	}
	elsif(isConsonant($word[$alphaIndex]) && isMatra($word[$alphaIndex+1])){
		$letter[$letterIndex]=$word[$alphaIndex].$word[$alphaIndex+1];
		$alphaIndex++;
		$letterIndex++; 
	#print "4";
	}
	elsif(isConsonant($word[$alphaIndex]) && isHalant($word[$alphaIndex+1])){
		$letter[$letterIndex]=$word[$alphaIndex].$word[$alphaIndex+1]; 
		$alphaIndex++; 
		$letterIndex++;
#print "5";
	}
	
	else{
		#print "\nWARNING: Unahandled condition in word @word (&#$word[$alphaIndex-1];)(&#$word[$alphaIndex];)(&#$word[$alphaIndex+1];)\n"; 
		$letter[$letterIndex]=$word[$alphaIndex]; 
		$letterIndex++; 
	#print "8 ";
	}
 }

 return @letter; 
}



sub isMatra {
	#print("\n Test for Vowel Marker for $_[0]\n"); 
	my  $unicode=$_[0] ;
	#$unicode as int; 
	if(($unicode>=2366)&&( $unicode<=2380))	{
		return 1; 	
	}

	else{
		return 0; 
	}
}

sub isHalant {
	 #print("\n Test for Halant for $_[0]\n"); 
	my $unicode=$_[0];
	 #$unicode as int; 
	if($unicode == 2381){ return 1; }
}


sub isConsonant {
	 #print("\n Test for Consonant for $_[0]\n"); 
	my $unicode=$_[0]; 
	#$unicode as int; 
	if($unicode >= 2325 && $unicode <= 2361){
		return 1; 
	}

	else{ letter present
		return 0;
	}
}


sub isSign { #eg chandra bindu
	 #print("\n Test for Sign for $_[0]\n"); 
	my $unicode=$_[0]; 
	#$unicode as int; 
	if($unicode >= 2305 && $unicode <= 2307){
		return 1; 
	}

	else{ letter present
		return 0;
	}
}
sub isVowel {
	 #print("\n Test for Vowel for $_[0]\n"); 
	my $unicode = 0;
	$unicode = $_[0];
	
	#$unicode as int; 
	if($unicode >= 2309 && $unicode <= 2324 )	{
		return 1; 
	}
	else	{
		return 0; 
	}
}

sub isWH #takes a letter (a string) and finds if it is wh

{
	my @wh_words;
	@wh_words={"23252379","ka"};
 my	$letter=$_[0];
my	$pos=0;
my $scalar;
foreach $scalar(@wh_words)
  {
   if($letter eq $scalar)
        {
           return 1;
        }
   }
return 0;
}


 sub presentWH  #takes a word and finds if it is wh word

 {
my @wh_words;
   my $data= "2325 2361 2381 2310 2305>2325 2375>2325 2379>2325 2340 2366>2325 2360 2381>2325 2360 2352 2368";
 @wh_words=split('>',$data); #note this must be consistent with that present in sub change_to_question
 
 my @bebhakti;
   my $data2= ">> 2354 2366 2312> 2325 2344> 2342 2375 2326 2368> 2342 2375 2326 2367> 2348 2366 2335>2338 2381 2357 2366 2352 2366> 2354 2366 2327 2368>2354 2366 2327 2367> 2344 2367 2350 2381 2340 2367 
";
 @bebhakti=split('>',$data2);

 my	$word=$_[0]; #eg ko lai
#print "   testing recived $word";
my	$pos=0;
my $scalar;

foreach $scalar(@wh_words)
  {  my $scalar1;
     #print "   testing with $scalar";
    foreach $scalar1(@bebhakti)
	{ my $tmp;
	   $tmp=$scalar."".$scalar1;  #print "\n\n TESTING FOR [$tmp] and [$word]";
	if($word eq $tmp)
	{
		        #print "found which";
			        return 1;
        }
   }#end of inner for each
   
   }#end of outer for each
#print "  returned 0";
return 0;


}

sub change_to_question
{
my @wh_words;
   my $data= "2325 2361 2381 2310 2305>2325 2375>2325 2379>2325 2340 2366>2325 2360 2381>2325 2360 2352 2368";
 @wh_words=split('>',$data); #note this must be consistent with that present in sub WHpresent
 
 my %nep;
 $nep{"2325 2375"}="kea";#"kea";
  $nep{"2325 2379"}="ko";#"ko";
    $nep{"2325 2340 2366"}="kata";#"kata";
	$nep{"2325 2360 2381"}="kass";#"kata";
	$nep{"2325 2360 2352 2368"}="kasari";#"kasari";
	$nep{"2325 2361 2381 2310 2305"}="kaha";#"kasari";
 
 my @bebhakti;
   my $data2= ">> 2354 2366 2312> 2325 2344> 2342 2375 2326 2368> 2342 2375 2326 2367> 2348 2366 2335> 2338 2381 2357 2366 2352 2366> 2354 2366 2327 2368> 2354 2366 2327 2367> 2344 2367 2350 2381 2340 2367 
";
 @bebhakti=split('>',$data2);

 my	$word=$_[0]; #eg ko lai
#print "   testing recived $word";
my	$pos=0;
my $scalar;

foreach $scalar(@wh_words)
  {  my $scalar1;
     #print "   testing with $scalar";
    foreach $scalar1(@bebhakti)
	{ my $tmp;
	   $tmp=$scalar."".$scalar1;
	if($word eq $tmp)
	{
		        my @splited;
				@splited=split($scalar,$word);
				$tmp=$nep{$scalar}."".$splited[1];
				#print "\n\n RETURNED AS $splited[1]";
			        return $tmp;
        }
   }#end of inner for each
   
   }#end of outer for each
#print "  returned 0";
return $word;

}


sub presentBebhakti# takes a word (string and finds if bhibhakti id present
{
#print "bhibkakti present ";
my $word=$_[0];
my @bhibhakti_list={"2354 2366 2312","2325 2378"};#(lago ko}
my $scalar;
foreach $scalar(@bhibhakti_list)
  {
   if(index($word,$scalar)>-1)
        {
           return 1;
        }
   }
return 0;

}

sub convert_to_question
{
return $_[0];
my @wh_words;
   my $data= "speechdb/23252375.wav>speechdb/23252379.wav>speechdb/2325.wav 23402366.wav";
 @wh_words=split('>',$data);
 
 my @bebhakti;
   my $data2= "speechdb/23542366.wav speechdb/2312.wav>speechdb/2325 2344.wav>2342 2375 2326 2368.wav>2342 2375 2326 2367.wav>2348 2366 2335>2338 2381 2357 2366 2352 2366.wav>2354 2366 2327 2368.wav>2354 2366 2327 2367.wav>2344 2367 2350 2381 2340 2367.wav 
";
 @bebhakti=split('>',$data2);

 my	$word=$_[0]; #eg ko lai
#print "   testing recived $word";
my	$pos=0;
my $scalar;

foreach $scalar(@wh_words)
  {  my $scalar1;
     #print "   testing with $scalar";
    foreach $scalar1(@bebhakti)
	{ my $tmp;
	   $tmp=$scalar." ".$scalar1;
	if($word eq $tmp)
	{
		        #print "found which";
			        return 1;
        }
   }#end of inner for each
   
   }#end of outer for each
print "  returned 0";
return 0;
}

sub handel_chandra_bindu
{
my $word=$_[0];
#print "\n TESTIING $word";
if($word=~m/2366 2305/i)
{ #handling kaha
	       # print "\nfound and";
		      my @tmp=split("2366 2305",$word);
                        $word=$tmp[0]."2381 2310 2305".$tmp[1];
                       return $word; 
				#return "x+halanta+yea+chandrabindu";
		}
elsif($word=~m/2367 2305/i)
{
	      #  print "\nfound and";
		      my @tmp=split("2367 2305",$word);
                        $word=$tmp[0]."2381 2311 2305".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
		elsif($word=~m/2368 2305/i)
{
	       # print "\nfound and";
		      my @tmp=split("2368 2305",$word);
                        $word=$tmp[0]."2381 2312 2305".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
		elsif($word=~m/2369 2305/i)
{
	     #   print "\nfound and";
		      my @tmp=split("2369 2305",$word);
                        $word=$tmp[0]."2381 2313 2305".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
elsif($word=~m/2370 2305/i)
{
	       # print "\nfound and";
		      my @tmp=split("2370 2305",$word);
                        $word=$tmp[0]."2381 2314 2305".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
		elsif($word=~m/2375 2305/i)
{
	        #print "\nfound and";
		      my @tmp=split("2375 2305",$word);
                        $word=$tmp[0]."2381 2319 2305".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
		elsif($word=~m/2376 2305/i)
{
	       # print "\nfound and";
		      my @tmp=split("2376 2305",$word);
                        $word=$tmp[0]."2381 2320 2305".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
		elsif($word=~m/2379 2305/i)
{
	        
		      my @tmp=split("2379 2305",$word);
                        $word=$tmp[0]."2381 2323 2305".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
elsif($word=~m/2380 2305/i)
{
	      
		      my @tmp=split("2380 2305",$word);
                        $word=$tmp[0]."2381 2324 2305".$tmp[1];
                       return $word; 
				#return "x+halanta+aii+chandrabindu";
		}
	
		
if($word=~m/2366 2306/i)
{ #handling kaha
	        
		      my @tmp=split("2366 2306",$word);
                        $word=$tmp[0]."2381 2310 2306".$tmp[1];
						
                       return $word; 
				#return "x+halanta+yea+chandrabindu";
		}
elsif($word=~m/2367 2306/i)
{
	        #print "\nfound and";
		      my @tmp=split("2367 2306",$word);
                        $word=$tmp[0]."2381 2311 2306".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
		elsif($word=~m/2368 2306/i)
{
	        #print "\nfound and";
		      my @tmp=split("2368 2306",$word);
                        $word=$tmp[0]."2381 2312 2306".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
		elsif($word=~m/2369 2306/i)
{
	        #print "\nfound and";
		      my @tmp=split("2369 2306",$word);
                        $word=$tmp[0]."2381 2313 2306".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
elsif($word=~m/2370 2306/i)
{
	        #print "\nfound and";
		      my @tmp=split("2370 2306",$word);
                        $word=$tmp[0]."2381 2314 2306".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
		elsif($word=~m/2375 2306/i)
{
	        #print "\nfound and";
		      my @tmp=split("2375 2306",$word);
                        $word=$tmp[0]."2381 2319 2306".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
		elsif($word=~m/2376 2306/i)
{
	        #print "\nfound and";
		      my @tmp=split("2376 2306",$word);
                        $word=$tmp[0]."2381 2320 2306".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
		elsif($word=~m/2379 2306/i)
{
	        #print "\nfound and";
		      my @tmp=split("2379 2306",$word);
                        $word=$tmp[0]."2381 2323 2306".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
elsif($word=~m/2380 2306/i)
{
	        #print "\nfound and";
		      my @tmp=split("2380 2306",$word);
                        $word=$tmp[0]."2381 2324 2306".$tmp[1];
                       return $word; 
				#return "x+halanta+aii+chandrabindu";
		}
		
#=================== handling upasarga ie : (2307)============================

if($word=~m/2366 2307/i)
{ #handling kaha
	        #print "\nfound and";
		      my @tmp=split("2366 2307",$word);
                        $word=$tmp[0]."2381 2310 2307".$tmp[1];
                       return $word; 
				#return "x+halanta+yea+chandrabindu";
		}
elsif($word=~m/2367 2307/i)
{
	        #print "\nfound and";
		      my @tmp=split("2367 2307",$word);
                        $word=$tmp[0]."2381 2311 2307".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
		elsif($word=~m/2368 2307/i)
{
	        #print "\nfound and";
		      my @tmp=split("2368 2307",$word);
                        $word=$tmp[0]."2381 2312 2307".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
		elsif($word=~m/2369 2307/i)
{
	        #print "\nfound and";
		      my @tmp=split("2369 2307",$word);
                        $word=$tmp[0]."2381 2313 2307".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
elsif($word=~m/2370 2307/i)
{
	        #print "\nfound and";
		      my @tmp=split("2370 2307",$word);
                        $word=$tmp[0]."2381 2314 2307".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
		elsif($word=~m/2375 2307/i)
{
	        #print "\nfound and";
		      my @tmp=split("2375 2307",$word);
                        $word=$tmp[0]."2381 2319 2307".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
		elsif($word=~m/2376 2307/i)
{
	        #print "\nfound and";
		      my @tmp=split("2376 2307",$word);
                        $word=$tmp[0]."2381 2320 2307".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
		elsif($word=~m/2379 2307/i)
{
	        #print "\nfound and";
		      my @tmp=split("2379 2307",$word);
                        $word=$tmp[0]."2381 2323 2307".$tmp[1];
                       return $word; 
				#return "x+halanta+wo+chandrabindu";
		}
elsif($word=~m/2380 2307/i)
{
	        #print "\nfound and";
		      my @tmp=split("2380 2307",$word);
                        $word=$tmp[0]."2381 2324 2307".$tmp[1];
                       return $word; 
				#return "x+halanta+aii+chandrabindu";
		}
		

#handling consonant , sign
my $i=0;
for($i=2325;$i<=2361;$i++)
{
my $tmp1;
$tmp1=$i." 2305";
if($word=~m/$tmp1/i)
{
	        #print "\nfound and";
		      my @tmp=split($tmp1,$word);
                        $word=$tmp[0]."".$i."2381 2309 2305".$tmp[1];
                       return $word; 
				#return "x+halanta+yea+chandrabindu";
		}

}

for($i=2325;$i<=2361;$i++)
{
my $tmp1;
$tmp1=$i." 2306";
if($word=~m/$tmp1/i)
{
	        #print "\nfound and";
		      my @tmp=split($tmp1,$word);
                        $word=$tmp[0]."".$i."2381 2309 2306".$tmp[1];
                       return $word; 
				#return "x+halanta+yea+chandrabindu";
		}

}


for($i=2325;$i<=2361;$i++)
{
my $tmp1;
$tmp1=$i." 2307";
if($word=~m/$tmp1/i)
{
	        #print "\nfound and";
		      my @tmp=split($tmp1,$word);
                        $word=$tmp[0]."".$i."2381 2309 2307".$tmp[1];
                       return $word; 
				#return "x+halanta+yea+chandrabindu";
		}

}

return $word;
}


sub handel_halanta
{
my @bebhakti;
   my $data2= " 2325 2379> 2354 2366 2312> 2325 2344> 2342 2375 2326 2368> 2342 2375 2326 2367> 2348 2366 2335> 2338 2381 2357 2366 2352 2366> 2354 2366 2327 2368> 2354 2366 2327 2367> 2344 2367 2350 2381 2340 2367 
";
 @bebhakti=split('>',$data2);
 
my $word=$_[0];
my $wordArraySize=$_[1];
 my $wordIndex=$_[2];
my $isLast=0;
if($wordArraySize==1)
{
#the word is verb so no halants
return $word;

}
elsif(is_verb($word))
{
 return $word;
}
else
{
my $scalar;
foreach $scalar(@bebhakti)
    {
	  if($word=~m/$scalar/i)
          {
	          #print "\n#############found and";
		      my @tmp=split($scalar,$word);
              my @letter=split(" ",$tmp[0]);
			  my $arraySize=@letter;
			  # #print "\n letter size is $letter[$arraySize-1] ";
			  # getc();
			  if($letter[$arraySize-1]==$letter[$arraySize-2]) 
			    {
				  return $word;
				} 
				elsif(isVowel($letter[$arraySize-1])) 
			    {
				  return $word;
				}
				elsif($letter[$arraySize-2] == 2381) 
			    {
				  return $word;
				}
				elsif(isConsonant($letter[$arraySize-1])) 
			    { #print "\n###LETTERIS $letter[$arraySize-1] ";
				  return $tmp[0]." 2381".$scalar.$tmp[1];
				}  
				else
				{
				return $word;
				}
				
		  }#end of inner if
 
	}#end of for each
	    #if no bebhakti then
		#print "\n\n NO BEBHAKTI";
		#getc();
		my @letter=split(" ",$word);
			  my $arraySize=@letter;
			 # print "\n ^^^^^ ARRAYIS $letter[$arraySize-2]";
			  if($letter[$arraySize-1]==$letter[$arraySize-2]) 
			    {
				  return $word;
				} 
				elsif($letter[$arraySize-2] eq "2381") 
			    {
				  return $word;
				} 
				elsif(isConsonant($letter[$arraySize-1])) 
			    {
				  return $word." 2381";
				} 
				
				else
				{
				return $word;
				}
				
}#end of outer else


}


sub is_verb
{
my %nep;
$nep{"2325 2360 2344"}="kasana";
$nep{"2326 2366 2314 2344"}="khauna";
$nep{"2332 2366 2314 2344"}="jauna";
$nep{"2349 2344 2344"}="bhanana";
$nep{"2327 2352 2344"}="garana";
$nep{"2340 2367 2346 2344"}="tipana";
$nep{"2354 2367 2346 2344"}="lipana";
$nep{"2346 2367 2340 2344"}="pitana";
$nep{""}="";


return $nep{$_[0]};
}
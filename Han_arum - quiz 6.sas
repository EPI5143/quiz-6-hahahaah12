libname clasdat "C:\SAS\epi5143 classdata";
****************
*Quiz 6;
***************;

data quiz6; 
set clasdat.nencounter;
run; *24531 obs;

proc contents data=quiz6;
run;

*only encounters that started in 2003;
data quiz_2003; 
set quiz6;
if year(datepart(EncStartDtm)) = 2003;
run; *3327 observation in quiz_2003;


proc freq data =quiz_2003;
table EncVisitTypeCd  ;
run;
proc sort data=quiz_2003;
by EncPatWID;
run; *3327 observation in quiz_2003;

*QUESTION a: 

# of patients who had at least 1 inpatient encounter that started in 2003;

*flatfile to end up 1 row per patient id - inpatient flagging and count ;
data quiz_2003_flat_inpt;
set quiz_2003;
by EncPatWID; 
if first.EncPatWID then do;
	inpt =0; inptcount = 0; *inpt = flagging inpatient visit, inptcount = # of inpt encounter ;
	end;

if EncVisitTypeCd ='INPT'  then do;
	inpt = 1; inptcount = inptcount+1;
	end;

if last.EncPatWID then output;
retain inpt inptcount;

run; *2891 obs;
ods listing ;
options formchar="|----|+|---+=|-/\<>*";

*frequency table to find the answer ;
proc freq data=quiz_2003_flat_inpt;
tables inpt inptcount;
run;
*
ANSWER FOR QUESTION A: 1074 patients had at least 1 inpatient enounter that started in 2003;

/*
                                     Inpatient encounter flag
                                      
                                                     Cumulative    Cumulative
                    inpt    Frequency     Percent     Frequency      Percent
                    ---------------------------------------------------------
                       0        1817       62.85          1817        62.85
                       1        1074       37.15          2891       100.00

*/

*QUESTION B: 

# of patients who had at least 1 emergency room encounter that started in 2003;

** flat file to end up 1 row per pt id - emerg flagging and count ;
data q2003_emerg;
set quiz_2003;
run; *3327 obs;

proc sort data=q2003_emerg;
by EncPatWID;
run;

data q2003_emerg_flat;
set q2003_emerg;
by EncPatWID; 
if first.EncPatWID then do;
	emerg =0; emergcount = 0; *emerg = flagging any er visit, emergcount = # of er encounter ;
	end;

if EncVisitTypeCd ='EMERG'  then do;
	emerg = 1; emergcount = emergcount+1;
	end;

if last.EncPatWID then output;
retain emerg emergcount;

run; *2891 obs;

*frequency table to find the answer ;
proc freq data=q2003_emerg_flat;
tables emerg emergcount;
run;

*ANSWER FOR QUESTION b: 1978 patients had at least 1 emergency encounter that started in 2003;

/*                         Flag for at least 1 emergency room encounter

                                                     Cumulative    Cumulative
                   emerg    Frequency     Percent     Frequency      Percent
                   ----------------------------------------------------------
                       0         913       31.58           913        31.58
                       1        1978       68.42          2891       100.00

*/

*QUESTION c: 

either inpt or emergency roon encounter that started in 2003;

data q2003_any;
set quiz_2003;
run;

proc sort data=q2003_any;
by EncPatWID;
run;

data q2003_any_flat;
set q2003_any;
by EncPatWID; 
if first.EncPatWID then do;
	enc =0; enccount = 0; *enc = flagging any type of visit, enccounter = # of any type of visit ;
	end;

	*flagging either emerg or inpatient;
if EncVisitTypeCd ='EMERG' or EncVisitTypeCd ='INPT' then do;
	enc = 1; enccount = enccount+1;
	end;

if last.EncPatWID then output;
retain enc enccount;

run; *2891 obs;

*frequency table to find the answer ;
proc freq data=q2003_any_flat;
tables enc enccount;
run;
*********************
ANSWER FOR QUESTION C: 2891 patients had at least 1 visit of either inpatient or emergency room encoutner that started in 2003;
*********************

*QUESTION d: 

patients who had at least 1 visit of either type, variable that counts the total # of encounters ;
proc freq data=q2003_any_flat;
where enc = 1;
table enccount;
run; 

**********************
ANSWER FOR QUESTION D:
**********************

2891 patients had at least 1 encounter of either type, and enccount' variable counts the number of any encounter. Below is the frequency table of the total encounter number


/* Frequency Table - # of any type of encounters  

     						number of any encounter (either inpt or ER)

                                                       Cumulative    Cumulative
                  enccount    Frequency     Percent     Frequency      Percent
                  -------------------------------------------------------------
                         1        2556       88.41          2556        88.41
                         2         270        9.34          2826        97.75
                         3          45        1.56          2871        99.31
                         4          14        0.48          2885        99.79
                         5           3        0.10          2888        99.90
                         6           1        0.03          2889        99.93
                         7           1        0.03          2890        99.97
                        12           1        0.03          2891       100.00
*/

;


*if I link the inpt and emerg dataset together, what happens?;
data link;
merge quiz_2003_flat_inpt (in=a) q2003_emerg_flat (in=b);
by EncPatWID;
if a;
run;


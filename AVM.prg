#/ Controller version = 3.14.01
#/ Date = 6/23/2026 3:12 PM
#/ User remarks = 
#0
!PNAME=
!PDESC=
PA_ComSupMotionType=PCClearAlarm
FILL (0,PA_HomeOrder)
FILL (1,PA_HomeOrder,6,7)
FILL (2,PA_HomeOrder,0,1)
FILL (3,PA_HomeOrder,2,2)
FILL (4,PA_HomeOrder,4,4)
FILL (0,PA_HomeAxis)
FILL (1,PA_HomeAxis,0,7)
PA_HomeAxis(3)=0
PA_HomeAxis(5)=0
!PA_HomeAxis(4)=0
WAIT 5000
PA_ComSupMotionType=AxisHome
!28s   9:43


STOP
#1
!PNAME=
!PDESC=

WAIT 5000
AUTOEXEC:
IF ^PST(7).#RUN
START 7,InitACS
END
!------- Assignment Variable Parameters -----------------------------------------------
INT MotionStart(INT MontionType);
INT CheckPara(INT MotionType);
!VOID LoginTestMode();
!VOID LogoutTestMode();
INT LastMotionType=0
!--------------------------Init---------------
PA_ComSupMotionType=NoMotion
AP_ComSupMotionRes=MotionReady

!---------------------------------------------
WHILE 1
IF PA_ComSupMotionType=AxisHome			!103
     IF  MotionStart(PA_ComSupMotionType)=1
	 
	 	IF PST(3).#RUN=1
	       STOP 3
		   IntervenePositoinMotion=0
		   KILLALL
		   
	     END 
		 
	    START 3,Axis_Home
		PA_AllHomedFlag=0
		Initializing=1
     END
	 ELSEIF PA_ComSupMotionType=PCOccurAlarm          !105
	 OccurAlarm(AlarmCode_ForcedAlarm,Alarm_High)
	ELSEIF PA_ComSupMotionType=ChuckVacuumOpenMotion				!106
     IF MotionStart(PA_ComSupMotionType)=1
	    START 3,ChuckVacuumOpenMotion
	 END 
	 
ELSEIF PA_ComSupMotionType=ChuckVacuumCloseMotion				!107
     IF MotionStart(PA_ComSupMotionType)=1
	    START 3,ChuckVacuumCloseMotion
	 END
ELSEIF PA_ComSupMotionType=LoadingPinUpMotion			!108
     IF MotionStart(PA_ComSupMotionType)=1
	    START 3,LoadingPinUpMotion
	 END
ELSEIF PA_ComSupMotionType=LoadingPinDownMotion			!109
     IF MotionStart(PA_ComSupMotionType)=1
	    START 3,LoadingPinDownMotion
	 END
	ELSEIF PA_ComSupMotionType=OpticFollowOpenMotion    !113
	 IF MotionStart(PA_ComSupMotionType)=1
	 
	 	IF PST(3).#RUN=1
	       STOP 3
	     END 
	 
	    START 3,CONNECT_Optic_TIR
	 END 
	 ELSEIF PA_ComSupMotionType=OpticFollowCloseMotion    !114
	 IF MotionStart(PA_ComSupMotionType)=1
	 
	 	IF PST(3).#RUN=1
	       STOP 3
	     END 
	 
	    START 3,DISCONNECT_Optic_TIR
	 END 
	 ELSEIF PA_ComSupMotionType=LoadingPinVacuumOpenMotion    !115
	 IF MotionStart(PA_ComSupMotionType)=1
	 
	 	IF PST(3).#RUN=1
	       STOP 3
	     END 
	 
	    START 3,LoadingPinVacuumOpenMotion
	 END
	  ELSEIF PA_ComSupMotionType=LoadingPinVacuumCloseMotion    !116
	 IF MotionStart(PA_ComSupMotionType)=1
	 
	 	IF PST(3).#RUN=1
	       STOP 3
	     END 
	 
	    START 3,LoadingPinVacuumCloseMotion
	 END
	ELSEIF PA_ComSupMotionType=AllEscapeMotion    !120
	 IF MotionStart(PA_ComSupMotionType)=1
	 
	 	IF PST(3).#RUN=1
	       STOP 3
	     END 
	 
	    START 3,ALL_ESCAPE
	 END 	 
	 ELSEIF PA_ComSupMotionType=TIR_Y_IntervenePositoin  ! 130
		 IF MotionStart(PA_ComSupMotionType)=1
	 
	 	IF PST(3).#RUN=1
	       STOP 3
	     END 
	 
	    START 3,TIR_Y_IntervenePositoinMotion
		END
	 
	 	 ELSEIF PA_ComSupMotionType=Open_Optic_CDA  !117
		 IF MotionStart(PA_ComSupMotionType)=1
	 
	 	IF PST(3).#RUN=1
	       STOP 3
	     END 
	 
	    START 3,Open_Optic_CDA
		END
	 
		  ELSEIF PA_ComSupMotionType= Close_Optic_CDA !118
		 IF MotionStart(PA_ComSupMotionType)=1
	 
	 	IF PST(3).#RUN=1
	       STOP 3
	     END 
	 
	    START 3,Close_Optic_CDA
		END 
!		ELSEIF PA_ComSupMotionType=Test_Mode_Login  !140
!		LoginTestMode()
		
		
!		ELSEIF PA_ComSupMotionType=Test_Mode_Logout  !141
!		LoginTestMode()
		
	 
ELSEIF PA_ComSupMotionType=NoMotion	| PA_ComSupMotionType=PCClearAlarm | PA_ComSupMotionType=PCOccurAlarm  		!0!104!105

ELSEIF PA_ComSupMotionType=StopOptic_X|PA_ComSupMotionType=StopOptic_Y|PA_ComSupMotionType=StopTIR_X|PA_ComSupMotionType=StopTIR_Y|PA_ComSupMotionType=StopOptic_Z|PA_ComSupMotionType=StopLDP_Z !121 122 123 124 125 126

	 WAIT(50)
ELSE	
	 OccurAlarm(AlarmCode_NoMotion,Alarm_Normal)
END
END


INT MotionStart(INT MotionType){ 
   INT RST=-1
   IF AP_ACSStatus = ACS_TsetMode|AP_ACS_TsetMode_Flag=1
   RST=1
   PA_ComSupMotionType=NoMotion
   DISP "TEST MOD :",MotionType
   RET RST
   END

   IF AP_ACSStatus=ACSStatus_Error
     OccurAlarm(AlarmCode_CanNotMotion,Alarm_Tips)
	 RET RST
   END 
   
   IF AP_ComSupMotionRes=MotionReady | AP_ComSupMotionRes=MotionSuccess
		IF CheckPara(MotionType)=-1
			OccurAlarm(AlarmCode_MotionDataErr,Alarm_Tips)
			DISP PA_ComSupMotionType
		ELSE
			AP_ComSupMotionRes=MotionRunning
			RST=1
		END
	ELSEIF AP_ComSupMotionRes=MotionRunning
	   OccurAlarm(AlarmCode_MotionRuning,Alarm_Tips)
	   DISP PA_ComSupMotionType
    ELSEIF AP_ComSupMotionRes=MotionError
       OccurAlarm(AlarmCode_CanNotMotion,Alarm_Tips)
	   DISP PA_ComSupMotionType
	END
	LastMotionType=PA_ComSupMotionType
	PA_ComSupMotionType=NoMotion
RET RST
}

INT CheckPara(INT CheckMotionTYpe)
{	
	INT RST = 1
	INT i = 0
	IF CheckMotionTYpe = AxisHome
		IF MAX(PA_HomeOrder) > AxisCount
			RST =- 1
			RET RST
		END
		IF  PA_EC_DI(0).1|PA_EC_DI(0).2<>1
		    RST =- 1
			RET RST
		END
		IF MAX(PA_HomeAxis) < 1
			RST =- 1
			RET RST
		END
		LOOP SIZEOF(PA_HomeAxis) - 1
			IF i > AxisCount-1
				RST = 1
				RET RST
			END

			IF PA_HomeAxis(i) = 1 & PA_HomeMode(i) <= 0
				RST =- 1
				RET RST
			END

			IF PA_HomeAxis(i) = 1 & PA_HomeVel(i) <= 0
				RST =- 1
				RET RST
			END

			IF PA_HomeAxis(i) = 1 & AST(i).#INHOMING= 1
				RST =- 1
				RET RST
			END

			i = i + 1
		END


	END
	IF PA_ComSupMotionType = LoadingPinUpMotion
		IF PA_AllHomedFlag = 0
			RST =- 1
			OccurAlarm(Alarm_Code_AllAxis_NotHomed,Alarm_High)
			RET RST
		END
		
		IF FPOS(TIR_Y0)<LoadingPinFreePosition(TIR_Y0)|IntervenePositoinMotion<>1
		  RST=-1
		  OccurAlarm(Alarm_Code_LDP_TIRY_intervene,Alarm_High)
		  RET RST
		IF (MST(Optic_X).#MOVE|MST(TIR_X).#MOVE|MST(Optic_Y0).#MOVE|MST(TIR_Y0).#MOVE) 
		  RST=-1
		  OccurAlarm(Alarm_Code_LDP_TIRY_intervene,Alarm_High)
		END
		  
		END
	
	END

	RET RST
	}
	
	


#2
!PNAME=
!PDESC=
AUTOEXEC:
WAIT 1000
FILL(-1,TIME_OUT,0,9)
INT TIMER(10)
FILL(0,TIMER,0,9)
FILL(10000,Delay,0,1)
!FILL (90000,PA_AxiHomeTimeOut)
FILL(10000,Delay,2,6)
FILL(5,Delay,7,9)
!INT AllHomeTimeOut=30000
INT TT=0
GLOBAL INT InterveneAlarm
VOID CheckHomeTimeOut();
FILL (-1,HomeAxis)
VOID CheckAxisError(INT AxisIndex);
WHILE 1

!----------AXIS ERROR----------------------------
	BLOCK		
		CheckAxisError(Optic_X)
		CheckAxisError(Optic_Y0)
		CheckAxisError(TIR_X)
		CheckAxisError(TIR_Y0)
		CheckAxisError(Optic_Z)
		CheckAxisError(LDP_Z)
	END
!-----------Home Timeout Alarm--------------
	IF MAX(HomeAxis) >= 0 & HomeTimeFlga <> 1

		CheckHomeTimeOut()

	END


!--------Hertbeat  TimeOut  Alarm----------------------	
	IF CO_Hert = 1
		TestHertTime = TIME
		CO_Hert = 2
		AP_AlarmCode(1) = 0
	END

	IF CO_Hert = 2 & PA_ShieldingHeartBeat = 0
		IF TIME- TestHertTime > HertTime
			OccurAlarm(AlarmCode_HeartBeatInterrupt, Alarm_Tips)

			DISP "HertTimeOut"

		END
	END

!-------Home Flage 	Refresh-------------------------
	IF (MFLAGS(Optic_X).#HOME& MFLAGS(Optic_Y0).#HOME& MFLAGS(TIR_X).#HOME& MFLAGS(TIR_Y0).#HOME& MFLAGS(Optic_Z).#HOME& MFLAGS(LDP_Z).#HOME) & PA_AllHomedFlag <> 1

		PA_AllHomedFlag = 1
		PA_EC_DO(0).31 = 1


	END
	IF (^MFLAGS(Optic_X).#HOME| ^MFLAGS(Optic_Y0).#HOME| ^MFLAGS(TIR_X).#HOME| ^MFLAGS(TIR_Y0).#HOME| ^MFLAGS(Optic_Z).#HOME| ^MFLAGS(LDP_Z).#HOME) & PA_AllHomedFlag <> 0
		PA_AllHomedFlag = 0
		PA_EC_DO(0).31 = 0

	END


END



VOID CheckHomeTimeOut()
{	
	INT i = 0
	INT LimitTime = 90000
	int jj
	LOOP AxisCount
	IF ABS(FPOS(i)-HomeCurrentPos(i))>HomeLimtiPos(i)
	KILL i
	END
		IF HomeAxis(i) <=0
		ELSE			
			IF ^MFLAGS(HomeAxis(i)).#HOME
				IF PA_AxiHomeTimeOut(HomeAxis(i)) > 0
					LimitTime = PA_AxiHomeTimeOut(HomeAxis(i))
				END
			jj=TIME- HomeStartTime(HomeAxis(i))
!			DISP jj,i
			IF TIME- HomeStartTime(HomeAxis(i)) > LimitTime
			
			
				OccurAlarm(163 + HomeAxis(i), Alarm_Normal,3)
!                OccurAlarm(AlarmCode_HomeTimeOut, Alarm_Normal, 3)
				DISP "HOMETIME OUT",HomeAxis(i)
				HomeAxis(i) =- 1
				KILL i
			END
			
	ELSE		
!		FDEF(HomeAxis(i)).#SRL= 1
!		FDEF(HomeAxis(i)).#SLL= 1
!		HomeAxis(i) =- 1
	END
	END
	i++
	END
	RET 
}

VOID CheckAxisError(INT AxisIndex){
 	INT ACode=0
 	INT BitOffset=0 
 	IF AxisIndex=Optic_X
    	ACode=0
  	ELSEIF AxisIndex=Optic_Y0
    	ACode=1 
  	ELSEIF AxisIndex=TIR_X
    	ACode=2 
  	ELSEIF AxisIndex=TIR_Y0
    	ACode=3
  	ELSEIF AxisIndex=Optic_Z
    	ACode=4 
  	ELSEIF AxisIndex=LDP_Z
    	ACode=5
  	END 

  	IF FAULT(AxisIndex).#RL=1 & AST(AxisIndex).#INHOMING<>1
    	BitOffset=0
		OccurAlarm(170+ACode,Alarm_Tips)           !!!!!Tips    170-- 175
  	END
  	IF FAULT(AxisIndex).#LL=1 & AST(AxisIndex).#INHOMING<>1
   		BitOffset=1
		OccurAlarm(176+ACode,Alarm_Tips)           !!!!!Tips 176-181
  	END
  	IF FAULT(AxisIndex).#NT=1                           !!!!!  hight   10--15
    	BitOffset=2
		OccurAlarm(10+ACode)
  	END
  	IF FAULT(AxisIndex).#HOT=1                             !!!! 20---25
   		BitOffset=4
		OccurAlarm(20+ACode)
  	END
	IF FAULT(AxisIndex).#SRL=1 & FDEF(AxisIndex).#SRL=1 & AST(AxisIndex).#INHOMING<>1     
    	BitOffset=5 
		OccurAlarm(182+ACode,Alarm_Tips)               !!!!!Tips 182--187
  	END
 	IF FAULT(AxisIndex).#SLL=1 & FDEF(AxisIndex).#SLL=1 & AST(AxisIndex).#INHOMING<>1
    	BitOffset=6
		OccurAlarm(188+ACode,Alarm_Tips)              !!!!!Tips 188--193
  	END
  	IF FAULT(AxisIndex).#ENCNC=1
   		BitOffset=7                                       !!!  30---35
		OccurAlarm(30+ACode)
  	END
! 	IF FAULT(AxisIndex).#ENC2NC=1
!    	BitOffset=8
		!OccurAlarm(BitOffset+ACode)
!  	END
  	IF FAULT(AxisIndex).#DRIVE=1                     !!!!  40---45
    	BitOffset=9
		OccurAlarm(40+ACode)
  	END
 	IF FAULT(AxisIndex).#ENC=1                       !!!! 50--55 
    	BitOffset=10
		OccurAlarm(50+ACode)
  	END
!  	IF FAULT(AxisIndex).#ENC2=1
!   		BitOffset=11
!  		!OccurAlarm(BitOffset+ACode)
!  	END
  	IF FAULT(AxisIndex).#PE=1                   !!!!  137---142
    	BitOffset=12
		OccurAlarm(137+ACode,Alarm_Normal)
  	END
   	IF FAULT(AxisIndex).#CPE=1                 !!!!!143---148
   		BitOffset=13
		OccurAlarm(143+ACode,Alarm_Normal)
  	END
    IF FAULT(AxisIndex).#VL =1             !!!!!!!!60--65
   		BitOffset=14
		OccurAlarm(60+ACode)
  	END
  	IF FAULT(AxisIndex).#AL =1
   		BitOffset=15
		OccurAlarm(70+ACode)
  	END
  	IF FAULT(AxisIndex).#CL=1
    	BitOffset=16
		OccurAlarm(80+ACode)
  	END
   	IF FAULT(AxisIndex).#SP =1
    	BitOffset=17
		OccurAlarm(90+ACode)
  	END
  	IF FAULT(AxisIndex).#STO=1
    	BitOffset=18
		OccurAlarm(100+ACode)
  	END
  	IF FAULT(AxisIndex).#HSSINC=1
    	BitOffset=20
		OccurAlarm(110+ACode)
  	END
  	RET 
}


#3
!PNAME=
!PDESC=

VOID SingleAxisHome(INT Axis,INT HomeMode,REAL HomeVel,REAL HomeOffset,REAL HomeCurrentLimit);
VOID ALLAxis_Home();
REAL startTime
!-----------------------------------Home-------------------------------------------------------------------------------
Axis_Home:
INT IntMin=0
LOOP AxisCount
ALLAxis_Home()
IntMin=IntMin+1
END
LOOP AxisCount
INT axis

TILL MST(axis).#INPOS 

END
TILL MST(0).#INPOS&MST(1).#INPOS&MST(2).#INPOS&MST(4).#INPOS
TARGRAD(2)=0.005
TARGRAD(4)=0.005
HomeTimeFlga =1
MotionEnd(MotionSuccess)
STOP

!pan duan huei yuan shun xu
VOID ALLAxis_Home()
{	
	INT i = 0
	INT j = 0
	INT k = 0
	INT l = 0
!	FILL(- 1, HomeAxis)
	LOOP AxisCount
		IF PA_HomeAxis(i) = 1
			k = k + 1
			IF PA_HomeOrder(i) = IntMin
				BLOCK					
					HomeStartTime(i) = TIME
					HomeAxis(i) = i
!					OffsetAxis = j
					DISP "HOME START", HomeAxis(i)
					SingleAxisHome(HomeAxis(i), PA_HomeMode(i), PA_HomeVel(i), PA_HomeOffset(i), PA_HomeCurrentLimit(i)) !hui yuan cehng xu
					DISP "HOMEING", HomeAxis(i)
				END
!				l = 1
!				j = j + 1
			END
		END
		i = i + 1
	END

	IF 1 !k>1
		i = 0
		j = 0
		LOOP SIZEOF(PA_HomeAxis)
			IF PA_HomeOrder(i) = IntMin & PA_HomeAxis(i) = 1
				startTime = TIME
				WHILE ^MFLAGS(i).#HOME!Pan Duan Hui Ling Wan Cheng
				END
				IF PA_HomeOffset(i) <> 0
					PTP/V i, 0, PA_HomeVel(i)
					DISP "MOVE ZERO", i
				END


				FDEF(i).#RL= 1
				FDEF(i).#LL= 1
				FDEF(i).#SRL= 1
				FDEF(i).#SLL= 1

				PA_HomeAxis(i) = 0
				HomeAxis(i) =- 1
!				j = j + 1
			END
			i = i + 1
		END
!	ELSEIF l = 1
!	FILL(-1, HomeAxis)
!	FILL(0, PA_HomeAxis)


	END
	RET 
}

VOID SingleAxisHome(INT Axis, INT HomeMode, REAL HomeVel, REAL HomeOffset, REAL HomeCurrentLimit)
{	
	FCLEAR ALL
	INT Axis_S 
	DISP "ENABLE ", Axis
	ENABLE Axis
	
	IF HomeMode = 18 & FAULT(Axis).#RL
		JOG/V Axis,- 1
		TILL ^FAULT(Axis).#RL
		KILL Axis
		WAIT 100
		TILL ^AST(Axis).#MOVE
	END
	IF HomeMode = 17 & FAULT(Axis).#LL

		JOG/V Axis, 1
		TILL ^FAULT(Axis).#LL
		KILL Axis
		WAIT 100
	END

	IF MFLAGS(TIR_X).#DEFCON= 0 | MFLAGS(TIR_Y0).#DEFCON= 0
		MFLAGS(TIR_X).#DEFCON= 1
		MFLAGS(TIR_Y0).#DEFCON= 1
	END

	MFLAGS(Axis).#HOME= 0
	FDEF(Axis).#SRL= 0
	FDEF(Axis).#SLL= 0
	FDEF(Axis).#RL= 0
	FDEF(Axis).#LL= 0
	startTime = TIME

	HOMEVELL(Axis) = HomeVel
	HOMEVELI(Axis) = HomeVel/ 2
	ACC(Axis)=10*HomeVel
	DEC(Axis)=10*HomeVel
	JERK(Axis)=100*HomeVel
	HomeOffset=-1*HomeOffset
	DISP"Axis,HomeMode,HomeVel,HomeOffset:",Axis,HomeMode,HomeVel,HomeOffset
	HomeTimeFlga=0
	HomeCurrentPos(Axis)=FPOS(Axis)
	
IF MFLAGS(Axis).#GANTRY

   IF Axis=Optic_Y0
   STOP 4
   START 4,Optic_Y_GANTRY
   
   END
   
   IF Axis=TIR_Y0
   STOP 4
   START 4,TIR_Y_GANTRY
   
   END 

ELSE
	HOME Axis,HomeMode,HomeVel, ,HomeOffset,HomeCurrentLimit
	END


RET
}

ChuckVacuumOpenMotion:
   IF  PA_EC_DO(3).2<>1
       PA_EC_DO(3).2=1   
   END
   MotionEnd(MotionSuccess)
STOP

ChuckVacuumCloseMotion:
   IF  PA_EC_DO(3).2<>0
       PA_EC_DO(3).2=0   
   END
   MotionEnd(MotionSuccess)
STOP

REAL LDP_Time

LoadingPinUpMotion:
!!!!up

PA_EC_DO(2).0 = 1;
PA_EC_DO(2).1 = 0
LDP_Time=TIME
TILL PA_EC_DI(0).1 = 1,PA_LDP_MotionTime
!PA_EC_DO(2).6 = 0;

IF TIME -LDP_Time>PA_LDP_MotionTime
OccurAlarm(LoadingPinUpTimeOut)
DISP "LoadingPinUpTimeOut"
MotionEnd(MotionSuccess)
ELSE MotionEnd(MotionSuccess)
END

STOP

LoadingPinDownMotion:

PA_EC_DO(2).1 = 1;
PA_EC_DO(2).0 = 0
LDP_Time=TIME
TILL PA_EC_DI(0).2 = 1,PA_LDP_MotionTime
!PA_EC_DO(2).7 = 0;
IF TIME -LDP_Time>PA_LDP_MotionTime
OccurAlarm(LoadingPinDownTimeOut)
DISP "LoadingPinDownTimeOut"
MotionEnd(MotionSuccess)
ELSE MotionEnd(MotionSuccess)
END

STOP



LoadingPinVacuumOpenMotion:
IF PA_EC_DO(3).6 <> 1
	PA_EC_DO(3).6 = 1
END
MotionEnd(MotionSuccess)
STOP

LoadingPinVacuumCloseMotion:
IF PA_EC_DO(3).6 <> 0
	PA_EC_DO(3).6 = 0
END
MotionEnd(MotionSuccess)
STOP

TIR_Y_IntervenePositoinMotion:
IF PA_AllHomedFlag = 0
	OccurAlarm(Alarm_Code_AllAxis_NotHomed, Alarm_High)
ELSE
ENABLE TIR_Y0
FMASK(TIR_Y0).#RL=1

JOG/V TIR_Y0,10
TILL FAULT(TIR_Y0).#RL
HALT TIR_Y0
LimitRightPosition(TIR_Y0)=FPOS(TIR_Y0)
LoadingPinFreePosition(TIR_Y0)=-(FreeDstence-LimitRightPosition(TIR_Y0))
PTP/V TIR_Y0,0,10
END
TILL ^MST(TIR_Y0).#MOVE|-0.01<FPOS(TIR_Y0)<0.01
IntervenePositoinMotion=1
AP_AlarmCode(173)=0
Initializing=0
MotionEnd(MotionSuccess)
DISP "TIR_Y_IntervenePositoinMotion OK"
STOP

Open_Optic_CDA:

PA_EC_DO(0).0=1
TILL PA_EC_DO(0).0=1
MotionEnd(MotionSuccess)
DISP "Open_Optic_CDA OK"
STOP


Close_Optic_CDA:

PA_EC_DO(0).0=0
TILL PA_EC_DO(0).0=0
MotionEnd(MotionSuccess)
DISP "Close_Optic_CDA OK"
STOP


CONNECT_Optic_TIR:
DISP "CONNECT_Optic_TIR:"
MFLAGS(TIR_X).#DEFCON=0  !CONNECT is allowed. axis1 is Slave;
MFLAGS(TIR_Y0).#DEFCON=0  !CONNECT is allowed. axis1 is Slave;
CONNECT RPOS(TIR_X) = APOS(Optic_X)
CONNECT RPOS(TIR_Y0) = APOS(Optic_Y0)
WAIT 50
DEPENDS TIR_X,Optic_X
DEPENDS TIR_Y0,Optic_Y0
PA_EC_DO(3).7=1
DISP"CONNECT_Optic_TIR_OK"
MotionEnd(MotionSuccess)
STOP

DISCONNECT_Optic_TIR:
DISP "DISCONNECT_Optic_TIR:"
MFLAGS(TIR_X).#DEFCON=1;	MFLAGS(TIR_Y0).#DEFCON=1
DISP"DISCONNECT_Optic_TIR_OK"
PA_EC_DO(3).7=0
MotionEnd(MotionSuccess)
STOP 
#4
!PNAME=
!PDESC=
INT Axis = 2
INT Axis_S = 3

Optic_Y_GANTRY:

!	Axis_S=Axis+1


Axis = 2
Axis_S = 3
HOMEVELL(Axis) = PA_HomeVel(Axis)
IST(Axis).#IND= 0;IST(Axis_S).#IND= 0
SET FPOS(Axis_S) = 0
MFLAGS(Axis).#HOME= 0
FDEF(Axis).#SRL= 0
FDEF(Axis).#SLL= 0
FDEF(Axis).#RL= 0
FDEF(Axis).#LL= 0

MFLAGS(Axis_S).#HOME= 0
FDEF(Axis_S).#SRL= 0
FDEF(Axis_S).#SLL= 0
FDEF(Axis_S).#RL= 0
FDEF(Axis_S).#LL= 0
TARGRAD(Axis)=0.01
ENABLE Axis
IF FAULT(Axis).#RL| FAULT(Axis_S).#RL
	JOG/V(Axis),- HOMEVELL(Axis)
	TILL ^FAULT(Axis).#RL& ^FAULT(Axis_S).#RL
	KILL Axis
END

JOG/V Axis, HOMEVELL(Axis)
TILL FAULT(Axis).#RL| FAULT(Axis_S).#RL
KILL Axis

IST(Axis).#IND= 0;IST(Axis_S).#IND= 0
JOG/V(Axis),- HOMEVELL(Axis)
TILL IST(Axis).#IND= 1
KILL Axis
PTP Axis, IND(Axis)
TILL MST(Axis).#INPOS
SET FPOS(Axis) = 0
WAIT 10
PTP Axis, PA_HomeOffset(Axis)
TILL MST(Axis).#INPOS
WAIT 10
SET FPOS(Axis) = 0;SET FPOS(Axis_S) = 0
MFLAGS(Axis).#HOME= 1
FDEF(Axis).#SRL= 1
FDEF(Axis).#SLL= 1
FDEF(Axis).#RL= 1
FDEF(Axis).#LL= 1

MFLAGS(Axis_S).#HOME= 1
FDEF(Axis_S).#SRL= 1
FDEF(Axis_S).#SLL= 1
FDEF(Axis_S).#RL= 1
FDEF(Axis_S).#LL= 1

STOP


TIR_Y_GANTRY:
Axis = 4
Axis_S = 5
!	Axis_S=Axis+1
HOMEVELL(Axis) = PA_HomeVel(Axis)


MFLAGS(Axis).#HOME= 0
FDEF(Axis).#SRL= 0
FDEF(Axis).#SLL= 0
FDEF(Axis).#RL= 0
FDEF(Axis).#LL= 0

MFLAGS(Axis_S).#HOME= 0
FDEF(Axis_S).#SRL= 0
FDEF(Axis_S).#SLL= 0
FDEF(Axis_S).#RL= 0
FDEF(Axis_S).#LL= 0
TARGRAD(Axis)=0.01
ENABLE Axis


IST(Axis).#IND= 0;IST(Axis_S).#IND= 0
SET FPOS(Axis_S) = 0
IF FAULT(Axis).#RL| FAULT(Axis_S).#RL
	JOG/V(Axis),- HOMEVELL(Axis)
	TILL ^FAULT(Axis).#RL& ^FAULT(Axis_S).#RL
	KILL Axis
END

JOG/V Axis, HOMEVELL(Axis)
TILL FAULT(Axis).#RL| FAULT(Axis_S).#RL
KILL Axis

IST(Axis).#IND= 0;IST(Axis_S).#IND= 0
JOG/V(Axis),- HOMEVELL(Axis)
TILL IST(Axis).#IND= 1
KILL Axis
PTP Axis, IND(Axis)
TILL MST(Axis).#INPOS
SET FPOS(Axis) = 0
WAIT 10
PTP Axis, PA_HomeOffset(Axis)
TILL MST(Axis).#INPOS
WAIT 10
SET FPOS(Axis) = 0;SET FPOS(Axis_S) = 0
MFLAGS(Axis).#HOME= 1
FDEF(Axis).#SRL= 1
FDEF(Axis).#SLL= 1
FDEF(Axis).#RL= 1
FDEF(Axis).#LL= 1

MFLAGS(Axis_S).#HOME= 1
FDEF(Axis_S).#SRL= 1
FDEF(Axis_S).#SLL= 1
FDEF(Axis_S).#RL= 1
FDEF(Axis_S).#LL= 1

STOP
	
	
	

#5
!PNAME=
!PDESC=
!----------------IO=---------------
AUTOEXEC:

WHILE 1


!!---DI Mapping-------------------------------------------------------
!!!PA_EC_DI(0).1  LoadingPinUp_Sign
!!!PA_EC_DI(0).2  LoadingPinDown_Sign
ECIN(72,PA_EC_DI(0))

!!---DO Mapping---
ECOUT(76,PA_EC_DO(0)) !0:Camera CDA Open
!!---AI Mapping---
ECIN(76,PA_EC_AI(1))  ! Wafer Chuck Vac
ECIN(78,PA_EC_AI(6))  ! ATF INPOS
ECIN(80,PA_EC_AI(3))  ! Loading Pins VAC
ECIN(82,PA_EC_AI(4))  ! MAC Bellows CDA
ECIN(84,PA_EC_AI(5))  ! Loading Pins CDA 11111
ECIN(86,PA_EC_AI(7))  ! Camera CDA

!!---AO Mapping---	!0 ~ 655357 --- 0 ~ +10V	   D=(65535/10)*U
ECOUT(78,PA_EC_AO(4))  ! Reflectiv IR
ECOUT(82,PA_EC_AO(0))	! T-IR
ECOUT(84,PA_EC_AO(8))	!Autofocus

!!---Festo Mapping---
!!!PA_EC_DO(3).2   Chuck_VAC
!!!PA_EC_DO(3).0   LoadingPinUp_CDA
!!!PA_EC_DO(3).1   LoadingPinDown_CDA
!!!PA_EC_DO(3).6   LoadingPin_VAC

ECOUT(508,PA_EC_DO(2))
ECOUT(509,PA_EC_DO(3))


WAIT 50

END

STOP
#6
!PNAME=
!PDESC=


SLVKP(Optic_Y0)=100
SLVKI(Optic_Y0)=100
SLPKP(Optic_Y0)=200
SLAFF(Optic_Y0)=80
SLFRC(Optic_Y0)=30
SLFRCN(Optic_Y0)=30	
MFLAGS(Optic_Y0).#NOFILT=1
MFLAGS(Optic_Y0).#NOTCH=1
SLVSOF(Optic_Y0)=500
SLVNFRQ(Optic_Y0)=508
SLVNWID(Optic_Y0)=20
SLVNATT(Optic_Y0)=7
MFLAGS(Optic_Y0).#NANO=1
TARGRAD(Optic_Y0)=0.005
SLZFF(Optic_Y0)=0.001
SLDZMAX(Optic_Y0)=0.001 
SLDZMIN(Optic_Y0)=0.0005
SLDZTIME(Optic_Y0) =1






!SLVKP(Optic_Y1)=10
!SLVKI(Optic_Y1)=50
!SLPKP(Optic_Y1)=50
!SLAFF(Optic_Y1)=5000
!SLFRC(Optic_Y1)=10
!SLFRCN(Optic_Y1)=20	
!MFLAGS(Optic_Y1).#NOFILT=0
!!MFLAGS(Optic_Y1).#NANO=0
!TARGRAD(Optic_Y1)=0.1
!SLZFF(Optic_Y1)=0.002
!SLDZMAX(Optic_Y1)=0.001 
!SLDZMIN(Optic_Y1)=0.0005
!SLDZTIME(Optic_Y1) =1



SLVKP(Optic_Y1)=40
SLVKI(Optic_Y1)=60
SLPKP(Optic_Y1)=400
SLAFF(Optic_Y1)=1200
SLFRC(Optic_Y1)=10
SLFRCN(Optic_Y1)=30
MFLAGS(Optic_Y1).#NOFILT=0
!MFLAGS(Optic_Y1).#NANO=0
TARGRAD(Optic_Y1)=0.1
SLZFF(Optic_Y1)=0.001
SLDZMAX(Optic_Y1)=0.02
SLDZMIN(Optic_Y1)=0.01
SLDZTIME(Optic_Y1) =1


SLVKP(TIR_Y0)=100
SLVKI(TIR_Y0)=150
SLPKP(TIR_Y0)=300
SLAFF(TIR_Y0)=2000
SLFRC(TIR_Y0)=10
SLFRCN(TIR_Y0)=20	
MFLAGS(TIR_Y0).#NOFILT=0
MFLAGS(TIR_Y0).#NANO=1
TARGRAD(TIR_Y0)=0.005
SETTLE(TIR_Y0)=1
SLZFF(TIR_Y0)=0.005
SLDZMAX(TIR_Y0)=0.001 
SLDZMIN(TIR_Y0)=0.0005
SLDZTIME(TIR_Y0) =1


SLVKP(TIR_Y1)=100
SLVKI(TIR_Y1)=150
SLPKP(TIR_Y1)=300
SLAFF(TIR_Y1)=1000
SLFRC(TIR_Y1)=10
SLFRCN(TIR_Y0)=10	
MFLAGS(TIR_Y1).#NOFILT=0
!MFLAGS(TIR_Y1).#NANO=0
TARGRAD(TIR_Y1)=0.2
SETTLE(TIR_Y1)=2
SLZFF(TIR_Y1)=0.005
SLDZMAX(TIR_Y1)=0.02
SLDZMIN(TIR_Y1)=0.01
SLDZTIME(TIR_Y1) =1






!TARGRAD(3)=0.005
! SLZFF(3)=0.2
!SLDZMAX(3)=0.001 
!SLDZMIN(3)=0.0005 
!SLDZTIME(3) =1
STOP

#7
!PNAME=
!PDESC=
AUTOEXEC:
WAIT 5000
InitACS:






!-----------------------------------2.StartBuffer------------------

IF PST(1).#RUN<>1
START 1,1
END
IF PST(2).#RUN<>1
START 2,1
END
IF PST(5).#RUN<>1
START 5,1
END
HertTime=60000

!-------------------------------------3.Variable Init --------------------
!Loading_Pin_PLMIT=-(PA_HomeOffset(TIR_Y)-160.305)
Loading_Pin_PLMIT=-1.9
Loading_Pin_NLMIT=-300
PA_AllHomedFlag=0
AP_ACS_TsetMode_Flag=0
PA_LDP_MotionTime=8000

FILL (70000,PA_AxiHomeTimeOut)

HomeLimtiPos(Optic_X)=300
HomeLimtiPos(Optic_Y0)=300
HomeLimtiPos(TIR_X)=300
HomeLimtiPos(TIR_Y0)=300
HomeLimtiPos(Optic_Z)=37
HomeLimtiPos(LDP_Z)=38

PA_EC_DO(0)=1

XCURI(Optic_Y0)=25
XCURV(Optic_Y0)=95
XCURI(Optic_Y1)=10
XCURV(Optic_Y1)=20

XCURI(TIR_Y0)=30
XCURV(TIR_Y0)=90
XCURI(TIR_Y1)=15
XCURV(TIR_Y1)=20


MFLAGS(Optic_Y0).25=1
MFLAGS(Optic_Y1).25=1

MFLAGS(TIR_Y0).25=1
MFLAGS(TIR_Y1).25=1




PA_HomeVel(Optic_X)=10;  PA_HomeMode(Optic_X)=2  ;  PA_HomeOffset(Optic_X)=20.38535 ;     PA_HomeCurrentLimit(Optic_X)=50
!PA_HomeVel(Optic_Y0)=10 ; PA_HomeMode(Optic_Y0)=2   ; PA_HomeOffset(Optic_Y0)=204.9385  ;    PA_HomeCurrentLimit(Optic_Y0)=70 
PA_HomeVel(Optic_Y0)=10 ; PA_HomeMode(Optic_Y0)=2   ; PA_HomeOffset(Optic_Y0)=18.11  ;    PA_HomeCurrentLimit(Optic_Y0)=90 
PA_HomeVel(Optic_Z)=2 ;  PA_HomeMode(Optic_Z)=18  ; PA_HomeOffset(Optic_Z)=0    ;    PA_HomeCurrentLimit(Optic_Z)=50
PA_HomeVel(LDP_Z)=2   ;  PA_HomeMode(LDP_Z)=17    ; PA_HomeOffset(LDP_Z)=0      ;    PA_HomeCurrentLimit(LDP_Z)=50
PA_HomeVel(TIR_X)=10  ;  PA_HomeMode(TIR_X)=2    ;  PA_HomeOffset(TIR_X)=64   ;PA_HomeCurrentLimit(TIR_X)=50
!PA_HomeVel(TIR_Y0)=10  ;  PA_HomeMode(TIR_Y0)=2    ;  PA_HomeOffset(TIR_Y0)=179.57   ; PA_HomeCurrentLimit(TIR_Y0)=100
PA_HomeVel(TIR_Y0)=10  ;  PA_HomeMode(TIR_Y0)=1    ;  PA_HomeOffset(TIR_Y0)=24   ; PA_HomeCurrentLimit(TIR_Y0)=100
STOP																				
#8
!PNAME=
!PDESC=
ON PA_ComSupMotionType = PCClearAlarm & PST(8).#RUN<> 1
FCLEAR ALL

INT i = 0
AP_ComSupMotionRes=MotionReady
AP_ACSStatus = ACSStatus_OK
FILL(0, AP_AlarmCode)
STOP 4
IF PST(1).#RUN<> 1
	START 1, 1
END
IF PST(2).#RUN<> 1
	START 2, 1
END
PA_ComSupMotionType = NoMotion
IF AP_ACSStatus = ACS_TsetMode | AP_ACS_TsetMode_Flag = 1

	AP_ACSStatus = ACS_TsetMode
ELSE	
	AP_ACSStatus = ACSStatus_OK

END


DISP "CLEAR ALARM OK"

RET 

ON PA_ComSupMotionType = Test_Mode_Login
LoginTestMode()
WAIT 1000
PA_ComSupMotionType=NoMotion
RET 

ON PA_ComSupMotionType = Test_Mode_Logout
LogoutTestMode()
WAIT 1000
PA_ComSupMotionType=NoMotion
RET 


ON PA_ComSupMotionType = StopOptic_X !121  
IF PST(3).#RUN= 1

	STOP 3
	KILLALL

END

KILL Optic_X
PA_ComSupMotionType = NoMotion
AP_ComSupMotionRes = MotionSuccess
RET 

ON PA_ComSupMotionType = StopOptic_Y !122  
IF PST(3).#RUN= 1

	STOP 3
	KILLALL

END

KILL Optic_Y0
PA_ComSupMotionType = NoMotion
AP_ComSupMotionRes = MotionSuccess
RET 

ON PA_ComSupMotionType = StopTIR_X !123  
IF PST(3).#RUN= 1

	STOP 3
	KILLALL

END

KILL TIR_X
PA_ComSupMotionType = NoMotion
AP_ComSupMotionRes = MotionSuccess
RET 

ON PA_ComSupMotionType = StopTIR_Y !124  
IF PST(3).#RUN= 1

	STOP 3
	KILLALL

END

KILL TIR_Y0
PA_ComSupMotionType = NoMotion
AP_ComSupMotionRes = MotionSuccess
RET 

ON PA_ComSupMotionType = StopOptic_Z !125  
IF PST(3).#RUN= 1

	STOP 3
	KILLALL

END

KILL Optic_Z
PA_ComSupMotionType = NoMotion
AP_ComSupMotionRes = MotionSuccess
RET 

ON PA_ComSupMotionType = StopLDP_Z !126  
IF PST(3).#RUN= 1

	STOP 3

	KILLALL
END
PA_ComSupMotionType = NoMotion
AP_ComSupMotionRes = MotionSuccess
KILL LDP_Z

RET 

ON PA_EC_DI(0).1
KILL(TIR_X, TIR_Y0)
DISABLE(TIR_X, TIR_Y0)
RET 





ON PST(1).#RUN<> 1 | PST(2).#RUN<> 1
WAIT(1000)

OccurAlarm(AlarmCode_StateMachineNotRun, Alarm_High)
DISP "buffer 1 or 2 stop"

RET
#9
!PNAME=
!PDESC=



STOP
ON VEL(Optic_X)>25
VEL(Optic_X)=20
ACC(Optic_X)=200
DEC(Optic_X)=200
JERK(Optic_X)=2000
RET
ON VEL(Optic_Y0)>25
VEL(Optic_Y0)=20
ACC(Optic_Y0)=200
DEC(Optic_Y0)=200
JERK(Optic_Y0)=2000
RET
ON VEL(TIR_X)>25
VEL(TIR_X)=20
ACC(TIR_X)=200
DEC(TIR_X)=200
JERK(TIR_X)=2000
RET
ON VEL(TIR_Y0)>25
VEL(TIR_Y0)=20
ACC(TIR_Y0)=200
DEC(TIR_Y0)=200
JERK(TIR_Y0)=2000
RET
ON VEL(Optic_Z)>16
VEL(Optic_Z)=10
ACC(Optic_Z)=100
DEC(Optic_Z)=100
JERK(Optic_Z)=1000
RET
ON VEL(LDP_Z)>11
DISP "11111111"
VEL(LDP_Z)=10
ACC(LDP_Z)=100
DEC(LDP_Z)=100
JERK(LDP_Z)=1000
RET

ON FAULT(Optic_X).#PE
OccurAlarm(137,Alarm_Normal)
RET
ON FAULT(Optic_Y0).#PE
OccurAlarm(138,Alarm_Normal)
RET
ON FAULT(TIR_X).#PE
OccurAlarm(139,Alarm_Normal)
RET
ON FAULT(TIR_Y0).#PE
OccurAlarm(140,Alarm_Normal)
RET
ON FAULT(Optic_Z).#PE
OccurAlarm(141,Alarm_Normal)
RET
ON FAULT(LDP_Z).#PE
OccurAlarm(142,Alarm_Normal)
RET

ON FAULT(Optic_X).#CPE
OccurAlarm(143,Alarm_Normal)
RET
ON FAULT(Optic_Y0).#CPE
OccurAlarm(144,Alarm_Normal)
RET
ON FAULT(TIR_X).#CPE
OccurAlarm(145,Alarm_Normal)
RET
ON FAULT(TIR_Y0).#CPE
OccurAlarm(146,Alarm_Normal)
RET
ON FAULT(Optic_Z).#CPE
OccurAlarm(147,Alarm_Normal)
RET
ON FAULT(LDP_Z).#CPE
OccurAlarm(148,Alarm_Normal)
RET

ON FAULT(Optic_X).#VL
OccurAlarm(60,Alarm_Normal)
RET
ON FAULT(Optic_Y0).#VL
OccurAlarm(61,Alarm_Normal)
RET
ON FAULT(TIR_X).#VL
OccurAlarm(62,Alarm_Normal)
RET
ON FAULT(TIR_Y0).#VL
OccurAlarm(63,Alarm_Normal)
RET
ON FAULT(Optic_Z).#VL
OccurAlarm(64,Alarm_Normal)
RET
ON FAULT(LDP_Z).#VL
OccurAlarm(65,Alarm_Normal)
RET
!

!
!
!!ON (MST(Optic_X).#MOVE|MST(Optic_X).#MOVE|MST(Optic_X).#MOVE|MST(TIR_Y0).#MOVE)&PA_EC_DO(2).7 = 0&ACS_TsetMode_Flag<>1
!!KILLALL 
!!OccurAlarm(AlarmCode_Loading_Cannot,Alarm_High)
!!PA_EC_DO(2).1 = 1
!!PA_EC_DO(2).0 = 0
!!
!!RET

ON (MST(Optic_X).#MOVE|MST(TIR_X).#MOVE|MST(Optic_Y0).#MOVE|MST(TIR_Y0).#MOVE)&PA_EC_DI(0).1 = 1&AP_ACS_TsetMode_Flag<>1&Initializing=0
HALT Optic_X
HALT TIR_X
HALT TIR_Y0
HALT Optic_Y0
DISP "ON 1"
OccurAlarm(AlarmCode_Loading_Cannot,Alarm_High)


RET
ON (FPOS(LDP_Z)>2|^MFLAGS(LDP_Z).#HOME)&((FVEL(Optic_Y0)<-0.1&FPOS(Optic_Y0)<-1)|(FVEL(TIR_Y0)<-0.1&FPOS(TIR_Y0)<-1))&AP_ACS_TsetMode_Flag<>1&Initializing=0
!WAIT 10
KILL Optic_X
KILL TIR_X
KILL TIR_Y0
KILL Optic_Y0
DISP "ON 2"
OccurAlarm(Alarm_Code_LDP_TIRY_intervene,Alarm_High)
!DISP "11111"

RET

!ON (FPOS(LDP_Z)>2|^MFLAGS(LDP_Z).#HOME)&((FVEL(Optic_X)<-0.1&FPOS(Optic_X)<-1)|(FVEL(TIR_X)<-0.1&FPOS(TIR_X)<-1))&AP_ACS_TsetMode_Flag<>1
!!WAIT 10
!KILL Optic_X
!KILL TIR_X
!KILL TIR_Y0
!KILL Optic_Y0
!DISP "ON 3"
!OccurAlarm(Alarm_Code_LDP_TIRY_intervene,Alarm_High)
!!DISP "11111"
!
!RET

ON (FPOS(LDP_Z)>5&FVEL(LDP_Z)>0.2|^MFLAGS(LDP_Z).#HOME)&(FPOS(Optic_Y0)<Loading_Pin_PLMIT|FPOS(Optic_X)<Loading_Pin_PLMIT|FPOS(TIR_X)<Loading_Pin_PLMIT|FPOS(TIR_Y0)<Loading_Pin_PLMIT)&AP_ACS_TsetMode_Flag<>1&Initializing=0
!WAIT 10
!HALT 0
!HALT 1
!HALT 2
!HALT 3
KILL 5
DISP "ON 4"
OccurAlarm(Alarm_Code_LDP_TIRY_intervene,Alarm_High)
!DISP "11111"

RET
!

!
!
!
ON PA_EC_DO(3).7=1&^MST(TIR_X).#ENABLED&MST(Optic_X).#ENABLED
ENABLE (TIR_X)
RET

ON PA_EC_DO(3).7 = 1&MST(TIR_X).#ENABLED & ^MST(Optic_X).#ENABLED
DISABLE TIR_X
RET

ON PA_EC_DO(3).7 = 1&^MST(TIR_Y0).#ENABLED & MST(Optic_Y0).#ENABLED
ENABLE TIR_Y0
RET

ON PA_EC_DO(3).7 = 1&MST(TIR_Y0).#ENABLED & ^MST(Optic_Y0).#ENABLED
DISABLE TIR_Y0
RET








#A
!PNAME=
!PDESC=
!axisdef X=0,Y=1,Z=2,T=3,A=4,B=5,C=6,D=7
!axisdef x=0,y=1,z=2,t=3,a=4,b=5,c=6,d=7

AXISDEF Optic_X=0,TIR_X=1,Optic_Y0=2,Optic_Y1=3,TIR_Y0=4,TIR_Y1=5,Optic_Z=6,LDP_Z=7

global int I(100),I0,I1,I2,I3,I4,I5,I6,I7,I8,I9,I90,I91,I92,I93,I94,I95,I96,I97,I98,I99
global real V(100),V0,V1,V2,V3,V4,V5,V6,V7,V8,V9,V90,V91,V92,V93,V94,V95,V96,V97,V98,V99



!-------------------------Axis Init---------------
GLOBAL INT AxisCount=8
GLOBAL INT AxisNums(8)
AxisNums(0)=0;AxisNums(1)=1;AxisNums(2)=2;AxisNums(3)=3;AxisNums(4)=4;AxisNums(5)=5;AxisNums(6)=6;AxisNums(7)=7
GLOBAL T(10)
GLOBAL INT HomeTimeFlga
GLOBAL INT HomeFlag
GLOBAL INT Initializing
GLOBAL REAL HomeCurrentPos(32)
GLOBAL REAL HomeLimtiPos(32)

GLOBAL INT PA_HomeOrder(32)
GLOBAL INT HomeAxis(32)
GLOBAL INT PA_HomeMode(32)
GLOBAL REAL PA_HomeVel(32)
GLOBAL REAL PA_HomeOffset(32)
GLOBAL INT PA_AxiHomeTimeOut(32)
GLOBAL REAL HomeStartTime(32)
GLOBAL INT PA_HomeAxis(32)
GLOBAL INT PA_HomeCurrentLimit(32)
GLOBAL INT PA_AllHomedFlag 
GLOBAL REAL PA_LimitP(8)
GLOBAL REAL PA_LimitN(8)

!-------------------------Loading_interference---------------

GLOBAL REAL IndexHomePosition(32)
GLOBAL REAL LimitRightPosition(32)
GLOBAL REAL LimitLeftPosition(32)
GLOBAL REAL LoadingPinFreePosition(32)

GLOBAL REAL CONST FreeDstence=50
GLOBAL INT IntervenePositoinMotion=0
GLOBAL INT Loading_Pin_PLMIT
GLOBAL INT Loading_Pin_NLMIT

!------Mapping----------
GLOBAL INT PA_EC_DI(3),PA_EC_DO(6),PA_EC_AI(16),PA_EC_AO(16)

!------Array------------

GLOBAL INT TIME_OUT(10),StepTime(100)
GLOBAL INT Delay(10)
GLOBAL INT HOMETIME(10)


!------ACS TO PC-----

GLOBAL INT HertTime=3000
GLOBAL INT CO_Hert=2
GLOBAL INT PA_ShieldingHeartBeat

GLOBAL INT OffsetAxis
GLOBAL INT PA_LDP_MotionTime

!-----PC TO ACS-------


!------------------Alarm_Hight------------
GLOBAL CONST INT AlarmCode_HeartBeatInterrupt=1
GLOBAL CONST INT AlarmCode_StateMachineNotRun=2

GLOBAL CONST INT AlarmCode_Loading_Cannot=4
GLOBAL CONST INT Alarm_Code_AllAxis_NotHomed=5
GLOBAL CONST INT Alarm_Code_LDP_TIRY_intervene=6
!GLOBAL CONST INT LoadingPinUpTimeOut=5
!GLOBAL CONST INT LoadingPinDownTimeOut=6
!GLOBAL CONST INT AlarmCode_LDP_Z_intervene=7
GLOBAL CONST INT AlarmCode_ForcedAlarm=8

GLOBAL CONST INT LoadingPinUpTimeOut=116
GLOBAL CONST INT LoadingPinDownTimeOut=117



!-----AlarmNum------




!--------home time out alarm-------
GLOBAL CONST INT Optic_X_HomeTimeOut=131
GLOBAL CONST INT Optic_Y_HomeTimeOut=132
GLOBAL CONST INT TIR_X_HomeTimeOut=133
GLOBAL CONST INT TIR_Y_HomeTimeOut=134
GLOBAL CONST INT Optic_Z_HomeTimeOut=135
GLOBAL CONST INT LDP_Z_HomeTimeOut=136



GLOBAL CONST INT AlarmCode_MotionDataErr=121
GLOBAL CONST INT AlarmCode_HomeTimeOut=123
GLOBAL CONST INT AlarmCode_NoMotion=162
GLOBAL CONST INT AlarmCode_NeedleExistInterveneRisk=163
GLOBAL CONST INT AlarmCode_CameraExistInterveneRisk=164
GLOBAL CONST INT AlarmCode_CanNotMotion=165
GLOBAL CONST INT AlarmCode_MotionRuning=166





!-----Alarm Limit------
GLOBAL INT LoadingVAC_AI_RLimit=199
GLOBAL INT ChuckVAC_AI_RLimit=195;


!----TEST----------
!GLOBAL INT TimeOutTest,TestCount
GLOBAL REAL TestHertTime

!-----Alarm Delay-----
GLOBAL INT Chuck_VAC_ON_Delay=5000
GLOBAL INT LDP_Cylinder_UP_Delay=10000
GLOBAL INT LDP_VAC_ON_Delay=5000
GLOBAL INT LDP_VAC_OFF_Delay=1000
GLOBAL INT LDP_Cylinder_Down_Delay=10000
GLOBAL INT Chuck_VAC_OFF_Delay=1000
GLOBAL INT ALL_ESCAPE_Delay=10000
GLOBAL INT Robot_Read_Delay=6000
GLOBAL INT LDP_Z_Delay=5000
GLOBAL INT MarkPoint_Delay=5000
GLOBAL INT Autofo_Delay=5000
GLOBAL INT Inch_Delay=5000
GLOBAL INT CentrePoint_Delay=5000
GLOBAL INT HomeDelay=30000

!---------------MotionType-----------------
GLOBAL CONST INT NoMotion=0
GLOBAL CONST INT CheckAxisHomeTimeOut=101
GLOBAL CONST INT LaserCompensate=102
GLOBAL CONST INT AxisHome=103
GLOBAL CONST INT PCClearAlarm=104
GLOBAL CONST INT PCOccurAlarm=105
GLOBAL CONST INT ChuckVacuumOpenMotion=106
!GLOBAL CONST INT SynPid=106
GLOBAL CONST INT ChuckVacuumCloseMotion=107
GLOBAL CONST INT LoadingPinUpMotion=108
GLOBAL CONST INT LoadingPinDownMotion=109
GLOBAL CONST INT AutoFocusMotion=110
GLOBAL CONST INT ReflectMotion=111
GLOBAL CONST INT TransmissiveIRMotion=112
GLOBAL CONST INT OpticFollowOpenMotion=113
GLOBAL CONST INT OpticFollowCloseMotion=114
GLOBAL CONST INT LoadingPinVacuumOpenMotion=115
GLOBAL CONST INT LoadingPinVacuumCloseMotion=116
GLOBAL CONST INT Open_Optic_CDA=117
GLOBAL CONST INT Close_Optic_CDA=118
GLOBAL CONST INT AllEscapeMotion=120

GLOBAL CONST INT StopOptic_X=121
GLOBAL CONST INT StopOptic_Y=122
GLOBAL CONST INT StopTIR_X=123
GLOBAL CONST INT StopTIR_Y=124
GLOBAL CONST INT StopOptic_Z=125
GLOBAL CONST INT StopLDP_Z=126
GLOBAL CONST INT TIR_Y_IntervenePositoin=130
GLOBAL CONST INT Test_Mode_Login=140
GLOBAL CONST INT Test_Mode_Logout=141


!------------ClearAlarm-----------------
GLOBAL INT PA_ClearAlarmCode(200)
GLOBAL INT AP_AlarmCode(200)

!---------------ALARM-----------------------
GLOBAL INT AP_ACSStatus=1
GLOBAL CONST INT ACSStatus_Error=-1
GLOBAL CONST INT ACSStatus_Tips=-2
GLOBAL CONST INT ACSStatus_OK=1
GLOBAL CONST INT ACS_TsetMode=3
!---------------ALARMGrade-----------------------
GLOBAL CONST INT Alarm_High=1
GLOBAL CONST INT Alarm_Normal=2
GLOBAL CONST INT Alarm_Tips=3
GLOBAL CONST INT Alarm_Buffer=4
!---------------MotionStatus-------------
GLOBAL CONST INT MotionReady=0
GLOBAL CONST INT MotionRunning=2
GlOBAL CONST INT MotionSuccess=1
GLOBAL CONST INT MotionError=-1


GLOBAL INT AP_ComSupMotionRes
GLOBAL INT PA_ComSupMotionType

GLOBAL INT AP_ACS_TsetMode_Flag



INT GetAlarmLevel(INT AlarmCode){
INT Level=0
IF AlarmCode<=120
Level=1
ELSEIF 121<AlarmCode<=160
Level=2
ELSEIF 161<AlarmCode<=200
Level=3
!ELSEIF 300<AlarmCode<=400
!Level=4
END

RET Level
}

VOID OccurAlarm(INT AlarmCode, INT AlarmLevel = 0, INT Buffer1 =- 1, INT Buffer2 =- 1)
{	
	DISP "Alarm", AlarmCode
	IF AlarmCode > SIZEOF(AP_AlarmCode)
		RET 
	END

	IF Buffer1 <>- 1
		STOP Buffer1
	END
	IF Buffer2 <>- 1
		STOP Buffer2
	END

	IF AlarmLevel = 0
		AlarmLevel = GetAlarmLevel(AlarmCode)
	END

	IF AP_AlarmCode(AlarmCode) = 1
		RET 
	END

	AP_AlarmCode(AlarmCode) = 1
	IF AlarmLevel = Alarm_High
		PA_ComSupMotionType = NoMotion
   AP_ComSupMotionRes=MotionError
		IF AP_ACSStatus = ACS_TsetMode | AP_ACS_TsetMode_Flag = 1
			AP_ACSStatus = ACS_TsetMode
		ELSE
			AP_ACSStatus = ACSStatus_Error
		END

		KILLALL
		WAIT 50
		DISABLEALL
	ELSEIF AlarmLevel = Alarm_Normal
		PA_ComSupMotionType = NoMotion
		IF AP_ACSStatus = ACS_TsetMode | AP_ACS_TsetMode_Flag = 1
			AP_ACSStatus = ACS_TsetMode
		ELSE
			AP_ACSStatus = ACSStatus_Error
		END
		KILLALL
   AP_ComSupMotionRes=MotionError
	ELSEIF AlarmLevel = Alarm_Tips
		IF AP_ACSStatus = ACS_TsetMode | AP_ACS_TsetMode_Flag = 1
			AP_ACSStatus = ACS_TsetMode
		ELSEIF AP_ACSStatus <> ACSStatus_Error

			AP_ACSStatus = ACSStatus_Tips
		END
!   IF AP_ACSStatus<>ACSStatus_Error
!      AP_ACSStatus=ACSStatus_Tips
!    END
	ELSEIF AlarmLevel = Alarm_Buffer
		PA_ComSupMotionType = NoMotion
		IF AP_ACSStatus = ACS_TsetMode | AP_ACS_TsetMode_Flag = 1
			AP_ACSStatus = ACS_TsetMode
		ELSE
			AP_ACSStatus = ACSStatus_Error
		END
	ELSE		
	END
	RET 
}

VOID ClearAlarm()
{	
	INT i = 0
	LOOP SIZEOF(AP_AlarmCode) - 1
		IF MAX(PA_ClearAlarmCode) < 1
			RET 
		END
		IF AP_AlarmCode(i) = 1 & PA_ClearAlarmCode(i) = 1
			AP_AlarmCode(i) = 0
			PA_ClearAlarmCode(i) = 0
		END
	END
	IF MAX(AP_AlarmCode, 0, 200) < 1
		IF AP_ACSStatus = ACS_TsetMode | AP_ACS_TsetMode_Flag = 1
			AP_ACSStatus = ACS_TsetMode
		ELSE
			AP_ACSStatus = ACSStatus_OK
		END
		AP_ComSupMotionRes = MotionReady
		FCLEAR ALL
		
		IF PST(1).#RUN<> 1
			START 1, 1
		END
		IF PST(2).#RUN<> 1
			START 2, 1
		END
		IF PST(8).#RUN<> 1
			START 2, 1
		END
	END
	STOP 3
	RET 
}
VOID MotionEnd(INT EndType)
{	
	PA_ComSupMotionType = NoMotion
	AP_ComSupMotionRes = EndType
	RET 
}


VOID LoginTestMode()
{	
	AP_ACSStatus = ACS_TsetMode
	AP_ACS_TsetMode_Flag = 1
	PA_ShieldingHeartBeat=1
	DISP "ACS_TSET_MODE LOGIN"

	RET 

}




VOID LogoutTestMode()
{	
	AP_ACSStatus = ACSStatus_OK
	AP_ACS_TsetMode_Flag = 0
	PA_ShieldingHeartBeat=0
	DISP "ACS_TSET_MODE LOGOUT"

	RET 
}

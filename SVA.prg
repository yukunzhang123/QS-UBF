#/ Controller version = 4.00
#/ Date = 7/13/2026 4:39 PM
#/ User remarks = 
#1
!PNAME=
!PDESC=
!WAIT 5000
!AUTOEXEC:

!START 1

!------- Assignment Variable Parameters -----------------------------------------------
!INT MotionStart(INT MontionType);
INT LastMotionType=0
!INT MoveFunc(INT AXIS);
!INT MotionStart(INT MotionType);
!INT CheckPara(INT CheckMotionTYpe);
!!--------------------------Init---------------
PA_ComSupMotionType=NoMotion
AP_ComSupMotionRes=MotionReady
!---------------------------------------------
!
WHILE 1
	IF PA_ComSupMotionType = PCOccurAlarm !105
			OccurAlarm(AlarmCode_ForcedAlarm, Alarm_High)
ELSEIF PA_ComSupMotionType = NoMotion | PA_ComSupMotionType = PCClearAlarm
	WAIT 100
ELSE	
	
END

END
#2
!PNAME=ALARM
!PDESC=

!WAIT 5000
!AUTOEXEC:

!VOID CheckHomeTimeOut();
VOID CheckAxisError(INT AxisIndex);
INT HeartTime=3000
INT CurrentHeartTime

!GLOBAL INT TAG 1401 ModHeartBeat=2 !48802
!GLOBAL INT TAG 1402 AlarmCode_ModBusHeartBeatInterrupt=3 !48804
INT ModBusHeartTime=3000


WHILE 1

!--------Home  TimeOut  Alarm----------------------	

IF MAX(HomeAxis)>-1
HomeMonitorActive=1
ELSE
HomeMonitorActive=0

END

IF HomeMonitorActive=1
CheckHomeTimeOut()
END

!--------Axis Error Alarm----------------------
BLOCK
CheckAxisError(TT_Y0)
CheckAxisError(TT_Y1)
CheckAxisError(BT_Y0)
CheckAxisError(BT_Y1)
CheckAxisError(BC_Z0)
CheckAxisError(BC_Z1)
CheckAxisError(BC_Z2)
CheckAxisError(SLA_Y0)
CheckAxisError(SLA_Y1)
CheckAxisError(TT_X0)
CheckAxisError(TT_X1)
CheckAxisError(BT_X0)
CheckAxisError(BT_X1)
CheckAxisError(OL_X)
CheckAxisError(OL_Y)
CheckAxisError(OL_Z)
CheckAxisError(OR_X)
CheckAxisError(OR_Y)
CheckAxisError(OR_Z)
CheckAxisError(TWLP)
CheckAxisError(BWLP)
END
!--------Hertbeat  TimeOut  Alarm----------------------	
!IF CO_HeartBeat = 1
!	CurrentHeartTime = TIME
!	CO_HeartBeat = 2
!END
!IF CO_HeartBeat = 2 & PA_ShieldingHeartBeat = 0
!	IF TIME- CurrentHeartTime > HeartTime
!		OccurAlarm(AlarmCode_HeartBeatInterrupt, Alarm_High)
!		DISP " HeartBeat Broken"
!	END
!END


!	IF ModHeartBeat = 2
!		CurrentHeartTime = TIME
!		ModHeartBeat = 1
!	END
!IF ModHeartBeat = 1
!	IF TIME- CurrentHeartTime > ModBusHeartTime
!		OccurAlarm(AlarmCode_ModBusHeartBeatInterrupt, Alarm_High)
!		DISP "MODBUS HeartBeat Broken"
!	END
!END


!WAIT 50


END


VOID CheckAxisError(INT AxisIndex)
{
    INT ACode = AxisToCode(AxisIndex)
    IF ACode < 0
        RET                     
    END

    !! Hard limit position (RL)
    IF FAULT(AxisIndex).#RL = 1 & AST(AxisIndex).#INHOMING <> 1
        OccurAlarm(610 + ACode, Alarm_Tips)
    END
    !! Hard limit position (LL)
    IF FAULT(AxisIndex).#LL = 1 & AST(AxisIndex).#INHOMING <> 1
        OccurAlarm(635 + ACode, Alarm_Tips)
    END
    !! Network Error. (NT)
    IF FAULT(AxisIndex).#NT = 1
        OccurAlarm(100 + ACode)
    END
    !! Motor Overheat (HOT)
    IF FAULT(AxisIndex).#HOT = 1
        OccurAlarm(125 + ACode)
    END
    !! Software Right Limit (SRL) 
    IF FAULT(AxisIndex).#SRL = 1 & FDEF(AxisIndex).#SRL = 1 & AST(AxisIndex).#INHOMING <> 1
        OccurAlarm(660 + ACode, Alarm_Tips)
    END
    !! Software Left Limit. (SLL)
    IF FAULT(AxisIndex).#SLL = 1 & FDEF(AxisIndex).#SLL = 1 & AST(AxisIndex).#INHOMING <> 1
        OccurAlarm(685 + ACode, Alarm_Tips)
    END
    !! Encoder Not Connected. (ENCNC)
    IF FAULT(AxisIndex).#ENCNC = 1
        OccurAlarm(150 + ACode)
    END
    !! Drive Alarm.(DRIVE)
    IF FAULT(AxisIndex).#DRIVE = 1
        OccurAlarm(175 + ACode)
    END
    !! Encoder Error. (ENC)
    IF FAULT(AxisIndex).#ENC = 1
        OccurAlarm(200 + ACode)
    END
    !! Position Error. (PE)
    IF FAULT(AxisIndex).#PE = 1
        OccurAlarm(440 + ACode, Alarm_Normal)
    END
    !! Critical Position Error. (CPE)
    IF FAULT(AxisIndex).#CPE = 1
        OccurAlarm(470 + ACode, Alarm_Normal)
    END
    !! Velocity Limit.(VL)
    IF FAULT(AxisIndex).#VL = 1
        OccurAlarm(225 + ACode)
    END
    !! Acceleration Limit. (AL)
    IF FAULT(AxisIndex).#AL = 1
        OccurAlarm(250 + ACode)
    END
    !! Current Limit. (CL)
    IF FAULT(AxisIndex).#CL = 1
        OccurAlarm(275 + ACode)
    END
    !! Servo Processor Alarm. (SP)
    IF FAULT(AxisIndex).#SP = 1
        OccurAlarm(300 + ACode)
    END
    !! Safe Torque Off (STO)
    IF FAULT(AxisIndex).#STO = 1
        OccurAlarm(325 + ACode)
    END
    !! (HSSINC)
    IF FAULT(AxisIndex).#HSSINC = 1
        OccurAlarm(350 + ACode)
    END
    RET
}









#3
!PNAME=ParaInit
!PDESC=
!ACS_Version________2025_8_14
AUTOEXEC:
WAIT 5000
INT i=0
!-----------BufferInit
!IF PST(1).#RUN=0
!START 1,1
!END
IF PST(2).#RUN=0
START 2,1
END
IF PST(4).#RUN=0
START 4,1
END


IF PST(6).#RUN=0
START 6,1
END
IF PST(7).#RUN=0
START 7,1
END
IF PST(9).#RUN=0
START 9,1
END
!-----------ParaInit
XCURI(TT_Y0)=40
XCURV(TT_Y0)=80
XCURI(TT_Y1)=30
XCURV(TT_Y1)=60

XCURI(BT_Y0)=40
XCURV(BT_Y0)=80
XCURI(BT_Y1)=30
XCURV(BT_Y1)=60

MFLAGS(TT_Y0).#GANTRY=1
MFLAGS(TT_Y1).#GANTRY=1
MFLAGS(BT_Y0).#GANTRY=1
MFLAGS(BT_Y1).#GANTRY=1

AxisVel(TT_Y0)=300
AxisVel(BT_Y0)=300
AxisVel(TT_X0)=0.75
AxisVel(TT_X1)=0.75
AxisVel(BT_X0)=0.75
AxisVel(BT_X1)=0.75
AxisVel(SLA_Y0)=2
AxisVel(SLA_Y1)=2
AxisVel(OL_X)=1.5
AxisVel(OL_Y)=1.5
AxisVel(OL_Z)=1.5
AxisVel(OR_X)=1.5
AxisVel(OR_Y)=1.5
AxisVel(OR_Z)=1.5
AxisVel(BC_Z0)=2
AxisVel(BC_Z1)=2
AxisVel(BC_Z2)=2
AxisVel(TWLP)=2
AxisVel(BWLP)=5


AxisToCode(TT_Y0)=0
AxisToCode(TT_Y1)=1
AxisToCode(BT_Y0)=2
AxisToCode(BT_Y1)=3
AxisToCode(BC_Z0)=4
AxisToCode(BC_Z1)=5
AxisToCode(BC_Z2)=6
AxisToCode(SLA_Y0)=8
AxisToCode(SLA_Y1)=9
AxisToCode(TT_X0)=10
AxisToCode(TT_X1)=11
AxisToCode(BT_X0)=12
AxisToCode(BT_X1)=13
AxisToCode(OL_X)=14
AxisToCode(OL_Y)=15
AxisToCode(OL_Z)=16
AxisToCode(OR_X)=18
AxisToCode(OR_Y)=19
AxisToCode(OR_Z)=20
AxisToCode(TWLP)=22
AxisToCode(BWLP)=23



LOOP 23
FDEF(i).#SRL=1
FDEF(i).#SLL=1
FDEF(i).#RL=1
FDEF(i).#LL=1
i++
END







!-----------VariableInit
FILL(-1,HomeAxis)
FILL (60,HOMETIME)
FILL (0,HomeFlags)
FILL (60000,PA_AxiHomeTimeOut)
FILL (90000,PA_AxiHomeTimeOut,0,3)
PA_AxiHomeTimeOut(OL_X)=90000
PA_AxiHomeTimeOut(OR_X)=90000

INT GantryHomeDelay=150000

INT AA=0
INT BB=0
INT CC=0

PA_HomeVel(TT_Y0)=20;PA_HomeMode(TT_Y0)=2;PA_HomeOffset(TT_Y0)=-296.05724;PA_HomeCurrentLimit(TT_Y0)=80;         PA_LimitP(TT_Y0)=1;PA_LimitN(TT_Y0)=-531
PA_HomeVel(BT_Y0)=20;PA_HomeMode(BT_Y0)=2;PA_HomeOffset(BT_Y0)=236.41;PA_HomeCurrentLimit(BT_Y0)=50;            PA_LimitP(BT_Y0)=531;PA_LimitN(BT_Y0)=-1
PA_HomeVel(OL_X)=1;PA_HomeMode(OL_X)=18;PA_HomeOffset(OL_X)=-3.17895;PA_HomeCurrentLimit(OL_X)=50;                PA_LimitP(OL_X)=-80;PA_LimitN(OL_X)=-150
PA_HomeVel(OL_Y)=1;PA_HomeMode(OL_Y)=18;PA_HomeOffset(OL_Y)=-25.66455;PA_HomeCurrentLimit(OL_Y)=50;               PA_LimitP(OL_Y)=20;PA_LimitN(OL_Y)=-20
PA_HomeVel(OL_Z)=1;PA_HomeMode(OL_Z)=17;PA_HomeOffset(OL_Z)=6.9329;PA_HomeCurrentLimit(OL_Z)=50;                 PA_LimitP(OL_Z)=6.2;PA_LimitN(OL_Z)=-1
PA_HomeVel(OR_X)=1;PA_HomeMode(OR_X)=17;PA_HomeOffset(OR_X)=4.3294;PA_HomeCurrentLimit(OR_X)=70;		         PA_LimitP(OR_X)=150;PA_LimitN(OR_X)=80
PA_HomeVel(OR_Y)=1;PA_HomeMode(OR_Y)=18;PA_HomeOffset(OR_Y)=-25.632025;PA_HomeCurrentLimit(OR_Y)=90;		         PA_LimitP(OR_Y)=20;PA_LimitN(OR_Y)=-20
PA_HomeVel(OR_Z)=1;PA_HomeMode(OR_Z)=17;PA_HomeOffset(OR_Z)=7.7927;PA_HomeCurrentLimit(OR_Z)=50;		         PA_LimitP(OR_Z)=6.2;PA_LimitN(OR_Z)=-1
PA_HomeVel(TWLP)=1;PA_HomeMode(TWLP)=18;PA_HomeOffset(TWLP)=0;PA_HomeCurrentLimit(TWLP)=50;				         PA_LimitP(TWLP)=0.1;PA_LimitN(TWLP)=-26
PA_HomeVel(BWLP)=1;PA_HomeMode(BWLP)=17;PA_HomeOffset(BWLP)=0;PA_HomeCurrentLimit(BWLP)=50;				         PA_LimitP(BWLP)=50;PA_LimitN(BWLP)=-0.2
PA_HomeVel(TT_X0)=0.2;PA_HomeMode(TT_X0)=17;PA_HomeOffset(TT_X0)=-1.44235;PA_HomeCurrentLimit(TT_X0)=50;        PA_LimitP(TT_X0)=1;PA_LimitN(TT_X0)=-1
PA_HomeVel(TT_X1)=0.2;PA_HomeMode(TT_X1)=17;PA_HomeOffset(TT_X1)=-1.307467;PA_HomeCurrentLimit(TT_X1)=50;        PA_LimitP(TT_X1)=1;PA_LimitN(TT_X1)=-1
PA_HomeVel(BT_X0)=0.2;PA_HomeMode(BT_X0)=18;PA_HomeOffset(BT_X0)=1.197542;PA_HomeCurrentLimit(BT_X0)=50;	         PA_LimitP(BT_X0)=1;PA_LimitN(BT_X0)=-1
PA_HomeVel(BT_X1)=0.2;PA_HomeMode(BT_X1)=18;PA_HomeOffset(BT_X1)=1.15029;PA_HomeCurrentLimit(BT_X1)=50;         PA_LimitP(BT_X1)=1;PA_LimitN(BT_X1)=-1
PA_HomeVel(SLA_Y0)=1;PA_HomeMode(SLA_Y0)=17;PA_HomeOffset(SLA_Y0)=4.5219;PA_HomeCurrentLimit(SLA_Y0)=50;         PA_LimitP(SLA_Y0)=8;PA_LimitN(SLA_Y0)=-4
PA_HomeVel(SLA_Y1)=1;PA_HomeMode(SLA_Y1)=17;PA_HomeOffset(SLA_Y1)=2.7703;PA_HomeCurrentLimit(SLA_Y1)=50;         PA_LimitP(SLA_Y1)=8;PA_LimitN(SLA_Y1)=-4 
PA_HomeVel(BC_Z0)=1;PA_HomeMode(BC_Z0)=17;PA_HomeOffset(BC_Z0)=-1.122;PA_HomeCurrentLimit(BC_Z0)=50;	         PA_LimitP(BC_Z0)=3.5;PA_LimitN(BC_Z0)=-0.01
PA_HomeVel(BC_Z1)=1;PA_HomeMode(BC_Z1)=17;PA_HomeOffset(BC_Z1)=-0.897;PA_HomeCurrentLimit(BC_Z1)=50;	         PA_LimitP(BC_Z1)=3.5;PA_LimitN(BC_Z1)=-0.01
PA_HomeVel(BC_Z2)=1;PA_HomeMode(BC_Z2)=17;PA_HomeOffset(BC_Z2)=-0.920;PA_HomeCurrentLimit(BC_Z2)=50;	         PA_LimitP(BC_Z2)=3.5;PA_LimitN(BC_Z2)=-0.01
!PA_HomeVel(BC_Z0)=1;PA_HomeMode(BC_Z0)=17;PA_HomeOffset(BC_Z0)=-4.8635;PA_HomeCurrentLimit(BC_Z0)=50;	         PA_LimitP(BC_Z0)=3.5;PA_LimitN(BC_Z0)=-0.01
!PA_HomeVel(BC_Z1)=1;PA_HomeMode(BC_Z1)=17;PA_HomeOffset(BC_Z1)=-4.560;PA_HomeCurrentLimit(BC_Z1)=50;	         PA_LimitP(BC_Z1)=3.5;PA_LimitN(BC_Z1)=-0.01
!PA_HomeVel(BC_Z2)=1;PA_HomeMode(BC_Z2)=17;PA_HomeOffset(BC_Z2)=-4.4785;PA_HomeCurrentLimit(BC_Z2)=50;	         PA_LimitP(BC_Z2)=3.5;PA_LimitN(BC_Z2)=-0.01


SRLIMIT(TT_Y0)=PA_LimitP(TT_Y0);SLLIMIT(TT_Y0)=PA_LimitN(TT_Y0)
SRLIMIT(BT_Y0)=PA_LimitP(BT_Y0);SLLIMIT(BT_Y0)=PA_LimitN(BT_Y0)
SRLIMIT(BC_Z0)=PA_LimitP(BC_Z0);SLLIMIT(BC_Z0)=PA_LimitN(BC_Z0)
SRLIMIT(BC_Z1)=PA_LimitP(BC_Z1);SLLIMIT(BC_Z1)=PA_LimitN(BC_Z1)
SRLIMIT(BC_Z2)=PA_LimitP(BC_Z2);SLLIMIT(BC_Z2)=PA_LimitN(BC_Z2)
SRLIMIT(SLA_Y0)=PA_LimitP(SLA_Y0);SLLIMIT(SLA_Y0)=PA_LimitN(SLA_Y0)
SRLIMIT(SLA_Y0)=PA_LimitP(SLA_Y1);SLLIMIT(SLA_Y1)=PA_LimitN(SLA_Y1)
SRLIMIT(TT_X0)=PA_LimitP(TT_X0);SLLIMIT(TT_X0)=PA_LimitN(TT_X0)
SRLIMIT(TT_X1)=PA_LimitP(TT_X1);SLLIMIT(TT_X1)=PA_LimitN(TT_X1)
SRLIMIT(BT_X0)=PA_LimitP(BT_X0);SLLIMIT(BT_X0)=PA_LimitN(BT_X0)
SRLIMIT(BT_X1)=PA_LimitP(BT_X1);SLLIMIT(BT_X1)=PA_LimitN(BT_X1)
SRLIMIT(OL_X)=PA_LimitP(OL_X);SLLIMIT(OL_X)=PA_LimitN(OL_X)
SRLIMIT(OL_Y)=PA_LimitP(OL_Y);SLLIMIT(OL_Y)=PA_LimitN(OL_Y)
SRLIMIT(OL_Z)=PA_LimitP(OL_Z);SLLIMIT(OL_Z)=PA_LimitN(OL_Z)
SRLIMIT(OR_X)=PA_LimitP(OR_X);SLLIMIT(OR_X)=PA_LimitN(OR_X)
SRLIMIT(OR_Y)=PA_LimitP(OR_Y);SLLIMIT(OR_Y)=PA_LimitN(OR_Y)
SRLIMIT(OR_Z)=PA_LimitP(OR_Z);SLLIMIT(OR_Z)=PA_LimitN(OR_Z)
SRLIMIT(TWLP)=PA_LimitP(TWLP);SLLIMIT(TWLP)=PA_LimitN(TWLP)
SRLIMIT(BWLP)=PA_LimitP(BWLP);SLLIMIT(BWLP)=PA_LimitN(BWLP)




! TT_Y0_HomeVelocity=20; TT_Y0_HomeMode=2; TT_Y0_HomeOffset1=-296.05724;TT_Y0_HomingCurrLimit=50;           TT_Y0_SRLIMIT=1;TT_Y0_SLLIMIT=-531
!! BT_Y0_HomeVelocity=20 ; BT_Y0_HomeMode=2; BT_Y0_HomeOffset1=383.7267; BT_Y0_HomingCurrLimit=50;         BT_Y0_SRLIMIT=531;BT_Y0_SLLIMIT=-1
! BT_Y0_HomeVelocity=20 ; BT_Y0_HomeMode=2; BT_Y0_HomeOffset1=236.41; BT_Y0_HomingCurrLimit=50;         BT_Y0_SRLIMIT=531;BT_Y0_SLLIMIT=-1
!! OL_X_HomeVelocity=1 ; OL_X_HomeMode=18; OL_X_HomeOffset1=-4.4805; OL_X_HomingCurrLimit=50;           OL_X_SRLIMIT=-79;OL_X_SLLIMIT=-125
! OL_X_HomeVelocity=1 ; OL_X_HomeMode=18; OL_X_HomeOffset1=-4.5155; OL_X_HomingCurrLimit=50;           OL_X_SRLIMIT=-120;OL_X_SLLIMIT=-150
!! OL_Y_HomeVelocity=1 ; OL_Y_HomeMode=18; OL_Y_HomeOffset1=-26.5977; OL_Y_HomingCurrLimit=50;          OL_Y_SRLIMIT=20;OL_Y_SLLIMIT=-20
! OL_Y_HomeVelocity=1 ; OL_Y_HomeMode=18; OL_Y_HomeOffset1=-25.6452; OL_Y_HomingCurrLimit=50;          OL_Y_SRLIMIT=20;OL_Y_SLLIMIT=-20
! OL_Z_HomeVelocity=1 ; OL_Z_HomeMode=17; OL_Z_HomeOffset1=6.9329; OL_Z_HomingCurrLimit=50;           OL_Z_SRLIMIT=4.2;OL_Z_SLLIMIT=-1
!! OR_X_HomeVelocity=0.5 ; OR_X_HomeMode=17; OR_X_HomeOffset1=4.1314; OR_X_HomingCurrLimit=70;          OR_X_SRLIMIT=130;OR_X_SLLIMIT=79
! OR_X_HomeVelocity=1 ; OR_X_HomeMode=17; OR_X_HomeOffset1=5.1714; OR_X_HomingCurrLimit=70;          OR_X_SRLIMIT=150;OR_X_SLLIMIT=120
!! OR_Y_HomeVelocity=1 ; OR_Y_HomeMode=18; OR_Y_HomeOffset1=-26.46785; OR_Y_HomingCurrLimit=90;       OR_Y_SRLIMIT=20;OR_Y_SLLIMIT=-20
! OR_Y_HomeVelocity=1 ; OR_Y_HomeMode=18; OR_Y_HomeOffset1=-24.78485; OR_Y_HomingCurrLimit=90;       OR_Y_SRLIMIT=20;OR_Y_SLLIMIT=-20
! OR_Z_HomeVelocity=1 ; OR_Z_HomeMode=17; OR_Z_HomeOffset1=7.7927; OR_Z_HomingCurrLimit=50;             OR_Z_SRLIMIT=4.2;OR_Z_SLLIMIT=-1
! TWLP_HomeVelocity=1 ; TWLP_HomeMode=18; TWLP_HomeOffset1=0; TWLP_HomingCurrLimit=50;                 TWLP_SRLIMIT=0.1;TWLP_SLLIMIT=-26
! BWLP_HomeVelocity=1 ; BWLP_HomeMode=17; BWLP_HomeOffset1=0; BWLP_HomingCurrLimit=50;                 BWLP_SRLIMIT=50;BWLP_SLLIMIT=-0.2
! TT_X1_HomeVelocity=0.2 ; TT_X1_HomeMode=17; TT_X1_HomeOffset1=-1.307467; TT_X1_HomingCurrLimit=50;       TT_X1_SRLIMIT=1;TT_X1_SLLIMIT=-1
! TT_X0_HomeVelocity=0.2 ; TT_X0_HomeMode=17; TT_X0_HomeOffset1=-1.44235; TT_X0_HomingCurrLimit=50;      TT_X0_SRLIMIT=1;TT_X0_SLLIMIT=-1
! BT_X0_HomeVelocity=0.2 ; BT_X0_HomeMode=18; BT_X0_HomeOffset1=1.387542; BT_X0_HomingCurrLimit=50;        BT_X0_SRLIMIT=1;BT_X0_SLLIMIT=-1
!! BT_X1_HomeVelocity=0.2 ; BT_X1_HomeMode=18; BT_X1_HomeOffset1=1.0953418; BT_X1_HomingCurrLimit=30;        BT_X1_SRLIMIT=1;BT_X1_SLLIMIT=-1
! BT_X1_HomeVelocity=0.2 ; BT_X1_HomeMode=18; BT_X1_HomeOffset1=1.24029; BT_X1_HomingCurrLimit=30;        BT_X1_SRLIMIT=1;BT_X1_SLLIMIT=-1
! SLA_Y0_HomeVelocity=1 ; SLA_Y0_HomeMode=17; SLA_Y0_HomeOffset1=4.5219; SLA_Y0_HomingCurrLimit=50;    SLA_Y0_SRLIMIT=8;SLA_Y0_SLLIMIT=-0.2
! SLA_Y1_HomeVelocity=1 ; SLA_Y1_HomeMode=17; SLA_Y1_HomeOffset1=2.7703; SLA_Y1_HomingCurrLimit=50;    SLA_Y1_SRLIMIT=8;SLA_Y1_SLLIMIT=-0.2
! BC_Z0_HomeVelocity=1 ; BC_Z0_HomeMode=17; BC_Z0_HomeOffset1=0; BC_Z0_HomingCurrLimit=50;         BC_Z0_SRLIMIT=3.5;BC_Z0_SLLIMIT=-0.01;
! BC_Z1_HomeVelocity=1 ; BC_Z1_HomeMode=17; BC_Z1_HomeOffset1=0; BC_Z1_HomingCurrLimit=50;         BC_Z1_SRLIMIT=3.5;BC_Z1_SLLIMIT=-0.01
! BC_Z2_HomeVelocity=1 ; BC_Z2_HomeMode=17; BC_Z2_HomeOffset1=0; BC_Z2_HomingCurrLimit=50;         BC_Z2_SRLIMIT=3.5;BC_Z2_SLLIMIT=-0.01
!
!SRLIMIT(TT_Y0)=TT_Y0_SRLIMIT;SLLIMIT(TT_Y0)=TT_Y0_SLLIMIT
!SRLIMIT(BT_Y0)=BT_Y0_SRLIMIT;SLLIMIT(BT_Y0)=BT_Y0_SLLIMIT
!SRLIMIT(BC_Z0)=BC_Z0_SRLIMIT;SLLIMIT(BC_Z0)=BC_Z0_SLLIMIT
!SRLIMIT(BC_Z1)=BC_Z1_SRLIMIT;SLLIMIT(BC_Z1)=BC_Z1_SLLIMIT
!SRLIMIT(BC_Z2)=BC_Z2_SRLIMIT;SLLIMIT(BC_Z2)=BC_Z2_SLLIMIT
!SRLIMIT(SLA_Y0)=SLA_Y0_SRLIMIT;SLLIMIT(SLA_Y0)=SLA_Y0_SLLIMIT
!SRLIMIT(SLA_Y0)=SLA_Y0_SRLIMIT;SLLIMIT(SLA_Y1)=SLA_Y0_SLLIMIT
!SRLIMIT(TT_X0)=TT_X0_SRLIMIT;SLLIMIT(TT_X0)=TT_X0_SLLIMIT
!SRLIMIT(TT_X1)=TT_X1_SRLIMIT;SLLIMIT(TT_X1)=TT_X1_SLLIMIT
!SRLIMIT(BT_X0)=BT_X0_SRLIMIT;SLLIMIT(BT_X0)=BT_X0_SLLIMIT
!SRLIMIT(BT_X1)=BT_X1_SRLIMIT;SLLIMIT(BT_X1)=BT_X1_SLLIMIT
!SRLIMIT(OL_X)=OL_X_SRLIMIT;SLLIMIT(OL_X)=OL_X_SLLIMIT
!SRLIMIT(OL_Y)=OL_Y_SRLIMIT;SLLIMIT(OL_Y)=OL_Y_SLLIMIT
!SRLIMIT(OL_Z)=OL_Z_SRLIMIT;SLLIMIT(OL_Z)=OL_Z_SLLIMIT
!SRLIMIT(OR_X)=OR_X_SRLIMIT;SLLIMIT(OR_X)=OR_X_SLLIMIT
!SRLIMIT(OR_Y)=OR_Y_SRLIMIT;SLLIMIT(OR_Y)=OR_Y_SLLIMIT
!SRLIMIT(OR_Z)=OR_Z_SRLIMIT;SLLIMIT(OR_Z)=OR_Z_SLLIMIT
!SRLIMIT(TWLP)=TWLP_SRLIMIT;SLLIMIT(TWLP)=TWLP_SLLIMIT
!SRLIMIT(BWLP)=BWLP_SRLIMIT;SLLIMIT(BWLP)=BWLP_SLLIMIT
!----------ModBus Init
CONID=1
setconf(309,0,1) !Hi word first, then Low word


!---------Init Flag
RebootFlag=1
STOP
#4
!PNAME=PLC-IN
!PDESC=

!----------------MODBUS EVENT--------------
WAIT 5000
AUTOEXEC:
INT JOGMove(32)
INT StartTime;
INT TICK_TIME(32);
INT AXISNUM;

!!!!!!WANGFEI 12.1
LOCAL STARTTIME, CASTTIME;
STARTTIME = TIME;
!!!!!!WANGFEI 12.1

VOID CheckAxisPara(INT AxisIndex);
INT CheckAxisLimit(INT AxisIndex);
VOID PLC_RunMotin(INT AxisIndex);
REAL CRETIME

WHILE 1

!	IF Initialize = 1
!		FILL(0, HomeFlags)
!	END

!AXISNUM = CurrentAxisNum;
	SWITCH CurrentAxisNum
		CASE 0:! TT_Y0

!!!!!!!!Motor Command Convert!!!!!!!!!!!!!!!!!!
!0.enable/disable motor
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_Y0)).0 = 1) & ^MST(TT_Y0).#ENABLED
				ENABLE TT_Y0;
				DISP "PLC_CMD: ENABLE TT_Y0"
			END
!1.disable motor
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_Y0)).1 = 1) & MST(TT_Y0).#ENABLED
				DISABLE TT_Y0;
				DISP "PLC_CMD: DISABLE TT_Y0"
			END
!2.home 
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_Y0)).2 = 1)
				DISP TIME
				WAIT 200
				IF ^PST(15).#RUN
					START 15, HOMING_TT_Gantry
				ELSE					
					STOP 15
					START 15, HOMING_TT_Gantry
				END
				DISP "PLC_CMD: HOMING_TT_Gantry"
			END
!3.JogP
			IF Axis_Control(GetPLC_AxisNumber(TT_Y0)).3 = 1 & Axis_Control(GetPLC_AxisNumber(TT_Y0)).7 <> 1 & ^MST(TT_Y0).#MOVE
				JOGMove(TT_Y0) = 1
				WAIT 10
				CheckAxisPara(TT_Y0)
				DISP "PLC_CMD: TT_Y0 JOG+"
				JOG TT_Y0,+ 
			ELSEIF Axis_Control(GetPLC_AxisNumber(TT_Y0)).3 = 0 & JOGMove(TT_Y0) = 1
				JOGMove(TT_Y0) = 0
				KILL TT_Y0
			END
!4.JogN
			IF Axis_Control(GetPLC_AxisNumber(TT_Y0)).4 = 1 & Axis_Control(GetPLC_AxisNumber(TT_Y0)).7 <> 1 & ^MST(TT_Y0).#MOVE
				JOGMove(TT_Y0) = 2
				WAIT 10
				CheckAxisPara(TT_Y0)
				DISP "PLC_CMD: TT_Y0 JOG-"
				JOG TT_Y0,- 
			ELSEIF Axis_Control(GetPLC_AxisNumber(TT_Y0)).4 = 0 & JOGMove(TT_Y0) = 2
				JOGMove(TT_Y0) = 0
				KILL TT_Y0
			END
!5.abs
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_Y0)).5 = 1) & Axis_Control(GetPLC_AxisNumber(TT_Y0)).7 <> 1 & ^MST(TT_Y0).#MOVE
				WAIT 10
				CheckAxisPara(TT_Y0)
				IF CheckAxisLimit(TT_Y0)=1
				PLC_RunMotin(TT_Y0)
				END
			END
!6.inc
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_Y0)).6 = 1) & Axis_Control(GetPLC_AxisNumber(TT_Y0)).7 <> 1 & ^MST(TT_Y0).#MOVE
				WAIT 10
				CheckAxisPara(TT_Y0)
				IF CheckAxisLimit(TT_Y0)=1
				PLC_RunMotin(TT_Y0)
			END
!7.STOP
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_Y0)).7 = 1)
				KILLALL;
			END

		END! CASE 0

		CASE 1:! TT_Y1
			IF EDGE(AxisGourpMove.1 = 1) & MST(BC_Z0).#ENABLED& MST(BC_Z1).#ENABLED& MST(BC_Z2).#ENABLED
			WAIT 10
			IF 0 < AxisGourp_BC_Z0_Vel & AxisGourp_BC_Z0_Vel <= XVEL(BC_Z0)
				PTP/V(BC_Z0, BC_Z1, BC_Z2), AxisGourp_BC_Z0_Pos, AxisGourp_BC_Z1_Pos, AxisGourp_BC_Z2_Pos, AxisGourp_BC_Z0_Vel;
				DISP "PLC_CMD: AxisGourp_BC_Move;", AxisGourp_BC_Z0_Pos, AxisGourp_BC_Z1_Pos, AxisGourp_BC_Z2_Pos
			ELSE				
				DISP "PLC_CMD: AxisGourp_BC_Move ,SET VEL Exception;"
                OccurAlarm(AlarmCode_AxisGrop1ParaErro,Alarm_Tips)
				PTP/V(BC_Z0, BC_Z1, BC_Z2), AxisGourp_BC_Z0_Pos, AxisGourp_BC_Z1_Pos, AxisGourp_BC_Z2_Pos, AxisVel(BC_Z0);
			END
		END

		IF EDGE(AxisGourpMove.2 = 1) & MST(OL_X).#ENABLED& MST(OL_Y).#ENABLED& MST(OL_Z).#ENABLED& MST(OR_X).#ENABLED& MST(OR_Y).#ENABLED& MST(OR_Z).#ENABLED
			WAIT 10
			IF 0 < AxisGourp_Optic_Vel & AxisGourp_Optic_Vel <= XVEL(OL_X)
				PTP/V(OL_X, OL_Y, OL_Z, OR_X, OR_Y, OR_Z), AxisGourp_OL_X_Pos, AxisGourp_OL_Y_Pos, AxisGourp_OL_Z_Pos, AxisGourp_OR_X_Pos, AxisGourp_OR_Y_Pos, AxisGourp_OR_Z_Pos, AxisGourp_Optic_Vel;
				DISP "PLC_CMD: OpticAxisGourp MOVE ,",AxisGourp_OL_X_Pos, AxisGourp_OL_Y_Pos, AxisGourp_OL_Z_Pos, AxisGourp_OR_X_Pos, AxisGourp_OR_Y_Pos, AxisGourp_OR_Z_Pos, AxisGourp_Optic_Vel
			ELSE
			    OccurAlarm(AlarmCode_AxisGrop2ParaErro,Alarm_Tips)
				DISP "PLC_CMD: OpticAxisGourp ,SET VEL Exception;"				
				PTP/V(OL_X, OL_Y, OL_Z, OR_X, OR_Y, OR_Z), AxisGourp_OL_X_Pos, AxisGourp_OL_Y_Pos, AxisGourp_OL_Z_Pos, AxisGourp_OR_X_Pos, AxisGourp_OR_Y_Pos, AxisGourp_OR_Z_Pos, AxisVel(OL_X);
			END
		END

		IF EDGE(AxisGourpMove.3 = 1) & MST(TT_X0).#ENABLED& MST(TT_X1).#ENABLED
			WAIT 10
			IF 0 < AxisGourp_UpTableX_Vel & AxisGourp_UpTableX_Vel <= XVEL(TT_X0)
				PTP/V(TT_X0, TT_X1), AxisGourp_TT_X0_Pos, AxisGourp_TT_X1_Pos, AxisGourp_UpTableX_Vel
				DISP "PLC_CMD: AxisGourp3_TT_X;", AxisGourp_TT_X0_Pos, AxisGourp_TT_X1_Pos, AxisGourp_UpTableX_Vel
			ELSE	
			    OccurAlarm(AlarmCode_AxisGrop3ParaErro,Alarm_Tips)
			    DISP "PLC_CMD: AxisGourp3_TT_X ,SET VEL Exception;"		
				PTP/V(TT_X0, TT_X1), AxisGourp_TT_X0_Pos, AxisGourp_TT_X1_Pos, AxisVel(TT_X0)
			END
		END

		IF EDGE(AxisGourpMove.4 = 1) & MST(BT_X0).#ENABLED& MST(BT_X1).#ENABLED
			WAIT 10
			IF 0 < AxisGourp_DownTableX_Vel & AxisGourp_DownTableX_Vel <= VEL(BT_X0)
				PTP/V(BT_X0, BT_X1), AxisGourp_BT_X0_Pos, AxisGourp_BT_X1_Pos, AxisGourp_DownTableX_Vel
				DISP "PLC_CMD: AxisGourp34_BT_X;", AxisGourp_BT_X0_Pos, AxisGourp_BT_X1_Pos, AxisGourp_DownTableX_Vel
			ELSE		
			    OccurAlarm(AlarmCode_AxisGrop4ParaErro,Alarm_Tips)
			    DISP "PLC_CMD: AxisGourp4_BT_X ,SET VEL Exception;"			
				PTP/V(BT_X0, BT_X1), AxisGourp_BT_X0_Pos, AxisGourp_BT_X1_Pos, AxisVel(BT_X0)
			END
		END

		IF EDGE(AxisGourpMove.5 = 1) & MST(TT_Y0).#ENABLED& MST(BT_Y0).#ENABLED
			WAIT 10
			IF 0 < AxisGourp_Gantry_Vel & AxisGourp_Gantry_Vel <= XVEL(TT_Y0)
				PTP/V(TT_Y0, BT_Y0), AxisGourp_TT_Y0_Pos, AxisGourp_BT_Y0_Pos, AxisGourp_Gantry_Vel
				DISP "PLC_CMD: AxisGourp5_TABLE;", AxisGourp_TT_Y0_Pos, AxisGourp_BT_Y0_Pos, AxisGourp_Gantry_Vel
			ELSE	
			    OccurAlarm(AlarmCode_AxisGrop5ParaErro,Alarm_Tips)
			    DISP "PLC_CMD: AxisGourp5_TABLE ,SET VEL Exception;"			
				PTP/V(TT_Y0, BT_Y0), AxisGourp_TT_Y0_Pos, AxisGourp_BT_Y0_Pos, AxisVel(TT_Y0)	
				DISP "PLC_CMD: AxisGourp5_TABLE;", AxisGourp_TT_Y0_Pos, AxisGourp_BT_Y0_Pos, AxisGourp_Gantry_Vel
			END
		END

		IF EDGE(AxisGourpMove.6 = 1) & MST(SLA_Y0).#ENABLED& MST(SLA_Y1).#ENABLED
			WAIT 10
			IF 0 < AxisGourp_SLA_Vel & AxisGourp_SLA_Vel <= XVEL(SLA_Y0)
				PTP/V(SLA_Y0, SLA_Y1), AxisGourp_SLA_Y0_Pos, AxisGourp_SLA_Y1_Pos, AxisGourp_SLA_Vel
				DISP "PLC_CMD: AxisGourp6_PEC;", AxisGourp_SLA_Y0_Pos, AxisGourp_SLA_Y1_Pos, AxisGourp_SLA_Vel
			ELSE
			    OccurAlarm(AlarmCode_AxisGrop6ParaErro,Alarm_Tips)
			    DISP "PLC_CMD: AxisGourp6_PEC ,SET VEL Exception;"				
				PTP/V(SLA_Y0, SLA_Y1), AxisGourp_SLA_Y0_Pos, AxisGourp_SLA_Y1_Pos, AxisVel(SLA_Y0)
				DISP "PLC_CMD: AxisGourp6_PEC;", AxisGourp_SLA_Y0_Pos, AxisGourp_SLA_Y1_Pos, AxisGourp_SLA_Vel
			END
		END

		IF EDGE(AxisGourpMove.7 = 1)
			IF 0 < AxisGourp_OpticZ_Vel & AxisGourp_OpticZ_Vel <= XVEL(OL_Z)
				PTP/V(OL_Z, OR_Z), AxisGourp_OL_Z1_Pos, AxisGourp_OR_Z1_Pos, AxisGourp_OpticZ_Vel
				DISP "PLC_CMD: AxisGourp7_OpticZ;", AxisGourp_OL_Z1_Pos, AxisGourp_OR_Z1_Pos, AxisGourp_OpticZ_Vel
			ELSE	
			    OccurAlarm(AlarmCode_AxisGrop7ParaErro,Alarm_Tips)
			    DISP "PLC_CMD: AxisGourp7_OpticZ ,SET VEL Exception;"			
				PTP/V(OL_Z, OR_Z), AxisGourp_OL_Z1_Pos, AxisGourp_OR_Z1_Pos, AxisVel(OL_Z)
				DISP "PLC_CMD: AxisGourp7_OpticZ;", AxisGourp_OL_Z1_Pos, AxisGourp_OR_Z1_Pos, AxisGourp_OpticZ_Vel
			END
		END

		IF EDGE(AxisGourpMove.13 = 1) & MST(OL_X).#ENABLED& MST(OL_Y).#ENABLED& MST(OL_Z).#ENABLED& MST(OR_X).#ENABLED& MST(OR_Y).#ENABLED& MST(OR_Z).#ENABLED& MST(TT_Y0).#ENABLED& MST(BT_Y0).#ENABLED
			IF (0 < AxisGourp_Optic_Vel & AxisGourp_Optic_Vel <= XVEL(OL_X)) & (0 < AxisGourp_Gantry_Vel & AxisGourp_Gantry_Vel <= XVEL(TT_Y0))
				PTP/V OL_Y, AxisGourp_OL_Y_Pos, AxisGourp_Optic_Vel
				TILL ^MST(OL_Y).#MOVE
				PTP/V OL_X, AxisGourp_OL_X_Pos, AxisGourp_Optic_Vel
				PTP/V OL_Z, AxisGourp_OL_Z_Pos, AxisGourp_Optic_Vel
				PTP/V OR_X, AxisGourp_OR_X_Pos, AxisGourp_Optic_Vel
				PTP/V OR_Y, AxisGourp_OR_Y_Pos, AxisGourp_Optic_Vel
				PTP/V OR_Z, AxisGourp_OR_Z_Pos, AxisGourp_Optic_Vel
				PTP/V(TT_Y0, BT_Y0), AxisGourp_TT_Y0_Pos, AxisGourp_BT_Y0_Pos, AxisVel(TT_Y0)
				DISP "PLC_CMD: AxisGourp13_Optic&Table;", AxisGourp_OL_X_Pos, AxisGourp_OL_Y_Pos, AxisGourp_OL_Z_Pos,AxisGourp_OR_X_Pos,AxisGourp_OR_Y_Pos,AxisGourp_OR_Z_Pos,AxisGourp_TT_Y0_Pos,AxisGourp_BT_Y0_Pos
			ELSE		
			    OccurAlarm(AlarmCode_AxisGrop13ParaErro,Alarm_Tips)
			    DISP "PLC_CMD: AxisGourp13_Optic&Table ,SET VEL Exception;"	
						
				PTP/V OL_Y, AxisGourp_OL_Y_Pos, AxisVel(OL_X)
				TILL ^MST(OL_Y).#MOVE
				PTP/V OL_X, AxisGourp_OL_X_Pos, AxisVel(OL_X)
				PTP/V OL_Z, AxisGourp_OL_Z_Pos, AxisVel(OL_X)
				PTP/V OR_X, AxisGourp_OR_X_Pos, AxisVel(OL_X)
				PTP/V OR_Y, AxisGourp_OR_Y_Pos, AxisVel(OL_X)
				PTP/V OR_Z, AxisGourp_OR_Z_Pos, AxisVel(OL_X)
				PTP/V(TT_Y0, BT_Y0), AxisGourp_TT_Y0_Pos, AxisGourp_BT_Y0_Pos, AxisVel(TT_Y0)
				DISP "PLC_CMD: AxisGourp13_Optic&Table;", AxisGourp_OL_X_Pos, AxisGourp_OL_Y_Pos, AxisGourp_OL_Z_Pos,AxisGourp_OR_X_Pos,AxisGourp_OR_Y_Pos,AxisGourp_OR_Z_Pos,AxisGourp_TT_Y0_Pos,AxisGourp_BT_Y0_Pos
				
			END
		END

		IF EDGE(AxisGourpMove.12 = 1)
			INT j = 0
			LOOP 25
				MFLAGS(j).#HOME= 0
				PA_HomeStatus(j) = 0
				j++ 
			END
		END
		END! CASE 1

		CASE 2:! BT_Y0
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_Y0)).0 = 1) & ^MST(BT_Y0).#ENABLED
				ENABLE BT_Y0;
				DISP "PLC_CMD: ENABLE BT_Y0"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_Y0)).1 = 1) & MST(BT_Y0).#ENABLED
				DISABLE BT_Y0;
				DISP "PLC_CMD: DISABLE BT_Y0"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_Y0)).2 = 1)
				WAIT 200
				IF ^PST(16).#RUN
					START 16, HOMING_BT_Gantry
				ELSE					
					STOP 16
					START 16, HOMING_BT_Gantry
				END
				DISP "PLC_CMD: HOMING_BT_Gantry"
			END
			IF Axis_Control(GetPLC_AxisNumber(BT_Y0)).3 = 1 & Axis_Control(GetPLC_AxisNumber(BT_Y0)).7 <> 1 & ^MST(BT_Y0).#MOVE
				JOGMove(BT_Y0) = 1
				WAIT 10
				CheckAxisPara(BT_Y0)
				JOG BT_Y0,+ 
				DISP "PLC_CMD: BT_Y0 JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(BT_Y0)).3 = 0 & JOGMove(BT_Y0) = 1
				JOGMove(BT_Y0) = 0
				KILL BT_Y0
			END
			IF Axis_Control(GetPLC_AxisNumber(BT_Y0)).4 = 1 & Axis_Control(GetPLC_AxisNumber(BT_Y0)).7 <> 1 & ^MST(BT_Y0).#MOVE
				JOGMove(BT_Y0) = 2
				WAIT 10
				CheckAxisPara(BT_Y0)
				JOG BT_Y0,- 
				DISP "PLC_CMD: BT_Y0 JOG-"
			ELSEIF Axis_Control(GetPLC_AxisNumber(BT_Y0)).4 = 0 & JOGMove(BT_Y0) = 2
				KILL BT_Y0
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_Y0)).5 = 1) & Axis_Control(GetPLC_AxisNumber(BT_Y0)).7 <> 1 & ^MST(BT_Y0).#MOVE
				WAIT 10
				CheckAxisPara(BT_Y0)
				IF CheckAxisLimit(BT_Y0)=1
				PLC_RunMotin(BT_Y0)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_Y0)).6 = 1) & Axis_Control(GetPLC_AxisNumber(BT_Y0)).7 <> 1 & ^MST(BT_Y0).#MOVE
				WAIT 10
				CheckAxisPara(BT_Y0)
				IF CheckAxisLimit(BT_Y0)=1
				PLC_RunMotin(BT_Y0)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_Y0)).7 = 1)
				KILLALL;
			END
		END

		CASE 3:
!NOT NEED
		END

		CASE 4:! BC_Z0
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BC_Z0)).0 = 1) & ^MST(BC_Z0).#ENABLED
				ENABLE BC_Z0;
				DISP "PLC_CMD: ENABLE BC_Z0"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BC_Z0)).1 = 1) & MST(BC_Z0).#ENABLED
				DISABLE BC_Z0;
				DISP "PLC_CMD: DISABLE BC_Z0"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BC_Z0)).2 = 1)
				WAIT 200
				IF ^PST(17).#RUN
					START 17, HOMING_BC_ALL
				ELSE					
					STOP 17
					START 17, HOMING_BC_ALL
				END
				DISP "PLC_CMD: HOMING_BC_ALL"
			END
			IF Axis_Control(GetPLC_AxisNumber(BC_Z0)).3 = 1 & Axis_Control(GetPLC_AxisNumber(BC_Z0)).7 <> 1 & ^MST(BC_Z0).#MOVE
				JOGMove(BC_Z0) = 1
				WAIT 10
				CheckAxisPara(BC_Z0)
				JOG BC_Z0,+ 
				DISP "PLC_CMD: BC_Z0 JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(BC_Z0)).3 = 0 & JOGMove(BC_Z0) = 1
				JOGMove(BC_Z0) = 0
				KILL BC_Z0
			END
			IF Axis_Control(GetPLC_AxisNumber(BC_Z0)).4 = 1 & Axis_Control(GetPLC_AxisNumber(BC_Z0)).7 <> 1 & ^MST(BC_Z0).#MOVE
				JOGMove(BC_Z0) = 2
				WAIT 10
				CheckAxisPara(BC_Z0)
				JOG BC_Z0,- 
				DISP "PLC_CMD: BC_Z0 JOG-"
			ELSEIF Axis_Control(GetPLC_AxisNumber(BC_Z0)).4 = 0 & JOGMove(BC_Z0) = 2
				JOGMove(BC_Z0) = 0
				KILL BC_Z0
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BC_Z0)).5 = 1) & Axis_Control(GetPLC_AxisNumber(BC_Z0)).7 <> 1 & ^MST(BC_Z0).#MOVE
				WAIT 10
				CheckAxisPara(BC_Z0)
				IF CheckAxisLimit(BC_Z0)=1
				PLC_RunMotin(BC_Z0)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BC_Z0)).6 = 1) & Axis_Control(GetPLC_AxisNumber(BC_Z0)).7 <> 1 & ^MST(BC_Z0).#MOVE
				WAIT 10
				CheckAxisPara(BC_Z0)
				IF CheckAxisLimit(BC_Z0)=1
				PLC_RunMotin(BC_Z0)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BC_Z0)).7 = 1)
				KILLALL;
			END
		END

		CASE 5:! BC_Z1
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BC_Z1)).0 = 1) & ^MST(BC_Z1).#ENABLED
				ENABLE BC_Z1;
				DISP "PLC_CMD: ENABLE BC_Z1"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BC_Z1)).1 = 1) & MST(BC_Z1).#ENABLED
				DISABLE BC_Z1;
				DISP "PLC_CMD: DISABLE BC_Z1"
			END
			IF (Axis_Control(GetPLC_AxisNumber(BC_Z1)).2 = 1)
				Axis_Control(GetPLC_AxisNumber(BC_Z1)).2 = 0
			END
			IF Axis_Control(GetPLC_AxisNumber(BC_Z1)).3 = 1 & Axis_Control(GetPLC_AxisNumber(BC_Z1)).7 <> 1 & ^MST(BC_Z1).#MOVE
				JOGMove(BC_Z1) = 1
				WAIT 10
				CheckAxisPara(BC_Z1)
				JOG BC_Z1,+ 
				DISP "PLC_CMD: BC_Z1 JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(BC_Z1)).3 = 0 & JOGMove(BC_Z1) = 1
				JOGMove(BC_Z1) = 0
				KILL BC_Z1
			END
			IF Axis_Control(GetPLC_AxisNumber(BC_Z1)).4 = 1 & Axis_Control(GetPLC_AxisNumber(BC_Z1)).7 <> 1 & ^MST(BC_Z1).#MOVE
				JOGMove(BC_Z1) = 2
				WAIT 10
				CheckAxisPara(BC_Z1)
				JOG BC_Z1,- 
				DISP "PLC_CMD: BC_Z1 JOG-"
			ELSEIF Axis_Control(GetPLC_AxisNumber(BC_Z1)).4 = 0 & JOGMove(BC_Z1) = 2
				JOGMove(BC_Z1) = 0
				KILL BC_Z1
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BC_Z1)).5 = 1) & Axis_Control(GetPLC_AxisNumber(BC_Z1)).7 <> 1 & ^MST(BC_Z1).#MOVE
				WAIT 10
				CheckAxisPara(BC_Z1)
				IF CheckAxisLimit(BC_Z1)=1
				PLC_RunMotin(BC_Z1)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BC_Z1)).6 = 1) & Axis_Control(GetPLC_AxisNumber(BC_Z1)).7 <> 1 & ^MST(BC_Z1).#MOVE
				WAIT 10
				CheckAxisPara(BC_Z1)
				IF CheckAxisLimit(BC_Z1)=1
				PLC_RunMotin(BC_Z1)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BC_Z1)).7 = 1)
				KILLALL;
			END
		END

		CASE 6:! BC_Z2
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BC_Z2)).0 = 1) & ^MST(BC_Z2).#ENABLED
				ENABLE BC_Z2;
				DISP "PLC_CMD: ENABLE BC_Z2"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BC_Z2)).1 = 1) & MST(BC_Z2).#ENABLED
				DISABLE BC_Z2;
				DISP "PLC_CMD: DISABLE BC_Z2"
			END
			IF (Axis_Control(GetPLC_AxisNumber(BC_Z2)).2 = 1)
				Axis_Control(GetPLC_AxisNumber(BC_Z2)).2 = 0
			END
			IF Axis_Control(GetPLC_AxisNumber(BC_Z2)).3 = 1 & Axis_Control(GetPLC_AxisNumber(BC_Z2)).7 <> 1 & ^MST(BC_Z2).#MOVE
				JOGMove(BC_Z2) = 1
				WAIT 10
				CheckAxisPara(BC_Z2)
				JOG BC_Z2,+ 
				DISP "PLC_CMD: BC_Z2 JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(BC_Z2)).3 = 0 & JOGMove(BC_Z2) = 1
				JOGMove(BC_Z2) = 0
				KILL BC_Z2
			END
			IF Axis_Control(GetPLC_AxisNumber(BC_Z2)).4 = 1 & Axis_Control(GetPLC_AxisNumber(BC_Z2)).7 <> 1 & ^MST(BC_Z2).#MOVE
				JOGMove(BC_Z2) = 2
				WAIT 10
				CheckAxisPara(BC_Z2)
				JOG BC_Z2,- 
				DISP "PLC_CMD: BC_Z2 JOG-"
			ELSEIF Axis_Control(GetPLC_AxisNumber(BC_Z2)).4 = 0 & JOGMove(BC_Z2) = 2
				JOGMove(BC_Z2) = 0
				KILL BC_Z2
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BC_Z2)).5 = 1) & Axis_Control(GetPLC_AxisNumber(BC_Z2)).7 <> 1 & ^MST(BC_Z2).#MOVE
				WAIT 10
				CheckAxisPara(BC_Z2)
				IF CheckAxisLimit(BC_Z2)=1
				PLC_RunMotin(BC_Z2)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BC_Z2)).6 = 1) & Axis_Control(GetPLC_AxisNumber(BC_Z2)).7 <> 1 & ^MST(BC_Z2).#MOVE
				WAIT 10
				CheckAxisPara(BC_Z2)
				IF CheckAxisLimit(BC_Z2)=1
				PLC_RunMotin(BC_Z2)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BC_Z2)).7 = 1)
				KILLALL;
			END
		END

		CASE 8:! SLA_Y0
			IF EDGE(Axis_Control(GetPLC_AxisNumber(SLA_Y0)).0 = 1) & ^MST(SLA_Y0).#ENABLED
				ENABLE SLA_Y0;
				DISP "PLC_CMD: ENABLE SLA_Y0"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(SLA_Y0)).1 = 1) & MST(SLA_Y0).#ENABLED
				DISABLE SLA_Y0;
				DISP "PLC_CMD: DISABLE SLA_Y0"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(SLA_Y0)).2 = 1)
				WAIT 200
				IF ^PST(18).#RUN
					START 18, HOMING_SLA_Y0
				ELSE					
					STOP 18
					START 18, HOMING_SLA_Y0
				END
				DISP "PLC_CMD: HOMING_SLA_Y0"
			END
			IF Axis_Control(GetPLC_AxisNumber(SLA_Y0)).3 = 1 & Axis_Control(GetPLC_AxisNumber(SLA_Y0)).7 <> 1 & ^MST(SLA_Y0).#MOVE
				JOGMove(SLA_Y0) = 1
				WAIT 10
				CheckAxisPara(SLA_Y0)
				JOG SLA_Y0,+ 
				DISP "PLC_CMD: SLA_Y0 JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(SLA_Y0)).3 = 0 & JOGMove(SLA_Y0) = 1
				JOGMove(SLA_Y0) = 0
				KILL SLA_Y0
			END
			IF Axis_Control(GetPLC_AxisNumber(SLA_Y0)).4 = 1 & Axis_Control(GetPLC_AxisNumber(SLA_Y0)).7 <> 1 & ^MST(SLA_Y0).#MOVE
				JOGMove(SLA_Y0) = 2
				WAIT 10
				CheckAxisPara(SLA_Y0)
				JOG SLA_Y0,- 
				DISP "PLC_CMD: SLA_Y0 JOG-"
			ELSEIF Axis_Control(GetPLC_AxisNumber(SLA_Y0)).4 = 0 & JOGMove(SLA_Y0) = 2
				JOGMove(SLA_Y0) = 0
				KILL SLA_Y0
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(SLA_Y0)).5 = 1) & Axis_Control(GetPLC_AxisNumber(SLA_Y0)).7 <> 1 & ^MST(SLA_Y0).#MOVE
				WAIT 10
				CheckAxisPara(SLA_Y0)
				IF CheckAxisLimit(SLA_Y0)=1
				PLC_RunMotin(SLA_Y0)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(SLA_Y0)).6 = 1) & Axis_Control(GetPLC_AxisNumber(SLA_Y0)).7 <> 1 & ^MST(SLA_Y0).#MOVE
				WAIT 10
				CheckAxisPara(SLA_Y0)
				IF CheckAxisLimit(SLA_Y0)=1
				PLC_RunMotin(SLA_Y0)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(SLA_Y0)).7 = 1)
				KILLALL;
			END
		END

		CASE 9:! SLA_Y1
			IF EDGE(Axis_Control(GetPLC_AxisNumber(SLA_Y1)).0 = 1) & ^MST(SLA_Y1).#ENABLED
				ENABLE SLA_Y1;
				DISP "PLC_CMD: ENABLE SLA_Y1"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(SLA_Y1)).1 = 1) & MST(SLA_Y1).#ENABLED
				DISABLE SLA_Y1;
				DISP "PLC_CMD: DISABLE SLA_Y1"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(SLA_Y1)).2 = 1)
				WAIT 200
				IF ^PST(19).#RUN
					START 19, HOMING_SLA_Y1
				ELSE					
					STOP 19
					START 19, HOMING_SLA_Y1
				END
				DISP "PLC_CMD: HOMING_SLA_Y1"
			END
			IF Axis_Control(GetPLC_AxisNumber(SLA_Y1)).3 = 1 & Axis_Control(GetPLC_AxisNumber(SLA_Y1)).7 <> 1 & ^MST(SLA_Y1).#MOVE
				JOGMove(SLA_Y1) = 1
				WAIT 10
				CheckAxisPara(SLA_Y1)
				JOG SLA_Y1,+ 
				DISP "PLC_CMD: SLA_Y1 JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(SLA_Y1)).3 = 0 & JOGMove(SLA_Y1) = 1
				JOGMove(SLA_Y1) = 0
				KILL SLA_Y1
			END
			IF Axis_Control(GetPLC_AxisNumber(SLA_Y1)).4 = 1 & Axis_Control(GetPLC_AxisNumber(SLA_Y1)).7 <> 1 & ^MST(SLA_Y1).#MOVE
				JOGMove(SLA_Y1) = 2
				WAIT 10
				CheckAxisPara(SLA_Y1)
				JOG SLA_Y1,- 
				DISP "PLC_CMD: SLA_Y1 JOG-"
			ELSEIF Axis_Control(GetPLC_AxisNumber(SLA_Y1)).4 = 0 & JOGMove(SLA_Y1) = 2
				JOGMove(SLA_Y1) = 0
				KILL SLA_Y1
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(SLA_Y1)).5 = 1) & Axis_Control(GetPLC_AxisNumber(SLA_Y1)).7 <> 1 & ^MST(SLA_Y1).#MOVE
				WAIT 10
				CheckAxisPara(SLA_Y1)
				IF CheckAxisLimit(SLA_Y1)=1
				PLC_RunMotin(SLA_Y1)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(SLA_Y1)).6 = 1) & Axis_Control(GetPLC_AxisNumber(SLA_Y1)).7 <> 1 & ^MST(SLA_Y1).#MOVE
				WAIT 10
				CheckAxisPara(SLA_Y1)
				IF CheckAxisLimit(SLA_Y1)=1
				PLC_RunMotin(SLA_Y1)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(SLA_Y1)).7 = 1)
				KILLALL;
			END
		END

		CASE 10:! TT_X0
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_X0)).0 = 1) & ^MST(TT_X0).#ENABLED
				ENABLE TT_X0;
				DISP "PLC_CMD: ENABLE TT_X0"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_X0)).1 = 1) & MST(TT_X0).#ENABLED
				DISABLE TT_X0;
				DISP "PLC_CMD: DISABLE TT_X0"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_X0)).2 = 1)
				WAIT 200
				IF ^PST(20).#RUN
					START 20, HOMING_TT_X0
				ELSE					
					STOP 20
					START 20, HOMING_TT_X0
				END
				DISP "PLC_CMD: HOMING_TT_X0"
			END
			IF Axis_Control(GetPLC_AxisNumber(TT_X0)).3 = 1 & Axis_Control(GetPLC_AxisNumber(TT_X0)).7 <> 1 & ^MST(TT_X0).#MOVE
				JOGMove(TT_X0) = 1
				WAIT 10
				CheckAxisPara(TT_X0)
				JOG TT_X0,+ 
				DISP "PLC_CMD: TT_X0 JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(TT_X0)).3 = 0 & JOGMove(TT_X0) = 1
				JOGMove(TT_X0) = 0
				KILL TT_X0
			END
			IF Axis_Control(GetPLC_AxisNumber(TT_X0)).4 = 1 & Axis_Control(GetPLC_AxisNumber(TT_X0)).7 <> 1 & ^MST(TT_X0).#MOVE
				JOGMove(TT_X0) = 2
				WAIT 10
				CheckAxisPara(TT_X0)
				JOG TT_X0,- 
				DISP "PLC_CMD: TT_X0 JOG-"
			ELSEIF Axis_Control(GetPLC_AxisNumber(TT_X0)).4 = 0 & JOGMove(TT_X0) = 2
				JOGMove(TT_X0) = 0
				KILL TT_X0
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_X0)).5 = 1) & Axis_Control(GetPLC_AxisNumber(TT_X0)).7 <> 1 & ^MST(TT_X0).#MOVE
				WAIT 10
				CheckAxisPara(TT_X0)
				IF CheckAxisLimit(TT_X0)=1
				PLC_RunMotin(TT_X0)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_X0)).6 = 1) & Axis_Control(GetPLC_AxisNumber(TT_X0)).7 <> 1 & ^MST(TT_X0).#MOVE
				WAIT 10
				CheckAxisPara(TT_X0)
				IF CheckAxisLimit(TT_X0)=1
				PLC_RunMotin(TT_X0)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_X0)).7 = 1)
				KILLALL;
			END
		END

		CASE 11:! TT_X1
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_X1)).0 = 1) & ^MST(TT_X1).#ENABLED
				ENABLE TT_X1;
				DISP "PLC_CMD: ENABLE TT_X1"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_X1)).1 = 1) & MST(TT_X1).#ENABLED
				DISABLE TT_X1;
				DISP "PLC_CMD: DISABLE TT_X1"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_X1)).2 = 1)
				WAIT 200
				IF ^PST(21).#RUN
					START 21, HOMING_TT_X1
				ELSE					
					STOP 21
					START 21, HOMING_TT_X1
				END
				DISP "PLC_CMD: HOMING_TT_X1"
			END
			IF Axis_Control(GetPLC_AxisNumber(TT_X1)).3 = 1 & Axis_Control(GetPLC_AxisNumber(TT_X1)).7 <> 1 & ^MST(TT_X1).#MOVE
				JOGMove(TT_X1) = 1
				WAIT 10
				CheckAxisPara(TT_X1)
				JOG TT_X1,+ 
				DISP "PLC_CMD: TT_X1 JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(TT_X1)).3 = 0 & JOGMove(TT_X1) = 1
				JOGMove(TT_X1) = 0
				KILL TT_X1
			END
			IF Axis_Control(GetPLC_AxisNumber(TT_X1)).4 = 1 & Axis_Control(GetPLC_AxisNumber(TT_X1)).7 <> 1 & ^MST(TT_X1).#MOVE
				JOGMove(TT_X1) = 2
				WAIT 10
				CheckAxisPara(TT_X1)
				JOG TT_X1,- 
				DISP "PLC_CMD: TT_X1 JOG-"
			ELSEIF Axis_Control(GetPLC_AxisNumber(TT_X1)).4 = 0 & JOGMove(TT_X1) = 2
				JOGMove(TT_X1) = 0
				KILL TT_X1
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_X1)).5 = 1) & Axis_Control(GetPLC_AxisNumber(TT_X1)).7 <> 1 & ^MST(TT_X1).#MOVE
				WAIT 10
				CheckAxisPara(TT_X1)
				IF CheckAxisLimit(TT_X1)=1
				PLC_RunMotin(TT_X1)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_X1)).6 = 1) & Axis_Control(GetPLC_AxisNumber(TT_X1)).7 <> 1 & ^MST(TT_X1).#MOVE
				WAIT 10
				CheckAxisPara(TT_X1)
				IF CheckAxisLimit(TT_X1)=1
				PLC_RunMotin(TT_X1)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TT_X1)).7 = 1)
				KILLALL;
			END
		END

		CASE 12:! BT_X0
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_X0)).0 = 1) & ^MST(BT_X0).#ENABLED
				ENABLE BT_X0;
				DISP "PLC_CMD: ENABLE BT_X0"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_X0)).1 = 1) & MST(BT_X0).#ENABLED
				DISABLE BT_X0;
				DISP "PLC_CMD: DISABLE BT_X0"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_X0)).2 = 1)
				WAIT 200
				IF ^PST(22).#RUN
					START 22, HOMING_BT_X0
				ELSE					
					STOP 22
					START 22, HOMING_BT_X0
				END
				DISP "PLC_CMD: HOMING_BT_X0"
			END
			IF Axis_Control(GetPLC_AxisNumber(BT_X0)).3 = 1 & Axis_Control(GetPLC_AxisNumber(BT_X0)).7 <> 1 & ^MST(BT_X0).#MOVE
				JOGMove(BT_X0) = 1
				WAIT 10
				CheckAxisPara(BT_X0)
				JOG BT_X0,+ 
				DISP "PLC_CMD: BT_X0 JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(BT_X0)).3 = 0 & JOGMove(BT_X0) = 1
				JOGMove(BT_X0) = 0
				KILL BT_X0
			END
			IF Axis_Control(GetPLC_AxisNumber(BT_X0)).4 = 1 & Axis_Control(GetPLC_AxisNumber(BT_X0)).7 <> 1 & ^MST(BT_X0).#MOVE
				JOGMove(BT_X0) = 2
				WAIT 10
				CheckAxisPara(BT_X0)
				JOG BT_X0,- 
				DISP "PLC_CMD: BT_X0 JOG-"
			ELSEIF Axis_Control(GetPLC_AxisNumber(BT_X0)).4 = 0 & JOGMove(BT_X0) = 2
				JOGMove(BT_X0) = 0
				KILL BT_X0
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_X0)).5 = 1) & Axis_Control(GetPLC_AxisNumber(BT_X0)).7 <> 1 & ^MST(BT_X0).#MOVE
				WAIT 10
				CheckAxisPara(BT_X0)
				IF CheckAxisLimit(BT_X0)=1
				PLC_RunMotin(BT_X0)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_X0)).6 = 1) & Axis_Control(GetPLC_AxisNumber(BT_X0)).7 <> 1 & ^MST(BT_X0).#MOVE
				WAIT 10
				CheckAxisPara(BT_X0)
				IF CheckAxisLimit(BT_X0)=1
				PLC_RunMotin(BT_X0)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_X0)).7 = 1)
				KILLALL;
			END
		END

		CASE 13:! BT_X1
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_X1)).0 = 1) & ^MST(BT_X1).#ENABLED
				ENABLE BT_X1;
				DISP "PLC_CMD: ENABLE BT_X1"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_X1)).1 = 1) & MST(BT_X1).#ENABLED
				DISABLE BT_X1;
				DISP "PLC_CMD: DISABLE BT_X1"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_X1)).2 = 1)
				WAIT 200
				IF ^PST(23).#RUN
					START 23, HOMING_BT_X1
				ELSE					
					STOP 23
					START 23, HOMING_BT_X1
				END
				DISP "PLC_CMD: HOMING_BT_X1"
			END
			IF Axis_Control(GetPLC_AxisNumber(BT_X1)).3 = 1 & Axis_Control(GetPLC_AxisNumber(BT_X1)).7 <> 1 & ^MST(BT_X1).#MOVE
				JOGMove(BT_X1) = 1
				WAIT 10
				CheckAxisPara(BT_X1)
				JOG BT_X1,+ 
				DISP "PLC_CMD: BT_X1 JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(BT_X1)).3 = 0 & JOGMove(BT_X1) = 1
				JOGMove(BT_X1) = 0
				KILL BT_X1
			END
			IF Axis_Control(GetPLC_AxisNumber(BT_X1)).4 = 1 & Axis_Control(GetPLC_AxisNumber(BT_X1)).7 <> 1 & ^MST(BT_X1).#MOVE
				JOGMove(BT_X1) = 2
				WAIT 10
				CheckAxisPara(BT_X1)
				JOG BT_X1,- 
				DISP "PLC_CMD: BT_X1 JOG-"
			ELSEIF Axis_Control(GetPLC_AxisNumber(BT_X1)).4 = 0 & JOGMove(BT_X1) = 2
				JOGMove(BT_X1) = 0
				KILL BT_X1
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_X1)).5 = 1) & Axis_Control(GetPLC_AxisNumber(BT_X1)).7 <> 1 & ^MST(BT_X1).#MOVE
				WAIT 10
				CheckAxisPara(BT_X1)
				IF CheckAxisLimit(BT_X1)=1
				PLC_RunMotin(BT_X1)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_X1)).6 = 1) & Axis_Control(GetPLC_AxisNumber(BT_X1)).7 <> 1 & ^MST(BT_X1).#MOVE
				WAIT 10
				CheckAxisPara(BT_X1)
				IF CheckAxisLimit(BT_X1)=1
				PLC_RunMotin(BT_X1)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BT_X1)).7 = 1)
				KILLALL;
			END
		END

		CASE 14:! OL_X
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_X)).0 = 1) & ^MST(OL_X).#ENABLED
				ENABLE OL_X;
				DISP "PLC_CMD: ENABLE OL_X"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_X)).1 = 1) & MST(OL_X).#ENABLED
				DISABLE OL_X;
				DISP "PLC_CMD: DISABLE OL_X"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_X)).2 = 1)
				WAIT 200
				IF ^PST(24).#RUN
					START 24, HOMING_OL_X
				ELSE					
					STOP 24
					START 24, HOMING_OL_X
				END
				DISP "PLC_CMD: HOMING_OL_X"
			END
			IF Axis_Control(GetPLC_AxisNumber(OL_X)).3 = 1 & Axis_Control(GetPLC_AxisNumber(OL_X)).7 <> 1 & ^MST(OL_X).#MOVE
				JOGMove(OL_X) = 1
				WAIT 10
				CheckAxisPara(OL_X)
				JOG OL_X,+ 
				DISP "PLC_CMD: OL_X JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(OL_X)).3 = 0 & JOGMove(OL_X) = 1
				JOGMove(OL_X) = 0
				KILL OL_X
			END
			IF Axis_Control(GetPLC_AxisNumber(OL_X)).4 = 1 & Axis_Control(GetPLC_AxisNumber(OL_X)).7 <> 1 & ^MST(OL_X).#MOVE
				JOGMove(OL_X) = 2
				WAIT 10
				CheckAxisPara(OL_X)
				JOG OL_X,- 
				DISP "PLC_CMD: OL_X JOG-"
			ELSEIF Axis_Control(GetPLC_AxisNumber(OL_X)).4 = 0 & JOGMove(OL_X) = 2
				JOGMove(OL_X) = 0
				KILL OL_X
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_X)).5 = 1) & Axis_Control(GetPLC_AxisNumber(OL_X)).7 <> 1 & ^MST(OL_X).#MOVE
				WAIT 10
				CheckAxisPara(OL_X)
				IF CheckAxisLimit(OL_X)=1
				PLC_RunMotin(OL_X)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_X)).6 = 1) & Axis_Control(GetPLC_AxisNumber(OL_X)).7 <> 1 & ^MST(OL_X).#MOVE
				WAIT 10
				CheckAxisPara(OL_X)
				IF CheckAxisLimit(OL_X)=1
				PLC_RunMotin(OL_X)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_X)).7 = 1)
				KILLALL;
			END
		END

		CASE 15:! OL_Y
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_Y)).0 = 1) & ^MST(OL_Y).#ENABLED
				ENABLE OL_Y;
				DISP "PLC_CMD: ENABLE OL_Y"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_Y)).1 = 1) & MST(OL_Y).#ENABLED
				DISABLE OL_Y;
				DISP "PLC_CMD: DISABLE OL_Y"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_Y)).2 = 1)
				WAIT 200
				IF ^PST(25).#RUN
					START 25, HOMING_OL_Y
				ELSE					
					STOP 25
					START 25, HOMING_OL_Y
				END
				DISP "PLC_CMD: HOMING_OL_Y"
			END
			IF Axis_Control(GetPLC_AxisNumber(OL_Y)).3 = 1 & Axis_Control(GetPLC_AxisNumber(OL_Y)).7 <> 1 & ^MST(OL_Y).#MOVE
				JOGMove(OL_Y) = 1
				WAIT 10
				CheckAxisPara(OL_Y)
				JOG OL_Y,+ 
				DISP "PLC_CMD: OL_Y JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(OL_Y)).3 = 0 & JOGMove(OL_Y) = 1
				JOGMove(OL_Y) = 0
				KILL OL_Y
			END
			IF Axis_Control(GetPLC_AxisNumber(OL_Y)).4 = 1 & Axis_Control(GetPLC_AxisNumber(OL_Y)).7 <> 1 & ^MST(OL_Y).#MOVE
				JOGMove(OL_Y) = 2
				WAIT 10
				CheckAxisPara(OL_Y)
				JOG OL_Y,- 
				DISP "PLC_CMD: OL_Y JOG-"
			ELSEIF Axis_Control(GetPLC_AxisNumber(OL_Y)).4 = 0 & JOGMove(OL_Y) = 2
				JOGMove(OL_Y) = 0
				KILL OL_Y
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_Y)).5 = 1) & Axis_Control(GetPLC_AxisNumber(OL_Y)).7 <> 1 & ^MST(OL_Y).#MOVE
				WAIT 10
				CheckAxisPara(OL_Y)
				IF CheckAxisLimit(OL_Y)=1
				PLC_RunMotin(OL_Y)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_Y)).6 = 1) & Axis_Control(GetPLC_AxisNumber(OL_Y)).7 <> 1 & ^MST(OL_Y).#MOVE
				WAIT 10
				CheckAxisPara(OL_Y)
				IF CheckAxisLimit(OL_Y)=1
				PLC_RunMotin(OL_Y)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_Y)).7 = 1)
				KILLALL;
			END
		END

		CASE 16:! OL_Z
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_Z)).0 = 1) & ^MST(OL_Z).#ENABLED
				ENABLE OL_Z;
				DISP "PLC_CMD: ENABLE OL_Z"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_Z)).1 = 1) & MST(OL_Z).#ENABLED
				DISABLE OL_Z;
				DISP "PLC_CMD: DISABLE OL_Z"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_Z)).2 = 1)
				WAIT 200
				IF ^PST(26).#RUN
					START 26, HOMING_OL_Z
				ELSE					
					STOP 26
					START 26, HOMING_OL_Z
				END
				DISP "PLC_CMD: HOMING_OL_Z"
			END
			IF Axis_Control(GetPLC_AxisNumber(OL_Z)).3 = 1 & Axis_Control(GetPLC_AxisNumber(OL_Z)).7 <> 1 & ^MST(OL_Z).#MOVE
				JOGMove(OL_Z) = 1
				WAIT 10
				CheckAxisPara(OL_Z)
				JOG OL_Z,+ 
				DISP "PLC_CMD: OL_Z JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(OL_Z)).3 = 0 & JOGMove(OL_Z) = 1
				JOGMove(OL_Z) = 0
				KILL OL_Z
			END
			IF Axis_Control(GetPLC_AxisNumber(OL_Z)).4 = 1 & Axis_Control(GetPLC_AxisNumber(OL_Z)).7 <> 1 & ^MST(OL_Z).#MOVE
				JOGMove(OL_Z) = 2
				WAIT 10
				CheckAxisPara(OL_Z)
				JOG OL_Z,- 
				DISP "PLC_CMD: OL_Z JOG-"
			ELSEIF Axis_Control(12).4 = 0 & JOGMove(OL_Z) = 2
				JOGMove(OL_Z) = 0
				KILL OL_Z
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_Z)).5 = 1) & Axis_Control(GetPLC_AxisNumber(OL_Z)).7 <> 1 & ^MST(OL_Z).#MOVE
				WAIT 10
				CheckAxisPara(OL_Z)
				IF CheckAxisLimit(OL_Z)=1
				PLC_RunMotin(OL_Z)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_Z)).6 = 1) & Axis_Control(GetPLC_AxisNumber(OL_Z)).7 <> 1 & ^MST(OL_Z).#MOVE
				WAIT 10
				CheckAxisPara(OL_Z)
				IF CheckAxisLimit(OL_Z)=1
				PLC_RunMotin(OL_Z)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OL_Z)).7 = 1)
				KILLALL;
			END
		END

		CASE 18:! OR_X
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_X)).0 = 1) & ^MST(OR_X).#ENABLED
				ENABLE OR_X;
				DISP "PLC_CMD: ENABLE OR_X"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_X)).1 = 1) & MST(OR_X).#ENABLED
				DISABLE OR_X;
				DISP "PLC_CMD: DISABLE OR_X"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_X)).2 = 1)
				WAIT 200
				IF ^PST(27).#RUN
					START 27, HOMING_OR_X
				ELSE					
					STOP 27
					START 27, HOMING_OR_X
				END
				DISP "PLC_CMD: HOMING_OR_X"
			END
			IF Axis_Control(GetPLC_AxisNumber(OR_X)).3 = 1 & Axis_Control(GetPLC_AxisNumber(OR_X)).7 <> 1 & ^MST(OR_X).#MOVE
				JOGMove(OR_X) = 1
				WAIT 10
				CheckAxisPara(OR_X)
				JOG OR_X,+ 
				DISP "PLC_CMD: OR_X JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(OR_X)).3 = 0 & JOGMove(OR_X) = 1
				JOGMove(OR_X) = 0
				KILL OR_X
			END
			IF Axis_Control(GetPLC_AxisNumber(OR_X)).4 = 1 & Axis_Control(GetPLC_AxisNumber(OR_X)).7 <> 1 & ^MST(OR_X).#MOVE
				JOGMove(OR_X) = 2
				WAIT 10
				CheckAxisPara(OR_X)
				JOG OR_X,- 
				DISP "PLC_CMD: OR_X JOG-"
			ELSEIF Axis_Control(GetPLC_AxisNumber(OR_X)).4 = 0 & JOGMove(OR_X) = 2
				JOGMove(OR_X) = 0
				KILL OR_X
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_X)).5 = 1) & Axis_Control(GetPLC_AxisNumber(OR_X)).7 <> 1 & ^MST(OR_X).#MOVE
				WAIT 10
				CheckAxisPara(OR_X)
				IF CheckAxisLimit(OR_X)=1
				PLC_RunMotin(OR_X)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_X)).6 = 1) & Axis_Control(GetPLC_AxisNumber(OR_X)).7 <> 1 & ^MST(OR_X).#MOVE
				WAIT 10
				CheckAxisPara(OR_X)
				IF CheckAxisLimit(OR_X)=1
				PLC_RunMotin(OR_X)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_X)).7 = 1)
				KILLALL;
			END
		END

		CASE 19:! OR_Y
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_Y)).0 = 1) & ^MST(OR_Y).#ENABLED
				ENABLE OR_Y;
				DISP "PLC_CMD: ENABLE OR_Y"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_Y)).1 = 1) & MST(OR_Y).#ENABLED
				DISABLE OR_Y;
				DISP "PLC_CMD: DISABLE OR_Y"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_Y)).2 = 1)
				WAIT 200
				IF ^PST(28).#RUN
					START 28, HOMING_OR_Y
				ELSE					
					STOP 28
					START 18, HOMING_OR_Y
				END
				DISP "PLC_CMD: HOMING_OR_Y"
			END
			IF Axis_Control(GetPLC_AxisNumber(OR_Y)).3 = 1 & Axis_Control(GetPLC_AxisNumber(OR_Y)).7 <> 1 & ^MST(OR_Y).#MOVE
				JOGMove(OR_Y) = 1
				WAIT 10
				CheckAxisPara(OR_Y)
				JOG OR_Y,+ 
				DISP "PLC_CMD: OR_Y JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(OR_Y)).3 = 0 & JOGMove(OR_Y) = 1
				JOGMove(OR_Y) = 0
				KILL OR_Y
			END
			IF Axis_Control(GetPLC_AxisNumber(OR_Y)).4 = 1 & Axis_Control(GetPLC_AxisNumber(OR_Y)).7 <> 1 & ^MST(OR_Y).#MOVE
				JOGMove(OR_Y) = 2
				WAIT 10
				CheckAxisPara(OR_Y)
				JOG OR_Y,- 
				DISP "PLC_CMD: OR_Y JOG-"
			ELSEIF Axis_Control(GetPLC_AxisNumber(OR_Y)).4 = 0 & JOGMove(OR_Y) = 2
				JOGMove(OR_Y) = 0
				KILL OR_Y
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_Y)).5 = 1) & Axis_Control(GetPLC_AxisNumber(OR_Y)).7 <> 1 & ^MST(OR_Y).#MOVE
				WAIT 10
				CheckAxisPara(OR_Y)
				IF CheckAxisLimit(OR_Y)=1
				PLC_RunMotin(OR_Y)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_Y)).6 = 1) & Axis_Control(GetPLC_AxisNumber(OR_Y)).7 <> 1 & ^MST(OR_Y).#MOVE
				WAIT 10
				CheckAxisPara(OR_Y)
				IF CheckAxisLimit(OR_Y)=1
				PLC_RunMotin(OR_Y)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_Y)).7 = 1)
				KILLALL;
			END
		END

		CASE 20:! OR_Z
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_Z)).0 = 1) & ^MST(OR_Z).#ENABLED
				ENABLE OR_Z;
				DISP "PLC_CMD: ENABLE OR_Z"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_Z)).1 = 1) & MST(OR_Z).#ENABLED
				DISABLE OR_Z;
				DISP "PLC_CMD: DISABLE OR_Z"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_Z)).2 = 1)
				WAIT 200
				IF ^PST(29).#RUN
					START 29, HOMING_OR_Z
				ELSE					
					STOP 29
					START 29, HOMING_OR_Z
				END
				DISP "PLC_CMD: HOMING_OR_Z"
			END
			IF Axis_Control(GetPLC_AxisNumber(OR_Z)).3 = 1 & Axis_Control(GetPLC_AxisNumber(OR_Z)).7 <> 1 & ^MST(OR_Z).#MOVE
				JOGMove(OR_Z) = 1
				WAIT 10
				CheckAxisPara(OR_Z)
				JOG OR_Z,+ 
				DISP "PLC_CMD: OR_Z JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(OR_Z)).3 = 0 & JOGMove(OR_Z) = 1
				JOGMove(OR_Z) = 0
				KILL OR_Z
			END
			IF Axis_Control(GetPLC_AxisNumber(OR_Z)).4 = 1 & Axis_Control(GetPLC_AxisNumber(OR_Z)).7 <> 1 & ^MST(OR_Z).#MOVE
				JOGMove(OR_Z) = 2
				WAIT 10
				CheckAxisPara(OR_Z)
				JOG OR_Z,- 
				DISP "PLC_CMD: OR_Z JOG-"
			ELSEIF Axis_Control(GetPLC_AxisNumber(OR_Z)).4 = 0 & JOGMove(OR_Z) = 2
				JOGMove(OR_Z) = 0
				KILL OR_Z
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_Z)).5 = 1) & Axis_Control(GetPLC_AxisNumber(OR_Z)).7 <> 1 & ^MST(OR_Z).#MOVE
				WAIT 10
				CheckAxisPara(OR_Z)
				IF CheckAxisLimit(OR_Z)=1
				PLC_RunMotin(OR_Z)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_Z)).6 = 1) & Axis_Control(GetPLC_AxisNumber(OR_Z)).7 <> 1 & ^MST(OR_Z).#MOVE
				WAIT 10
				CheckAxisPara(OR_Z)
				IF CheckAxisLimit(OR_Z)=1
				PLC_RunMotin(OR_Z)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(OR_Z)).7 = 1)
				KILLALL;
			END
		END

		CASE 22:! TWLP
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TWLP)).0 = 1) & ^MST(TWLP).#ENABLED
				ENABLE TWLP;
				DISP "PLC_CMD: ENABLE TWLP"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TWLP)).1 = 1) & MST(TWLP).#ENABLED
				DISABLE TWLP;
				DISP "PLC_CMD: DISABLE TWLP"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TWLP)).2 = 1)
				WAIT 200
				IF ^PST(30).#RUN
					START 30, HOMING_TWLP
				ELSE					
					STOP 30
					START 30, HOMING_TWLP
				END
				DISP "PLC_CMD: HOMING_TWLP"
			END
			IF Axis_Control(GetPLC_AxisNumber(TWLP)).3 = 1 & Axis_Control(GetPLC_AxisNumber(TWLP)).7 <> 1 & ^MST(TWLP).#MOVE
				JOGMove(TWLP) = 1
				WAIT 10
				CheckAxisPara(TWLP)
				JOG TWLP,+ 
				DISP "PLC_CMD: TWLP JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(TWLP)).3 = 0 & JOGMove(TWLP) = 1
				JOGMove(TWLP) = 0
				KILL TWLP
			END
			IF Axis_Control(GetPLC_AxisNumber(TWLP)).4 = 1 & Axis_Control(GetPLC_AxisNumber(TWLP)).7 <> 1 & ^MST(TWLP).#MOVE
				JOGMove(TWLP) = 2
				WAIT 10
				CheckAxisPara(TWLP)
				JOG TWLP,- 
				DISP "PLC_CMD: TWLP JOG-"
			ELSEIF Axis_Control(GetPLC_AxisNumber(TWLP)).4 = 0 & JOGMove(TWLP) = 2
				JOGMove(TWLP) = 0
				KILL TWLP
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TWLP)).5 = 1)& Axis_Control(GetPLC_AxisNumber(TWLP)).7 <> 1 & ^MST(TWLP).#MOVE
				WAIT 10
				CheckAxisPara(TWLP)
				IF CheckAxisLimit(TWLP)=1
				PLC_RunMotin(TWLP)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TWLP)).6 = 1) & Axis_Control(GetPLC_AxisNumber(TWLP)).7 <> 1 & ^MST(TWLP).#MOVE
				WAIT 10
				CheckAxisPara(TWLP)
				IF CheckAxisLimit(TWLP)=1
				PLC_RunMotin(TWLP)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(TWLP)).7 = 1)
				KILLALL;
			END
		END

		CASE 23:! BWLP
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BWLP)).0 = 1) & ^MST(BWLP).#ENABLED
				ENABLE BWLP;
				DISP "PLC_CMD: ENABLE BWLP"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BWLP)).1 = 1) & MST(BWLP).#ENABLED
				DISABLE BWLP;
				DISP "PLC_CMD: DISABLE BWLP"
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BWLP)).2 = 1)
				WAIT 200
				IF ^PST(31).#RUN
					START 31, HOMING_BWLP
				ELSE					
					STOP 31
					START 31, HOMING_BWLP
				END
				DISP "PLC_CMD: HOMING_BWLP"
			END
			IF Axis_Control(GetPLC_AxisNumber(BWLP)).3 = 1 & Axis_Control(GetPLC_AxisNumber(BWLP)).7 <> 1 & ^MST(BWLP).#MOVE
				JOGMove(BWLP) = 1
				WAIT 10
				CheckAxisPara(BWLP)
				JOG BWLP,+ 
				DISP "PLC_CMD: BWLP JOG+"
			ELSEIF Axis_Control(GetPLC_AxisNumber(BWLP)).3 = 0 & JOGMove(BWLP) = 1
				JOGMove(BWLP) = 0
				KILL BWLP
			END
			IF Axis_Control(GetPLC_AxisNumber(BWLP)).4 = 1 & Axis_Control(GetPLC_AxisNumber(BWLP)).7 <> 1 & ^MST(BWLP).#MOVE
				JOGMove(BWLP) = 2
				WAIT 10
				CheckAxisPara(BWLP)
				JOG BWLP,- 
				DISP "PLC_CMD: BWLP JOG-"
			ELSEIF Axis_Control(GetPLC_AxisNumber(BWLP)).4 = 0 & JOGMove(BWLP) = 2
				JOGMove(BWLP) = 0
				KILL BWLP
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BWLP)).5 = 1)
				WAIT 10
				CheckAxisPara(BWLP)
				IF CheckAxisLimit(BWLP)=1
				PLC_RunMotin(BWLP)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BWLP)).6 = 1) & Axis_Control(GetPLC_AxisNumber(BWLP)).7 <> 1 & ^MST(BWLP).#MOVE
				WAIT 10
				CheckAxisPara(BWLP)
				IF CheckAxisLimit(BWLP)=1
				PLC_RunMotin(BWLP)
				END
			END
			IF EDGE(Axis_Control(GetPLC_AxisNumber(BWLP)).7 = 1)
				KILLALL;
			END
		END

	END! SWITCH

	CurrentAxisNum++ 
	IF CurrentAxisNum > 23
		CurrentAxisNum = 0;
	END
END! WHILE

VOID CheckAxisPara(INT AxisIndex)
{	
	String CurrentAxisName(10)
	CurrentAxisName = GetAxisName(AxisIndex)
	IF ^MST(AxisIndex).#ENABLED
		ENABLE AxisIndex
		DISP AxisIndex, ":DO NOT ENABLE"
	END
	
	IF Axis_Vel(GetPLC_AxisNumber(AxisIndex)) <= 0 | Axis_Vel(GetPLC_AxisNumber(AxisIndex)) > XVEL(AxisIndex)
		VEL(AxisIndex) = AxisVel(AxisIndex)
		ACC(AxisIndex) = AxisVel(AxisIndex) * 5
		DEC(AxisIndex) = AxisVel(AxisIndex) * 5
		JERK(AxisIndex) = AxisVel(AxisIndex) * 30
		OccurAlarm(725 + AxisIndex, Alarm_Tips)
		DISP CurrentAxisName, AxisIndex, ":SET THE ERRO PARA"
	ELSE		
		VEL(AxisIndex) = Axis_Vel(GetPLC_AxisNumber(AxisIndex))
		ACC(AxisIndex) = Axis_Acc(GetPLC_AxisNumber(AxisIndex)) * 5
		DEC(AxisIndex) = Axis_Acc(GetPLC_AxisNumber(AxisIndex)) * 5
		JERK(AxisIndex) = Axis_Acc(GetPLC_AxisNumber(AxisIndex)) * 30
	END


	RET 
}

VOID PLC_RunMotin(INT AxisIndex)
{	
	REAL PLC_APOS
	PLC_APOS = Axis_Pos(GetPLC_AxisNumber(AxisIndex))
	String CurrentAxisName(10)
	CurrentAxisName = GetAxisName(AxisIndex)

	IF CheckAxisLimit(AxisIndex)

		IF Axis_Control(GetPLC_AxisNumber(AxisIndex)).5 = 1 !ABS

			PTP AxisIndex, Axis_Pos(GetPLC_AxisNumber(AxisIndex))

			DISP CurrentAxisName, "PLC_CMD_ABS ", PLC_APOS, "Current Position", FPOS(AxisIndex)

		ELSEIF Axis_Control(GetPLC_AxisNumber(AxisIndex)).6 = 1 !INC

			PTP/R AxisIndex, Axis_Pos(GetPLC_AxisNumber(AxisIndex))

			DISP CurrentAxisName, "PLC_CMD_INC ", PLC_APOS, "Current Position", FPOS(AxisIndex)

		END



	ELSE		

	END

	RET 
}




INT CheckAxisLimit(INT AxisIndex)
{	
	INT result
	String CurrentAxisName(10)
	CurrentAxisName = GetAxisName(AxisIndex)
	IF Axis_Control(GetPLC_AxisNumber(AxisIndex)).5=1    !ABS
	IF Axis_Pos(GetPLC_AxisNumber(AxisIndex)) > SRLIMIT(AxisIndex) | Axis_Pos(GetPLC_AxisNumber(AxisIndex)) < SLLIMIT(AxisIndex)

		result =- 1
		OccurAlarm(750+AxisIndex,Alarm_Tips)
		DISP CurrentAxisName, AxisIndex, ":SET THE ERRO POS"
	ELSE		
		result = 1
	END
	
	ELSEIF Axis_Control(GetPLC_AxisNumber(AxisIndex)).6=1    !INC
	IF Axis_Pos(GetPLC_AxisNumber(AxisIndex))+FPOS(AxisIndex) > SRLIMIT(AxisIndex) | Axis_Pos(GetPLC_AxisNumber(AxisIndex))+FPOS(AxisIndex) < SLLIMIT(AxisIndex)

		result =- 1
		OccurAlarm(750+AxisIndex,Alarm_Tips)
		DISP CurrentAxisName, AxisIndex, ": Exceeded limit"
	ELSE		
		result = 1
	END
    END
	RET result
}



STOP
#5
!PNAME=
!PDESC=
ON ^MST(SLA_Y0).#INPOS|^MST(SLA_Y1).#INPOS

SCTRIGGER/4 2

RET
#6
!PNAME=PLC_READ
!PDESC=

!-----------------MODBUS READ------------------------
WAIT 5000
AUTOEXEC:
INT i
REAL HeartTime=0
CONID=1
setconf(309,0,1) !Hi word first, then Low word

WHILE 1
    i = 0
    LOOP 24   ! i from 0 to 23
        ! ----- Heartbeat toggle (only for axis 0 / TT_Y0) -----
        IF TIME - HeartTime > 500 & Axis_State(0).5 = 1
            Axis_State(0).5 = 0
            HeartTime = TIME
        ELSEIF TIME - HeartTime > 500 & Axis_State(0).5 = 0
            Axis_State(0).5 = 1
            HeartTime = TIME
        END

        ! ----- Map axis status bits using CASE -----
        SWITCH i
            CASE 0:   ! 0
                !------ AXIS ENABLED ------
                IF MST(TT_Y0).#ENABLED
                    Axis_State(0).0 = 1   ! bit0: enabled
                ELSE
                    Axis_State(0).0 = 0
                END
                !------ AXIS READY (drive ready) ------
                IF FAULT(TT_Y0).#DRIVE
                    Axis_State(0).1 = 1   ! bit1: drive ready
                ELSE
                    Axis_State(0).1 = 0
                END
                !------ AXIS BUSY (moving) ------
                IF MST(TT_Y0).#MOVE
                    Axis_State(0).2 = 1   ! bit2: moving
                ELSE
                    Axis_State(0).2 = 0
                END
                !------ AXIS HOMED ------
                IF MFLAGS(TT_Y0).#HOME & PA_HomeStatus(TT_Y0)
                    Axis_State(0).3 = 1   ! bit3: homed
                ELSE
                    Axis_State(0).3 = 0
                END
                !------ AXIS FAULT (other than limit) ------
                IF FAULT(TT_Y0) <> 0 & ^FAULT(TT_Y0).#RL & ^FAULT(TT_Y0).#LL & ^FAULT(TT_Y0).#SRL & ^FAULT(TT_Y0).#SLL
                    Axis_State(0).4 = 1   ! bit4: general fault
                ELSE
                    Axis_State(0).4 = 0
                END
                !------ ACS STATE ERROR ------
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(0).6 = 1   ! bit6: ACS error
                ELSE
                    Axis_State(0).6 = 0
                END
                !------ SOFT LIMIT POSITIVE (SRL) ------
                IF FAULT(TT_Y0).#SRL
                    Axis_State(0).7 = 1   ! bit7: +soft limit
                ELSE
                    Axis_State(0).7 = 0
                END
                !------ SOFT LIMIT NEGATIVE (SLL) ------
                IF FAULT(TT_Y0).#SLL
                    Axis_State(0).8 = 1   ! bit8: -soft limit
                ELSE
                    Axis_State(0).8 = 0
                END
                !------ HARD LIMIT POSITIVE (RL) ------
                IF FAULT(TT_Y0).#RL
                    Axis_State(0).9 = 1   ! bit9: +hard limit
                ELSE
                    Axis_State(0).9 = 0
                END
                !------ HARD LIMIT NEGATIVE (LL) ------
                IF FAULT(TT_Y0).#LL
                    Axis_State(0).10 = 1  ! bit10: -hard limit
                ELSE
                    Axis_State(0).10 = 0
                END
                !------ ACTUAL POSITION ------
                Axis_ActPos(0) = FPOS(TT_Y0)
				END
                

            CASE 1:   ! 1
                IF MST(TT_Y1).#ENABLED
                    Axis_State(1).0 = 1
                ELSE
                    Axis_State(1).0 = 0
                END
                IF FAULT(TT_Y1).#DRIVE
                    Axis_State(1).1 = 1
                ELSE
                    Axis_State(1).1 = 0
                END
                IF MST(TT_Y1).#MOVE
                    Axis_State(1).2 = 1
                ELSE
                    Axis_State(1).2 = 0
                END
                IF MFLAGS(TT_Y1).#HOME & PA_HomeStatus(TT_Y1)
                    Axis_State(1).3 = 1
                ELSE
                    Axis_State(1).3 = 0
                END
                IF FAULT(TT_Y1) <> 0 & ^FAULT(TT_Y1).#RL & ^FAULT(TT_Y1).#LL & ^FAULT(TT_Y1).#SRL & ^FAULT(TT_Y1).#SLL
                    Axis_State(1).4 = 1
                ELSE
                    Axis_State(1).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(1).6 = 1
                ELSE
                    Axis_State(1).6 = 0
                END
                IF FAULT(TT_Y1).#SRL
                    Axis_State(1).7 = 1
                ELSE
                    Axis_State(1).7 = 0
                END
                IF FAULT(TT_Y1).#SLL
                    Axis_State(1).8 = 1
                ELSE
                    Axis_State(1).8 = 0
                END
                IF FAULT(TT_Y1).#RL
                    Axis_State(1).9 = 1
                ELSE
                    Axis_State(1).9 = 0
                END
                IF FAULT(TT_Y1).#LL
                    Axis_State(1).10 = 1
                ELSE
                    Axis_State(1).10 = 0
                END
                Axis_ActPos(1) = FPOS(TT_Y1)
                END

            CASE 2:   ! 2 
                IF MST(BT_Y0).#ENABLED
                    Axis_State(5).0 = 1
                ELSE
                    Axis_State(5).0 = 0
                END
                IF FAULT(BT_Y0).#DRIVE
                    Axis_State(5).1 = 1
                ELSE
                    Axis_State(5).1 = 0
                END
                IF MST(BT_Y0).#MOVE
                    Axis_State(5).2 = 1
                ELSE
                    Axis_State(5).2 = 0
                END
                IF MFLAGS(BT_Y0).#HOME & PA_HomeStatus(BT_Y0)
                    Axis_State(5).3 = 1
                ELSE
                    Axis_State(5).3 = 0
                END
                IF FAULT(BT_Y0) <> 0 & ^FAULT(BT_Y0).#RL & ^FAULT(BT_Y0).#LL & ^FAULT(BT_Y0).#SRL & ^FAULT(BT_Y0).#SLL
                    Axis_State(5).4 = 1
                ELSE
                    Axis_State(5).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(5).6 = 1
                ELSE
                    Axis_State(5).6 = 0
                END
                IF FAULT(BT_Y0).#SRL
                    Axis_State(5).7 = 1
                ELSE
                    Axis_State(5).7 = 0
                END
                IF FAULT(BT_Y0).#SLL
                    Axis_State(5).8 = 1
                ELSE
                    Axis_State(5).8 = 0
                END
                IF FAULT(BT_Y0).#RL
                    Axis_State(5).9 = 1
                ELSE
                    Axis_State(5).9 = 0
                END
                IF FAULT(BT_Y0).#LL
                    Axis_State(5).10 = 1
                ELSE
                    Axis_State(5).10 = 0
                END
                Axis_ActPos(5) = FPOS(BT_Y0)
                END

            CASE 3:   ! 3
                IF MST(BT_Y1).#ENABLED
                    Axis_State(6).0 = 1
                ELSE
                    Axis_State(6).0 = 0
                END
                IF FAULT(BT_Y1).#DRIVE
                    Axis_State(6).1 = 1
                ELSE
                    Axis_State(6).1 = 0
                END
                IF MST(BT_Y1).#MOVE
                    Axis_State(6).2 = 1
                ELSE
                    Axis_State(6).2 = 0
                END
                IF MFLAGS(BT_Y1).#HOME & PA_HomeStatus(BT_Y1)
                    Axis_State(6).3 = 1
                ELSE
                    Axis_State(6).3 = 0
                END
                IF FAULT(BT_Y1) <> 0 & ^FAULT(BT_Y1).#RL & ^FAULT(BT_Y1).#LL & ^FAULT(BT_Y1).#SRL & ^FAULT(BT_Y1).#SLL
                    Axis_State(6).4 = 1
                ELSE
                    Axis_State(6).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(6).6 = 1
                ELSE
                    Axis_State(6).6 = 0
                END
                IF FAULT(BT_Y1).#SRL
                    Axis_State(6).7 = 1
                ELSE
                    Axis_State(6).7 = 0
                END
                IF FAULT(BT_Y1).#SLL
                    Axis_State(6).8 = 1
                ELSE
                    Axis_State(6).8 = 0
                END
                IF FAULT(BT_Y1).#RL
                    Axis_State(6).9 = 1
                ELSE
                    Axis_State(6).9 = 0
                END
                IF FAULT(BT_Y1).#LL
                    Axis_State(6).10 = 1
                ELSE
                    Axis_State(6).10 = 0
                END
                Axis_ActPos(6) = FPOS(BT_Y1)
                END

            CASE 4:   ! 4
                IF MST(BC_Z0).#ENABLED
                    Axis_State(16).0 = 1
                ELSE
                    Axis_State(16).0 = 0
                END
                IF FAULT(BC_Z0).#DRIVE
                    Axis_State(16).1 = 1
                ELSE
                    Axis_State(16).1 = 0
                END
                IF MST(BC_Z0).#MOVE
                    Axis_State(16).2 = 1
                ELSE
                    Axis_State(16).2 = 0
                END
                IF MFLAGS(BC_Z0).#HOME & PA_HomeStatus(BC_Z0)
                    Axis_State(16).3 = 1
                ELSE
                    Axis_State(16).3 = 0
                END
                IF FAULT(BC_Z0) <> 0 & ^FAULT(BC_Z0).#RL & ^FAULT(BC_Z0).#LL & ^FAULT(BC_Z0).#SRL & ^FAULT(BC_Z0).#SLL
                    Axis_State(16).4 = 1
                ELSE
                    Axis_State(16).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(16).6 = 1
                ELSE
                    Axis_State(16).6 = 0
                END
                IF FAULT(BC_Z0).#SRL
                    Axis_State(16).7 = 1
                ELSE
                    Axis_State(16).7 = 0
                END
                IF FAULT(BC_Z0).#SLL
                    Axis_State(16).8 = 1
                ELSE
                    Axis_State(16).8 = 0
                END
                IF FAULT(BC_Z0).#RL
                    Axis_State(16).9 = 1
                ELSE
                    Axis_State(16).9 = 0
                END
                IF FAULT(BC_Z0).#LL
                    Axis_State(16).10 = 1
                ELSE
                    Axis_State(16).10 = 0
                END
                Axis_ActPos(16) = FPOS(BC_Z0)
                END

            CASE 5:   ! 5
                IF MST(BC_Z1).#ENABLED
                    Axis_State(17).0 = 1
                ELSE
                    Axis_State(17).0 = 0
                END
                IF FAULT(BC_Z1).#DRIVE
                    Axis_State(17).1 = 1
                ELSE
                    Axis_State(17).1 = 0
                END
                IF MST(BC_Z1).#MOVE
                    Axis_State(17).2 = 1
                ELSE
                    Axis_State(17).2 = 0
                END
                IF MFLAGS(BC_Z1).#HOME & PA_HomeStatus(BC_Z1)
                    Axis_State(17).3 = 1
                ELSE
                    Axis_State(17).3 = 0
                END
                IF FAULT(BC_Z1) <> 0 & ^FAULT(BC_Z1).#RL & ^FAULT(BC_Z1).#LL & ^FAULT(BC_Z1).#SRL & ^FAULT(BC_Z1).#SLL
                    Axis_State(17).4 = 1
                ELSE
                    Axis_State(17).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(17).6 = 1
                ELSE
                    Axis_State(17).6 = 0
                END
                IF FAULT(BC_Z1).#SRL
                    Axis_State(17).7 = 1
                ELSE
                    Axis_State(17).7 = 0
                END
                IF FAULT(BC_Z1).#SLL
                    Axis_State(17).8 = 1
                ELSE
                    Axis_State(17).8 = 0
                END
                IF FAULT(BC_Z1).#RL
                    Axis_State(17).9 = 1
                ELSE
                    Axis_State(17).9 = 0
                END
                IF FAULT(BC_Z1).#LL
                    Axis_State(17).10 = 1
                ELSE
                    Axis_State(17).10 = 0
                END
                Axis_ActPos(17) = FPOS(BC_Z1)
                END

            CASE 6:   ! 6
                IF MST(BC_Z2).#ENABLED
                    Axis_State(18).0 = 1
                ELSE
                    Axis_State(18).0 = 0
                END
                IF FAULT(BC_Z2).#DRIVE
                    Axis_State(18).1 = 1
                ELSE
                    Axis_State(18).1 = 0
                END
                IF MST(BC_Z2).#MOVE
                    Axis_State(18).2 = 1
                ELSE
                    Axis_State(18).2 = 0
                END
                IF MFLAGS(BC_Z2).#HOME & PA_HomeStatus(BC_Z2)
                    Axis_State(18).3 = 1
                ELSE
                    Axis_State(18).3 = 0
                END
                IF FAULT(BC_Z2) <> 0 & ^FAULT(BC_Z2).#RL & ^FAULT(BC_Z2).#LL & ^FAULT(BC_Z2).#SRL & ^FAULT(BC_Z2).#SLL
                    Axis_State(18).4 = 1
                ELSE
                    Axis_State(18).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(18).6 = 1
                ELSE
                    Axis_State(18).6 = 0
                END
                IF FAULT(BC_Z2).#SRL
                    Axis_State(18).7 = 1
                ELSE
                    Axis_State(18).7 = 0
                END
                IF FAULT(BC_Z2).#SLL
                    Axis_State(18).8 = 1
                ELSE
                    Axis_State(18).8 = 0
                END
                IF FAULT(BC_Z2).#RL
                    Axis_State(18).9 = 1
                ELSE
                    Axis_State(18).9 = 0
                END
                IF FAULT(BC_Z2).#LL
                    Axis_State(18).10 = 1
                ELSE
                    Axis_State(18).10 = 0
                END
                Axis_ActPos(18) = FPOS(BC_Z2)
                END

            CASE 8:   ! 8
                IF MST(SLA_Y0).#ENABLED
                    Axis_State(19).0 = 1
                ELSE
                    Axis_State(19).0 = 0
                END
                IF FAULT(SLA_Y0).#DRIVE
                    Axis_State(19).1 = 1
                ELSE
                    Axis_State(19).1 = 0
                END
                IF MST(SLA_Y0).#MOVE
                    Axis_State(19).2 = 1
                ELSE
                    Axis_State(19).2 = 0
                END
                IF MFLAGS(SLA_Y0).#HOME & PA_HomeStatus(SLA_Y0)
                    Axis_State(19).3 = 1
                ELSE
                    Axis_State(19).3 = 0
                END
                IF FAULT(SLA_Y0) <> 0 & ^FAULT(SLA_Y0).#RL & ^FAULT(SLA_Y0).#LL & ^FAULT(SLA_Y0).#SRL & ^FAULT(SLA_Y0).#SLL
                    Axis_State(19).4 = 1
                ELSE
                    Axis_State(19).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(19).6 = 1
                ELSE
                    Axis_State(19).6 = 0
                END
                IF FAULT(SLA_Y0).#SRL
                    Axis_State(19).7 = 1
                ELSE
                    Axis_State(19).7 = 0
                END
                IF FAULT(SLA_Y0).#SLL
                    Axis_State(19).8 = 1
                ELSE
                    Axis_State(19).8 = 0
                END
                IF FAULT(SLA_Y0).#RL
                    Axis_State(19).9 = 1
                ELSE
                    Axis_State(19).9 = 0
                END
                IF FAULT(SLA_Y0).#LL
                    Axis_State(19).10 = 1
                ELSE
                    Axis_State(19).10 = 0
                END
                Axis_ActPos(19) = FPOS(SLA_Y0)
                END

            CASE 9:   ! 9
                IF MST(SLA_Y1).#ENABLED
                    Axis_State(20).0 = 1
                ELSE
                    Axis_State(20).0 = 0
                END
                IF FAULT(SLA_Y1).#DRIVE
                    Axis_State(20).1 = 1
                ELSE
                    Axis_State(20).1 = 0
                END
                IF MST(SLA_Y1).#MOVE
                    Axis_State(20).2 = 1
                ELSE
                    Axis_State(20).2 = 0
                END
                IF MFLAGS(SLA_Y1).#HOME & PA_HomeStatus(SLA_Y1)
                    Axis_State(20).3 = 1
                ELSE
                    Axis_State(20).3 = 0
                END
                IF FAULT(SLA_Y1) <> 0 & ^FAULT(SLA_Y1).#RL & ^FAULT(SLA_Y1).#LL & ^FAULT(SLA_Y1).#SRL & ^FAULT(SLA_Y1).#SLL
                    Axis_State(20).4 = 1
                ELSE
                    Axis_State(20).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(20).6 = 1
                ELSE
                    Axis_State(20).6 = 0
                END
                IF FAULT(SLA_Y1).#SRL
                    Axis_State(20).7 = 1
                ELSE
                    Axis_State(20).7 = 0
                END
                IF FAULT(SLA_Y1).#SLL
                    Axis_State(20).8 = 1
                ELSE
                    Axis_State(20).8 = 0
                END
                IF FAULT(SLA_Y1).#RL
                    Axis_State(20).9 = 1
                ELSE
                    Axis_State(20).9 = 0
                END
                IF FAULT(SLA_Y1).#LL
                    Axis_State(20).10 = 1
                ELSE
                    Axis_State(20).10 = 0
                END
                Axis_ActPos(20) = FPOS(SLA_Y1)
                END

            CASE 10:   ! 10
                IF MST(TT_X0).#ENABLED
                    Axis_State(2).0 = 1
                ELSE
                    Axis_State(2).0 = 0
                END
                IF FAULT(TT_X0).#DRIVE
                    Axis_State(2).1 = 1
                ELSE
                    Axis_State(2).1 = 0
                END
                IF MST(TT_X0).#MOVE
                    Axis_State(2).2 = 1
                ELSE
                    Axis_State(2).2 = 0
                END
                IF MFLAGS(TT_X0).#HOME & PA_HomeStatus(TT_X0)
                    Axis_State(2).3 = 1
                ELSE
                    Axis_State(2).3 = 0
                END
                IF FAULT(TT_X0) <> 0 & ^FAULT(TT_X0).#RL & ^FAULT(TT_X0).#LL & ^FAULT(TT_X0).#SRL & ^FAULT(TT_X0).#SLL
                    Axis_State(2).4 = 1
                ELSE
                    Axis_State(2).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(2).6 = 1
                ELSE
                    Axis_State(2).6 = 0
                END
                IF FAULT(TT_X0).#SRL
                    Axis_State(2).7 = 1
                ELSE
                    Axis_State(2).7 = 0
                END
                IF FAULT(TT_X0).#SLL
                    Axis_State(2).8 = 1
                ELSE
                    Axis_State(2).8 = 0
                END
                IF FAULT(TT_X0).#RL
                    Axis_State(2).9 = 1
                ELSE
                    Axis_State(2).9 = 0
                END
                IF FAULT(TT_X0).#LL
                    Axis_State(2).10 = 1
                ELSE
                    Axis_State(2).10 = 0
                END
                Axis_ActPos(2) = FPOS(TT_X0)
                END

            CASE 11:   ! 11
                IF MST(TT_X1).#ENABLED
                    Axis_State(3).0 = 1
                ELSE
                    Axis_State(3).0 = 0
                END
                IF FAULT(TT_X1).#DRIVE
                    Axis_State(3).1 = 1
                ELSE
                    Axis_State(3).1 = 0
                END
                IF MST(TT_X1).#MOVE
                    Axis_State(3).2 = 1
                ELSE
                    Axis_State(3).2 = 0
                END
                IF MFLAGS(TT_X1).#HOME & PA_HomeStatus(TT_X1)
                    Axis_State(3).3 = 1
                ELSE
                    Axis_State(3).3 = 0
                END
                IF FAULT(TT_X1) <> 0 & ^FAULT(TT_X1).#RL & ^FAULT(TT_X1).#LL & ^FAULT(TT_X1).#SRL & ^FAULT(TT_X1).#SLL
                    Axis_State(3).4 = 1
                ELSE
                    Axis_State(3).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(3).6 = 1
                ELSE
                    Axis_State(3).6 = 0
                END
                IF FAULT(TT_X1).#SRL
                    Axis_State(3).7 = 1
                ELSE
                    Axis_State(3).7 = 0
                END
                IF FAULT(TT_X1).#SLL
                    Axis_State(3).8 = 1
                ELSE
                    Axis_State(3).8 = 0
                END
                IF FAULT(TT_X1).#RL
                    Axis_State(3).9 = 1
                ELSE
                    Axis_State(3).9 = 0
                END
                IF FAULT(TT_X1).#LL
                    Axis_State(3).10 = 1
                ELSE
                    Axis_State(3).10 = 0
                END
                Axis_ActPos(3) = FPOS(TT_X1)
                END

            CASE 12:   ! 12
                IF MST(BT_X0).#ENABLED
                    Axis_State(7).0 = 1
                ELSE
                    Axis_State(7).0 = 0
                END
                IF FAULT(BT_X0).#DRIVE
                    Axis_State(7).1 = 1
                ELSE
                    Axis_State(7).1 = 0
                END
                IF MST(BT_X0).#MOVE
                    Axis_State(7).2 = 1
                ELSE
                    Axis_State(7).2 = 0
                END
                IF MFLAGS(BT_X0).#HOME & PA_HomeStatus(BT_X0)
                    Axis_State(7).3 = 1
                ELSE
                    Axis_State(7).3 = 0
                END
                IF FAULT(BT_X0) <> 0 & ^FAULT(BT_X0).#RL & ^FAULT(BT_X0).#LL & ^FAULT(BT_X0).#SRL & ^FAULT(BT_X0).#SLL
                    Axis_State(7).4 = 1
                ELSE
                    Axis_State(7).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(7).6 = 1
                ELSE
                    Axis_State(7).6 = 0
                END
                IF FAULT(BT_X0).#SRL
                    Axis_State(7).7 = 1
                ELSE
                    Axis_State(7).7 = 0
                END
                IF FAULT(BT_X0).#SLL
                    Axis_State(7).8 = 1
                ELSE
                    Axis_State(7).8 = 0
                END
                IF FAULT(BT_X0).#RL
                    Axis_State(7).9 = 1
                ELSE
                    Axis_State(7).9 = 0
                END
                IF FAULT(BT_X0).#LL
                    Axis_State(7).10 = 1
                ELSE
                    Axis_State(7).10 = 0
                END
                Axis_ActPos(7) = FPOS(BT_X0)
                END

            CASE 13:   ! 13
                IF MST(BT_X1).#ENABLED
                    Axis_State(8).0 = 1
                ELSE
                    Axis_State(8).0 = 0
                END
                IF FAULT(BT_X1).#DRIVE
                    Axis_State(8).1 = 1
                ELSE
                    Axis_State(8).1 = 0
                END
                IF MST(BT_X1).#MOVE
                    Axis_State(8).2 = 1
                ELSE
                    Axis_State(8).2 = 0
                END
                IF MFLAGS(BT_X1).#HOME & PA_HomeStatus(BT_X1)
                    Axis_State(8).3 = 1
                ELSE
                    Axis_State(8).3 = 0
                END
                IF FAULT(BT_X1) <> 0 & ^FAULT(BT_X1).#RL & ^FAULT(BT_X1).#LL & ^FAULT(BT_X1).#SRL & ^FAULT(BT_X1).#SLL
                    Axis_State(8).4 = 1
                ELSE
                    Axis_State(8).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(8).6 = 1
                ELSE
                    Axis_State(8).6 = 0
                END
                IF FAULT(BT_X1).#SRL
                    Axis_State(8).7 = 1
                ELSE
                    Axis_State(8).7 = 0
                END
                IF FAULT(BT_X1).#SLL
                    Axis_State(8).8 = 1
                ELSE
                    Axis_State(8).8 = 0
                END
                IF FAULT(BT_X1).#RL
                    Axis_State(8).9 = 1
                ELSE
                    Axis_State(8).9 = 0
                END
                IF FAULT(BT_X1).#LL
                    Axis_State(8).10 = 1
                ELSE
                    Axis_State(8).10 = 0
                END
                Axis_ActPos(8) = FPOS(BT_X1)
                END

            CASE 14:   ! 14
                IF MST(OL_X).#ENABLED
                    Axis_State(10).0 = 1
                ELSE
                    Axis_State(10).0 = 0
                END
                IF FAULT(OL_X).#DRIVE
                    Axis_State(10).1 = 1
                ELSE
                    Axis_State(10).1 = 0
                END
                IF MST(OL_X).#MOVE
                    Axis_State(10).2 = 1
                ELSE
                    Axis_State(10).2 = 0
                END
                IF MFLAGS(OL_X).#HOME & PA_HomeStatus(OL_X)
                    Axis_State(10).3 = 1
                ELSE
                    Axis_State(10).3 = 0
                END
                IF FAULT(OL_X) <> 0 & ^FAULT(OL_X).#RL & ^FAULT(OL_X).#LL & ^FAULT(OL_X).#SRL & ^FAULT(OL_X).#SLL
                    Axis_State(10).4 = 1
                ELSE
                    Axis_State(10).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(10).6 = 1
                ELSE
                    Axis_State(10).6 = 0
                END
                IF FAULT(OL_X).#SRL
                    Axis_State(10).7 = 1
                ELSE
                    Axis_State(10).7 = 0
                END
                IF FAULT(OL_X).#SLL
                    Axis_State(10).8 = 1
                ELSE
                    Axis_State(10).8 = 0
                END
                IF FAULT(OL_X).#RL
                    Axis_State(10).9 = 1
                ELSE
                    Axis_State(10).9 = 0
                END
                IF FAULT(OL_X).#LL
                    Axis_State(10).10 = 1
                ELSE
                    Axis_State(10).10 = 0
                END
                Axis_ActPos(10) = FPOS(OL_X)
                END

            CASE 15:   ! 15
                IF MST(OL_Y).#ENABLED
                    Axis_State(11).0 = 1
                ELSE
                    Axis_State(11).0 = 0
                END
                IF FAULT(OL_Y).#DRIVE
                    Axis_State(11).1 = 1
                ELSE
                    Axis_State(11).1 = 0
                END
                IF MST(OL_Y).#MOVE
                    Axis_State(11).2 = 1
                ELSE
                    Axis_State(11).2 = 0
                END
                IF MFLAGS(OL_Y).#HOME & PA_HomeStatus(OL_Y)
                    Axis_State(11).3 = 1
                ELSE
                    Axis_State(11).3 = 0
                END
                IF FAULT(OL_Y) <> 0 & ^FAULT(OL_Y).#RL & ^FAULT(OL_Y).#LL & ^FAULT(OL_Y).#SRL & ^FAULT(OL_Y).#SLL
                    Axis_State(11).4 = 1
                ELSE
                    Axis_State(11).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(11).6 = 1
                ELSE
                    Axis_State(11).6 = 0
                END
                IF FAULT(OL_Y).#SRL
                    Axis_State(11).7 = 1
                ELSE
                    Axis_State(11).7 = 0
                END
                IF FAULT(OL_Y).#SLL
                    Axis_State(11).8 = 1
                ELSE
                    Axis_State(11).8 = 0
                END
                IF FAULT(OL_Y).#RL
                    Axis_State(11).9 = 1
                ELSE
                    Axis_State(11).9 = 0
                END
                IF FAULT(OL_Y).#LL
                    Axis_State(11).10 = 1
                ELSE
                    Axis_State(11).10 = 0
                END
                Axis_ActPos(11) = FPOS(OL_Y)
                END

            CASE 16:   ! 16
                IF MST(OL_Z).#ENABLED
                    Axis_State(12).0 = 1
                ELSE
                    Axis_State(12).0 = 0
                END
                IF FAULT(OL_Z).#DRIVE
                    Axis_State(12).1 = 1
                ELSE
                    Axis_State(12).1 = 0
                END
                IF MST(OL_Z).#MOVE
                    Axis_State(12).2 = 1
                ELSE
                    Axis_State(12).2 = 0
                END
                IF MFLAGS(OL_Z).#HOME & PA_HomeStatus(OL_Z)
                    Axis_State(12).3 = 1
                ELSE
                    Axis_State(12).3 = 0
                END
                IF FAULT(OL_Z) <> 0 & ^FAULT(OL_Z).#RL & ^FAULT(OL_Z).#LL & ^FAULT(OL_Z).#SRL & ^FAULT(OL_Z).#SLL
                    Axis_State(12).4 = 1
                ELSE
                    Axis_State(12).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(12).6 = 1
                ELSE
                    Axis_State(12).6 = 0
                END
                IF FAULT(OL_Z).#SRL
                    Axis_State(12).7 = 1
                ELSE
                    Axis_State(12).7 = 0
                END
                IF FAULT(OL_Z).#SLL
                    Axis_State(12).8 = 1
                ELSE
                    Axis_State(12).8 = 0
                END
                IF FAULT(OL_Z).#RL
                    Axis_State(12).9 = 1
                ELSE
                    Axis_State(12).9 = 0
                END
                IF FAULT(OL_Z).#LL
                    Axis_State(12).10 = 1
                ELSE
                    Axis_State(12).10 = 0
                END
                Axis_ActPos(12) = FPOS(OL_Z)
                END

            CASE 18:   ! 18
                IF MST(OR_X).#ENABLED
                    Axis_State(13).0 = 1
                ELSE
                    Axis_State(13).0 = 0
                END
                IF FAULT(OR_X).#DRIVE
                    Axis_State(13).1 = 1
                ELSE
                    Axis_State(13).1 = 0
                END
                IF MST(OR_X).#MOVE
                    Axis_State(13).2 = 1
                ELSE
                    Axis_State(13).2 = 0
                END
                IF MFLAGS(OR_X).#HOME & PA_HomeStatus(OR_X)
                    Axis_State(13).3 = 1
                ELSE
                    Axis_State(13).3 = 0
                END
                IF FAULT(OR_X) <> 0 & ^FAULT(OR_X).#RL & ^FAULT(OR_X).#LL & ^FAULT(OR_X).#SRL & ^FAULT(OR_X).#SLL
                    Axis_State(13).4 = 1
                ELSE
                    Axis_State(13).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(13).6 = 1
                ELSE
                    Axis_State(13).6 = 0
                END
                IF FAULT(OR_X).#SRL
                    Axis_State(13).7 = 1
                ELSE
                    Axis_State(13).7 = 0
                END
                IF FAULT(OR_X).#SLL
                    Axis_State(13).8 = 1
                ELSE
                    Axis_State(13).8 = 0
                END
                IF FAULT(OR_X).#RL
                    Axis_State(13).9 = 1
                ELSE
                    Axis_State(13).9 = 0
                END
                IF FAULT(OR_X).#LL
                    Axis_State(13).10 = 1
                ELSE
                    Axis_State(13).10 = 0
                END
                Axis_ActPos(13) = FPOS(OR_X)
                END

            CASE 19:   ! 19
                IF MST(OR_Y).#ENABLED
                    Axis_State(14).0 = 1
                ELSE
                    Axis_State(14).0 = 0
                END
                IF FAULT(OR_Y).#DRIVE
                    Axis_State(14).1 = 1
                ELSE
                    Axis_State(14).1 = 0
                END
                IF MST(OR_Y).#MOVE
                    Axis_State(14).2 = 1
                ELSE
                    Axis_State(14).2 = 0
                END
                IF MFLAGS(OR_Y).#HOME & PA_HomeStatus(OR_Y)
                    Axis_State(14).3 = 1
                ELSE
                    Axis_State(14).3 = 0
                END
                IF FAULT(OR_Y) <> 0 & ^FAULT(OR_Y).#RL & ^FAULT(OR_Y).#LL & ^FAULT(OR_Y).#SRL & ^FAULT(OR_Y).#SLL
                    Axis_State(14).4 = 1
                ELSE
                    Axis_State(14).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(14).6 = 1
                ELSE
                    Axis_State(14).6 = 0
                END
                IF FAULT(OR_Y).#SRL
                    Axis_State(14).7 = 1
                ELSE
                    Axis_State(14).7 = 0
                END
                IF FAULT(OR_Y).#SLL
                    Axis_State(14).8 = 1
                ELSE
                    Axis_State(14).8 = 0
                END
                IF FAULT(OR_Y).#RL
                    Axis_State(14).9 = 1
                ELSE
                    Axis_State(14).9 = 0
                END
                IF FAULT(OR_Y).#LL
                    Axis_State(14).10 = 1
                ELSE
                    Axis_State(14).10 = 0
                END
                Axis_ActPos(14) = FPOS(OR_Y)
                END

            CASE 20:   ! 20
                IF MST(OR_Z).#ENABLED
                    Axis_State(15).0 = 1
                ELSE
                    Axis_State(15).0 = 0
                END
                IF FAULT(OR_Z).#DRIVE
                    Axis_State(15).1 = 1
                ELSE
                    Axis_State(15).1 = 0
                END
                IF MST(OR_Z).#MOVE
                    Axis_State(15).2 = 1
                ELSE
                    Axis_State(15).2 = 0
                END
                IF MFLAGS(OR_Z).#HOME & PA_HomeStatus(OR_Z)
                    Axis_State(15).3 = 1
                ELSE
                    Axis_State(15).3 = 0
                END
                IF FAULT(OR_Z) <> 0 & ^FAULT(OR_Z).#RL & ^FAULT(OR_Z).#LL & ^FAULT(OR_Z).#SRL & ^FAULT(OR_Z).#SLL
                    Axis_State(15).4 = 1
                ELSE
                    Axis_State(15).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(15).6 = 1
                ELSE
                    Axis_State(15).6 = 0
                END
                IF FAULT(OR_Z).#SRL
                    Axis_State(15).7 = 1
                ELSE
                    Axis_State(15).7 = 0
                END
                IF FAULT(OR_Z).#SLL
                    Axis_State(15).8 = 1
                ELSE
                    Axis_State(15).8 = 0
                END
                IF FAULT(OR_Z).#RL
                    Axis_State(15).9 = 1
                ELSE
                    Axis_State(15).9 = 0
                END
                IF FAULT(OR_Z).#LL
                    Axis_State(15).10 = 1
                ELSE
                    Axis_State(15).10 = 0
                END
                Axis_ActPos(15) = FPOS(OR_Z)
                END

            CASE 22:   ! 22
                IF MST(TWLP).#ENABLED
                    Axis_State(4).0 = 1
                ELSE
                    Axis_State(4).0 = 0
                END
                IF FAULT(TWLP).#DRIVE
                    Axis_State(4).1 = 1
                ELSE
                    Axis_State(4).1 = 0
                END
                IF MST(TWLP).#MOVE
                    Axis_State(4).2 = 1
                ELSE
                    Axis_State(4).2 = 0
                END
                IF MFLAGS(TWLP).#HOME & PA_HomeStatus(TWLP)
                    Axis_State(4).3 = 1
                ELSE
                    Axis_State(4).3 = 0
                END
                IF FAULT(TWLP) <> 0 & ^FAULT(TWLP).#RL & ^FAULT(TWLP).#LL & ^FAULT(TWLP).#SRL & ^FAULT(TWLP).#SLL
                    Axis_State(4).4 = 1
                ELSE
                    Axis_State(4).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(4).6 = 1
                ELSE
                    Axis_State(4).6 = 0
                END
                IF FAULT(TWLP).#SRL
                    Axis_State(4).7 = 1
                ELSE
                    Axis_State(4).7 = 0
                END
                IF FAULT(TWLP).#SLL
                    Axis_State(4).8 = 1
                ELSE
                    Axis_State(4).8 = 0
                END
                IF FAULT(TWLP).#RL
                    Axis_State(4).9 = 1
                ELSE
                    Axis_State(4).9 = 0
                END
                IF FAULT(TWLP).#LL
                    Axis_State(4).10 = 1
                ELSE
                    Axis_State(4).10 = 0
                END
                Axis_ActPos(4) = FPOS(TWLP)
                END

            CASE 23:   ! 23
                IF MST(BWLP).#ENABLED
                    Axis_State(9).0 = 1
                ELSE
                    Axis_State(9).0 = 0
                END
                IF FAULT(BWLP).#DRIVE
                    Axis_State(9).1 = 1
                ELSE
                    Axis_State(9).1 = 0
                END
                IF MST(BWLP).#MOVE
                    Axis_State(9).2 = 1
                ELSE
                    Axis_State(9).2 = 0
                END
                IF MFLAGS(BWLP).#HOME & PA_HomeStatus(BWLP)
                    Axis_State(9).3 = 1
                ELSE
                    Axis_State(9).3 = 0
                END
                IF FAULT(BWLP) <> 0 & ^FAULT(BWLP).#RL & ^FAULT(BWLP).#LL & ^FAULT(BWLP).#SRL & ^FAULT(BWLP).#SLL
                    Axis_State(9).4 = 1
                ELSE
                    Axis_State(9).4 = 0
                END
                IF AP_ComSupMotionRes = ACSStatus_Error
                    Axis_State(9).6 = 1
                ELSE
                    Axis_State(9).6 = 0
                END
                IF FAULT(BWLP).#SRL
                    Axis_State(9).7 = 1
                ELSE
                    Axis_State(9).7 = 0
                END
                IF FAULT(BWLP).#SLL
                    Axis_State(9).8 = 1
                ELSE
                    Axis_State(9).8 = 0
                END
                IF FAULT(BWLP).#RL
                    Axis_State(9).9 = 1
                ELSE
                    Axis_State(9).9 = 0
                END
                IF FAULT(BWLP).#LL
                    Axis_State(9).10 = 1
                ELSE
                    Axis_State(9).10 = 0
                END
                Axis_ActPos(9) = FPOS(BWLP)
                END

            DEFAULT:
                ! Unused axis indices (7,17,21) - do nothing
                END
        END   ! SWITCH i

        i = i + 1
		
    END   ! LOOP
END   ! WHILE

STOP
#7
!PNAME=EIP_RELY
!PDESC=

!EIP RELY
!100 INT IN FOR MASTER , 101 INT OUT FOR MASTER
!102 REAL IN FOR MASTER  ,103 REAL OUT FOR MASTER
WAIT 5000
AUTOEXEC:
WHILE 1
! ========== Output Integer Assembly (101) ==========
	EIPSETASM(101, 1, 2000, 0, 0) ! AXIS 0 (TT_Y0)
	EIPSETASM(101, 2, 2000, 1, 0) ! AXIS 1 (TT_Y1)
	EIPSETASM(101, 3, 2000, 2, 0) ! AXIS 2 (TT_X0)
	EIPSETASM(101, 4, 2000, 3, 0) ! AXIS 3 (TT_X1)
	EIPSETASM(101, 5, 2000, 4, 0) ! AXIS 4 (TWLP)
	EIPSETASM(101, 6, 2000, 5, 0) ! AXIS 5 (BT_Y0)
	EIPSETASM(101, 7, 2000, 6, 0) ! AXIS 6 (BT_Y1)
	EIPSETASM(101, 8, 2000, 7, 0) ! AXIS 7 (BT_X0)
	EIPSETASM(101, 9, 2000, 8, 0) ! AXIS 8 (BT_X1)
	EIPSETASM(101, 10, 2000, 9, 0) ! AXIS 9 (BWLP)
	EIPSETASM(101, 11, 2000, 10, 0) ! AXIS 10 (OL_X)
	EIPSETASM(101, 12, 2000, 11, 0) ! AXIS 11 (OL_Y)
	EIPSETASM(101, 13, 2000, 12, 0) ! AXIS 12 (OL_Z)
	EIPSETASM(101, 14, 2000, 13, 0) ! AXIS 13 (OR_X)
	EIPSETASM(101, 15, 2000, 14, 0) ! AXIS 14 (OR_Y)
	EIPSETASM(101, 16, 2000, 15, 0) ! AXIS 15 (OR_Z)
	EIPSETASM(101, 17, 2000, 16, 0) ! AXIS 16 (BC_Z0)
	EIPSETASM(101, 18, 2000, 17, 0) ! AXIS 17 (BC_Z1)
	EIPSETASM(101, 19, 2000, 18, 0) ! AXIS 18 (BC_Z2)
	EIPSETASM(101, 20, 2000, 19, 0) ! AXIS 19 (SLA_Y0)  
	EIPSETASM(101, 21, 2000, 20, 0) ! AXIS 20 (SLA_Y1)  
	EIPSETASM(101, 22, 1206, 0, 0) ! AxisGourpMove
	EIPSETASM(101, 23, 1257, 0, 0) ! AxisGourp_Optic_Switch
	EIPSETASM(101, 24, 1303, 0, 0) ! AxisGourp_UpTableX_Switch
	EIPSETASM(101, 25, 1353, 0, 0) ! AxisGourp_DownTableX_Switch
	EIPSETASM(101, 26, 1453, 0, 0) ! AxisGourp_Gantry_Switch
	EIPSETASM(101, 27, 1503, 0, 0) ! AxisGourp_SLA_Switch
	EIPSETASM(101, 28, 1553, 0, 0) ! AxisGourp_OpticZ_Switch
	EIPSETASM(101, 29, 1150, 0, 0) ! Home_All

! ========== Output Real Assembly (103) ==========
	EIPSETASM(103, 1, 2001, 0, 0) ! TT_Y0_Pos
	EIPSETASM(103, 2, 2002, 0, 0) ! TT_Y0_Vel
	EIPSETASM(103, 3, 2003, 0, 0) ! TT_Y0_Acc
	EIPSETASM(103, 4, 2004, 0, 0) ! TT_Y0_Dec
	EIPSETASM(103, 5, 2001, 1, 0) ! TT_Y1_Pos
	EIPSETASM(103, 6, 2002, 1, 0) ! TT_Y1_Vel
	EIPSETASM(103, 7, 2003, 1, 0) ! TT_Y1_Acc
	EIPSETASM(103, 8, 2004, 1, 0) ! TT_Y1_Dec
	EIPSETASM(103, 9, 2001, 2, 0) ! TT_X0_Pos
	EIPSETASM(103, 10, 2002, 2, 0) ! TT_X0_Vel
	EIPSETASM(103, 11, 2003, 2, 0) ! TT_X0_Acc
	EIPSETASM(103, 12, 2004, 2, 0) ! TT_X0_Dec
	EIPSETASM(103, 13, 2001, 3, 0) ! TT_X1_Pos
	EIPSETASM(103, 14, 2002, 3, 0) ! TT_X1_Vel
	EIPSETASM(103, 15, 2003, 3, 0) ! TT_X1_Acc
	EIPSETASM(103, 16, 2004, 3, 0) ! TT_X1_Dec
	EIPSETASM(103, 17, 2001, 4, 0) ! TWLP_Pos
	EIPSETASM(103, 18, 2002, 4, 0) ! TWLP_Vel
	EIPSETASM(103, 19, 2003, 4, 0) ! TWLP_Acc
	EIPSETASM(103, 20, 2004, 4, 0) ! TWLP_Dec
	EIPSETASM(103, 21, 2001, 5, 0) ! BT_Y0_Pos
	EIPSETASM(103, 22, 2002, 5, 0) ! BT_Y0_Vel
	EIPSETASM(103, 23, 2003, 5, 0) ! BT_Y0_Acc
	EIPSETASM(103, 24, 2004, 5, 0) ! BT_Y0_Dec
	EIPSETASM(103, 25, 2001, 6, 0) ! BT_Y1_Pos
	EIPSETASM(103, 26, 2002, 6, 0) ! BT_Y1_Vel
	EIPSETASM(103, 27, 2003, 6, 0) ! BT_Y1_Acc
	EIPSETASM(103, 28, 2004, 6, 0) ! BT_Y1_Dec
	EIPSETASM(103, 29, 2001, 7, 0) ! BT_X0_Pos
	EIPSETASM(103, 30, 2002, 7, 0) ! BT_X0_Vel
	EIPSETASM(103, 31, 2003, 7, 0) ! BT_X0_Acc
	EIPSETASM(103, 32, 2004, 7, 0) ! BT_X0_Dec
	EIPSETASM(103, 33, 2001, 8, 0) ! BT_X1_Pos
	EIPSETASM(103, 34, 2002, 8, 0) ! BT_X1_Vel
	EIPSETASM(103, 35, 2003, 8, 0) ! BT_X1_Acc
	EIPSETASM(103, 36, 2004, 8, 0) ! BT_X1_Dec
	EIPSETASM(103, 37, 2001, 9, 0) ! BWLP_Pos
	EIPSETASM(103, 38, 2002, 9, 0) ! BWLP_Vel
	EIPSETASM(103, 39, 2003, 9, 0) ! BWLP_Acc
	EIPSETASM(103, 40, 2004, 9, 0) ! BWLP_Dec
	EIPSETASM(103, 41, 2001, 10, 0) ! OL_X_Pos
	EIPSETASM(103, 42, 2002, 10, 0) ! OL_X_Vel
	EIPSETASM(103, 43, 2003, 10, 0) ! OL_X_Acc
	EIPSETASM(103, 44, 2004, 10, 0) ! OL_X_Dec
	EIPSETASM(103, 45, 2001, 11, 0) ! OL_Y_Pos
	EIPSETASM(103, 46, 2002, 11, 0) ! OL_Y_Vel
	EIPSETASM(103, 47, 2003, 11, 0) ! OL_Y_Acc
	EIPSETASM(103, 48, 2004, 11, 0) ! OL_Y_Dec
	EIPSETASM(103, 49, 2001, 12, 0) ! OL_Z_Pos
	EIPSETASM(103, 50, 2002, 12, 0) ! OL_Z_Vel
	EIPSETASM(103, 51, 2003, 12, 0) ! OL_Z_Acc
	EIPSETASM(103, 52, 2004, 12, 0) ! OL_Z_Dec
	EIPSETASM(103, 53, 2001, 13, 0) ! OR_X_Pos
	EIPSETASM(103, 54, 2002, 13, 0) ! OR_X_Vel
	EIPSETASM(103, 55, 2003, 13, 0) ! OR_X_Acc
	EIPSETASM(103, 56, 2004, 13, 0) ! OR_X_Dec
	EIPSETASM(103, 57, 2001, 14, 0) ! OR_Y_Pos
	EIPSETASM(103, 58, 2002, 14, 0) ! OR_Y_Vel
	EIPSETASM(103, 59, 2003, 14, 0) ! OR_Y_Acc
	EIPSETASM(103, 60, 2004, 14, 0) ! OR_Y_Dec
	EIPSETASM(103, 61, 2001, 15, 0) ! OR_Z_Pos
	EIPSETASM(103, 62, 2002, 15, 0) ! OR_Z_Vel
	EIPSETASM(103, 63, 2003, 15, 0) ! OR_Z_Acc
	EIPSETASM(103, 64, 2004, 15, 0) ! OR_Z_Dec
	EIPSETASM(103, 65, 2001, 16, 0) ! BC_Z0_Pos
	EIPSETASM(103, 66, 2002, 16, 0) ! BC_Z0_Vel
	EIPSETASM(103, 67, 2003, 16, 0) ! BC_Z0_Acc
	EIPSETASM(103, 68, 2004, 16, 0) ! BC_Z0_Dec
	EIPSETASM(103, 69, 2001, 17, 0) ! BC_Z1_Pos
	EIPSETASM(103, 70, 2002, 17, 0) ! BC_Z1_Vel
	EIPSETASM(103, 71, 2003, 17, 0) ! BC_Z1_Acc
	EIPSETASM(103, 72, 2004, 17, 0) ! BC_Z1_Dec
	EIPSETASM(103, 73, 2001, 18, 0) ! BC_Z2_Pos
	EIPSETASM(103, 74, 2002, 18, 0) ! BC_Z2_Vel
	EIPSETASM(103, 75, 2003, 18, 0) ! BC_Z2_Acc
	EIPSETASM(103, 76, 2004, 18, 0) ! BC_Z2_Dec
	EIPSETASM(103, 77, 2001, 19, 0) ! SLA_Y0_Pos
	EIPSETASM(103, 78, 2002, 19, 0) ! SLA_Y0_Vel
	EIPSETASM(103, 79, 2003, 19, 0) ! SLA_Y0_Acc
	EIPSETASM(103, 80, 2004, 19, 0) ! SLA_Y0_Dec
	EIPSETASM(103, 81, 2001, 20, 0) ! SLA_Y1_Pos
	EIPSETASM(103, 82, 2002, 20, 0) ! SLA_Y1_Vel
	EIPSETASM(103, 83, 2003, 20, 0) ! SLA_Y1_Acc
	EIPSETASM(103, 84, 2004, 20, 0) ! SLA_Y1_Dec

! ========== Output Real Assembly AxisGourp (103) ==========
	EIPSETASM(103, 85, 1200, 0, 0) ! AxisGourp_BC_Z0_Pos
	EIPSETASM(103, 86, 1201, 0, 0) ! AxisGourp_BC_Z1_Pos
	EIPSETASM(103, 87, 1202, 0, 0) ! AxisGourp_BC_Z2_Pos
	EIPSETASM(103, 88, 1203, 0, 0) ! AxisGourp_BC_Z0_Vel
	EIPSETASM(103, 89, 1250, 0, 0) ! AxisGourp_OL_X_Pos
	EIPSETASM(103, 90, 1251, 0, 0) ! AxisGourp_OL_Y_Pos
	EIPSETASM(103, 91, 1252, 0, 0) ! AxisGourp_OL_Z_Pos
	EIPSETASM(103, 92, 1253, 0, 0) ! AxisGourp_OR_X_Pos
	EIPSETASM(103, 93, 1254, 0, 0) ! AxisGourp_OR_Y_Pos
	EIPSETASM(103, 94, 1255, 0, 0) ! AxisGourp_OR_Z_Pos
	EIPSETASM(103, 95, 1256, 0, 0) ! AxisGourp_Optic_Vel
	EIPSETASM(103, 96, 1300, 0, 0) ! AxisGourp_TT_X0_Pos
	EIPSETASM(103, 97, 1301, 0, 0) ! AxisGourp_TT_X1_Pos
	EIPSETASM(103, 98, 1302, 0, 0) ! AxisGourp_UpTableX_Vel
	EIPSETASM(103, 99, 1350, 0, 0) ! AxisGourp_BT_X0_Pos
	EIPSETASM(103, 100, 1351, 0, 0) ! AxisGourp_BT_X1_Pos
	EIPSETASM(103, 101, 1352, 0, 0) ! AxisGourp_DownTableX_Vel
	EIPSETASM(103, 102, 1450, 0, 0) ! AxisGourp_TT_Y0_Pos
	EIPSETASM(103, 103, 1451, 0, 0) ! AxisGourp_TT_Y1_Pos
	EIPSETASM(103, 104, 1452, 0, 0) ! AxisGourp_Gantry_Vel
	EIPSETASM(103, 105, 1500, 0, 0) ! AxisGourp_SLA_Y0_Pos
	EIPSETASM(103, 106, 1501, 0, 0) ! AxisGourp_SLA_Y1_Pos
	EIPSETASM(103, 107, 1502, 0, 0) ! AxisGourp_SLA_Vel
	EIPSETASM(103, 108, 1550, 0, 0) ! AxisGourp_OL_Z1_Pos
	EIPSETASM(103, 109, 1551, 0, 0) ! AxisGourp_OR_Z1_Pos
	EIPSETASM(103, 110, 1552, 0, 0) ! AxisGourp_OpticZ_Vel

! ========== Input Integer Assembly (100) ==========
	EIPSETASM(100, 27, 2005, 0, 0) ! TT_Y0_State
	EIPSETASM(100, 28, 2005, 1, 0) ! TT_Y1_State
	EIPSETASM(100, 29, 2005, 2, 0) ! TT_X0_State
	EIPSETASM(100, 30, 2005, 3, 0) ! TT_X1_State
	EIPSETASM(100, 31, 2005, 4, 0) ! TWLP_State
	EIPSETASM(100, 32, 2005, 5, 0) ! BT_Y0_State
	EIPSETASM(100, 33, 2005, 6, 0) ! BT_Y1_State
	EIPSETASM(100, 34, 2005, 7, 0) ! BT_X0_State
	EIPSETASM(100, 35, 2005, 8, 0) ! BT_X1_State
	EIPSETASM(100, 36, 2005, 9, 0) ! BWLP_State
	EIPSETASM(100, 37, 2005, 10, 0) ! OL_X_State
	EIPSETASM(100, 38, 2005, 11, 0) ! OL_Y_State
	EIPSETASM(100, 39, 2005, 12, 0) ! OL_Z_State
	EIPSETASM(100, 40, 2005, 13, 0) ! OR_X_State
	EIPSETASM(100, 41, 2005, 14, 0) ! OR_Y_State
	EIPSETASM(100, 42, 2005, 15, 0) ! OR_Z_State
	EIPSETASM(100, 43, 2005, 16, 0) ! BC_Z0_State
	EIPSETASM(100, 44, 2005, 17, 0) ! BC_Z1_State
	EIPSETASM(100, 45, 2005, 18, 0) ! BC_Z2_State
	EIPSETASM(100, 46, 2005, 19, 0) ! SLA_Y0_State
	EIPSETASM(100, 47, 2005, 20, 0) ! SLA_Y1_State

! ========== Input Real Assembly (102) ==========
	EIPSETASM(102, 16, 2006, 0, 0) ! TT_Y0_ActPos
	EIPSETASM(102, 17, 2006, 1, 0) ! TT_Y1_ActPos
	EIPSETASM(102, 18, 2006, 2, 0) ! TT_X0_ActPos
	EIPSETASM(102, 19, 2006, 3, 0) ! TT_X1_ActPos
	EIPSETASM(102, 20, 2006, 4, 0) ! TWLP_ActPos
	EIPSETASM(102, 21, 2006, 5, 0) ! BT_Y0_ActPos
	EIPSETASM(102, 22, 2006, 6, 0) ! BT_Y1_ActPos
	EIPSETASM(102, 23, 2006, 7, 0) ! BT_X0_ActPos
	EIPSETASM(102, 24, 2006, 8, 0) ! BT_X1_ActPos
	EIPSETASM(102, 25, 2006, 9, 0) ! BWLP_ActPos
	EIPSETASM(102, 26, 2006, 10, 0) ! OL_X_ActPos
	EIPSETASM(102, 27, 2006, 11, 0) ! OL_Y_ActPos
	EIPSETASM(102, 28, 2006, 12, 0) ! OL_Z_ActPos
	EIPSETASM(102, 29, 2006, 13, 0) ! OR_X_ActPos
	EIPSETASM(102, 30, 2006, 14, 0) ! OR_Y_ActPos
	EIPSETASM(102, 31, 2006, 15, 0) ! OR_Z_ActPos
	EIPSETASM(102, 32, 2006, 16, 0) ! BC_Z0_ActPos
	EIPSETASM(102, 33, 2006, 17, 0) ! BC_Z1_ActPos
	EIPSETASM(102, 34, 2006, 18, 0) ! BC_Z2_ActPos
	EIPSETASM(102, 35, 2006, 19, 0) ! SLA_Y0_ActPos
	EIPSETASM(102, 36, 2006, 20, 0) ! SLA_Y1_ActPos

	WAIT 50
END
#8
!PNAME=
!PDESC=
!ON PA_ComSupMotionType=PCOccurAlarm & PST(8).#RUN<>1 & (PA_AlarmLevel=Alarm_High | PA_AlarmLevel=Alarm_Normal | PA_AlarmLevel=Alarm_Tips)
!  IF PA_AlarmCode=0
!      PA_AlarmCode=AlarmCode_PCOccurAlarm
!   END
!
!RET
ON PA_ComSupMotionType=PCClearAlarm & PST(8).#RUN<>1
  PA_ComSupMotionType=NoMotion
  AP_ACSStatus=1
  FILL (0,AP_AlarmCode)
 INT i=0
  BLOCK
     IF MAX(PA_ClearAlarmCode)>0 & MAX(AP_AlarmCode)>0
        LOOP SIZEOF(AP_AlarmCode)-1
           IF AP_AlarmCode(i)=1 & PA_ClearAlarmCode(i)=1
              AP_AlarmCode(i)=0
              PA_ClearAlarmCode(i)=0
            END
           i=i+1
        END
     END
  END
    FCLEAR ALL
 IF MAX(AP_AlarmCode,0,600)<1
	AP_ACSStatus=ACSStatus_OK
    AP_ComSupMotionRes=MotionReady
!	IF PST(1).#RUN<>1
!	   START 1,1
!	END
	IF PST(2).#RUN<>1
	  START 2,1
	END
	IF PST(4).#RUN<>1
	  START 4,1
	END
	IF PST(6).#RUN<>1
	  START 6,1
	END
	IF PST(7).#RUN<>1
	  START 7,1
	END
	IF PST(9).#RUN<>1
	  START 9,1
	END
	
 END
DISP "CLEAR ALARM OK"
RET 

ON EDGE (AxisGourpMove.12)
LOOP 24
INT j=0

MFLAGS(i).#HOME=0
j++

END

RET

! FIRST HOME
ON EDGE(AxisGourpMove.8=1&^AxisGourpMove.9&^AxisGourpMove.10&^AxisGourpMove.11)
!STOP 30;STOP 31;STOP 18;STOP 19;STOP 26;STOP 29
JudgeBufferRunning(31,31,18,19,26,29,5)
WAIT 100
START 30,1    !TWLP
START 31,1    !BWLP
START 18,1    !SLA_Y0
START 19,1    !SLA_Y1
START 26,1    !OL_Z
START 29,1    !OR_Z
DISP "TWLP??BWLP??SLA_Y0??SLA_Y1??OL_Z??OR_Z START HOME"
RET
! SECOND HOME
ON EDGE(^AxisGourpMove.8=1&AxisGourpMove.9&^AxisGourpMove.10&^AxisGourpMove.11)
!STOP 30
JudgeBufferRunning(17,5)
WAIT 100
START 17,1    !BC_ALL
DISP "BC_ALL HOME"

RET
!THIRDLY HOME
ON EDGE(^AxisGourpMove.8=1&^AxisGourpMove.9&AxisGourpMove.10&^AxisGourpMove.11)
!STOP 20;STOP 21;STOP 22;STOP 23;STOP 24;STOP 27
JudgeBufferRunning(20,21,22,23,24,27,5)
WAIT 100
START 20,1    !TT_X0
START 21,1    !TT_X1
START 22,1    !BT_X0
START 23,1    !BT_X1
START 24,1    !OL_X
START 27,1    !OR_X
RET

!FOURTHLY HOME
ON EDGE(^AxisGourpMove.8=1&^AxisGourpMove.9&^AxisGourpMove.10&AxisGourpMove.11)
!STOP 25;STOP 28;STOP 15;STOP 16
JudgeBufferRunning(25,28,15,16,5)
WAIT 100
START 25,1    !OL_Y
START 28,1    !OR_Y
START 15,1    !TT_Y0
START 16,1    !TT_Y0

RET



!
STOP
ON PST(4).#RUN<>1 | PST(2).#RUN<>1| PST(6).#RUN<>1| PST(7).#RUN<>1 |PST(9).#RUN<>1
	WAIT 1000

		OccurAlarm(AlarmCode_StateMachineNotRun,Alarm_High) 
	
RET
ON PST(4).#RUN<>1
!
!WAIT 1000
!
!START 4,1
!RET

!ON PST(6).#RUN<>1
!
!WAIT 1000
!
!START 6,1
!
!RET
!ON PST(7).#RUN<>1
!
!WAIT 1000
!
!START 7,1
!RET

#9
!PNAME=AXIS_PARA_PET
!PDESC=
WAIT 5000
AUTOEXEC:
INT InposAxis
REAL OutOffTime(32)
REAL OutOffAlarmTime=10000
REAL Inpos(32)
REAL PEpos(32)
REAL AxisFpos(32)
WHILE 1

IF AP_ACSStatus <>- 1

	Inpos(InposAxis) = 20 * TARGRAD(InposAxis)
	PEpos(InposAxis) = ABS(TPOS(InposAxis) - FPOS(InposAxis))

	IF PE(InposAxis) < Inpos(InposAxis)
		IF TARGRAD(InposAxis) < PEpos(InposAxis)

			IF AST(InposAxis).#MOVE& MST(InposAxis).#ENABLED

				IF OutOffTime(InposAxis) = 0

					OutOffTime(InposAxis) = TIME
					AxisFpos(InposAxis)=FPOS(InposAxis)
				END
				IF TIME- OutOffTime(InposAxis) > OutOffAlarmTime&ABS(AxisFpos(InposAxis)-FPOS(InposAxis))<Inpos(InposAxis)
!					OccurAlarm(551 + InposAxis, Alarm_Tips)
				END



			END
			ELSE		
		OutOffTime(InposAxis) = 0
		END
	
	ELSE		
		OutOffTime(InposAxis) = 0
	END

	InposAxis++ 
	IF InposAxis > 23

		InposAxis = 0
	END

END






IF VEL(TT_Y0)>700|VEL(TT_Y0)<=0
VEL(TT_Y0)=AxisVel(TT_Y0)
ACC(TT_Y0)=AxisVel(TT_Y0)*10
DEC(TT_Y0)=AxisVel(TT_Y0)*10
JERK(TT_Y0)=AxisVel(TT_Y0)*10
OccurAlarm(725, Alarm_Tips)
DISP "BUFFER 9"
END


IF JERK(TT_Y0)>10000|ACC(TT_Y0)>2000|DEC(TT_Y0)>2000
 JERK(TT_Y0)=6000
 ACC(TT_Y0)=2000
 DEC(TT_Y0)=2000
 DISP "SET JERK(TT_Y0)=6000"
OccurAlarm(725, Alarm_Tips)
DISP "BUFFER 9"
END

IF VEL(BT_Y0)>700|VEL(BT_Y0)<=0
VEL(BT_Y0)=AxisVel(BT_Y0)
ACC(BT_Y0)=AxisVel(BT_Y0)*10
DEC(BT_Y0)=AxisVel(BT_Y0)*10
JERK(BT_Y0)=AxisVel(BT_Y0)*10
OccurAlarm(727, Alarm_Tips)
DISP "BUFFER 9"

END

IF JERK(BT_Y0)>10000|ACC(BT_Y0)>2000|DEC(BT_Y0)>2000
 JERK(BT_Y0)=6000
 ACC(BT_Y0)=2000
 DEC(BT_Y0)=2000
 DISP "SET JERK(BT_Y0)=6000"
OccurAlarm(727, Alarm_Tips)
DISP "BUFFER 9"
END

IF  VEL(BC_Z0)<>VEL(BC_Z1)|VEL(BC_Z0)<>VEL(BC_Z2)|VEL(BC_Z1)<>VEL(BC_Z2)
VEL(BC_Z0)=AxisVel(BC_Z0)
VEL(BC_Z1)=AxisVel(BC_Z0)
VEL(BC_Z2)=AxisVel(BC_Z0)


ACC(BC_Z0)=AxisVel(BC_Z0)*10
ACC(BC_Z1)=AxisVel(BC_Z0)*10
ACC(BC_Z2)=AxisVel(BC_Z0)*10
DEC(BC_Z0)=AxisVel(BC_Z0)*10
DEC(BC_Z1)=AxisVel(BC_Z0)*10
DEC(BC_Z2)=AxisVel(BC_Z0)*10
JERK(BC_Z0)=AxisVel(BC_Z0)*50
JERK(BC_Z1)=AxisVel(BC_Z0)*50
JERK(BC_Z2)=AxisVel(BC_Z0)*50

 DISP "STAGE VEL ERRO"
OccurAlarm(729, Alarm_Tips)
DISP "BUFFER 9"

END

IF VEL(BC_Z0)>5|VEL(BC_Z0)<=0
VEL(BC_Z0)=AxisVel(BC_Z0)
ACC(BC_Z0)=AxisVel(BC_Z0)*10
DEC(BC_Z0)=AxisVel(BC_Z0)*10
JERK(BC_Z0)=AxisVel(BC_Z0)*50
OccurAlarm(729, Alarm_Tips)
DISP "BUFFER 9"
END

IF VEL(BC_Z1)>5|VEL(BC_Z1)<=0
VEL(BC_Z1)=AxisVel(BC_Z0)
ACC(BC_Z1)=AxisVel(BC_Z0)*10
DEC(BC_Z1)=AxisVel(BC_Z0)*10
JERK(BC_Z1)=AxisVel(BC_Z0)*50
OccurAlarm(730, Alarm_Tips)
DISP "BUFFER 9"
END

IF VEL(BC_Z2)>5|VEL(BC_Z2)<=0
VEL(BC_Z2)=AxisVel(BC_Z0)
ACC(BC_Z2)=AxisVel(BC_Z0)*10
DEC(BC_Z2)=AxisVel(BC_Z0)*10
JERK(BC_Z2)=AxisVel(BC_Z0)*50
OccurAlarm(731, Alarm_Tips)
DISP "BUFFER 9"
END



IF VEL(SLA_Y0)>5|VEL(SLA_Y0)<=0
VEL(SLA_Y0)=AxisVel(SLA_Y0)
ACC(SLA_Y0)=AxisVel(SLA_Y0)*10
DEC(SLA_Y0)=AxisVel(SLA_Y0)*10
JERK(SLA_Y0)=AxisVel(SLA_Y0)*10
OccurAlarm(733, Alarm_Tips)
DISP "BUFFER 9"
END

IF VEL(SLA_Y1)>5|VEL(SLA_Y1)<=0
VEL(SLA_Y1)=AxisVel(SLA_Y1)
ACC(SLA_Y1)=AxisVel(SLA_Y1)*10
DEC(SLA_Y1)=AxisVel(SLA_Y1)*10
JERK(SLA_Y1)=AxisVel(SLA_Y1)*10
OccurAlarm(734, Alarm_Tips)
DISP "BUFFER 9"
END

IF VEL(TT_X0)>0.75|VEL(TT_X0)<=0
VEL(TT_X0)=AxisVel(TT_X0)
ACC(TT_X0)=AxisVel(TT_X0)*10
DEC(TT_X0)=AxisVel(TT_X0)*10
JERK(TT_X0)=AxisVel(TT_X0)*100
OccurAlarm(735, Alarm_Tips)
DISP "BUFFER 9"
END

IF VEL(TT_X1)>0.75|VEL(TT_X1)<=0
VEL(TT_X1)=AxisVel(TT_X1)
ACC(TT_X1)=AxisVel(TT_X1)*10
DEC(TT_X1)=AxisVel(TT_X1)*10
JERK(TT_X1)=AxisVel(TT_X1)*100
OccurAlarm(736, Alarm_Tips)
DISP "BUFFER 9"
END

IF VEL(BT_X0)>0.75|VEL(BT_X0)<=0

VEL(BT_X0)=AxisVel(BT_X0)
ACC(BT_X0)=AxisVel(BT_X0)*10
DEC(BT_X0)=AxisVel(BT_X0)*10
JERK(BT_X0)=AxisVel(BT_X0)*100
OccurAlarm(737, Alarm_Tips)
DISP "BUFFER 9"
END

IF VEL(BT_X1)>0.75|VEL(BT_X1)<=0

VEL(BT_X1)=AxisVel(BT_X1)
ACC(BT_X1)=AxisVel(BT_X1)*10
DEC(BT_X1)=AxisVel(BT_X1)*10
JERK(BT_X1)=AxisVel(BT_X1)*100
DISP "BUFFER 9"
OccurAlarm(738, Alarm_Tips)
END



IF VEL(OL_X)>1.6|VEL(OL_X)<=0|ACC(OL_X)>VEL(OL_X)*10|DEC(OL_X)>VEL(OL_X)*10|JERK(OL_X)>VEL(OL_X)*50
VEL(OL_X)=AxisVel(OL_X)
ACC(OL_X)=AxisVel(OL_X)*10
DEC(OL_X)=AxisVel(OL_X)*10
JERK(OL_X)=AxisVel(OL_X)*10
OccurAlarm(739, Alarm_Tips)
DISP "BUFFER 9"
END

IF VEL(OL_Y)>1.6|VEL(OL_Y)<=0|ACC(OL_Y)>VEL(OL_Y)*10|DEC(OL_Y)>VEL(OL_Y)*10|JERK(OL_X)>VEL(OL_Y)*50
VEL(OL_Y)=AxisVel(OL_Y)
ACC(OL_Y)=AxisVel(OL_Y)*10
DEC(OL_Y)=AxisVel(OL_Y)*10
JERK(OL_Y)=AxisVel(OL_Y)*10
OccurAlarm(740, Alarm_Tips)
DISP "BUFFER 9"
END

IF VEL(OL_Z)>1.6|VEL(OL_Z)<=0|ACC(OL_Z)>VEL(OL_Z)*10|DEC(OL_Z)>VEL(OL_Z)*10|JERK(OL_X)>VEL(OL_Z)*50
VEL(OL_Z)=AxisVel(OL_Z)
ACC(OL_Z)=AxisVel(OL_Z)*10
DEC(OL_Z)=AxisVel(OL_Z)*10
JERK(OL_Z)=AxisVel(OL_Z)*10
OccurAlarm(741, Alarm_Tips)
DISP "BUFFER 9"
END


IF VEL(OR_X)>1.6|VEL(OR_X)<=0|ACC(OR_X)>VEL(OR_X)*10|DEC(OR_X)>VEL(OR_X)*10|JERK(OL_X)>VEL(OR_X)*50
VEL(OR_X)=AxisVel(OR_X)
ACC(OR_X)=AxisVel(OR_X)*10
DEC(OR_X)=AxisVel(OR_X)*10
JERK(OR_X)=AxisVel(OR_X)*10
OccurAlarm(743, Alarm_Tips)
DISP "BUFFER 9"
END

IF VEL(OR_Y)>1.6|VEL(OR_Y)<=0|ACC(OR_Y)>VEL(OR_Y)*10|DEC(OR_Y)>VEL(OR_Y)*10|JERK(OL_X)>VEL(OR_Y)*50
!DISP "22222"
VEL(OR_Y)=AxisVel(OR_Y)
ACC(OR_Y)=AxisVel(OR_Y)*10
DEC(OR_Y)=AxisVel(OR_Y)*10
JERK(OR_Y)=AxisVel(OR_Y)*10
OccurAlarm(744, Alarm_Tips)
DISP "BUFFER 9"
END

IF  VEL(OR_Z)>1.6|VEL(OR_Z)<=0|ACC(OR_Z)>VEL(OR_Z)*10|DEC(OR_Z)>VEL(OR_Z)*10|JERK(OL_X)>VEL(OR_Z)*50
VEL(OR_Z)=AxisVel(OR_Z)
ACC(OR_Z)=AxisVel(OR_Z)*10
DEC(OR_Z)=AxisVel(OR_Z)*10
JERK(OR_Z)=AxisVel(OR_Z)*10
OccurAlarm(745, Alarm_Tips)
DISP "BUFFER 9"
END

IF VEL(TWLP)>16|VEL(TWLP)<=0
VEL(TWLP)=AxisVel(TWLP)
ACC(TWLP)=AxisVel(TWLP)*10
DEC(TWLP)=AxisVel(TWLP)*10
JERK(TWLP)=AxisVel(TWLP)*10
OccurAlarm(747, Alarm_Tips)
DISP "BUFFER 9"
END

IF VEL(BWLP)>20|VEL(BWLP)<=0
VEL(BWLP)=AxisVel(BWLP)
ACC(BWLP)=AxisVel(BWLP)*10
DEC(BWLP)=AxisVel(BWLP)*10
JERK(BWLP)=AxisVel(BWLP)*10
OccurAlarm(748, Alarm_Tips)
DISP "BUFFER 9"
END




END








STOP












#10
!PNAME=
!PDESC=
LOOP 10

PTP/R SLA_Y0,-0.002
SCTRIGGER/2 2 
TILL ^MST(8).#MOVE



END

STOP

#11
!PNAME=
!PDESC=
ENABLE 0
VEL(0)=1

PTP 0,100000
WHILE ^MST(0).#INPOS
DISP PPOS(0)
END

STOP
#13
!PNAME=PID
!PDESC=
!SLVKP(BT_Y0)=150
!SLVKI(BT_Y0)=150
!SLPKP(BT_Y0)=160
!SLAFF(BT_Y0)=1200
!
!SLVKP(BT_Y1)=20
!SLVKI(BT_Y1)=60
!SLPKP(BT_Y1)=10
!SLAFF(BT_Y1)=200
!TARGRAD(BT_Y1)=0.01

SLVKP(8)=30
SLPKP(8)=350
SLVKI(8)=400
SLAFF(8)=3000


TARGRAD(8)=0.001
TARGRAD(9)=0.001

SLVKP(BT_Y0)=828.774 
SLVKI(BT_Y0)=154.416
SLPKP(BT_Y0)=200
SLAFF(BT_Y0)=500 

SLVKP(BT_Y1)=300
SLVKI(BT_Y1)=200
SLPKP(BT_Y1)=200
SLAFF(BT_Y1)=1




MFLAGS(BT_Y0).#NOTCH=0
SLVNFRQ(BT_Y0)= 283.113
SLVNWID (BT_Y0)=78.4795 
SLVNATT (BT_Y0)=5.54269

SLVKP(TT_Y0)=600
SLVKI(TT_Y0)=300
SLPKP(TT_Y0)=200
SLAFF(TT_Y0)=50
!



SLVKP(TT_Y1)=200
SLVKI(TT_Y1)=200
SLPKP(TT_Y1)=200
SLAFF(TT_Y1)=50




MFLAGS(TT_Y0).#NOTCH=0
SLVNFRQ(TT_Y0)=276
SLVNWID (TT_Y0)=20
SLVNATT (TT_Y0)=3

MFLAGS(TT_Y1).#NOTCH=0
SLVNFRQ(TT_Y1)=276
SLVNWID (TT_Y1)=20
SLVNATT (TT_Y1)=3
TARGRAD(TT_Y1)=0.001
SLDZMAX(TT_Y1)=0.005
SLDZMIN(TT_Y1)=0.002
!
!SLVKP(TT_Y1)=5
!SLVKI(TT_Y1)=30
!SLPKP(TT_Y1)=10
!SLVSOF(TT_Y1)=700
!
!
!MFLAGS(TT_Y1).#NOTCH=0
!SLVNFRQ(TT_Y1)=705
!SLVNWID (TT_Y1)=10
!SLVNATT (TT_Y1)=10
!TARGRAD(TT_Y1)=0.01


!SLVKP(8)=20
!SLVKI(8)=300
!SLPKP(8)=300
!SLAFF(8)=1000
!MFLAGS(8).#NOFILT=0
!MFLAGS(8).#NANO=1
!SLVSOF (8)=700
!SLFRC(8)=10
!SLFRCN(8)=10
!TARGRAD(8)=0.001
! SLZFF(8)=0.001
!SLDZMAX(8)=0.001 
!SLDZMIN(8)=0.0001
!SLDZTIME(8) =1
!MFLAGS(8).#NOTCH=1
!SLVNFRQ(8)=414 
!SLVNWID (8)=5
!SLVNATT (8)=10
!
!
!
!
!SLVKP(9)=40
!SLVKI(9)=300
!SLPKP(9)=400
!SLAFF(9)=200
!MFLAGS(9).#NOFILT=1
!MFLAGS(9).#NANO=1
!SLVSOF (9)=1000
!SLFRC(9)=20
!SLFRCN(9)=20
!TARGRAD(9)=0.01
! SLZFF(9)=0.001
!SLDZMAX(9)=0.001 
!SLDZMIN(9)=0.0001
!SLDZTIME(9) =1
!
!
!
!SLPKP(5)=100
!SLVKP(5)=110
!SLVKI(5)=150
!SLAFF(5)=30
!TARGRAD(5)=0.005
!
!
!SLVKP(OL_Y)=60
!SLVKI(OL_Y)=80
!SLPKP(OL_Y)=10
!SLAFF(OL_Y)=0
!
!SLVKP(OR_Y)=120
!SLVKI(OR_Y)=80
!SLPKP(OR_Y)=50


STOP

#15
!PNAME=TT_Y0_HOME
!PDESC=
!TT_Y0_HOME
HOMING_TT_Gantry:


PA_HomeStatus(TT_Y0)=0


!------- Logical  Motion  ------------------------------------------------------------
FCLEAR TT_Y0
FDEF(TT_Y0).#SLL=0
FDEF(TT_Y0).#SRL=0
!FDEF(TT_Y0).#SLL=0
FDEF(TT_Y1).#RL=0
FDEF(TT_Y1).#RL=0
FMASK(TT_Y0).#SRL=0
FMASK(TT_Y0).#SLL=0
!FMASK(TT_Y1).#RL=1
!ENABLE (TT_Y0); TILL MST(TT_Y0).#ENABLED
MFLAGS(TT_Y0).#HOME = 0
!TILL PA_Sys_DataEnsure=1
!DISABLE TT_Y0 
!WAIT 500
!ENABLE TT_Y0

	IF ^MFLAGS(TT_Y0).#BRUSHOK             !commutation
		COMMUT (TT_Y0), XRMS(TT_Y0)*0.8      !commut=commutation
		TILL MFLAGS(TT_Y0).#BRUSHOK
	END

HOMEVELL(TT_Y0) = PA_HomeVel(TT_Y0)
HOMEVELI(TT_Y0) = PA_HomeVel(TT_Y0)/2
ACC(TT_Y0)=PA_HomeVel(TT_Y0)*10
DEC(TT_Y0)=PA_HomeVel(TT_Y0)*10
JERK(TT_Y0)=PA_HomeVel(TT_Y0)*50


WAIT 100
!!!!-296.0164
HomeAxis(TT_Y0)=TT_Y0
HomeStartTime(TT_Y0)=TIME
HOME TT_Y0, PA_HomeMode(TT_Y0), PA_HomeVel(TT_Y0) , ,PA_HomeOffset(TT_Y0),PA_HomeCurrentLimit(TT_Y0), ,1
DISP "TT_Gantry Start HOME"
TILL MFLAGS(TT_Y0).#HOME=1
WAIT 100
SET FPOS(TT_Y1)=0


FDEF(TT_Y0).#SRL=1
FDEF(TT_Y0).#SLL=1
FDEF(TT_Y0).#RL=1
FDEF(TT_Y0).#LL=1
FDEF(TT_Y1).#RL=1
FDEF(TT_Y1).#RL=1
!FMASK(TT_Y1).#RL=0
!SLLIMIT(TT_Y0)=-531  
!SRLIMIT(TT_Y0)=3	 

!SET FPOS(TT_Y0)=0
ACC(TT_Y0)=1000
DEC(TT_Y0)=1000
JERK(TT_Y0)=4000
PTP/EV TT_Y0,0,200
TILL MST(TT_Y0).#INPOS
FMASK(TT_Y0).#SRL=1
FMASK(TT_Y0).#SLL=1
SLLIMIT(TT_Y0)=PA_LimitN(TT_Y0)
SRLIMIT(TT_Y0)=PA_LimitP(TT_Y0)
WAIT 1000
PA_HomeStatus(TT_Y0)=1 ;DISP "TT_Gantry Home OK"


!------- Reset API Status  -------------------------------------------------------------
!Buffer_API_Activate(1)=0
!------- Buffer Finish Status  ---------------------------------------------------------	                   
!Buffer_Motion_Finish(1)=1
!DISABLE(TT_Y0)

STOP
#16
!PNAME=BT_Y0_HOME
!PDESC=
!BT_Y0home
HOMING_BT_Gantry:

PA_HomeStatus(BT_Y0)=0


!------- Logical  Motion  ------------------------------------------------------------
FCLEAR BT_Y0
FDEF(BT_Y0).#SLL=0
FDEF(BT_Y0).#SRL=0
FMASK(BT_Y0).#SRL=0
FMASK(BT_Y0).#SLL=0
!ENABLE (BT_Y0); TILL MST(BT_Y0).#ENABLED
MFLAGS(BT_Y0).#HOME = 0
!TILL PA_Sys_DataEnsure=1
!DISABLE BT_Y0 
!WAIT 500
!ENABLE BT_Y0
!XCURI(BT_Y1)=40
!XCURV(BT_Y1)=80

HOMEVELL(BT_Y0) = PA_HomeVel(BT_Y0)
HOMEVELI(BT_Y0) = PA_HomeVel(BT_Y0)/2
ACC(BT_Y0)=PA_HomeVel(BT_Y0)*10
DEC(BT_Y0)=PA_HomeVel(BT_Y0)*10
JERK(BT_Y0)=PA_HomeVel(BT_Y0)*50

	IF ^MFLAGS(BT_Y0).#BRUSHOK             !commutation
		COMMUT (BT_Y0), XRMS(BT_Y0)*0.8      !commut=commutation
		TILL MFLAGS(BT_Y0).#BRUSHOK
	END

HomeAxis(BT_Y0)=BT_Y0
HomeStartTime(BT_Y0)=TIME
HOME BT_Y0, PA_HomeMode(BT_Y0), PA_HomeVel(BT_Y0) , ,PA_HomeOffset(BT_Y0),PA_HomeCurrentLimit(BT_Y0), ,1
DISP "BT_Gantry Start HOME"
TILL MFLAGS(BT_Y0).#HOME=1
SET FPOS(BT_Y1)=0



WAIT 1000
!SET FPOS(BT_Y0)=0
ACC(BT_Y0)=1000
DEC(BT_Y0)=1000
JERK(BT_Y0)=4000

PTP/EV BT_Y0,0,200
TILL MST(BT_Y0).#INPOS
FDEF(BT_Y0).#SRL=1
FDEF(BT_Y0).#SLL=1
FDEF(BT_Y0).#RL=1
FDEF(BT_Y0).#LL=1
SLLIMIT(BT_Y0)=PA_LimitN(BT_Y0)
SRLIMIT(BT_Y0)=PA_LimitP(BT_Y0)
FMASK(BT_Y0).#SRL=1
FMASK(BT_Y0).#SLL=1
PA_HomeStatus(BT_Y0)=1 ;DISP "BT_Gantry Home Done"
!XCURI(BT_Y1)=10
!XCURV(BT_Y1)=20
!------- Reset API Status  -------------------------------------------------------------
!Buffer_API_Activate(1)=0
!------- Buffer Finish Status  ---------------------------------------------------------	                   
!Buffer_Motion_Finish(1)=1
!DISABLE(BT_Y0)

STOP
#17
!PNAME=BC_ALL_HOME
!PDESC=
!BC_ALL HOME
HOMING_BC_ALL:
PA_HomeStatus(BC_Z0)=0
!------- Confirm API Status  -----------------------------------------------------------
!Buffer_API_Activate(10)=1
!------- Logical  Motion  ------------------------------------------------------------

! AP_AllHome_Finish=0
MFLAGS(BC_Z0).#HOME = 0
MFLAGS(BC_Z1).#HOME = 0
MFLAGS(BC_Z2).#HOME = 0

FMASK(BC_Z0).#SRL=1
FMASK(BC_Z0).#SLL=1

FMASK(BC_Z1).#SRL=1
FMASK(BC_Z1).#SLL=1

FMASK(BC_Z2).#SRL=1
FMASK(BC_Z2).#SLL=1

PTP/V (BC_Z0,BC_Z1,BC_Z2),0,0,0,1

FCLEAR BC_Z0
FDEF(BC_Z0).#SLL=0
FDEF(BC_Z0).#SRL=0
!ENABLE (BC_Z1); TILL MST(BC_Z1).#ENABLED
IF FAULT(BC_Z0).#LL
PTP/RE BC_Z0,1
END
MFLAGS(BC_Z0).#HOME = 0
!TILL PA_Sys_DataEnsure=1
HOMEVELL(BC_Z0) = PA_HomeVel(BC_Z0)
HOMEVELI(BC_Z0) = PA_HomeVel(BC_Z0)/2

TILL ^MST(BC_Z0).#MOVE,10000

FCLEAR BC_Z1
FDEF(BC_Z1).#SLL=0
FDEF(BC_Z1).#SRL=0
!ENABLE (BC_Z1); TILL MST(BC_Z1).#ENABLED
IF FAULT(BC_Z1).#LL
PTP/RE BC_Z1,1
END
MFLAGS(BC_Z1).#HOME = 0
!TILL PA_Sys_DataEnsure=1
HOMEVELL(BC_Z1) = PA_HomeVel(BC_Z1)
HOMEVELI(BC_Z1) = PA_HomeVel(BC_Z1)/2


FCLEAR BC_Z2
FDEF(BC_Z2).#SLL=0
FDEF(BC_Z2).#SRL=0
!ENABLE (BC_Z2); TILL MST(BC_Z2).#ENABLED
IF FAULT(BC_Z2).#LL
PTP/RE BC_Z2,1
END
MFLAGS(BC_Z2).#HOME = 0
!TILL PA_Sys_DataEnsure=1
HOMEVELL(BC_Z2) = PA_HomeVel(BC_Z2)
HOMEVELI(BC_Z2) = PA_HomeVel(BC_Z2)/2

HOME BC_Z0, PA_HomeMode(BC_Z0), PA_HomeVel(BC_Z0) , ,0,PA_HomeCurrentLimit(BC_Z0)
DISP "BC_Z0 Start HOME"
HOME BC_Z1, PA_HomeMode(BC_Z1), PA_HomeVel(BC_Z1) , ,0,PA_HomeCurrentLimit(BC_Z1)
DISP "BC_Z1 Start HOME"
HOME BC_Z2, PA_HomeMode(BC_Z2), PA_HomeVel(BC_Z2) , ,0,PA_HomeCurrentLimit(BC_Z2)
DISP "BC_Z2 Start HOME"
TILL MFLAGS(BC_Z0).#HOME=1&MFLAGS(BC_Z1).#HOME=1&MFLAGS(BC_Z2).#HOME=1

WAIT 1000
SET FPOS(BC_Z0)=PA_HomeOffset(BC_Z0)

SET FPOS(BC_Z1)=PA_HomeOffset(BC_Z1)


SET FPOS(BC_Z2)=PA_HomeOffset(BC_Z2)
TILL MFLAGS(BC_Z0).#HOME&MFLAGS(BC_Z1).#HOME&MFLAGS(BC_Z2).#HOME
ptp/v (BC_Z0,BC_Z1,BC_Z2),0,0,0,1
TILL MST(BC_Z0).#INPOS&MST(BC_Z1).#INPOS&MST(BC_Z2).#INPOS,10000
FDEF(BC_Z0).#SRL=1
FDEF(BC_Z0).#SLL=1
SLLIMIT(BC_Z0)=PA_LimitN(BC_Z0)
SRLIMIT(BC_Z0)=PA_LimitP(BC_Z0)
FMASK(BC_Z0).#SRL=1
FMASK(BC_Z0).#SLL=1



FDEF(BC_Z1).#SRL=1
FDEF(BC_Z1).#SLL=1
SLLIMIT(BC_Z1)=PA_LimitN(BC_Z2)
SRLIMIT(BC_Z1)=PA_LimitP(BC_Z2)
FMASK(BC_Z1).#SRL=1
FMASK(BC_Z1).#SLL=1





FDEF(BC_Z2).#SRL=1
FDEF(BC_Z2).#SLL=1
SLLIMIT(BC_Z2)=PA_LimitN(BC_Z2)
SRLIMIT(BC_Z2)=PA_LimitP(BC_Z2)
FMASK(BC_Z2).#SRL=1
FMASK(BC_Z2).#SLL=1




!BLOCK
!CALL HOMING_BC_Z0
!CALL HOMING_BC_Z1
!CALL HOMING_BC_Z2
!END

PA_HomeStatus(BC_Z0)=1 
PA_HomeStatus(BC_Z1)=1 
PA_HomeStatus(BC_Z2)=1 
;DISP "BC_Z0??BC_Z1??BC_Z2 Home Done"
STOP




#18
!PNAME=SLA_Y0_HOME
!PDESC=
!SLA_Y0 HOME
HOMING_SLA_Y0:
PA_HomeStatus(SLA_Y0)=0

!------- Confirm API Status  -----------------------------------------------------------
!Buffer_API_Activate(1)=1
!------- Assignment Variable Parameters -----------------------------------------------
!GLOBAL INT SLA_Y0_HomeVelocity,SLA_Y0_HomeMode,SLA_Y0_HomeOffset1,SLA_Y0_HomingCurrLimit
!------- Comfirm Variable Parameters --------------------------------------------------
!SLA_Y0_HomeVelocity=1 ; SLA_Y0_HomeMode=17; SLA_Y0_HomeOffset1=0; SLA_Y0_HomingCurrLimit=30
!------- Comfirm Axis PID Parameters --------------------------------------------------

!------- Logical  Motion  ------------------------------------------------------------
FCLEAR SLA_Y0
FDEF(SLA_Y0).#SLL=0
FDEF(SLA_Y0).#SRL=0
FMASK(SLA_Y0).#SRL=0
FMASK(SLA_Y0).#SLL=0
!ENABLE (SLA_Y0); TILL MST(SLA_Y0).#ENABLED
	IF FAULT(SLA_Y0).#LL

		JOG/V SLA_Y0, 1
		TILL ^FAULT(SLA_Y0).#LL
		KILL SLA_Y0
		WAIT 100
		END
MFLAGS(SLA_Y0).#HOME = 0
!TILL PA_Sys_DataEnsure=1
HOMEVELL(SLA_Y0) = PA_HomeVel(SLA_Y0)
HOMEVELI(SLA_Y0) = PA_HomeVel(SLA_Y0)/2


HomeAxis(SLA_Y0)=SLA_Y0
HomeStartTime(SLA_Y0)=TIME
HOME SLA_Y0, PA_HomeMode(SLA_Y0), PA_HomeVel(SLA_Y0) , ,0,PA_HomeCurrentLimit(SLA_Y0)
DISP "SLA_Y0 Start HOME"
TILL MFLAGS(SLA_Y0).#HOME=1
ptp/ev SLA_Y0,PA_HomeOffset(SLA_Y0),1
TILL ^MST(SLA_Y0).#MOVE
WAIT 1000
SET FPOS(SLA_Y0)=0

FDEF(SLA_Y0).#SRL=1
FDEF(SLA_Y0).#SLL=1
SLLIMIT(SLA_Y0)=PA_LimitN(SLA_Y0)
SRLIMIT(SLA_Y0)=PA_LimitP(SLA_Y0)
FMASK(SLA_Y0).#SRL=1
FMASK(SLA_Y0).#SLL=1

PA_HomeStatus(SLA_Y0)=1 ;DISP "SLA_Y0 Home Done"
!ptp/ev SLA_Y0,-150,10
!TILL ^MST(SLA_Y0).#MOVE
!SET FPOS(SLA_Y0)=0
!SLLIMIT(SLA_Y0)=ACSSoftWarePosition(SLA_Y0)(0)
!------- Reset API Status  -------------------------------------------------------------
!Buffer_API_Activate(1)=0
!------- Buffer Finish Status  ---------------------------------------------------------	                   
!Buffer_Motion_Finish(1)=1
!DISABLE(SLA_Y0)


STOP
#19
!PNAME=SLA_Y1_HOME
!PDESC=
!SLA_Y1
HOMING_SLA_Y1:
PA_HomeStatus(SLA_Y1)=0

!------- Confirm API Status  -----------------------------------------------------------
!Buffer_API_Activate(1)=1
!------- Assignment Variable Parameters -----------------------------------------------
!GLOBAL INT SLA_Y1_HomeVelocity,SLA_Y1_HomeMode,SLA_Y1_HomeOffset1,SLA_Y1_HomingCurrLimit
!------- Comfirm Variable Parameters --------------------------------------------------
!SLA_Y1_HomeVelocity=1 ; SLA_Y1_HomeMode=17; SLA_Y1_HomeOffset1=0; SLA_Y1_HomingCurrLimit=50
!------- Comfirm Axis PID Parameters --------------------------------------------------

!------- Logical  Motion  ------------------------------------------------------------
FCLEAR SLA_Y1
FDEF(SLA_Y1).#SLL=0
FDEF(SLA_Y1).#SRL=0
FMASK(SLA_Y1).#SRL=0
FMASK(SLA_Y1).#SLL=0
!ENABLE (SLA_Y1); TILL MST(SLA_Y1).#ENABLED
	IF FAULT(SLA_Y1).#LL

		JOG/V SLA_Y1, 1
		TILL ^FAULT(SLA_Y1).#LL
		KILL SLA_Y1
		WAIT 100
		END
MFLAGS(SLA_Y1).#HOME = 0
!TILL PA_Sys_DataEnsure=1
HOMEVELL(SLA_Y1) = PA_HomeVel(SLA_Y1)
HOMEVELI(SLA_Y1) = PA_HomeVel(SLA_Y1)/2


HomeAxis(SLA_Y1)=SLA_Y1
HomeStartTime(SLA_Y1)=TIME
HOME SLA_Y1, PA_HomeMode(SLA_Y1), PA_HomeVel(SLA_Y1) , ,0,PA_HomeCurrentLimit(SLA_Y1)
DISP "SLA_Y1 Start HOME"
TILL MFLAGS(SLA_Y1).#HOME=1
ptp/ev SLA_Y1,PA_HomeOffset(SLA_Y1),1
TILL ^MST(SLA_Y1).#MOVE
WAIT 1000
SET FPOS(SLA_Y1)=0

FDEF(SLA_Y1).#SRL=1
FDEF(SLA_Y1).#SLL=1
SLLIMIT(SLA_Y1)=PA_LimitN(SLA_Y1)
SRLIMIT(SLA_Y1)=PA_LimitP(SLA_Y1)
FMASK(SLA_Y1).#SRL=1
FMASK(SLA_Y1).#SLL=1

PA_HomeStatus(SLA_Y1)=1 ;DISP "SLA_Y1 Home Done"
!ptp/ev SLA_Y1,-150,10
!TILL ^MST(SLA_Y1).#MOVE
!SET FPOS(SLA_Y1)=0
!SLLIMIT(SLA_Y1)=ACSSoftWarePosition(SLA_Y1)(0)
!------- Reset API Status  -------------------------------------------------------------
!Buffer_API_Activate(1)=0
!------- Buffer Finish Status  ---------------------------------------------------------	                   
!Buffer_Motion_Finish(1)=1
!DISABLE(SLA_Y1)


STOP
#20
!PNAME=TT_X0_HOME
!PDESC=
!TT_X0 HOME
HOMING_TT_X0:

PA_HomeStatus(TT_X0)=0

!------- Confirm API Status  -----------------------------------------------------------
!Buffer_API_Activate(1)=1
!------- Assignment Variable Parameters -----------------------------------------------
!GLOBAL INT TT_X0_HomeVelocity,TT_X0_HomeMode,TT_X0_HomeOffset1,TT_X0_HomingCurrLimit
!------- Comfirm Variable Parameters --------------------------------------------------
!TT_X0_HomeVelocity=0.2 ; TT_X0_HomeMode=17; TT_X0_HomeOffset1=0; TT_X0_HomingCurrLimit=50
!!------- Comfirm Axis PID Parameters --------------------------------------------------

!------- Logical  Motion  ------------------------------------------------------------
FCLEAR TT_X0
FDEF(TT_X0).#SLL=0
FDEF(TT_X0).#SRL=0
FMASK(TT_X0).#SRL=0
FMASK(TT_X0).#SLL=0
!ENABLE (TT_X0); TILL MST(TT_X0).#ENABLED
MFLAGS(TT_X0).#HOME = 0
!TILL PA_Sys_DataEnsure=1
HOMEVELL(TT_X0) = PA_HomeVel(TT_X0)
HOMEVELI(TT_X0) = PA_HomeVel(TT_X0)/2

	IF FAULT(TT_X0).#LL

		JOG/V TT_X0, 0.2
		TILL ^FAULT(TT_X0).#LL
		KILL TT_X0
		WAIT 100
		END
        HomeAxis(TT_X0)=TT_X0
        HomeStartTime(TT_X0)=TIME
		HOME TT_X0, PA_HomeMode(TT_X0), PA_HomeVel(TT_X0), , PA_HomeOffset(TT_X0), PA_HomeCurrentLimit(TT_X0)
		DISP "TT_X0 Start HOME"
		TILL MFLAGS(TT_X0).#HOME = 1
		
WAIT 1000
!SET FPOS(TT_X0)=0

PTP/EV TT_X0, 0, 0.3

TILL MST(TT_X0).#INPOS

FDEF(TT_X0).#SRL=1
FDEF(TT_X0).#SLL=1
SLLIMIT(TT_X0)=PA_LimitN(TT_X0)
SRLIMIT(TT_X0)=PA_LimitP(TT_X0)
FMASK(TT_X0).#SRL=1
FMASK(TT_X0).#SLL=1
!


PA_HomeStatus(TT_X0)=1 ;DISP "TT_X0 Home Done"
!SET FPOS(TT_X0)=0
!SLLIMIT(TT_X0)=ACSSoftWarePosition(TT_X0)(0)
!------- Reset API Status  -------------------------------------------------------------
!Buffer_API_Activate(1)=0
!------- Buffer Finish Status  ---------------------------------------------------------	                   
!Buffer_Motion_Finish(1)=1
!DISABLE(TT_X0)

STOP
#21
!PNAME=TT_X1_HOME
!PDESC=
!TT_X1
HOMING_TT_X1:
PA_HomeStatus(TT_X1) = 0

!------- Confirm API Status  -----------------------------------------------------------
!Buffer_API_Activate(1)=1
!------- Assignment Variable Parameters -----------------------------------------------
!GLOBAL INT TT_X1_HomeVelocity,TT_X1_HomeMode,TT_X1_HomeOffset1,TT_X1_HomingCurrLimit
!------- Comfirm Variable Parameters --------------------------------------------------
!TT_X1_HomeVelocity=0.2 ; TT_X1_HomeMode=17; TT_X1_HomeOffset1=0; TT_X1_HomingCurrLimit=50
!------- Comfirm Axis PID Parameters --------------------------------------------------

!------- Logical  Motion  ------------------------------------------------------------
FCLEAR TT_X1
FDEF(TT_X1).#SLL= 0
FDEF(TT_X1).#SRL= 0
FMASK(TT_X1).#SRL= 0
FMASK(TT_X1).#SLL= 0
!ENABLE (TT_X1); TILL MST(TT_X1).#ENABLED
MFLAGS(TT_X1).#HOME= 0
!TILL PA_Sys_DataEnsure=1
HOMEVELL(TT_X1) = PA_HomeVel(TT_X1)
HOMEVELI(TT_X1) = PA_HomeVel(TT_X1) / 2

	IF FAULT(TT_X1).#LL

		JOG/v TT_X1, 0.2
		TILL ^FAULT(TT_X1).#LL
		KILL TT_X1
		WAIT 100
		END
		HomeAxis(TT_X1)=TT_X1
        HomeStartTime(TT_X1)=TIME
		HOME TT_X1, PA_HomeMode(TT_X1), PA_HomeVel(TT_X1), , PA_HomeOffset(TT_X1), PA_HomeCurrentLimit(TT_X1)
		DISP "TT_X1 Start HOME"
		TILL MFLAGS(TT_X1).#HOME = 1

WAIT 1000
!SET FPOS(TT_X1)=0

PTP/EV TT_X1, 0, 0.3

	TILL MST(TT_X1).#INPOS
	FDEF(TT_X1).#SRL = 1
	FDEF(TT_X1).#SLL = 1
	SLLIMIT(TT_X1) =PA_LimitN(TT_X1)
	SRLIMIT(TT_X1) = PA_LimitP(TT_X1)
	FMASK(TT_X1).#SRL = 1
	FMASK(TT_X1).#SLL = 1
	

	PA_HomeStatus(TT_X1) = 1 ;DISP "TT_X1 Home Done"
!SET FPOS(TT_X1)=0
!SLLIMIT(TT_X1)=ACSSoftWarePosition(TT_X1)(0)
!------- Reset API Status  -------------------------------------------------------------
!Buffer_API_Activate(1)=0
!------- Buffer Finish Status  ---------------------------------------------------------	                   
!Buffer_Motion_Finish(1)=1
!DISABLE(TT_X1)

STOP   
#22
!PNAME=BT_X0_HOME
!PDESC=
!BT_X0 HOME
HOMING_BT_X0:
PA_HomeStatus(BT_X0)=0

!------- Confirm API Status  -----------------------------------------------------------
!Buffer_API_Activate(1)=1
!------- Assignment Variable Parameters -----------------------------------------------
!GLOBAL INT BT_X0_HomeVelocity,BT_X0_HomeMode,BT_X0_HomeOffset1,BT_X0_HomingCurrLimit
!------- Comfirm Variable Parameters --------------------------------------------------
!BT_X0_HomeVelocity=0.2 ; BT_X0_HomeMode=17; BT_X0_HomeOffset1=0; BT_X0_HomingCurrLimit=50
!------- Comfirm Axis PID Parameters --------------------------------------------------

!------- Logical  Motion  ------------------------------------------------------------
FCLEAR BT_X0
FDEF(BT_X0).#SLL=0
FDEF(BT_X0).#SRL=0
FMASK(BT_X0).#SRL=0
FMASK(BT_X0).#SLL=0
!ENABLE (BT_X0); TILL MST(BT_X0).#ENABLED
MFLAGS(BT_X0).#HOME = 0
!TILL PA_Sys_DataEnsure=1
HOMEVELL(BT_X0) = PA_HomeVel(BT_X0)
HOMEVELI(BT_X0) = PA_HomeVel(BT_X0)/2
	IF FAULT(BT_X0).#RL

		JOG/V BT_X0, -0.5
		TILL ^FAULT(BT_X0).#RL
		KILL BT_X0
		WAIT 100
		END

HomeAxis(BT_X0)=BT_X0
HomeStartTime(BT_X0)=TIME
HOME BT_X0, PA_HomeMode(BT_X0), PA_HomeVel(BT_X0) , ,PA_HomeOffset(BT_X0),PA_HomeCurrentLimit(BT_X0)
DISP "BT_X0 Start HOME"
TILL MFLAGS(BT_X0).#HOME=1

WAIT 1000
!SET FPOS(BT_X0)=0

PTP/EV BT_X0,0,0.5
TILL ^MST(BT_X0).#MOVE
FDEF(BT_X0).#SRL=1
FDEF(BT_X0).#SLL=1
SLLIMIT(BT_X0)=PA_LimitN(BT_X0)
SRLIMIT(BT_X0)=PA_LimitP(BT_X0)
FMASK(BT_X0).#SRL=1
FMASK(BT_X0).#SLL=1

PA_HomeStatus(BT_X0)=1 ;DISP "BT_X0 Home Done"
!SET FPOS(BT_X0)=0
!SLLIMIT(BT_X0)=ACSSoftWarePosition(BT_X0)(0)
!------- Reset API Status  -------------------------------------------------------------
!Buffer_API_Activate(1)=0
!------- Buffer Finish Status  ---------------------------------------------------------	                   
!Buffer_Motion_Finish(1)=1
!DISABLE(BT_X0)

STOP
#23
!PNAME=BT_X1_HOME
!PDESC=
!BT_X1 HOME
HOMING_BT_X1:
PA_HomeStatus(BT_X1)=0

!------- Confirm API Status  -----------------------------------------------------------
!Buffer_API_Activate(1)=1
!------- Assignment Variable Parameters -----------------------------------------------
!GLOBAL INT BT_X1_HomeVelocity,BT_X1_HomeMode,BT_X1_HomeOffset1,BT_X1_HomingCurrLimit
!------- Comfirm Variable Parameters --------------------------------------------------
!BT_X1_HomeVelocity=0.2 ; BT_X1_HomeMode=17; BT_X1_HomeOffset1=0; BT_X1_HomingCurrLimit=50
!------- Comfirm Axis PID Parameters --------------------------------------------------

!------- Logical  Motion  ------------------------------------------------------------
FCLEAR BT_X1
FDEF(BT_X1).#SLL=0
FDEF(BT_X1).#SRL=0
FMASK(BT_X1).#SRL=0
FMASK(BT_X1).#SLL=0
!ENABLE (BT_X1); TILL MST(BT_X1).#ENABLED
MFLAGS(BT_X1).#HOME = 0
!TILL PA_Sys_DataEnsure=1
HOMEVELL(BT_X1) = PA_HomeVel(BT_X1)
HOMEVELI(BT_X1) = PA_HomeVel(BT_X1)/2
	IF FAULT(BT_X1).#RL

		JOG/V BT_X1, -0.5
		TILL ^FAULT(BT_X1).#RL
		KILL BT_X1
		WAIT 100
		END

HomeAxis(BT_X1)=BT_X1
HomeStartTime(BT_X1)=TIME
HOME BT_X1, PA_HomeMode(BT_X1), PA_HomeVel(BT_X1) , ,PA_HomeOffset(BT_X1),PA_HomeCurrentLimit(BT_X1)
DISP "BT_X1 Start HOME"
TILL MFLAGS(BT_X1).#HOME=1

WAIT 1000
!SET FPOS(BT_X1)=0

ptp/ev BT_X1,0,0.5
TILL ^MST(BT_X1).#MOVE
FDEF(BT_X1).#SRL=1
FDEF(BT_X1).#SLL=1
SLLIMIT(BT_X1)=PA_LimitN(BT_X1)
SRLIMIT(BT_X1)=PA_LimitP(BT_X1)
FMASK(BT_X1).#SRL=1
FMASK(BT_X1).#SLL=1

PA_HomeStatus(BT_X1)=1 ;DISP "BT_X1 Home Done"
!SET FPOS(BT_X1)=0
!SLLIMIT(BT_X1)=ACSSoftWarePosition(BT_X1)(0)
!------- Reset API Status  -------------------------------------------------------------
!Buffer_API_Activate(1)=0
!------- Buffer Finish Status  ---------------------------------------------------------	                   
!Buffer_Motion_Finish(1)=1
!DISABLE(BT_X1)

STOP
#24
!PNAME=OL_X_HOME
!PDESC=
!OL_X HOME
HOMING_OL_X:

PA_HomeStatus(OL_X)=0

!------- Confirm API Status  -----------------------------------------------------------
!Buffer_API_Activate(1)=1
!------- Assignment Variable Parameters -----------------------------------------------
!GLOBAL INT OL_X_HomeVelocity,OL_X_HomeMode,OL_X_HomeOffset1,OL_X_HomingCurrLimit
!------- Comfirm Variable Parameters --------------------------------------------------
!OL_X_HomeVelocity=1 ; OL_X_HomeMode=17; OL_X_HomeOffset1=0; OL_X_HomingCurrLimit=50
!------- Comfirm Axis PID Parameters --------------------------------------------------

!------- Logical  Motion  ------------------------------------------------------------
FCLEAR OL_X
FDEF(OL_X).#SLL=0
FDEF(OL_X).#SRL=0
FMASK(OL_X).#SRL=0
FMASK(OL_X).#SLL=0
FDEF(OL_X).#LL=0
FDEF(OL_X).#RL=0
!ENABLE (OL_X); TILL MST(OL_X).#ENABLED
MFLAGS(OL_X).#HOME = 0
!TILL PA_Sys_DataEnsure=1

!	IF ^MFLAGS(OL_X).#BRUSHOK             !commutation
!		COMMUT (OL_X), XRMS(OL_X)*0.8      !commut=commutation
!		TILL MFLAGS(OL_X).#BRUSHOK
!	END

HOMEVELL(OL_X) = PA_HomeVel(OL_X)
HOMEVELI(OL_X) = PA_HomeVel(OL_X)/2

	IF FAULT(OL_X).#LL

		JOG/V OL_X, -1
		TILL ^FAULT(OL_X).#LL
		KILL OL_X
		WAIT 100
		END

ACC(OL_X)=PA_HomeVel(OL_X)*10
DEC(OL_X)=PA_HomeVel(OL_X)*10
JERK(OL_X)=PA_HomeVel(OL_X)*50
HomeAxis(OL_X)=OL_X
HomeStartTime(OL_X)=TIME
HOME OL_X, PA_HomeMode(OL_X), PA_HomeVel(OL_X) , ,0,PA_HomeCurrentLimit(OL_X)
DISP "OL_X Start HOME"
TILL MFLAGS(OL_X).#HOME=1


!WAIT 1000
!SET FPOS(OL_X)=0

!ptp/ev OL_X,-5.0215,1
!ptp/ev OL_X,-4.6515,1
!ptp/ev OL_X,-4.8015,1
!ptp/ev OL_X,-9.4055,1
ptp/ev OL_X,PA_HomeOffset(OL_X),1
TILL MST(OL_X).#INPOS
WAIT 1000
SET FPOS(OL_X)=-85
FDEF(OL_X).#RL=1
FDEF(OL_X).#LL=1
!FDEF(OL_X).#SRL=1
!FDEF(OL_X).#SLL=1
!FDEF(OL_X).#RL=1
!FDEF(OL_X).#LL=1
SLLIMIT(OL_X)=PA_LimitN(OL_X)
SRLIMIT(OL_X)=PA_LimitP(OL_X)
FMASK(OL_X).#SRL=1
FMASK(OL_X).#SLL=1
FDEF(OL_X).#SLL=1
FDEF(OL_X).#SRL=1
PA_HomeStatus(OL_X)=1 ;DISP "OL_X Home Done"
!SLLIMIT(OL_X)=ACSSoftWarePosition(OL_X)(0)
!------- Reset API Status  -------------------------------------------------------------
!Buffer_API_Activate(1)=0
!------- Buffer Finish Status  ---------------------------------------------------------	                   
!Buffer_Motion_Finish(1)=1
!DISABLE(OL_X)

STOP
#25
!PNAME=OL_Y_HOME
!PDESC=
!OL_Y HOME
HOMING_OL_Y:

PA_HomeStatus(OL_Y)=0

!------- Confirm API Status  -----------------------------------------------------------
!Buffer_API_Activate(1)=1
!------- Assignment Variable Parameters -----------------------------------------------
!GLOBAL INT OL_Y_HomeVelocity,OL_Y_HomeMode,OL_Y_HomeOffset1,OL_Y_HomingCurrLimit
!------- Comfirm Variable Parameters --------------------------------------------------
!OL_Y_HomeVelocity=1 ; OL_Y_HomeMode=18; OL_Y_HomeOffset1=0; OL_Y_HomingCurrLimit=50
!------- Comfirm Axis PID Parameters --------------------------------------------------

!------- Logical  Motion  ------------------------------------------------------------
FCLEAR OL_Y
FDEF(OL_Y).#SLL=0
FDEF(OL_Y).#SRL=0
FMASK(OL_Y).#SRL=0
FMASK(OL_Y).#SLL=0
!ENABLE (OL_Y); TILL MST(OL_Y).#ENABLED
	IF FAULT(OL_Y).#RL

		JOG/V OL_Y, -1
		TILL ^FAULT(OL_Y).#RL
		KILL OL_Y
		WAIT 100
		END
MFLAGS(OL_Y).#HOME = 0
!TILL PA_Sys_DataEnsure=1
HOMEVELL(OL_Y) = PA_HomeVel(OL_Y)
HOMEVELI(OL_Y) = PA_HomeVel(OL_Y)/2


ACC(OL_Y)=PA_HomeVel(OL_Y)*10
DEC(OL_Y)=PA_HomeVel(OL_Y)*10
JERK(OL_Y)=PA_HomeVel(OL_Y)*50
HomeAxis(OL_Y)=OL_Y
HomeStartTime(OL_Y)=TIME
HOME OL_Y, PA_HomeMode(OL_Y), PA_HomeVel(OL_Y) , ,0,PA_HomeCurrentLimit(OL_Y)
DISP "OL_Y Start HOME"
TILL MFLAGS(OL_Y).#HOME=1


!ptp/ev OL_Y,-27.1314,1
!ptp/ev OL_Y,-27.2564,1
!ptp/ev OL_Y,-26.7504,1
ptp/ev OL_Y,PA_HomeOffset(OL_Y),1
TILL ^MST(OL_Y).#MOVE
WAIT 1000
SET FPOS(OL_Y)=0
!FDEF(OL_Y).#SRL=1
!FDEF(OL_Y).#SLL=1
SLLIMIT(OL_Y)=PA_LimitN(OL_Y)
SRLIMIT(OL_Y)=PA_LimitP(OL_Y)
FMASK(OL_Y).#SRL=1
FMASK(OL_Y).#SLL=1
FDEF(OL_Y).#SLL=1
FDEF(OL_Y).#SRL=1
PA_HomeStatus(OL_Y)=1 ;DISP "OL_Y Home Done"
!SLLIMIT(OL_Y)=ACSSoftWarePosition(OL_Y)(0)
!------- Reset API Status  -------------------------------------------------------------
!Buffer_API_Activate(1)=0
!------- Buffer Finish Status  ---------------------------------------------------------	                   
!Buffer_Motion_Finish(1)=1
!DISABLE(OL_Y)

STOP
#26
!PNAME=OL_Z_HOME
!PDESC=
!OL_Z HOME
HOMING_OL_Z:

PA_HomeStatus(OL_Z)=0

!------- Confirm API Status  -----------------------------------------------------------
!Buffer_API_Activate(1)=1
!------- Assignment Variable Parameters -----------------------------------------------
!GLOBAL INT OL_Z_HomeVelocity,OL_Z_HomeMode,OL_Z_HomeOffset1,OL_Z_HomingCurrLimit
!------- Comfirm Variable Parameters --------------------------------------------------
!OL_Z_HomeVelocity=0.5 ; OL_Z_HomeMode=17; OL_Z_HomeOffset1=0; OL_Z_HomingCurrLimit=50
!!------- Comfirm Axis PID Parameters --------------------------------------------------

!------- Logical  Motion  ------------------------------------------------------------
FCLEAR OL_Z
FDEF(OL_Z).#SLL=0	
FDEF(OL_Z).#SRL=0
FMASK(OL_Z).#SRL=0
FMASK(OL_Z).#SLL=0
	IF FAULT(OL_Z).#LL

		JOG/V OL_Z, 1
		TILL ^FAULT(OL_Z).#LL
		KILL OL_Z
		WAIT 100
		END
!ENABLE (OL_Z); TILL MST(OL_Z).#ENABLED
MFLAGS(OL_Z).#HOME = 0
!TILL PA_Sys_DataEnsure=1
HOMEVELL(OL_Z) = PA_HomeVel(OL_Z)
HOMEVELI(OL_Z) = PA_HomeVel(OL_Z)/2


ACC(OL_Z)=PA_HomeVel(OL_Z)*10
DEC(OL_Z)=PA_HomeVel(OL_Z)*10
JERK(OL_Z)=PA_HomeVel(OL_Z)*50
HomeAxis(OL_Z)=OL_Z
HomeStartTime(OL_Z)=TIME
HOME OL_Z, PA_HomeMode(OL_Z), PA_HomeVel(OL_Z) , ,0,PA_HomeCurrentLimit(OL_Z)
DISP "OL_Z Start HOME"
TILL MFLAGS(OL_Z).#HOME=1




WAIT 1000
!SET FPOS(OL_Z)=0

ptp/ev OL_Z,PA_HomeOffset(OL_Z),1
TILL ^MST(OL_Z).#MOVE
WAIT 1000
SET FPOS(OL_Z)=0
WAIT 1000
FDEF(OL_Z).#SRL=1
FDEF(OL_Z).#SLL=1
FDEF(OL_Z).#RL=1
FDEF(OL_Z).#LL=1
SLLIMIT(OL_Z)=PA_LimitN(OL_Z)
SRLIMIT(OL_Z)=PA_LimitP(OL_Z)
FMASK(OL_Z).#SRL=1
FMASK(OL_Z).#SLL=1
PA_HomeStatus(OL_Z)=1 ;DISP "OL_Z Home Done"
!SLLIMIT(OL_Z)=ACSSoftWarePosition(OL_Z)(0)
!------- Reset API Status  -------------------------------------------------------------
!Buffer_API_Activate(1)=0
!------- Buffer Finish Status  ---------------------------------------------------------	                   
!Buffer_Motion_Finish(1)=1
!DISABLE(OL_Z)

STOP
#27
!PNAME=OR_X_HOME
!PDESC=
!OR_X HOME
HOMING_OR_X:

PA_HomeStatus(OR_X)=0

!------- Confirm API Status  -----------------------------------------------------------
!Buffer_API_Activate(1)=1
!------- Assignment Variable Parameters -----------------------------------------------
!GLOBAL INT OR_X_HomeVelocity,OR_X_HomeMode,OR_X_HomeOffset1,OR_X_HomingCurrLimit
!------- Comfirm Variable Parameters --------------------------------------------------
!OR_X_HomeVelocity=0.5 ; OR_X_HomeMode=18; OR_X_HomeOffset1=0; OR_X_HomingCurrLimit=50
!!------- Comfirm Axis PID Parameters --------------------------------------------------

!------- Logical  Motion  ------------------------------------------------------------
FCLEAR OR_X
FDEF(OR_X).#SLL=0
FDEF(OR_X).#SRL=0
FMASK(OR_X).#SRL=0
FMASK(OR_X).#SLL=0
!ENABLE (OR_X); TILL MST(OR_X).#ENABLED
MFLAGS(OR_X).#HOME = 0
!TILL PA_Sys_DataEnsure=1
HOMEVELL(OR_X) = PA_HomeVel(OR_X)
HOMEVELI(OR_X) = PA_HomeVel(OR_X)/2

	IF FAULT(OR_X).#LL

		JOG/V OR_X, 1
		TILL ^FAULT(OR_X).#LL
		KILL OR_X
		WAIT 100
		END


ACC(OR_X)=PA_HomeVel(OR_X)*10
DEC(OR_X)=PA_HomeVel(OR_X)*10
JERK(OR_X)=PA_HomeVel(OR_X)*50
HomeAxis(OR_X)=OR_X
HomeStartTime(OR_X)=TIME
HOME OR_X, PA_HomeMode(OR_X), PA_HomeVel(OR_X) , ,0,PA_HomeCurrentLimit(OR_X)
DISP "OR_X Start HOME"
TILL MFLAGS(OR_X).#HOME=1



!WAIT 1000
!SET FPOS(OR_X)=0

!ptp/ev OR_X,4.1164,1
!ptp/ev OR_X,4.7714,1
!ptp/ev OR_X,4.5364,1
!ptp/ev OR_X,9.1364,1
ptp/ev OR_X,PA_HomeOffset(OR_X),1
TILL MST(OR_X).#INPOS
WAIT 1000
SET FPOS(OR_X)=85
!FDEF(OR_X).#SRL=1
!FDEF(OR_X).#SLL=1
SLLIMIT(OR_X)=PA_LimitN(OR_X)
SRLIMIT(OR_X)=PA_LimitP(OR_X)
FDEF(OR_X).#SLL=1
FDEF(OR_X).#SRL=1
FMASK(OR_X).#SRL=1
FMASK(OR_X).#SLL=1
PA_HomeStatus(OR_X)=1 ;DISP "OR_X Home Done"
!SLLIMIT(OR_X)=ACSSoftWarePosition(OR_X)(0)
!------- Reset API Status  -------------------------------------------------------------
!Buffer_API_Activate(1)=0
!------- Buffer Finish Status  ---------------------------------------------------------	                   
!Buffer_Motion_Finish(1)=1
!DISABLE(OR_X)

STOP
#28
!PNAME=OR_Y_HOME
!PDESC=
!OR_Y HOME
HOMING_OR_Y:

PA_HomeStatus(OR_Y)=0

!------- Confirm API Status  -----------------------------------------------------------
!Buffer_API_Activate(1)=1
!------- Assignment Variable Parameters -----------------------------------------------
!GLOBAL INT OR_Y_HomeVelocity,OR_Y_HomeMode,OR_Y_HomeOffset1,OR_Y_HomingCurrLimit
!------- Comfirm Variable Parameters --------------------------------------------------
!OR_Y_HomeVelocity=1.8 ; OR_Y_HomeMode=17; OR_Y_HomeOffset1=0; OR_Y_HomingCurrLimit=70
!------- Comfirm Axis PID Parameters --------------------------------------------------

!------- Logical  Motion  ------------------------------------------------------------
FCLEAR OR_Y
FDEF(OR_Y).#SLL=0
FDEF(OR_Y).#SRL=0
FMASK(OR_Y).#SRL=0
FMASK(OR_Y).#SLL=0
!ENABLE (OR_Y); TILL MST(OR_Y).#ENABLED
	IF FAULT(OR_Y).#RL

		JOG/V OR_Y, -1
		TILL ^FAULT(OR_Y).#RL
		KILL OR_Y
		WAIT 100
		END
MFLAGS(OR_Y).#HOME = 0
!TILL PA_Sys_DataEnsure=1
HOMEVELL(OR_Y) = PA_HomeVel(OR_Y)
HOMEVELI(OR_Y) = PA_HomeVel(OR_Y)/2


HomeAxis(OR_Y)=OR_Y
HomeStartTime(OR_Y)=TIME
ACC(OR_Y)=PA_HomeVel(OR_Y)*10
DEC(OR_Y)=PA_HomeVel(OR_Y)*10
JERK(OR_Y)=PA_HomeVel(OR_Y)*50
HOME OR_Y, PA_HomeMode(OR_Y), PA_HomeVel(OR_Y) , ,0,PA_HomeCurrentLimit(OR_Y)
DISP "OR_Y Start HOME"
TILL MFLAGS(OR_Y).#HOME=1



!ptp/ev OR_Y,-28.00785,1
!ptp/ev OR_Y,-28.32885,1
!ptp/ev OR_Y,-28.25885,1
!ptp/ev OR_Y,-27.87785,1
ptp/ev OR_Y,PA_HomeOffset(OR_Y),1
TILL ^MST(OR_Y).#MOVE
WAIT 1000
SET FPOS(OR_Y)=0
!FDEF(OR_Y).#SRL=1
!FDEF(OR_Y).#SLL=1
SLLIMIT(OR_Y)=PA_LimitN(OR_Y)
SRLIMIT(OR_Y)=PA_LimitP(OR_Y)
FMASK(OR_Y).#SRL=1
FMASK(OR_Y).#SLL=1
FDEF(OR_Y).#SLL=1
FDEF(OR_Y).#SRL=1
PA_HomeStatus(OR_Y)=1 ;DISP "OR_Y Home Done"
!SLLIMIT(OR_Y)=ACSSoftWarePosition(OR_Y)(0)
!------- Reset API Status  -------------------------------------------------------------
!Buffer_API_Activate(1)=0
!------- Buffer Finish Status  ---------------------------------------------------------	                   
!Buffer_Motion_Finish(1)=1
!DISABLE(OR_Y)

STOP
#29
!PNAME=OR_Z_HOME
!PDESC=
!OR_Z HOME
HOMING_OR_Z:

PA_HomeStatus(OR_Z)=0

!------- Confirm API Status  -----------------------------------------------------------
!Buffer_API_Activate(1)=1
!------- Assignment Variable Parameters -----------------------------------------------
!GLOBAL INT OR_Z_HomeVelocity,OR_Z_HomeMode,OR_Z_HomeOffset1,OR_Z_HomingCurrLimit
!------- Comfirm Variable Parameters --------------------------------------------------
!OR_Z_HomeVelocity=1 ; OR_Z_HomeMode=17; OR_Z_HomeOffset1=0; OR_Z_HomingCurrLimit=50
!------- Comfirm Axis PID Parameters --------------------------------------------------

!------- Logical  Motion  ------------------------------------------------------------
FCLEAR OR_Z
FDEF(OR_Z).#SLL=0
FDEF(OR_Z).#SRL=0
FMASK(OR_Z).#SRL=0
FMASK(OR_Z).#SLL=0
!ENABLE (OR_Z); TILL MST(OR_Z).#ENABLED
MFLAGS(OR_Z).#HOME = 0
!TILL PA_Sys_DataEnsure=1
HOMEVELL(OR_Z) = PA_HomeVel(OR_Z)
HOMEVELI(OR_Z) = PA_HomeVel(OR_Z)/2

	IF FAULT(OR_Z).#LL

		JOG/V OR_Z, 1
		TILL ^FAULT(OR_Z).#LL
		KILL OR_Z
		WAIT 100
		END


ACC(OR_Z)=PA_HomeVel(OR_Z)*10
DEC(OR_Z)=PA_HomeVel(OR_Z)*10
JERK(OR_Z)=PA_HomeVel(OR_Z)*50
HomeAxis(OR_Z)=OR_Z
HomeStartTime(OR_Z)=TIME
HOME OR_Z, PA_HomeMode(OR_Z), PA_HomeVel(OR_Z) , ,0,PA_HomeCurrentLimit(OR_Z)
DISP "OR_Z Start HOME"
TILL MFLAGS(OR_Z).#HOME=1



WAIT 1000
!SET FPOS(OR_Z)=0

!ptp/ev OR_Z,4,1
ptp/ev OR_Z,PA_HomeOffset(OR_Z),1
TILL ^MST(OR_Z).#MOVE
WAIT 1000
SET FPOS(OR_Z)=0
FDEF(OR_Z).#SRL=1
FDEF(OR_Z).#SLL=1
FDEF(OR_Z).#RL=1
FDEF(OR_Z).#LL=1
SLLIMIT(OR_Z)=PA_LimitN(OR_Z)
SRLIMIT(OR_Z)=PA_LimitP(OR_Z)
FMASK(OR_Z).#SRL=1
FMASK(OR_Z).#SLL=1
PA_HomeStatus(OR_Z)=1 ;DISP "OR_Z Home Done"
!SLLIMIT(OR_Z)=ACSSoftWarePosition(OR_Z)(0)
!------- Reset API Status  -------------------------------------------------------------
!Buffer_API_Activate(1)=0
!------- Buffer Finish Status  ---------------------------------------------------------	                   
!Buffer_Motion_Finish(1)=1
!DISABLE(OR_Z)

STOP
#30
!PNAME=TWLP_HOME
!PDESC=
!TWLP HOME
HOMING_TWLP:

PA_HomeStatus(TWLP)=0

!------- Confirm API Status  -----------------------------------------------------------
!Buffer_API_Activate(1)=1
!------- Assignment Variable Parameters -----------------------------------------------
!GLOBAL INT TWLP_HomeVelocity,TWLP_HomeMode,TWLP_HomeOffset1,TWLP_HomingCurrLimit
!------- Comfirm Variable Parameters --------------------------------------------------
!TWLP_HomeVelocity=1 ; TWLP_HomeMode=18; TWLP_HomeOffset1=0; TWLP_HomingCurrLimit=50
!------- Comfirm Axis PID Parameters --------------------------------------------------

!------- Logical  Motion  ------------------------------------------------------------
FCLEAR TWLP
FDEF(TWLP).#SLL=0
FDEF(TWLP).#SRL=0
FMASK(TWLP).#SRL=0
FMASK(TWLP).#SLL=0
!ENABLE (TWLP); TILL MST(TWLP).#ENABLED
	IF FAULT(TWLP).#RL

		JOG/V TWLP, -0.5
		TILL ^FAULT(TWLP).#RL
		KILL TWLP
		WAIT 100
		END
MFLAGS(TWLP).#HOME = 0
!TILL PA_Sys_DataEnsure=1
HOMEVELL(TWLP) = PA_HomeVel(TWLP)
HOMEVELI(TWLP) = PA_HomeVel(TWLP)/2
ACC(TWLP)=PA_HomeVel(TWLP)*10
DEC(TWLP)=PA_HomeVel(TWLP)*10
JERK(TWLP)=PA_HomeVel(TWLP)*50


HomeAxis(TWLP)=TWLP
HomeStartTime(TWLP)=TIME
HOME TWLP, PA_HomeMode(TWLP), PA_HomeVel(TWLP) , ,PA_HomeOffset(TWLP),PA_HomeCurrentLimit(TWLP)
DISP "TWLP Start HOME"
TILL MFLAGS(TWLP).#HOME=1


PTP TWLP,0
TILL ^MST(TWLP).#MOVE
FDEF(TWLP).#SRL=1
FDEF(TWLP).#SLL=1
SLLIMIT(TWLP)=PA_LimitN(TWLP)
SRLIMIT(TWLP)=PA_LimitP(TWLP)
FMASK(TWLP).#SRL=1
FMASK(TWLP).#SLL=1

PA_HomeStatus(TWLP)=1 ;DISP "TWLP Home Done"
!ptp/ev TWLP,-150,10
!TILL ^MST(TWLP).#MOVE
!SET FPOS(TWLP)=0
!SLLIMIT(TWLP)=ACSSoftWarePosition(TWLP)(0)
!------- Reset API Status  -------------------------------------------------------------
!Buffer_API_Activate(1)=0
!------- Buffer Finish Status  ---------------------------------------------------------	                   
!Buffer_Motion_Finish(1)=1
!DISABLE(TWLP)

STOP
#31
!PNAME=BWLP_HOME
!PDESC=
!BWLP HOME
HOMING_BWLP:

PA_HomeStatus(BWLP)=0 

!------- Confirm API Status  -----------------------------------------------------------
!Buffer_API_Activate(1)=1
!------- Assignment Variable Parameters -----------------------------------------------
!GLOBAL INT BWLP_HomeVelocity,BWLP_HomeMode,BWLP_HomeOffset1,BWLP_HomingCurrLimit
!------- Comfirm Variable Parameters --------------------------------------------------
!BWLP_HomeVelocity=1 ; BWLP_HomeMode=17; BWLP_HomeOffset1=0; BWLP_HomingCurrLimit=50
!------- Comfirm Axis PID Parameters --------------------------------------------------

!------- Logical  Motion  ------------------------------------------------------------
FCLEAR BWLP
FDEF(BWLP).#SLL=0
FDEF(BWLP).#SRL=0
FMASK(BWLP).#SRL=0
FMASK(BWLP).#SLL=0
!ENABLE (BWLP); TILL MST(BWLP).#ENABLED
MFLAGS(BWLP).#HOME = 0
!TILL PA_Sys_DataEnsure=1
HOMEVELL(BWLP) = PA_HomeVel(BWLP)
HOMEVELI(BWLP) = PA_HomeVel(BWLP)/2

	IF FAULT(BWLP).#LL

		JOG/V BWLP, 0.5
		TILL ^FAULT(BWLP).#LL
		KILL BWLP
		WAIT 100
		END


HomeAxis(BWLP)=BWLP
HomeStartTime(BWLP)=TIME
HOME BWLP, PA_HomeMode(BWLP), PA_HomeVel(BWLP) , ,PA_HomeOffset(BWLP),PA_HomeCurrentLimit(BWLP)
DISP "BWLP Start HOME"
TILL MFLAGS(BWLP).#HOME=1


PTP BWLP,0
TILL ^MST(BWLP).#MOVE
FDEF(BWLP).#SRL=1
FDEF(BWLP).#SLL=1
SLLIMIT(BWLP)=PA_LimitN(BWLP)
SRLIMIT(BWLP)=PA_LimitP(BWLP)
FMASK(BWLP).#SRL=1
FMASK(BWLP).#SLL=1

PA_HomeStatus(BWLP)=1 ;DISP "BWLP Home Done"
!ptp/ev BWLP,-150,10
!TILL ^MST(BWLP).#MOVE
!SET FPOS(BWLP)=0
!SLLIMIT(BWLP)=ACSSoftWarePosition(BWLP)(0)
!------- Reset API Status  -------------------------------------------------------------
!Buffer_API_Activate(1)=0
!------- Buffer Finish Status  ---------------------------------------------------------	                   
!Buffer_Motion_Finish(1)=1
!DISABLE(BWLP)

STOP
#A
!PNAME=
!PDESC=
!axisdef X=0,Y=1,Z=2,T=3,A=4,B=5,C=6,D=7
!axisdef x=0,y=1,z=2,t=3,a=4,b=5,c=6,d=7
global int I(100),I0,I1,I2,I3,I4,I5,I6,I7,I8,I9,I90,I91,I92,I93,I94,I95,I96,I97,I98,I99
global real V(100),V0,V1,V2,V3,V4,V5,V6,V7,V8,V9,V90,V91,V92,V93,V94,V95,V96,V97,V98,V99
GLOBAL CONST INT AxisCount=32
AXISDEF TT_Y0=0,TT_Y1=1,BT_Y0=2,BT_Y1=3,BC_Z0=4,BC_Z1=5,BC_Z2=6,SLA_Y0=8,SLA_Y1=9,TT_X0=10,TT_X1=11,BT_X0=12,BT_X1=13,OL_X=14,OL_Y=15,OL_Z=16,OR_X=18,OR_Y=19,OR_Z=20,TWLP=22,BWLP=23
!TT_Y0_HomeOffset1=-293.8264
GLOBAL INT RebootFlag=0

!------------20241217 V1.0.0


GLOBAL INT CurrentAxisNum;
!----------------------MODBUS--------------
GLOBAL REAL TAG 1000 RunTime!48000
GLOBAL INT TAG 1400 Initialize !48800
GLOBAL INT TAG 1402 HomeFlags(32) !48804


GLOBAL INT PA_HomeOrder(32)
GLOBAL INT HomeAxis(32)
GLOBAL INT PA_HomeMode(32)
GLOBAL REAL PA_HomeVel(32)
GLOBAL REAL PA_HomeOffset(32)
GLOBAL INT PA_AxiHomeTimeOut(32)
GLOBAL REAL HomeStartTime(32)
GLOBAL INT PA_HomeAxis(32)
GLOBAL INT PA_HomeCurrentLimit(32)
GLOBAL REAL PA_LimitP(32)
GLOBAL REAL PA_LimitN(32)
GLOBAL INT AxisToCode(32)
GLOBAL INT AxisMoveFlage(32)
GLOBAL REAL AxisMoveTime(32)

!----------EIP-----------------
! PLC TO ACS (INT) - TAG 2000~2031
GLOBAL INT TAG 2000 Axis_Control(32)

! PLC TP ACS (REAL) - TAG 2032~2223
GLOBAL REAL TAG 2001 Axis_Pos(32)      ! 2032~2063
GLOBAL REAL TAG 2002 Axis_Vel(32)      ! 2064~2095
GLOBAL REAL TAG 2003 Axis_Acc(32)      ! 2096~2127
GLOBAL REAL TAG 2004 Axis_Dec(32)      ! 2128~2159

! ACS TO PLC (INT) - TAG 2160~2191
GLOBAL INT TAG 2005 Axis_State(32)

! ACS TO PLC (REAL) - TAG 2192~2223
GLOBAL REAL TAG 2006 Axis_ActPos(32)





!-----------Group Axis--------------------------

GLOBAL REAL TAG 1200 AxisGourp_BC_Z0_Pos  !48400
GLOBAL REAL TAG 1201 AxisGourp_BC_Z1_Pos  !48402
GLOBAL REAL TAG 1202 AxisGourp_BC_Z2_Pos  !48404
GLOBAL REAL TAG 1203 AxisGourp_BC_Z0_Vel  !48406
GLOBAL REAL TAG 1204 AxisGourp_BC_Z1_Vel  !48408
GLOBAL REAL TAG 1205 AxisGourp_BC_Z2_Vel  !48410
GLOBAL INT TAG 1206 AxisGourpMove             !48412

GLOBAL REAL TAG 1250 AxisGourp_OL_X_Pos  !48500
GLOBAL REAL TAG 1251 AxisGourp_OL_Y_Pos  !48502
GLOBAL REAL TAG 1252 AxisGourp_OL_Z_Pos  !48504
GLOBAL REAL TAG 1253 AxisGourp_OR_X_Pos  !48506
GLOBAL REAL TAG 1254 AxisGourp_OR_Y_Pos  !48508
GLOBAL REAL TAG 1255 AxisGourp_OR_Z_Pos  !48510
GLOBAL REAL TAG 1256 AxisGourp_Optic_Vel  !48512
!GLOBAL INT TAG 1257 AxisGourp_Optic_Switch  !48514

GLOBAL REAL TAG 1300 AxisGourp_TT_X0_Pos  !48600
GLOBAL REAL TAG 1301 AxisGourp_TT_X1_Pos  !48602
GLOBAL REAL TAG 1302 AxisGourp_UpTableX_Vel  !48604
!GLOBAL INT TAG 1303 AxisGourp_UpTableX_Switch  !48606

GLOBAL REAL TAG 1350 AxisGourp_BT_X0_Pos  !48700
GLOBAL REAL TAG 1351 AxisGourp_BT_X1_Pos  !48702
GLOBAL REAL TAG 1352 AxisGourp_DownTableX_Vel  !48704
!GLOBAL INT TAG 1353 AxisGourp_DownTableX_Switch  !48706

GLOBAL REAL TAG 1450 AxisGourp_TT_Y0_Pos  !48900
GLOBAL REAL TAG 1451 AxisGourp_BT_Y0_Pos  !48902
GLOBAL REAL TAG 1452 AxisGourp_Gantry_Vel  !48904
!GLOBAL INT TAG 1453 AxisGourp_Gantry_Switch  !48906

GLOBAL REAL TAG 1500 AxisGourp_SLA_Y0_Pos  !49000
GLOBAL REAL TAG 1501 AxisGourp_SLA_Y1_Pos  !40902
GLOBAL REAL TAG 1502 AxisGourp_SLA_Vel  !49004
!GLOBAL INT TAG 1503 AxisGourp_SLA_Switch  !49006

GLOBAL REAL TAG 1550 AxisGourp_OL_Z1_Pos  !49100
GLOBAL REAL TAG 1551 AxisGourp_OR_Z1_Pos  !49102
GLOBAL REAL TAG 1552 AxisGourp_OpticZ_Vel  !49104
!GLOBAL INT TAG 1553 AxisGourp_OpticZ_Switch  !49106


!-----MODBUS-REDA FOR PLC--------

! ??????????????????????????Axis_State??Axis_ActPos????????????TAG????????????????????????????????
! ??????????????????????????????????

GLOBAL INT TAG 1600 TT_Y0_State  !49200
GLOBAL REAL TAG 1601 TT_Y0_ActPos  !49202

GLOBAL INT TAG 1602 TT_Y1_State  !49204
GLOBAL REAL TAG 1603 TT_Y1_ActPos  !49206

GLOBAL INT TAG 1604 TT_X0_State  !49208
GLOBAL REAL TAG 1605 TT_X0_ActPos  !49210

GLOBAL INT TAG 1606 TT_X1_State  !49212
GLOBAL REAL TAG 1607 TT_X1_ActPos  !49214

GLOBAL INT TAG 1608 TWLP_State  !49216
GLOBAL REAL TAG 1609 TWLP_ActPos  !49218

GLOBAL INT TAG 1610 BT_Y0_State  !49220
GLOBAL REAL TAG 1611 BT_Y0_ActPos  !49222

GLOBAL INT TAG 1612 BT_Y1_State  !49224
GLOBAL REAL TAG 1613 BT_Y1_ActPos  !49226

GLOBAL INT TAG 1614 BT_X0_State  !49228
GLOBAL REAL TAG 1615 BT_X0_ActPos  !49230

GLOBAL INT TAG 1616 BT_X1_State  !49232
GLOBAL REAL TAG 1617 BT_X1_ActPos  !49234

GLOBAL INT TAG 1618 BWLP_State  !49236
GLOBAL REAL TAG 1619 BWLP_ActPos  !49238

GLOBAL INT TAG 1620 OL_X_State  !49240
GLOBAL REAL TAG 1621 OL_X_ActPos  !49242

GLOBAL INT TAG 1622 OL_Y_State  !49244
GLOBAL REAL TAG 1623 OL_Y_ActPos  !49246

GLOBAL INT TAG 1624 OL_Z_State  !49248
GLOBAL REAL TAG 1625 OL_Z_ActPos  !49250

GLOBAL INT TAG 1626 OR_X_State  !49252
GLOBAL REAL TAG 1627 OR_X_ActPos  !49254

GLOBAL INT TAG 1628 OR_Y_State  !49256
GLOBAL REAL TAG 1629 OR_Y_ActPos  !49258

GLOBAL INT TAG 1630 OR_Z_State  !49260
GLOBAL REAL TAG 1631 OR_Z_ActPos  !49262


GLOBAL INT TAG 1632 BC_Z0_State  !49264
GLOBAL REAL TAG 1633 BC_Z0_ActPos  !49266


GLOBAL INT TAG 1634 BC_Z1_State  !49268
GLOBAL REAL TAG 1635 BC_Z1_ActPos  !49270


GLOBAL INT TAG 1636 BC_Z2_State  !49272
GLOBAL REAL TAG 1637 BC_Z2_ActPos  !49274

GLOBAL INT TAG 1638 SLA_Y0_State  !49276
GLOBAL REAL TAG 1639 SLA_Y0_ActPos  !49278

GLOBAL INT TAG 1640 SLA_Y1_State  !49280
GLOBAL REAL TAG 1641 SLA_Y1_ActPos  !49282








GLOBAL INT TAG 1700 AxisGourp_BC_State  !49400
GLOBAL INT TAG 1701 AxisGourp_BC_ActPos1  !49402
GLOBAL INT TAG 1702 AxisGourp_BC_ActPos2  !49404
GLOBAL INT TAG 1703 AxisGourp_BC_ActPos3  !49406
GLOBAL INT TAG 1704 AxisGourp_BC_ActPos4  !49408
GLOBAL INT TAG 1705 AxisGourp_BC_ActPos5  !49410
GLOBAL INT TAG 1706 AxisGourp_BC_ActPos6  !49412

GLOBAL INT TAG 1707 AxisGourp_Optic_State  !49414
GLOBAL INT TAG 1708 AxisGourp_Optic_ActPos1  !49416
GLOBAL INT TAG 1709 AxisGourp_Optic_ActPos2  !49418
GLOBAL INT TAG 1710 AxisGourp_Optic_ActPos3  !49420
GLOBAL INT TAG 1711 AxisGourp_Optic_ActPos4  !49422
GLOBAL INT TAG 1712 AxisGourp_Optic_ActPos5  !49424
GLOBAL INT TAG 1713 AxisGourp_Optic_ActPos6  !49426

GLOBAL INT TAG 1714 AxisGourp_UpTableX_State  !49428
GLOBAL INT TAG 1715 AxisGourp_UpTableX_ActPos1  !49430
GLOBAL INT TAG 1716 AxisGourp_UpTableX_ActPos2  !49432
GLOBAL INT TAG 1717 AxisGourp_UpTableX_ActPos3  !49434
GLOBAL INT TAG 1718 AxisGourp_UpTableX_ActPos4  !49436
GLOBAL INT TAG 1719 AxisGourp_UpTableX_ActPos5  !49438
GLOBAL INT TAG 1720 AxisGourp_UpTableX_ActPos6  !49440   UpStageX

GLOBAL INT TAG 1721 AxisGourp_DownTableX_State  !49442
GLOBAL INT TAG 1722 AxisGourp_DownTableX_ActPos1  !49444
GLOBAL INT TAG 1723 AxisGourp_DownTableX_ActPos2  !49446
GLOBAL INT TAG 1724 AxisGourp_DownTableX_ActPos3  !49448
GLOBAL INT TAG 1725 AxisGourp_DownTableX_ActPos4  !49450
GLOBAL INT TAG 1726 AxisGourp_DownTableX_ActPos5  !49452
GLOBAL INT TAG 1727 AxisGourp_DownTableX_ActPos6  !49454   DownStageX

GLOBAL INT TAG 1728 AxisGourp_Gantry_State  !49456
GLOBAL INT TAG 1729 AxisGourp_Gantry_ActPos1  !49458
GLOBAL INT TAG 1730 AxisGourp_Gantry_ActPos2  !49460
GLOBAL INT TAG 1731 AxisGourp_Gantry_ActPos3  !49462
GLOBAL INT TAG 1732 AxisGourp_Gantry_ActPos4  !49464
GLOBAL INT TAG 1733 AxisGourp_Gantry_ActPos5  !49466
GLOBAL INT TAG 1734 AxisGourp_Gantry_ActPos6  !49468   AirFloat

GLOBAL INT TAG 1735 AxisGourp_SLA_State  !49470
GLOBAL INT TAG 1736 AxisGourp_SLA_ActPos1  !49472
GLOBAL INT TAG 1737 AxisGourp_SLA_ActPos2  !49474
GLOBAL INT TAG 1738 AxisGourp_SLA_ActPos3  !49476
GLOBAL INT TAG 1739 AxisGourp_SLA_ActPos4  !49478
GLOBAL INT TAG 1740 AxisGourp_SLA_ActPos5  !49480
GLOBAL INT TAG 1741 AxisGourp_SLA_ActPos6  !49482   SLA

GLOBAL INT TAG 1742 AxisGourp_OpticZ_State  !49484
GLOBAL INT TAG 1743 AxisGourp_OpticZ_ActPos1  !49486
GLOBAL INT TAG 1744 AxisGourp_OpticZ_ActPos2  !49488
GLOBAL INT TAG 1745 AxisGourp_OpticZ_ActPos3  !49490
GLOBAL INT TAG 1746 AxisGourp_OpticZ_ActPos4  !49492
GLOBAL INT TAG 1747 AxisGourp_OpticZ_ActPos5  !49494
GLOBAL INT TAG 1748 AxisGourp_OpticZ_ActPos6  !49496   Lens_Z






!!------------HOMING -----------------
GLOBAL REAL TT_Y0_HomeVelocity=20, TT_Y0_HomeMode=2, TT_Y0_HomeOffset1=-299.3264,TT_Y0_HomingCurrLimit=50,TT_Y0_SRLIMIT=3,TT_Y0_SLLIMIT=-531
GLOBAL REAL BT_Y0_HomeVelocity=20 , BT_Y0_HomeMode=1, BT_Y0_HomeOffset1=236.07, BT_Y0_HomingCurrLimit=50,BT_Y0_SRLIMIT=531,BT_Y0_SLLIMIT=-1
GLOBAL REAL OL_X_HomeVelocity=1 , OL_X_HomeMode=17, OL_X_HomeOffset1=0, OL_X_HomingCurrLimit=50,OL_X_SRLIMIT=-65,OL_X_SLLIMIT=-150
GLOBAL REAL OL_Y_HomeVelocity=1 , OL_Y_HomeMode=18, OL_Y_HomeOffset1=0, OL_Y_HomingCurrLimit=50,OL_Y_SRLIMIT=0,OL_Y_SLLIMIT=-42
GLOBAL REAL OL_Z_HomeVelocity=0.5 , OL_Z_HomeMode=17, OL_Z_HomeOffset1=0, OL_Z_HomingCurrLimit=50,OL_Z_SRLIMIT=6,OL_Z_SLLIMIT=0
GLOBAL REAL OR_X_HomeVelocity=0.5 , OR_X_HomeMode=18, OR_X_HomeOffset1=0, OR_X_HomingCurrLimit=50,OR_X_SRLIMIT=150,OR_X_SLLIMIT=100
GLOBAL REAL OR_Y_HomeVelocity=1.8 , OR_Y_HomeMode=18, OR_Y_HomeOffset1=0, OR_Y_HomingCurrLimit=70,OR_Y_SRLIMIT=0,OR_Y_SLLIMIT=-42
GLOBAL REAL OR_Z_HomeVelocity=1 , OR_Z_HomeMode=17, OR_Z_HomeOffset1=0, OR_Z_HomingCurrLimit=50,OR_Z_SRLIMIT=2.6,OR_Z_SLLIMIT=0
GLOBAL REAL TWLP_HomeVelocity=1 , TWLP_HomeMode=18, TWLP_HomeOffset1=0, TWLP_HomingCurrLimit=50!,TWLP_SRLIMIT=-0.1,TWLP_SLLIMIT=-26
GLOBAL REAL BWLP_HomeVelocity=1 , BWLP_HomeMode=17, BWLP_HomeOffset1=0, BWLP_HomingCurrLimit=50!,BWLP_SRLIMIT=50,BWLP_SLLIMIT=0
GLOBAL REAL TT_X0_HomeVelocity=0.2 , TT_X0_HomeMode=17, TT_X0_HomeOffset1=-1, TT_X0_HomingCurrLimit=50,TT_X0_SRLIMIT=1,TT_X0_SLLIMIT=-1
GLOBAL REAL TT_X1_HomeVelocity=0.2 , TT_X1_HomeMode=17, TT_X1_HomeOffset1=-1, TT_X1_HomingCurrLimit=50,TT_X1_SRLIMIT=1,TT_X1_SLLIMIT=-1
GLOBAL REAL BT_X0_HomeVelocity=0.2 , BT_X0_HomeMode=17, BT_X0_HomeOffset1=-1.1, BT_X0_HomingCurrLimit=50,BT_X0_SRLIMIT=1,BT_X0_SLLIMIT=-1
GLOBAL REAL BT_X1_HomeVelocity=0.2 , BT_X1_HomeMode=17, BT_X1_HomeOffset1=-1, BT_X1_HomingCurrLimit=30,BT_X1_SRLIMIT=1,BT_X1_SLLIMIT=-1
GLOBAL REAL SLA_Y0_HomeVelocity=1 , SLA_Y0_HomeMode=17, SLA_Y0_HomeOffset1=0, SLA_Y0_HomingCurrLimit=50,SLA_Y0_SRLIMIT=22,SLA_Y0_SLLIMIT=0
GLOBAL REAL SLA_Y1_HomeVelocity=1 , SLA_Y1_HomeMode=17, SLA_Y1_HomeOffset1=0, SLA_Y1_HomingCurrLimit=50,SLA_Y1_SRLIMIT=25,SLA_Y1_SLLIMIT=2
GLOBAL REAL BC_Z0_HomeVelocity=1 , BC_Z0_HomeMode=17, BC_Z0_HomeOffset1=0, BC_Z0_HomingCurrLimit=50,BC_Z0_SRLIMIT=15,BC_Z0_SLLIMIT=0
GLOBAL REAL BC_Z1_HomeVelocity=1 , BC_Z1_HomeMode=17, BC_Z1_HomeOffset1=0, BC_Z1_HomingCurrLimit=50,BC_Z1_SRLIMIT=15,BC_Z1_SLLIMIT=0
GLOBAL REAL BC_Z2_HomeVelocity=1 , BC_Z2_HomeMode=17, BC_Z2_HomeOffset1=0, BC_Z2_HomingCurrLimit=50,BC_Z2_SRLIMIT=15,BC_Z2_SLLIMIT=0
GLOBAL INT HOMETIME(32)
GLOBAL INT HomeDelay=50000
GLOBAL INT PA_HomeStatus(32)

GLOBAL INT HomeStartFlags(32)

GLOBAL INT PA_ComSupMotionType

GLOBAL REAL AxisVel(32)

!------------Axis name-------------
GLOBAL STRING  AxisName(32)



!---------Alarm_Hight---------------------------
GLOBAL CONST INT AlarmCode_HeartBeatInterrupt=1
GLOBAL CONST INT AlarmCode_StateMachineNotRun=2
GLOBAL CONST INT AlarmCode_ModBusHeartBeatInterrupt=3
GLOBAL CONST INT AlarmCode_ExistEmptyAlarm=4
GLOBAL CONST INT AlarmCode_ForcedAlarm=8

!---------Alarm_Normal---------------------------
GLOBAL CONST INT AlarmCode_MotionDataErr=1003
!---------Alarm HomeTimeOut---------------------------



!---------Alarm_Tips---------------------------
GLOBAL CONST INT AlarmCode_AxisGrop1ParaErro=775
GLOBAL CONST INT AlarmCode_AxisGrop2ParaErro=776
GLOBAL CONST INT AlarmCode_AxisGrop3ParaErro=777
GLOBAL CONST INT AlarmCode_AxisGrop4ParaErro=778
GLOBAL CONST INT AlarmCode_AxisGrop5ParaErro=779
GLOBAL CONST INT AlarmCode_AxisGrop6ParaErro=780
GLOBAL CONST INT AlarmCode_AxisGrop7ParaErro=781
GLOBAL CONST INT AlarmCode_AxisGrop13ParaErro=787


!---------------ALARM-----------------------
GLOBAL INT AP_ACSStatus=1
GLOBAL CONST INT ACSStatus_Error=-1
GLOBAL CONST INT ACSStatus_Tips=-2
GLOBAL CONST INT ACSStatus_OK=1
!---------------MotionStatus-------------
GLOBAL CONST INT MotionReady=0
GLOBAL CONST INT MotionRunning=2
GlOBAL CONST INT MotionSuccess=1
GLOBAL CONST INT MotionError=-1
!---------------MotionType-----------------
GLOBAL CONST INT NoMotion=0
GLOBAL CONST INT CheckAxisHomeTimeOut=101
GLOBAL CONST INT LaserCompensate=102
GLOBAL CONST INT AxisHome=103
GLOBAL CONST INT PCClearAlarm=104
GLOBAL CONST INT PCOccurAlarm=105


!---------------ALARMGrade-----------------------
GLOBAL CONST INT Alarm_Null=-1
GLOBAL CONST INT Alarm_High=1
GLOBAL CONST INT Alarm_Normal=2
GLOBAL CONST INT Alarm_Tips=3
GLOBAL CONST INT Alarm_Buffer=4
!------------ClearAlarm-----------------
GLOBAL INT PA_ClearAlarmCode(800)
GLOBAL INT AP_AlarmCode(800)
GLOBAL INT AP_ComSupMotionRes
!------------HeartBeat-----------------
GLOBAL INT CO_HeartBeat=2
GLOBAL INT PA_ShieldingHeartBeat


INT GetAlarmLevel(INT AlarmCode){
INT Level=0
IF 0<AlarmCode<=400
Level=Alarm_High  !1
ELSEIF 400<AlarmCode<550
Level=Alarm_Normal !2
ELSEIF 550<=AlarmCode<=800
Level=Alarm_Tips   !3
!ELSEIF 800<AlarmCode<=1000
!Level=4
ELSEIF AlarmCode>800|AlarmCode<=0
Level=Alarm_Null !-1
END

RET Level
}

VOID OccurAlarm(INT AlarmCode, INT AlarmLevel = 0, INT StopBuffer1 = -1, INT StopBuffer2 = -1)
{
    DISP "Alarm", AlarmCode
    IF AlarmCode > SIZEOF(AP_AlarmCode)
        RET
    END

    !! STOP BUFFER
    IF StopBuffer1 <> -1
        STOP StopBuffer1
    END
    IF StopBuffer2 <> -1
        STOP StopBuffer2
    END

    !!GET AlarmLevel
    IF AlarmLevel = 0
        AlarmLevel = GetAlarmLevel(AlarmCode)
    END
    
	IF AlarmLevel=-1 !Alarm_Null
	    DISP "Alarm", AlarmCode
		AP_AlarmCode(AlarmCode_ExistEmptyAlarm)=1
	END
    
!    IF AP_AlarmCode(AlarmCode)= 1
!        RET
!    END

    AP_AlarmCode(AlarmCode) = 1

    
    SWITCH AlarmLevel
        CASE 1: !Alarm_High
            PA_ComSupMotionType = NoMotion
            AP_ACSStatus = ACSStatus_Error
            KILLALL
            WAIT 1000
			END
        CASE 2: !Alarm_Normal
            PA_ComSupMotionType = NoMotion
            AP_ACSStatus = ACSStatus_Error
			END
        CASE 3:  !Alarm_Tips
            IF AP_ACSStatus <> ACSStatus_Error
                AP_ACSStatus = ACSStatus_Tips
            END
			END
        CASE 4: !Alarm_Buffer
            PA_ComSupMotionType = NoMotion
            AP_ACSStatus = ACSStatus_Error
    END
	END
    RET
}


INT GetAxisHomeBuffer(INT axis)
{
INT AxisBuffer
IF axis=TT_Y0|axis=TT_Y1
AxisBuffer=15
ELSEIF axis=BT_Y0|axis=BT_Y1
AxisBuffer=16
ELSEIF axis=BC_Z0|axis=BC_Z1|axis=BC_Z2
AxisBuffer=17
ELSEIF axis=SLA_Y0
AxisBuffer=18
ELSEIF axis=SLA_Y1
AxisBuffer=19
ELSEIF axis=TT_X0
AxisBuffer=20
ELSEIF axis=TT_X1
AxisBuffer=21
ELSEIF axis=BT_X0
AxisBuffer=22
ELSEIF axis=BT_X1
AxisBuffer=23
ELSEIF axis=OL_X
AxisBuffer=24
ELSEIF axis=OL_Y
AxisBuffer=25
ELSEIF axis=OL_Z
AxisBuffer=26
ELSEIF axis=OR_X
AxisBuffer=27
ELSEIF axis=OR_Y
AxisBuffer=28
ELSEIF axis=OR_Z
AxisBuffer=29
ELSEIF axis=TWLP
AxisBuffer=30
ELSEIF axis=BWLP
AxisBuffer=31
END
RET AxisBuffer
}


GLOBAL INT HomeMonitorActive = 0   !! 1=enable monitoring, 0=disable
!! Home timeout monitor (suggest to call every 50~100ms in #2 loop)

VOID CheckHomeTimeOut()
{	
	INT i
	INT AxisNo
	INT DefaultTO = 60000 !! default timeout 60s
	INT TimeOut

	LOOP SIZEOF(HomeAxis) - 1
		AxisNo = HomeAxis(i)
		IF AxisNo <= 0 !! not active or already finished
           i++
		ELSE			

!! homing not yet completed
			IF ^MFLAGS(AxisNo).#HOME & PA_HomeStatus(AxisNo) <> 1
!! determine timeout: use axis specific value if set, otherwise default
				IF PA_AxiHomeTimeOut(AxisNo) > 0
					TimeOut = PA_AxiHomeTimeOut(AxisNo)
				ELSE					
					TimeOut = DefaultTO
				END

				IF TIME- HomeStartTime(AxisNo) > TimeOut
!! trigger timeout alarm (alarm code = 161 + axis index, normal level)
					OccurAlarm(411 + AxisNo, Alarm_Normal,GetAxisHomeBuffer(AxisNo))
					DISP "Home TimeOut! Axis=", AxisNo
!! clear monitoring flag to avoid repeated alarms
					HomeAxis(i) =- 1
!! optional: stop the axis motion
					KILL AxisNo
				END
			ELSE				
!! homing completed: restore soft limits and end monitoring
				FDEF(AxisNo).#SRL= 1
				FDEF(AxisNo).#SLL= 1
				HomeAxis(i) =- 1
			END
			i++
		END
	END
	RET 
}



VOID JudgeBufferRunning(INT Buffer1,INT Buffer2=-1,INT Buffer3=-1,INT Buffer4=-1,INT Buffer5=-1,INT Buffer6=-1,INT Buffer7=-1,INT Buffer8=-1,INT Buffer9=-1,INT Buffer10=-1){

IF Buffer1>GETCONF(99,0)

RET
ELSE 
STOP Buffer1
END

IF Buffer2<>-1
STOP Buffer2
END
!
IF Buffer3<>-1
STOP Buffer3
END
!
IF Buffer4<>-1
STOP Buffer4
END

IF Buffer5<>-1
STOP Buffer5
END

IF Buffer6<>-1
STOP Buffer6
END

IF Buffer7<>-1
STOP Buffer7
END

IF Buffer8<>-1
STOP Buffer8
END

IF Buffer9<>-1
STOP Buffer9
END

IF Buffer10<>-1
STOP Buffer10
END

RET
}


INT GetPLC_AxisNumber(INT Axis)
{
  Int AixsPLC_number
  IF Axis=0 
  AixsPLC_number=0     ! TT_Y0 
  
  ELSEIF Axis=1     ! TT_Y1
  AixsPLC_number=1
  
  ELSEIF Axis=2     ! BT_Y0
  AixsPLC_number=5
  
  ELSEIF Axis=3     ! BT_Y1
  AixsPLC_number=6
  
  ELSEIF Axis=4     ! BC_Z0
  AixsPLC_number=16
  
  ELSEIF Axis=5     ! BC_Z1
  AixsPLC_number=17
  
  ELSEIF Axis=6     ! BC_Z2
  AixsPLC_number=18
  
  ELSEIF Axis=8     ! SLA_Y0
  AixsPLC_number=19
  
  ELSEIF Axis=9     ! SLA_Y1
  AixsPLC_number=20
  
  ELSEIF Axis=10    ! TT_X0
  AixsPLC_number=2
  
  ELSEIF Axis=11    ! TT_X1
  AixsPLC_number=3
  
  ELSEIF Axis=12    ! BT_X0
  AixsPLC_number=7
  
  ELSEIF Axis=13    ! BT_X1
  AixsPLC_number=8
  
  ELSEIF Axis=14    ! OL_X
  AixsPLC_number=10
  
  ELSEIF Axis=15    ! OL_Y
  AixsPLC_number=11
  
  ELSEIF Axis=16    ! OL_Z
  AixsPLC_number=12
  
  ELSEIF Axis=18    ! OR_X
  AixsPLC_number=13
  
  ELSEIF Axis=19    ! OR_Y
  AixsPLC_number=14
  
  ELSEIF Axis=20    ! OR_Z
  AixsPLC_number=15
  
  ELSEIF Axis=22    ! TWLP
  AixsPLC_number=4
  
  ELSEIF Axis=23    ! BWLP
  AixsPLC_number=9
  END
  
  RET AixsPLC_number
  
}

STRING GetAxisName(10)(INT Axis)
{
    STRING axisName(10)
    IF Axis = 0
        axisName = "TT_Y0"
    ELSEIF Axis = 1
        axisName = "TT_Y1"
    ELSEIF Axis = 2
        axisName = "BT_Y0"
		DISP "222"
    ELSEIF Axis = 3
        axisName = "BT_Y1"
    ELSEIF Axis = 4
        axisName = "BC_Z0"
    ELSEIF Axis = 5
        axisName = "BC_Z1"
    ELSEIF Axis = 6
        axisName = "BC_Z2"
    ELSEIF Axis = 8
        axisName = "SLA_Y0"
    ELSEIF Axis = 9
        axisName = "SLA_Y1"
    ELSEIF Axis = 10
        axisName = "TT_X0"
    ELSEIF Axis = 11
        axisName = "TT_X1"
    ELSEIF Axis = 12
        axisName = "BT_X0"
    ELSEIF Axis = 13
        axisName = "BT_X1"
    ELSEIF Axis = 14
        axisName = "OL_X"
    ELSEIF Axis = 15
        axisName = "OL_Y"
    ELSEIF Axis = 16
        axisName = "OL_Z"
    ELSEIF Axis = 18
        axisName = "OR_X"
    ELSEIF Axis = 19
        axisName = "OR_Y"
    ELSEIF Axis = 20
        axisName = "OR_Z"
    ELSEIF Axis = 22
        axisName = "TWLP"
    ELSEIF Axis = 23
        axisName = "BWLP"
    
        
    END
    RET axisName
}

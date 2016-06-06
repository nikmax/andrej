
//+------------------------------------------------------------------+
//|                                                     AndrejEA.mq4 |
//|                                                     Anton Sander |
//|                                          http://sanderinvest.com |
//+------------------------------------------------------------------+
#property copyright "Anton Sander"
#property link      "http://sanderinvest.com"
#property version   "1.00"
#property strict

extern string Separator1  = "------ Expert Settings ------";
extern int    Magic       = 20160605;
extern double StopLoss    = 10.0;
extern double TakeProfit  = 30.0;
extern int startBSU  =    0; // "00:00"
extern int stopBSU   = 1050; // "17:30"
extern int startBPU1 =  540; // "09:00"
extern int stopBPU1  = 1080; // "18:00"
extern int startBPU2 =  570; // "09:30"
extern int stopBPU2  = 1080; // "18:00"
extern int closeLimit= 1140; // "19:00"
extern int closeOrder= 1260; // "21:00"

double SLValue = 0;
double TPValue = 0;
int divider = 0;

int OnInit(){
	if(_Digits == 3 || _Digits == 5){
		divider = 1;
		SLValue = StopLoss*10;
		TPValue = TakeProfit*10;
	}else{
		SLValue = StopLoss;
		TPValue = TakeProfit;
	}
    return(INIT_SUCCEEDED);
}
void OnDeinit(const int reason){
	return;
}
void OnTick(){
	if (closeLimit < (TimeHour(TimeCurrent())*60+TimeMinute(TimeCurrent()))){
		//
	}
	if (closeOrder < (TimeHour(TimeCurrent())*60+TimeMinute(TimeCurrent()))){
		//
	}
	
	double LotSize = 0.01;
	if(Time[0] != TimeCurrent()) return;
	datetime tBPU2 = Time[1];
	int i = 3;
	if ((TimeHour(tBPU2)*60+TimeMinute(tBPU2)) < startBPU2) return;
	if ((TimeHour(tBPU2)*60+TimeMinute(tBPU2)) > stopBPU2) return;
	double hBPU2 = High[1];
	double hBPU1 = High[2];
	//
	if(NormalizeDouble(hBPU2,_Digits-divider) == NormalizeDouble(hBPU1,_Digits-divider)){
		Print("hBPU1"+NormalizeDouble(hBPU1,_Digits-divider));
		while ((TimeHour(Time[i])*60+TimeMinute(Time[i])) < startBSU || (TimeHour(Time[i])*60+TimeMinute(Time[i])) > stopBSU){
			Print("High["+i+"]: "+NormalizeDouble(High[i],_Digits-divider));
			Print("Low["+i+"]: "+NormalizeDouble(Low[i],_Digits-divider));
			if(NormalizeDouble(hBPU2,_Digits-divider) == NormalizeDouble(High[i],_Digits-divider) || 
			   NormalizeDouble(hBPU2,_Digits-divider) == NormalizeDouble(Low[i],_Digits-divider)){
				if(false) return;
				if (OrderSend(_Symbol,OP_SELLLIMIT,LotSize,ND(hBPU2),0,ND(hBPU2+SLValue),ND(hBPU2-TPValue),NULL,Magic,0,clrNONE)) {};
				ObjectCreate(0,"TestLine"+hBPU2 , OBJ_HLINE,0,0,ND(hBPU2));
			}
			i++;
		}
	}else{
		double lBPU2 = Low[1];
		double lBPU1 = Low[2];
		//
		if(NormalizeDouble(lBPU2,_Digits-divider) == NormalizeDouble(lBPU1,_Digits-divider)){
			Print("lPBU1: "+NormalizeDouble(lBPU1,_Digits-divider));
			Print(TimeHour(Time[i]));
			Print(TimeMinute(Time[i]));
			Print(TimeHour(Time[i])*60+TimeMinute(Time[i]));
			while ((TimeHour(Time[i])*60+TimeMinute(Time[i])) < startBSU || (TimeHour(Time[i])*60+TimeMinute(Time[i])) > stopBSU){
				Print("High["+i+"]: "+NormalizeDouble(High[i],_Digits-divider));
				Print("Low["+i+"]: "+NormalizeDouble(Low[i],_Digits-divider));
				if(NormalizeDouble(lBPU2,_Digits-divider) == NormalizeDouble(High[i],_Digits-divider) || 
			   		NormalizeDouble(lBPU2,_Digits-divider) == NormalizeDouble(Low[i],_Digits-divider)){
					if(false) return;
					if (OrderSend(_Symbol,OP_BUYLIMIT,LotSize,ND(lBPU2),0,ND(lBPU2-SLValue),ND(lBPU2+TPValue),NULL,Magic,0,clrNONE)) {};
					ObjectCreate(0,"TestLine"+lBPU2 , OBJ_HLINE,0,0,ND(lBPU2));
				}
				i++;
			}
		}
	}
}
double ND(double pr){
	return NormalizeDouble(pr,_Digits);
}

//+------------------------------------------------------------------+
//|                                                          how.mq4 |
//|                                                             you1 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "you1"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <CallFunc.mqh>




//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
  
   
  Alert(InitSocket());
  
  int resvCount = 1;
  while(1)
  {
     
     string rsv = ResvSocket();
     
     Alert("ResvMsg:" + rsv);
     
     Alert("SendResult:" + SendSocket("resv num" + resvCount));
     //"resv num" + 
     resvCount++;
     
  }
 Alert("init end");
 //RGB(1,1,1);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
//socket close
   DeInitSocket();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

double Stoploss = 1000;
double Profit = 500;

int ShortMA_Period = 15;
int LongMA_Period = 45;

void OnTick()
  {
//---

   double Short1,Short2,Long1,Long2;
   
   
   
   Short1 = iMA(NULL,0,ShortMA_Period,0,MODE_SMA,PRICE_CLOSE,1);
   Short2 = iMA(NULL,0,ShortMA_Period,0,MODE_SMA,PRICE_CLOSE,2);
   Long1 = iMA(NULL,0,LongMA_Period,0,MODE_SMA,PRICE_CLOSE,1);
   Long2 = iMA(NULL,0,LongMA_Period,0,MODE_SMA,PRICE_CLOSE,2);

      if(OrdersTotal() == 0)
      {
         if(Short1>Long1&&Short2<Long2)
         {
            Alert("true");
            OrderSend(Symbol(),OP_BUY,0.1,Ask,3,Ask-(Stoploss*Point),Ask+(Profit*Point),"autoBUY",0,0,Blue);
         }
         else if(Short1<Long1&&Short2>Long2)
         {
            OrderSend(Symbol(),OP_SELL,0.1,Bid,3,Bid+(Stoploss*Point),Bid-(Profit*Point),"autoSELL",0,0,Red);
         }
         
      }
      
      Comment(DoubleToStr(Short1) + "\n" + 
      DoubleToStr(Short2) +"\n" + 
      DoubleToStr(Long1) +"\n" + 
      DoubleToStr(Long2) +"\n");
  }

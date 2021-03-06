//+------------------------------------------------------------------+
//|                                                   SockPortal.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <CallFunc.mqh>
#include <JsonParser.mqh>
#include <RunMT4.mqh>
#include <CallFunc.mqh>
#include <Reply.mqh>

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   //
   EventSetMillisecondTimer(1000);
   //InitSocket()を実行
   
   //SendSocket
   //type3が返ってくるまでレシーブ命令で待機
   
   
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
void OnTick()
  {
//---
	
   string name;
   int type;
   string reply;
   
   JsonParser(name,type);
   RunMT4(reply);
   Reply(reply);
   
   Alert("kokohaSockPortal !!!!!!");
   
   
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   //
  }
//+------------------------------------------------------------------+


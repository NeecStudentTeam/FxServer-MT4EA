//+------------------------------------------------------------------+
//|                                                       RunMT4.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <JsonParser.mqh>

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import

void RunMT4(string &reply){
   
   string name;
   int type;
   
   JsonParser(name,type);
   
   Alert("kokohaRunMT4");
   
   
   switch(type){
      case 1:
              
         Alert("case1 no nakayadeeeeee     type::::" + type );
         
         reply = "uooooooooooooooo";
         
         /*OrderSend(){
         }*/
      
         break;
      case 2:
         /*OrderClose(){
         }*/
      
         break;
      }
      
  return;
}
//+------------------------------------------------------------------+

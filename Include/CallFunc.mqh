//+------------------------------------------------------------------+
//|                                                     CallFunc.mqh |
//|                                                             you1 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "you1"
#property link      "https://www.mql5.com"
#property strict
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
//+------------------------------------------------------------------+

#import "CallFunc.ex4"
string CallFunc(string func_name, string param);
string CallFunc();

#import "stdlib.ex4"
string ErrorDescription(int error_code);
int    RGB(int red_value,int green_value,int blue_value);
bool   CompareDoubles(double number1,double number2);
string DoubleToStrMorePrecision(double number,int precision);
string IntegerToHexString(int integer_number);


#import "MT4DLL.dll"
double movingAverages(double,double,double,double);
string my_function(string,string);
int my_function2(string);
int InitSocket();
void DeInitSocket();
char SendSocket(string);
string ResvSocket();
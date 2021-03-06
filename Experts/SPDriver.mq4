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
#include <hash.mqh>
#include <json.mqh>


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

//MT4DLL.dllで定義された関数を使ってソケット通信を確立します。
int OnInit()
  {
//--- create timer

	//ソケット通信を確立する命令を実行。なんかint型が返ってくるらしい
	int i = InitSocket();
	Alert("InitSocket",i);
	while(1){
		//RceiveするけどスペルはResv
		//string rcv = ResvSocket();
		//テストで一々サーバー立てなくて良いように仮のrcv
		string rcv = "{\"type\" : 3, \"name\" : \"OnInit\", \"params\" : [\"true\"] }";
		//ソケットを送る（返す命令が決まっているので多分ＪＳＯＮのパース/生成する必要ない）
		SendSocket("{\"type\" : 4, \"name\" : \"OnInit\", \"params\" : [\"true\"] }");
	//ループ終了
	}
	
	Alert("【OnInit】接続が確立されました！されてないけど！");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+

//
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();

	//ソケットを閉じます
	Alert("【OnDeinit】接続が切断されました！");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
	Alert("【OnTick】C#から命令が来ました");
	/*
	//パースした結果をハッシュテーブルに入れます。
		//MQL4がクラスを返せずインターフェースが使えないクソ仕様だから、
		//参照がループしてコンパイルできなくなったりと色々問題が発生。
		//ハッシュテーブルをどこで定義するか思いつかない。決めてない。。。
	JsonParser(0,"{\"type\" : 1, \"name\" : \"GetRate\", \"params\" : [\"3\",\"4\"] }");
	//関数を実行します
	RunMT4();				//引数追加しといて
	//文字列を生成します
	Reply();					//引数追加しといて
	*/
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
	Alert("【OnTimer】命令を待っています...");
//---
/*
	Alert("【OnTimer】C#から命令が来ました");
	//パースした結果をハッシュテーブルに入れます
	JsonParser(0,"{\"type\" : 1, \"name\" : \"GetRate\", \"params\" : [\"3\",\"4\"] }");
	//関数を実行します
	RunMT4();				//引数追加しといて
	//文字列を生成します
	Reply();					//引数追加しといて
	*/
  }
  
//+------------------------------------------------------------------+



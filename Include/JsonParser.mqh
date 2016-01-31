//+------------------------------------------------------------------+
//|                                              StringTokenizer.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <hash.mqh>
#include <json.mqh>
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

void JsonParser(string &name,int &type){
   string s ="{\"type\":1,\"name\":\"OrderSend\",\"params\":1}";
   
   
   JSONParser *parser = new JSONParser();

   JSONValue *jv = parser.parse(s);
   
   
   Alert("kokoha JsonPaser");

      if (jv == NULL) {
         Print("error:"+(string)parser.getErrorCode()+parser.getErrorMessage());
   
      } else {
         Print("PARSED:"+jv.toString());
        
         if (jv.isObject()) { // check root value is an object. (it can be an array)
            JSONObject *jo = jv;
            
           name = jo.getString("name");
           type = jo.getInt("type");
           Alert("name:::::::" + name);
           Alert("type:::::::" + type);
                      
            // Safe access in case JSON data is missing or different.
           // if (jo.getString("firstName",s) ) Print("firstName = "+s);
            
            // Loop over object keys
            JSONIterator *it = new JSONIterator(jo);
            for( ; it.hasNext() ; it.next()) {
               Print("loop:"+it.key()+" = "+it.val().toString());
            }
                        
            delete it;
        }
        delete jv;
    }
delete parser;

}
//+------------------------------------------------------------------+

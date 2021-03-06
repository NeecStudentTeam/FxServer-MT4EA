// $Id: json.mqh 118 2014-02-28 23:50:37Z ydrol $
#ifndef YDROL_JSON_MQH
#define YDROL_JSON_MQH
#include  <hash.mqh>

// (C)2014 Andrew Lord forex@NICKNAME@lordy.org.uk
// Parse a JSON String - Adapted for mql4++ from my gawk implementation
// ( https://code.google.com/p/oversight/source/browse/trunk/bin/catalog/json.awk )

/*
   TODO the constants true|false|null could be represented as fixed objects.
      To do this the deleting of _hash and _array must skip these objects.

   TODO test null

   TODO Parse Unicode Escape
*/


/*
   See json_demo for examples.

 This requires the hash.mqh ( http://codebase.mql4.com/9238 , http://lordy.co.nf/hash )



 */

/// Different types of JSON Values
/// 異なるタイプのJSON値
enum ENUM_JSON_TYPE { JSON_NULL, JSON_OBJECT , JSON_ARRAY, JSON_NUMBER, JSON_STRING , JSON_BOOL };

class JSONString ;

///
/// Generic class for all JSON types (Number, String, Bool, Array, Object )
/// 一般的なJSON値のクラス(Number, String, Bool, Array, Object )
/// It is a subclass of HashValue so it can be stored in an JSON Object hash
/// それがJSONオブジェクトのハッシュに格納することができるハッシュ値のサブクラスです
///
class JSONValue : public HashValue {
    private:
    ENUM_JSON_TYPE _type;

    public:
        JSONValue() {}
        ~JSONValue() {}
        ENUM_JSON_TYPE getType() { return _type; }
        void setType(ENUM_JSON_TYPE t) { _type = t; }

        /// True if JSONValue is a instance of JSONString
        /// JSON値にJSON Stringのインスタンスがある場合はtrue
        bool isString() { return _type == JSON_STRING; }

        /// True if JSONValue is a instance of JSONNull 
        /// JSON値にJSON Nullのインスタンスがある場合はtrue
        bool isNull() { return _type == JSON_NULL; }

        /// True if JSONValue is a instance of JSONObject
        /// JSON値にJSON Objectのインスタンスがある場合はtrue
        bool isObject() { return _type == JSON_OBJECT; }

        /// True if JSONValue is a instance of JSONArray
        /// JSON値にJSON Arrayのインスタンスがある場合はtrue
        bool isArray() { return _type == JSON_ARRAY; }

        /// True if JSONValue is a instance of JSONNumber
        /// JSON値にJSON Numberのインスタンスがある場合はtrue
        bool isNumber() { return _type == JSON_NUMBER; }

        /// True if JSONValue is a instance of JSONBool
        /// JSON値にJSON boolのインスタンスがある場合はtrue
        bool isBool() { return _type == JSON_BOOL; }

        // Override in child classes
        // 子クラスでオーバーライド
        virtual string toString() {
            return "";
        }

        // Some convenience getters to cast to the subtype. - this is bad OO design!
        // いくつかの便利なゲッターを、サブタイプにキャストします。 - これは悪いOO設計です！しね

        /// If this JSONValue is an instance of JSONString return the string (or cast will fail)
        /// JSON値にJSONstringのインスタンスがある場合は、string型を返す（または失敗キャスト）
        string getString() { return ((JSONString *)GetPointer(this)).getString(); }

        /// If this JSONValue is an instance of JSONNumber return the double (or cast will fail)
        /// JSON値にJSONNumberのインスタンスがある場合は、double型を返す（または失敗キャスト）
        double getDouble() { return ((JSONNumber *)GetPointer(this)).getDouble(); }

        /// If this JSONValue is an instance of JSONNumber return the long (or cast will fail)
        /// JSON値にJSONNumberのインスタンスがある場合は、long型を返す（または失敗キャスト）
        long getLong() { return ((JSONNumber *)GetPointer(this)).getLong(); }

        /// If this JSONValue is an instance of JSONNumber return the int (or cast will fail)
        /// JSON値にJSONNumberのインスタンスがある場合は、int型を返す（または失敗キャスト）
        int getInt() { return ((JSONNumber *)GetPointer(this)).getInt(); }

        /// If this JSONValue is an instance of JSONBool return the bool (or cast will fail)
        /// JSON値にJSONBoolのインスタンスがある場合は、bool型を返す（または失敗キャスト）
        bool getBool() { return ((JSONBool *)GetPointer(this)).getBool(); }


        /// Get the string value of the JSONValue, without Program termination
        /// プログラムの終了せずに、JSONValueの文字列値を取得します。
        /// @param val : String object from which value will be extracted.
        /// @param out : The string than was extracted.
        /// @return true if OK else false
        static bool getString(JSONValue *val,string &out)
        {
            if (val != NULL && val.isString()) {
                out = val.getString();
                return true;
            }
            return false;
        }
        /// Get the bool value of the JSONValue, without Program termination
        /// プログラムの終了せずに、JSONValueのbool値を取得します。
        /// @param val : String object from which value will be extracted.
        /// @param out : The bool than was extracted.
        /// @return true if OK else false
        static bool getBool(JSONValue *val,bool &out)
        {
            if (val != NULL && val.isBool()) {
                out = val.getBool();
                return true;
            }
            return false;
        }
        /// Get the double value of the JSONValue, without Program termination
        /// プログラムの終了せずに、JSONValueのdouble値を取得します。
        /// @param val : String object from which value will be extracted.
        /// @param out : The double than was extracted.
        /// @return true if OK else false
        static bool getDouble(JSONValue *val,double &out)
        {
            if (val != NULL && val.isNumber()) {
                out = val.getDouble();
                return true;
            }
            return false;
        }
        /// Get the long value of the JSONValue, without Program termination
        /// プログラムの終了せずに、JSONValueのlong値を取得します。
        /// @param val : String object from which value will be extracted.
        /// @param out : The long than was extracted.
        /// @return true if OK else false
        static bool getLong(JSONValue *val,long &out)
        {
            if (val != NULL && val.isNumber()) {
                out = val.getLong();
                return true;
            }
            return false;
        }
        /// Get the int value of the JSONValue, without Program termination
        /// プログラムの終了せずに、JSONValueのint値を取得します。
        /// @param val : String object from which value will be extracted.
        /// @param out : The int than was extracted.
        /// @return true if OK else false
        static bool getInt(JSONValue *val,int &out)
        {
            if (val != NULL && val.isNumber()) {
                out = val.getInt();
                return true;
            }
            return false;
        }
};

// -----------------------------------------

/// Class to represent a JSON String 
/// JSON Stringを表すクラス
class JSONString : public JSONValue {
    private:
        string _string;
    public:
        JSONString(string s) {
            setString(s);
            setType(JSON_STRING);
        }
        JSONString() {
            setType(JSON_STRING);
        }
        string getString() { return _string; }
        void setString(string v) { _string = v; }
        string toString() { return StringConcatenate("\"",_string,"\""); }
};


// -----------------------------------------

/// Class to represent a JSON Bool 
/// JSON Boolを表すクラス
class JSONBool : public JSONValue {
    private:
        bool _bool;
    public:
        JSONBool(bool b) {
            setBool(b);
            setType(JSON_BOOL);
        }
        JSONBool() {
            setType(JSON_BOOL);
        }
        bool getBool() { return _bool; }
        void setBool(bool v) { _bool = v; }
        string toString() { return (string)_bool; }

};

// -----------------------------------------

/// A JSON number may be internall replresented as either an MQL4 double or a long depending on how it was parsed. 
/// JSON numberはMQL4で解析されたこに応じて double型またはlong型のいずれかの中身を表すことができる。（？）
/// If one type is set the other is zeroed.
/// 一つのタイプが設定されている場合、他方はゼロにされます。
class JSONNumber : public JSONValue {
    private:
        long _long;
        double _dbl;
    public:
        JSONNumber(long l) {
            _long = l;
            _dbl = 0;
        }
        JSONNumber(double d) {
            _long = 0;
            _dbl = d;
        }
        /// Get the long value, (cast) from internal double if necessary,
        /// long値を取得する,必要に応じてdouble型を取得する（？）
        long getLong() {
            if (_dbl != 0) {
                return (long)_dbl;
            } else {
                return _long;
            }
        }
        /// Get the int value, (cast) from internal value.
        /// int値を取得する,必要に応じて内部の値を取得する(?)
        int getInt() {
            if (_dbl != 0) {
                return (int)_dbl;
            } else {
                return (int)_long;
            }
        }
        /// Get the double value, (cast) from internal long if necessary.
        /// double値を取得する,必要に応じて内部のlong型を取得する（？）
        double getDouble() 
        {
            if (_long != 0) {
                return (double)_long;
            } else {
                return _dbl;
            }
        }
        string toString() {
            // Favour the long
            if (_long != 0) {
                return (string)_long;
            } else {
                return (string)_dbl;
            }
        }
};
// -----------------------------------------


/// This class should not be necessary, but null is genrally infrequent so
/// I havent bothered to code it away yet.
/// このクラスは必要ありませんが、nullはので、私はそれをまだ離れてコーディングする困っていません一般的にまれです ?

class JSONNull : public JSONValue {
    public:
    JSONNull()
    {
        setType(JSON_NULL);
    }
    ~JSONNull() {}
    string toString() 
    {
        return "null";
    }
};

//forward declaration
//前方宣言
class JSONArray ;

/// This represents a JSONObject which is represented internally as a Hash
/// これは、ハッシュとして内部的に表現されるJSONObjectを表し
class JSONObject : public JSONValue {
    private:
    Hash *_hash;
    public:
        JSONObject() {
            setType(JSON_OBJECT);
        }
        ~JSONObject() {
            if (_hash != NULL) delete _hash;
        }
        /// Lookup key and get associated string value - halt program if wrong type(cast error) or doesnt exist(null pointer)
        /// キーを検索し、関連付けられたstringの値を取得 - 停止プログラム,間違ったタイプ（キャストエラー）または存在しない場合(NULLポインタ）
        string getString(string key) 
        {
            return getValue(key).getString();
        }
        /// Lookup key and get associated bool value - halt program if wrong type(cast error) or doesnt exist(null pointer)
        /// キーを検索し、関連付けられたboolの値を取得 - 停止プログラム,間違ったタイプ（キャストエラー）または存在しない場合(NULLポインタ）
        bool getBool(string key) 
        {
            return getValue(key).getBool();
        }
        /// Lookup key and get associated double value - halt program if wrong type(cast error) or doesnt exist(null pointer)
        /// ルックアップキーと関連付けられたdoubleの値を取得 - 停止プログラム,間違ったタイプ（キャストエラー）または存在しない場合(NULLポインタ）
        
        double getDouble(string key) 
        {
            return getValue(key).getDouble();
        }
        /// Lookup key and get associated long value - halt program if wrong type(cast error) or doesnt exist(null pointer)
        /// キーを検索し、関連付けられたlongの値を取得 - 停止プログラム,間違ったタイプ（キャストエラー）または存在しない場合(NULLポインタ）        
        long getLong(string key) 
        {
            return getValue(key).getLong();
        }
        /// Lookup key and get associated int value - halt program if wrong type(cast error) or doesnt exist(null pointer)
        /// ルックアップキーと関連付けられたintの値を取得 - 停止プログラム,間違ったタイプ（キャストエラー）または存在しない場合(NULLポインタ）
        int getInt(string key) 
        {
            return getValue(key).getInt();
        }

        /// Lookup key and get associated string value, return false if failure.
        /// キーのルックアップと関連するstringの値を取得し、失敗した場合はfalseを返します。
        bool getString(string key,string &out)
        {
            return getString(getValue(key),out);
        }
        /// Lookup key and get associated bool value, return false if failure.
        /// キーのルックアップと関連するboolの値を取得し、失敗した場合はfalseを返します。
        bool getBool(string key,bool &out)
        {
            return getBool(getValue(key),out);
        }
        /// Lookup key and get associated double value, return false if failure.
        /// キーのルックアップと関連するdoubleの値を取得し、失敗した場合はfalseを返します。
        bool getDouble(string key,double &out)
        {
            return getDouble(getValue(key),out);
        }
        /// Lookup key and get associated long value, return false if failure.
        /// キーのルックアップと関連するlongの値を取得し、失敗した場合はfalseを返します。
        bool getLong(string key,long &out)
        {
            return getLong(getValue(key),out);
        }
        /// Lookup key and get associated int value, return false if failure.
        /// キーのルックアップと関連するintの値を取得し、失敗した場合はfalseを返します。
        bool getInt(string key,int &out)
        {
            return getInt(getValue(key),out);
        }

        /// Lookup key and get associated array, NULL if not present. Cast failure if not an Array.
        /// キーを探して連想するarrayを取得する。存在しない場合はNULL。Arrayが存在しない場合はキャスト失敗
        JSONArray *getArray(string key) 
        {
            return getValue(key);
        }
        /// Lookup key and get associated Object, NULL if not present. Cast failure if not an Object.
        /// キーを探して連想するObjectを取得する。存在しない場合はNULL。Objectが存在しない場合はキャスト失敗
        JSONObject *getObject(string key) 
        {
            return getValue(key);
        }
        /// Lookup key and get associated value - best for data whose structure might change as any type can safely be returned.
        /// キーを探し値を取得 - いずれかのタイプを安全に返すことができるように、その構造データのための最高は変更される可能性があります
        JSONValue *getValue(string key) 
        {
            if (_hash == NULL) {
                return NULL;
            }
            return (JSONValue*)_hash.hGet(key);
        }

        /// Store the value against the specified key string - Used by the parser.
        /// 指定されたキー文字列に対する値を格納 - パーサによって使用される
        void put(string key,JSONValue *v)
        {
            if (_hash == NULL) _hash = new Hash();
            _hash.hPut(key,v);
        }
        string toString() {
           string s = "{";
           if (_hash != NULL) {
               HashLoop *l;
               int n=0;
               
               for(l = new HashLoop(_hash) ; l.hasNext() ; l.next() ) {
                   JSONValue *v = (JSONValue *)(l.val());
                   s = StringConcatenate(s,(++n==1?"":","),
                           "\"",l.key(),"\" : ",v.toString());
               }
               delete l;
           }
           s = s + "}";
           return s; 
        }

        /// Return the internal Hash - Used by JSONIterator
        /// 内部のハッシュを返す - JSONIteratorで使用される
        Hash *getHash() {
            return _hash;
        }
};

/// This is a JSONArray which is represented internally as a MQL4 dynamic array of JSONValue * 
/// これはJSONValueのMQL4動的配列として内部的に表現されたJSON配列です
class JSONArray : public JSONValue {
    private:
        int _size;
        JSONValue *_array[];
    public:
        JSONArray() {
            setType(JSON_ARRAY);
        }
        ~JSONArray() {
            // clean up array
            // 配列をクリーンアップ
            for(int i = ArrayRange(_array,0)-1 ; i >= 0 ; i-- ) {
                if (CheckPointer(_array[i]) == POINTER_DYNAMIC ) delete _array[i];
            }
        }
        // Getters for Objects (key lookup ) --------------------------------------
        
        /// Lookup string value by array index - halt program if wrong type(cast error) or doesnt exist(null pointer)
        /// arrayインデックスのstring値を検索 - 違ったタイプ(cast error)か存在しない場合(null pointer)停止プログラム
        string getString(int index) 
        {
            return getValue(index).getString();
        }
        /// Lookup bool value by array index - halt program if wrong type(cast error) or doesnt exist(null pointer)
        /// arrayインデックスのbool値を検索 - 違ったタイプ(cast error)か存在しない場合(null pointer)停止プログラム
        bool getBool(int index) 
        {
            return getValue(index).getBool();
        }
        /// Lookup double value by array index - halt program if wrong type(cast error) or doesnt exist(null pointer)
        /// arrayインデックスのdouble値を検索 - 違ったタイプ(cast error)か存在しない場合(null pointer)停止プログラム
        double getDouble(int index) 
        {
            return getValue(index).getDouble();
        }
        /// Lookup long value by array index - halt program if wrong type(cast error) or doesnt exist(null pointer)
        /// arrayインデックスのlong値を検索 - 違ったタイプ(cast error)か存在しない場合(null pointer)停止プログラム
        long getLong(int index) 
        {
            return getValue(index).getLong();
        }
        /// Lookup int value by array index - halt program if wrong type(cast error) or doesnt exist(null pointer)
        /// arrayインデックスのint値を検索 - 違ったタイプ(cast error)か存在しない場合(null pointer)停止プログラム
        int getInt(int index) 
        {
            return getValue(index).getInt();
        }

        /// Lookup JSONString by array index. NULL if not present. Cast failure if not an Object.
        /// arrayインデックスのJSONStringを検索,存在しない場合はNULL。Objectでない場合はキャスト失敗
        bool getString(int index,string &out)
        {
            return getString(getValue(index),out);
        }
        /// Lookup JSONBool by array index. NULL if not present. Cast failure if not an Object.
        /// arrayインデックスのJSONBoolを検索,存在しない場合はNULL。Objectでない場合はキャスト失敗
        bool getBool(int index,bool &out)
        {
            return getBool(getValue(index),out);
        }
        /// Lookup JSONNumber by array index. NULL if not present. Cast failure if not an Object.
        /// arrayインデックスのJSONNumberを検索,存在しない場合はNULL。Objectでない場合はキャスト失敗
        bool getDouble(int index,double &out)
        {
            return getDouble(getValue(index),out);
        }
        /// Lookup JSONNumber by array index. NULL if not present. Cast failure if not an Object.
        /// arrayインデックスのJSONNumberを検索,存在しない場合はNULL。Objectでない場合はキャスト失敗
        bool getLong(int index,long &out)
        {
            return getLong(getValue(index),out);
        }
        /// Lookup JSONNumber by array index. NULL if not present. Cast failure if not an Object.
        /// arrayインデックスのJSONNumberを検索,存在しない場合はNULL。Objectでない場合はキャスト失敗
        bool getInt(int index,int &out)
        {
            return getInt(getValue(index),out);
        }


        /// Lookup array child by index, NULL if not present. Cast failure if not an Array.
        /// インデックスのarrayの子を検索,存在しない場合はNULL。Arrayでない場合はキャスト失敗
        JSONArray *getArray(int index) 
        {
            return getValue(index);
        }
        
        /// Lookup object child by index, NULL if not present. Cast failure if not an Array.
        /// インデックスのobjectの子を検索,存在しない場合はNULL。Arrayでない場合はキャスト失敗
        JSONObject *getObject(int index) 
        {
            return getValue(index);
        }
        /// The following method allows any type to be returned. Use this when parsing unpredictable data
        /// 以下の方法は、任意のタイプを返すことが可能になります。この構文解析予測不可能なデータを使用してください
        JSONValue *getValue(int index) 
        {
            return _array[index];
        }

        /// Used by the Parser when building the array
        /// 配列を構築する際にパーサによって使用されます
        bool put(int index,JSONValue *v)
        {
            if (index >= _size) {
                int oldSize = _size;
                int newSize = ArrayResize(_array,index+1,30);
                if (newSize <= index) return false;
                _size = newSize;

                // initialise
                // 初期化
                for(int i = oldSize ; i< newSize ; i++ ) _array[i] = NULL;
            }
            // Delete old entry if any
            // もし古いエントリがあれば削除
            if (_array[index] != NULL) delete _array[index];

            //set new entry
            //新しいエントリを設定
            _array[index] = v;

            return true;
        }

        string toString() {
           string s = "[";
           if (_size > 0) {
               s = StringConcatenate(s,_array[0].toString());
               for(int i = 1 ; i< _size ; i++ ) {
                  s = StringConcatenate(s,",",_array[i].toString());
               }
           }
           s = s + "]";
           return s; 
        }

        int size() {
            return _size;
        }
};



/// Parse JSON text using a simple recursive descent parser
/// Exmaple
/// 
/// <pre>
///    string s = "{ \"firstName\": \"John\","+
///       " \"lastName\": \"Smith\","+
///       " \"age\": 25,"+
///       " \"address\": { \"streetAddress\": \"21 2nd Street\", \"city\": \"New York\", \"state\": \"NY\", \"postalCode\": \"10021\" },"+
///       " \"phoneNumber\": [ { \"type\": \"home\", \"number\": \"212 555-1234\" }, { \"type\": \"fax\", \"number\": \"646 555-4567\" } ],"+
///       " \"gender\":{ \"type\":\"male\" }  }";
///
///    JSONParser *parser = new JSONParser();
///
///    JSONValue *jv = parser.parse(s);
///
///    if (jv == NULL) {
///
///        Print("error:"+(string)parser.getErrorCode()+parser.getErrorMessage());
///
///    } else {
///
///        Print("PARSED:"+jv.toString());
///
///        if (jv.isObject()) {
///
///            JSONObject *jo = jv;
///
///            // Direct access - will throw null pointer if wrong getter used.
///
///            Print("firstName:" + jo.getString("firstName"));
///            Print("city:" + jo.getObject("address").getString("city"));
///            Print("phone:" + jo.getArray("phoneNumber").getObject(0).getString("number"));
///
///            // Safe access in case JSON data is missing or different.
///
///            if (jo.getString("firstName",s) ) Print("firstName = "+s);
///
///            // Loop over object returning JSONValue
///
///            JSONIterator *it = new JSONIterator(jo);
///            for( ; it.hasNext() ; it.next()) {
///                Print("loop:"+it.key()+" = "+it.val().toString());
///            }
///            delete it;
///        }
///        delete jv;
///    }
///    delete parser;
/// </pre>

class JSONParser {
    private:
        /// Current parse position
        /// 現在の解析位置
        int _pos;
        /// The input string is expanded into an array of ushort (wchar)
        /// 入力文字列がUSHORTの配列に展開されている（wchar型）
        ushort _in[];
        /// Length of string
        /// 文字列の長さ
        int _len;
        /// The original input string
        /// 元の入力文字列
        string _instr;

        int _errCode;
        string _errMsg;

        void setError(int code=1,string msg="unknown error") {
            _errCode |= code;
            if (_errMsg == "") {
                _errMsg = "JSONParser::Error "+msg;
            } else {
                _errMsg = StringConcatenate(_errMsg,"\n",msg);
            }
        }
        
        /// Parse a JSON Object
        /// JSONオブジェクトを解析
        JSONObject *parseObject() 
        {
            JSONObject *o = new JSONObject();
            skipSpace();
            if (expect('{')) {
                    while (_errCode == 0) {
                        skipSpace();
                        if (_in[_pos] != '"') break;

                        // Read the key
                        string key = parseString();

                        if (_errCode != 0 || key == NULL) break;

                        skipSpace();

                        if (!expect(':')) break;

                        // read the value
                        JSONValue *v = parseValue();
                        if (_errCode != 0 ) break;

                        o.put(key,v);

                        skipSpace();

                        if (!expectOptional(',')) break;
                    }
                    if (!expect('}')) {
                        setError(2,"expected \" or } ");
                    }
            }
            if (_errCode != 0) {
                delete o;
                o = NULL;
            }
            return o;
        }

        bool isDigit(ushort c) {
            return (c >= '0' && c <= '9' ) || c == '+'  || c == '-'  ; 
        }

        bool isDoubleDigit(ushort c) {
            return (c >= '0' && c <= '9' ) || c == '+'  || c == '-'  || c == '.'  || c == 'e'  || c == 'E' ; 
        }

        void skipSpace() {
            while (_in[_pos] == ' ' || _in[_pos] == '\t' || _in[_pos]=='\r' || _in[_pos] == '\n' ) {
                if (_pos >= _len ) break;
                _pos++;
            }
        }

        bool expect(ushort c)
        {
            bool ret = false;
            if (c == _in[_pos]) {
                _pos++;
                ret = true;
            } else {
                setError(1,StringConcatenate("expected ",
                        ShortToString(c),"(",c,")",
                        " got ",ShortToString(_in[_pos]),"(",_in[_pos],")"));
            }
            return ret;
        }

        bool expectOptional(ushort c)
        {
            bool ret=false;
            if (c == _in[_pos]) {
                _pos++;
                ret = true;
            }
            return ret;
        }

        string parseString()
        {
            string ret = "";
            if(expect('"')) {
                while(true) {
                    int end=_pos;
                    while(end < _len && _in[end] != '"' && _in[end] != '\\' ) {
                        end++;
                    }

                    if (end >= _len) {
                        setError(2,"missing quote: end"+(string)end+":len"+(string)_len+":"+ShortToString(_in[_pos])+":"+StringSubstr(_instr,_pos,10)+"...");
                        break;
                    }
                    // Check if character was escaped.
                    // 文字をエスケープしていないか確認。
                    // TODO \" \\ \/ \b \f \n \r \t \u0000
                    if (_in[end] == '\\') {
                        // Add partial string and get more
                        ret = ret + StringSubstr(_instr,_pos,end-_pos);
                        end++;
                        if (end >= _len) {
                          setError(4,"parse error after escape");
                        } else {
                            ushort c = 0;
                            switch(_in[end]) {
                                case '"':
                                case '\\':
                                case '/':
                                    c = _in[end];
                                    break;
                                case 'b': c = 8; break; // backspace - 8
                                case 'f': c = 12; break; // form feed 12
                                case 'n': c = '\n'; break;
                                case 'r': c = '\r'; break;
                                case 't': c = '\t'; break;
                                default:
                                          setError(3,"unknown escape");
                            }
                            if (c == 0) break;
                            ret = ret + ShortToString(c);
                            _pos = end+1;
                        }
                    } else if (_in[end] == '"') {
                        // End of string
                        // 文字列の最後
                        ret = ret + StringSubstr(_instr,_pos,end-_pos);
                        _pos = end+1;
                        break;
                    }
                }
            }
            if (_errCode != 0) {
                ret = NULL;
            }
            return ret;
        }

        JSONValue *parseValue() 
        {
            JSONValue *ret = NULL;
            skipSpace();

            if (_in[_pos] == '[')  {

                ret = (JSONValue*)parseArray();

            } else if (_in[_pos] == '{')  {

                ret = (JSONValue*)parseObject();

            } else if (_in[_pos] == '"')  {

                string s = parseString();
                ret = (JSONValue*)new JSONString(s);

            } else if (isDoubleDigit(_in[_pos])) {
                bool isDoubleOnly = false;
                long l=0;
                long sign;
                // number
                int i = _pos;

                if (_in[_pos] == '-') {
                    sign = -1;
                    _pos++;
                } else if (_in[_pos] == '+') {
                    sign = 1;
                    _pos++;
                } else {
                    sign = 1;
                }

                while(i < _len && isDigit(_in[i])) {
                    l = l * 10 + ( _in[i] - '0' );
                    i++;
                }
                if (isDoubleDigit(_in[i])) {
                    // Looks like a real number;
                    // 実数のように見る。
                    while(i < _len && isDoubleDigit(_in[i])) {
                        i++;
                    }
                    string s1 = StringSubstr(_instr,_pos,i-_pos);
                    double d = sign * StringToDouble(s1);
                    ret = (JSONValue*)new JSONNumber(d); // Create a Number as double only　//double型のNumberを作成
                } else {
                    l = sign * l;
                    ret = (JSONValue*)new JSONNumber(l); // Create a Number as a long　　   //long型のNumberを作成
                }
                _pos = i;

            } else if (_in[_pos] == 't' && StringSubstr(_instr,_pos,4) == "true")  {

                ret = (JSONValue*)new JSONBool(true);
                _pos += 4;

            } else if (_in[_pos] == 'f' && StringSubstr(_instr,_pos,5) == "false")  {

                ret = (JSONValue*)new JSONBool(false);
                _pos += 5;

            } else if (_in[_pos] == 'n' && StringSubstr(_instr,_pos,4) == "null")  {

                ret = (JSONValue*)new JSONNull();
                _pos += 4;

            } else {

                setError(3,"error parsing value at position "+(string)_pos);

            }

            if (_errCode != 0 && ret != NULL ) {
                delete ret;
                ret = NULL;
            }
            return ret;
        }

        JSONArray *parseArray()
        {
            JSONArray *ret = new JSONArray();

            int index = 0;
            skipSpace();
            if (expect('[')) {
                while (_errCode == 0) {
                    skipSpace();

                    // read the value
                    // 値を読み込む
                    JSONValue *v = parseValue();
                    if (_errCode != 0) break;

                    if (!ret.put(index++,v)) {
                        setError(3,"memory error adding "+(string)index);
                        break;
                    }

                    skipSpace();

                    if (!expectOptional(',')) break;
                }
                if (!expect(']')) {
                    setError(2,"list: expected , or ] ");
                }
            }

            if (_errCode != 0 ) {
                delete ret;
                ret = NULL;
            }
            return ret;
        }
    public:
        int getErrorCode()
        {
            return _errCode;
        }
        string getErrorMessage()
        {
            return _errMsg;
        }
        /// Parse a sequnce of characters and return a JSONValue.
        /// 文字列を解析し、JSONの値を返します。
        JSONValue *parse(
                string s ///< Serialized JSON text // 直列化されたJSONテキスト
             )
        {
            int inLen;
            JSONValue *ret = NULL;
            StringTrimLeft(s);
            StringTrimRight(s);

            _instr = s;
            _len = StringToShortArray(_instr,_in); // nul '0' is added to length
            _pos = 0;
            _errCode = 0;
            _errMsg = "";
            inLen = StringLen(_instr);
            if (_len != inLen + 1 /* nul */ ) {
                setError(1,StringConcatenate("unable to create array ",inLen," got ",_len));
            } else {
                _len --;
                ret = parseValue();
                if (_errCode != 0) {
                    _errMsg = StringConcatenate(_errMsg," at ",_pos," [",StringSubstr(_instr,_pos,10),"...]");
                }
            }
            return ret;
        }

};

/// Class to iterate over a JSONObject (not a JSONArray)
/// JSONObjectを反復処理するためのクラス
class JSONIterator {
    private:
        HashLoop * _l;

    public:
    // Create iterator and move to first item
    // イテレータを作成し、最初の項目に移動
    JSONIterator(JSONObject *jo) 
    {
        _l = new HashLoop(jo.getHash());
    }
    ~JSONIterator() 
    {
        delete _l;
    }
    // Check if more items
    // アイテムが複数あるか確認
    bool hasNext() 
    {
        return _l.hasNext();
    }

    // Move to next item
    // 次のアイテムへ移動
    void next() {
        _l.next();
    }

    // Return item
    // アイテムを返す
    JSONValue *val()
    {
        return (JSONValue *) (_l.val());
    }

    // Return key
    // キーを返す
    string key()
    {
        return _l.key();
    }

};

void json_demo() 
{
    string s = "{ \"firstName\": \"John\","+
       " \"lastName\": \"Smith\","+
       " \"age\": 25,"+
       " \"address\": { \"streetAddress\": \"21 2nd Street\", \"city\": \"New York\", \"state\": \"NY\", \"postalCode\": \"10021\" },"+
       " \"phoneNumber\": [ { \"type\": \"home\", \"number\": \"212 555-1234\" }, { \"type\": \"fax\", \"number\": \"646 555-4567\" } ],"+
       " \"gender\":{ \"type\":\"male\" }  }";

    JSONParser *parser = new JSONParser();
    JSONValue *jv = parser.parse(s);
    Print("json:");
    if (jv == NULL) {
        Print("error:"+(string)parser.getErrorCode()+parser.getErrorMessage());
    } else {
        Print("PARSED:"+jv.toString());
        if (jv.isObject()) {
            JSONObject *jo = jv;

            // Direct access - will throw null pointer if wrong getter used.
            // 直接アクセス - 間違ったゲッターを使用した場合はnullポインタをスローします。
            Print("firstName:" + jo.getString("firstName"));
            Print("city:" + jo.getObject("address").getString("city"));
            Print("phone:" + jo.getArray("phoneNumber").getObject(0).getString("number"));

            // Safe access in case JSON data is missing or different.
            // ケースJSONデータである金庫のアクセスが存在しないか、または異なっています。
            if (jo.getString("firstName",s) ) Print("firstName = "+s);

            // Loop over object returning JSONValue
            //JSONValueを返すオブジェクトをループ
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



#endif

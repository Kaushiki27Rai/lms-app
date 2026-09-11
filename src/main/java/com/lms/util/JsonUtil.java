package com.lms.util;
import java.util.*;
/** Small dependency-free JSON codec for this servlet API's simple request/response payloads. */
public final class JsonUtil {
 private JsonUtil(){}
 public static String value(Object o){
  if(o==null)return "null"; if(o instanceof Number||o instanceof Boolean)return o.toString(); if(o instanceof String)return quote((String)o);
  if(o instanceof Map){StringBuilder b=new StringBuilder("{"); for(Object e0:((Map<?,?>)o).entrySet()){Map.Entry<?,?>e=(Map.Entry<?,?>)e0;if(b.length()>1)b.append(',');b.append(quote(String.valueOf(e.getKey()))).append(':').append(value(e.getValue()));}return b.append('}').toString();}
  if(o instanceof Iterable){StringBuilder b=new StringBuilder("[");for(Object x:(Iterable<?>)o){if(b.length()>1)b.append(',');b.append(value(x));}return b.append(']').toString();} return quote(String.valueOf(o));
 }
 public static String quote(String s){return "\""+s.replace("\\","\\\\").replace("\"","\\\"").replace("\n","\\n").replace("\r","\\r")+"\"";}
 public static String field(String body,String name){java.util.regex.Matcher m=java.util.regex.Pattern.compile("\\\""+java.util.regex.Pattern.quote(name)+"\\\"\\s*:\\s*\\\"([^\\\"]*)\\\"").matcher(body);return m.find()?m.group(1):null;}
}

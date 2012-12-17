<%@page
contentType="application/json"%><%@page
import="org.json.simple.JSONObject"%><%@page
import="org.json.simple.JSONArray"%><%@page
import="kr.co.websync.safeschool.hn"%><%

  request.setCharacterEncoding("UTF-8");

  String realpath=application.getRealPath("/");
  String input=request.getParameter("i");
  JSONArray output=kr.co.websync.safeschool.hn.run(realpath,input);

  response.setCharacterEncoding("UTF-8");
  response.addHeader("Access-Control-Allow-Origin","*");
  response.addHeader("Access-Control-Allow-Headers","Content-Type, X-Requested-With");
  response.addHeader("Access-Control-Allow-Methods","GET, POST, OPTIONS");

  //JSONObject obj=new JSONObject();
  //obj.put("output",output);
  //obj.put("test","한글안되냐?");
  out.print(output);
  out.flush();

%>

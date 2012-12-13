<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="kr.co.websync.safeschool.hn"%>
<% String realPath = application.getRealPath("/"); %>
<%-- contextpath=${pageContext.request.contextPath} --%>
<%
  JSONObject obj=new JSONObject();
  obj.put("name","foo");
  obj.put("num",new Integer(100));
  obj.put("balance",new Double(1000.21));
  obj.put("is_vip",new Boolean(true));
  obj.put("nickname",null);
  obj.put("dir",System.getProperty("user.dir"));
  obj.put("contextpath",realPath);
  obj.put("test",kr.co.websync.safeschool.hn.run(realPath));
  out.print(obj);
  out.flush();
%>

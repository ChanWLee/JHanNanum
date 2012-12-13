<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="kr.co.websync.safeschool.hn"%>
<%-- contextpath=${pageContext.request.contextPath} --%>
<%
  String realPath=application.getRealPath("/");
  String input=request.getParameter("i");
  String output=kr.co.websync.safeschool.hn.run(realPath,input);
  JSONObject obj=new JSONObject();
  obj.put("userdir",System.getProperty("user.dir"));
  obj.put("realpath",realPath);
  obj.put("output",kr.co.websync.safeschool.hn.run(realPath));
  out.print(obj);
  out.flush();
%>

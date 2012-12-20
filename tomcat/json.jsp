<%@page contentType="application/json"
%><%@page import="java.io.FileNotFoundException"
%><%@page import="java.io.IOException"
%><%@page import="java.util.LinkedList"
%><%@page import="java.util.ArrayList"
%><%@page import="java.util.HashMap"
%><%@page import="java.util.List"
%><%@page import="java.util.Map"
%><%@page import="org.json.simple.JSONValue"
%><%@page import="org.json.simple.JSONObject"
%><%@page import="org.json.simple.JSONArray"
%><%@page import="kr.ac.kaist.swrc.jhannanum.comm.Eojeol"
%><%@page import="kr.ac.kaist.swrc.jhannanum.comm.Sentence"
%><%@page import="kr.ac.kaist.swrc.jhannanum.hannanum.Workflow"
%><%@page import="kr.ac.kaist.swrc.jhannanum.hannanum.WorkflowFactory"
%><%@page import="kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.MorphAnalyzer.ChartMorphAnalyzer.ChartMorphAnalyzer"
%><%@page import="kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.PosTagger.HmmPosTagger.HMMTagger"
%><%@page import="kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.MorphemeProcessor.SimpleMAResult09.SimpleMAResult09"
%><%@page import="kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.MorphemeProcessor.SimpleMAResult22.SimpleMAResult22"
%><%@page import="kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.MorphemeProcessor.UnknownMorphProcessor.UnknownProcessor"
%><%@page import="kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PlainTextProcessor.InformalSentenceFilter.InformalSentenceFilter"
%><%@page import="kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PlainTextProcessor.SentenceSegmentor.SentenceSegmentor"
%><%@page import="kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PosProcessor.SimplePOSResult09.SimplePOSResult09"
%><%@page import="kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PosProcessor.SimplePOSResult22.SimplePOSResult22"
%><%@page import="kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PosProcessor.NounExtractor.NounExtractor"
%><%

  request.setCharacterEncoding("UTF-8");

  String realpath=application.getRealPath("/");
  String input=request.getParameter("i");

  response.setCharacterEncoding("UTF-8");
  response.addHeader("Access-Control-Allow-Origin","*");
  response.addHeader("Access-Control-Allow-Headers","Content-Type, X-Requested-With");
  response.addHeader("Access-Control-Allow-Methods","GET, POST, OPTIONS");

  Workflow workflow = new Workflow(realpath);

  try {

    workflow.appendPlainTextProcessor(new SentenceSegmentor(),null);
    workflow.appendPlainTextProcessor(new InformalSentenceFilter(),null);
    workflow.setMorphAnalyzer(new ChartMorphAnalyzer(),"conf/plugin/MajorPlugin/MorphAnalyzer/ChartMorphAnalyzer.json");
    workflow.appendMorphemeProcessor(new UnknownProcessor(),null);
    workflow.setPosTagger(new HMMTagger(),"conf/plugin/MajorPlugin/PosTagger/HmmPosTagger.json");
    //workflow.appendPosProcessor(new NounExtractor(), null); // noun only

    workflow.activateWorkflow(true);

    workflow.analyze(input);

    LinkedList<Sentence> resultList =
	workflow.getResultOfDocument(new Sentence(0,0,false));

    //out.print(JSONValue.toJSONString(resultList));

/*
    JSONArray output = new JSONArray();

    for(Sentence s : resultList){
      Eojeol[] eojeolArray = s.getEojeols();
      ArrayList<List<Map>> a = new ArrayList<List<Map>>();
      for(int i=0;i<eojeolArray.length;i++){
	ArrayList<Map> b = new ArrayList<Map>();
	for(int j=0;j<eojeolArray[i].length;j++){
	  HashMap<String,String> obj=new HashMap<String,String>();
	  String tag=eojeolArray[i].getTag(j);
	  String morpheme=eojeolArray[i].getMorpheme(j);
	  obj.put(tag,morpheme);
	  b.add(obj);
	}
	a.add(b);
      }
      output.add(a);
    }

    out.print(output);
*/

    ArrayList<List> l = new ArrayList<List>();

    for(Sentence s : resultList){
      Eojeol[] eojeolArray = s.getEojeols();
      ArrayList<List> a = new ArrayList<List>();
      for(int i=0;i<eojeolArray.length;i++){
	ArrayList<Map> b = new ArrayList<Map>();
	for(int j=0;j<eojeolArray[i].length;j++){
	  HashMap<String,String> obj=new HashMap<String,String>();
	  String tag=eojeolArray[i].getTag(j);
	  String morpheme=eojeolArray[i].getMorpheme(j);
	  obj.put(tag,morpheme);
	  b.add(obj);
	}
	a.add(b);
      }
      l.add(a);
    }

    out.print(l);

/*
    ArrayList<List> l = new ArrayList<List>();

    for(Sentence s : resultList){
      Eojeol[] eojeolArray = s.getEojeols();
      ArrayList<Map> a = new ArrayList<Map>();
      for(int i=0;i<eojeolArray.length;i++){
	HashMap<String,String> b=new HashMap<String,String>();
	for(int j=0;j<eojeolArray[i].length;j++){
	  String tag=""+j+":"+eojeolArray[i].getTag(j);
	  String morpheme=eojeolArray[i].getMorpheme(j);
	  b.put(tag,morpheme);
	}
	a.add(b);
      }
      l.add(a);
    }

    out.print(l);
*/

  } catch (FileNotFoundException e) {
    e.printStackTrace();
    //System.exit(0);
  } catch (IOException e) {
    e.printStackTrace();
    //System.exit(0);
  } catch (Exception e) {
    e.printStackTrace();
    //System.exit(0);
  }

  /* Shutdown the workflow */
  workflow.close();

  out.flush();

%>

package kr.co.websync.safeschool;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.LinkedList;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.json.simple.JSONArray;

import kr.ac.kaist.swrc.jhannanum.comm.Eojeol;
import kr.ac.kaist.swrc.jhannanum.comm.Sentence;
import kr.ac.kaist.swrc.jhannanum.hannanum.Workflow;
import kr.ac.kaist.swrc.jhannanum.hannanum.WorkflowFactory;

import kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.MorphAnalyzer.ChartMorphAnalyzer.ChartMorphAnalyzer;
import kr.ac.kaist.swrc.jhannanum.plugin.MajorPlugin.PosTagger.HmmPosTagger.HMMTagger;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.MorphemeProcessor.SimpleMAResult09.SimpleMAResult09;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.MorphemeProcessor.SimpleMAResult22.SimpleMAResult22;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.MorphemeProcessor.UnknownMorphProcessor.UnknownProcessor;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PlainTextProcessor.InformalSentenceFilter.InformalSentenceFilter;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PlainTextProcessor.SentenceSegmentor.SentenceSegmentor;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PosProcessor.SimplePOSResult09.SimplePOSResult09;
import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PosProcessor.SimplePOSResult22.SimplePOSResult22;

import kr.ac.kaist.swrc.jhannanum.plugin.SupplementPlugin.PosProcessor.NounExtractor.NounExtractor;

public class hn
{

    public static JSONArray run(String baseDir,String input) {

	Workflow workflow = new Workflow(baseDir);
        JSONArray output = new JSONArray();

	try {

	    workflow.appendPlainTextProcessor(new SentenceSegmentor(), null);
	    workflow.appendPlainTextProcessor(new InformalSentenceFilter(), null);
	    workflow.setMorphAnalyzer(new ChartMorphAnalyzer(), "conf/plugin/MajorPlugin/MorphAnalyzer/ChartMorphAnalyzer.json");
	    workflow.appendMorphemeProcessor(new UnknownProcessor(), null);
	    workflow.setPosTagger(new HMMTagger(), "conf/plugin/MajorPlugin/PosTagger/HmmPosTagger.json");

	    //workflow.appendPosProcessor(new NounExtractor(), null); // noun only

	    workflow.activateWorkflow(true);

	    workflow.analyze(input);

	    //output.append(workflow.getResultOfDocument());
	    LinkedList<Sentence> resultList =
                workflow.getResultOfDocument(new Sentence(0,0,false));
            for(Sentence s : resultList){
                Eojeol[] eojeolArray = s.getEojeols();
                ArrayList<List<Map<String,String>>> a = new ArrayList<List<Map<String,String>>>();
                for(int i=0;i<eojeolArray.length;i++){
                    ArrayList<Map<String,String>> b = new ArrayList<Map<String,String>>();
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

	    workflow.close();

	} catch (FileNotFoundException e) {
	    e.printStackTrace();
	    //System.exit(0);
	} catch (IOException e) {
	    e.printStackTrace();
	    //System.exit(0);
	} catch (Exception e) {
	    e.printStackTrace();
	}

	/* Shutdown the workflow */
	workflow.close();

	return output;//.toString();

    }

}


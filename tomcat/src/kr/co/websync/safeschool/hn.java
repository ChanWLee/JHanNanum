package kr.co.websync.safeschool;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.LinkedList;

import kr.ac.kaist.swrc.jhannanum.hannanum.Workflow;
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

    public static String run(String baseDir,String input) {

	Workflow workflow = new Workflow(baseDir);
	StringBuffer output = new StringBuffer();

	try {

	    workflow.appendPlainTextProcessor(new SentenceSegmentor(), null);
	    workflow.appendPlainTextProcessor(new InformalSentenceFilter(), null);
	    workflow.setMorphAnalyzer(new ChartMorphAnalyzer(), "conf/plugin/MajorPlugin/MorphAnalyzer/ChartMorphAnalyzer.json");
	    workflow.appendMorphemeProcessor(new UnknownProcessor(), null);
	    workflow.setPosTagger(new HMMTagger(), "conf/plugin/MajorPlugin/PosTagger/HmmPosTagger.json");

	    workflow.appendPosProcessor(new NounExtractor(), null); // noun only

	    workflow.activateWorkflow(true);

/*
	    String document = "한나눔 형태소 분석기는 KLDP에서 제공하는 공개 소프트웨어 프로젝트 사이트에 등록되어 있다.";

	    workflow.analyze(document);
	    //System.out.println(workflow.getResultOfDocument());
	    output.append(workflow.getResultOfDocument());

	    document = "日時: 2010년 7월 30일 오후 1시\n"
		+ "場所: Coex Conference Room\n";

	    workflow.analyze(document);
	    //System.out.println(workflow.getResultOfDocument());
	    output.append(workflow.getResultOfDocument());
*/

	    workflow.analyze(input);
	    //System.out.println(workflow.getResultOfDocument());
	    output.append(workflow.getResultOfDocument());

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

	return output.toString();

    }

}


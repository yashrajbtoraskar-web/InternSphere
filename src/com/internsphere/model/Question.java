package com.internsphere.model;

import java.util.List;
import java.util.ArrayList;

public class Question {
    private int questionId;
    private int examId;
    private String questionText;
    private String type;
    private String section;
    private int marks;
    private String explanation;
    private List<Option> options = new ArrayList<>();

    public Question() {}

    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }
    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }
    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getSection() { return section; }
    public void setSection(String section) { this.section = section; }
    public int getMarks() { return marks; }
    public void setMarks(int marks) { this.marks = marks; }
    public String getExplanation() { return explanation; }
    public void setExplanation(String explanation) { this.explanation = explanation; }
    public List<Option> getOptions() { return options; }
    public void setOptions(List<Option> options) { this.options = options; }
}

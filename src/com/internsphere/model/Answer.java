package com.internsphere.model;

import java.math.BigDecimal;

public class Answer {
    private int answerId;
    private int attemptId;
    private int questionId;
    private Integer selectedOption;
    private String descriptiveAnswer;
    private BigDecimal marksAwarded;
    private String questionText;       // transient
    private String questionType;       // transient
    private String section;            // transient
    private String explanation;        // transient
    private String selectedOptionText; // transient
    private String correctOptionText;  // transient
    private int questionMarks;         // transient

    public Answer() {}

    public int getAnswerId() { return answerId; }
    public void setAnswerId(int answerId) { this.answerId = answerId; }
    public int getAttemptId() { return attemptId; }
    public void setAttemptId(int attemptId) { this.attemptId = attemptId; }
    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }
    public Integer getSelectedOption() { return selectedOption; }
    public void setSelectedOption(Integer selectedOption) { this.selectedOption = selectedOption; }
    public String getDescriptiveAnswer() { return descriptiveAnswer; }
    public void setDescriptiveAnswer(String descriptiveAnswer) { this.descriptiveAnswer = descriptiveAnswer; }
    public BigDecimal getMarksAwarded() { return marksAwarded; }
    public void setMarksAwarded(BigDecimal marksAwarded) { this.marksAwarded = marksAwarded; }
    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }
    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }
    public String getSection() { return section; }
    public void setSection(String section) { this.section = section; }
    public String getExplanation() { return explanation; }
    public void setExplanation(String explanation) { this.explanation = explanation; }
    public String getSelectedOptionText() { return selectedOptionText; }
    public void setSelectedOptionText(String selectedOptionText) { this.selectedOptionText = selectedOptionText; }
    public String getCorrectOptionText() { return correctOptionText; }
    public void setCorrectOptionText(String correctOptionText) { this.correctOptionText = correctOptionText; }
    public int getQuestionMarks() { return questionMarks; }
    public void setQuestionMarks(int questionMarks) { this.questionMarks = questionMarks; }
}

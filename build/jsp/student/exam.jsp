<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.internsphere.model.*, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exam — InternSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bloodmoon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/exam.css">
    <style>
        body { margin:0; overflow:hidden; background:#0a0a0a; }
        .exam-fullscreen { min-height:100vh; display:flex; flex-direction:column; }
        .exam-topbar { background:rgba(19,19,19,0.95); border-bottom:1px solid rgba(185,28,28,0.3); padding:12px 24px; display:flex; justify-content:space-between; align-items:center; backdrop-filter:blur(12px); position:sticky; top:0; z-index:100; }
        .exam-topbar .brand { font-weight:700; font-size:14px; color:var(--primary); letter-spacing:2px; }
        .exam-topbar .timer { font-family:'Space Grotesk',monospace; font-size:28px; font-weight:700; color:#fff; padding:6px 20px; border-radius:8px; background:rgba(185,28,28,0.15); border:1px solid rgba(185,28,28,0.3); }
        .exam-topbar .timer.warning { color:#fbbf24; background:rgba(251,191,36,0.1); border-color:rgba(251,191,36,0.3); animation:pulse 1s infinite; }
        .exam-topbar .timer.danger { color:#ef4444; background:rgba(239,68,68,0.15); border-color:#ef4444; animation:pulse 0.5s infinite; }
        .exam-body { flex:1; display:grid; grid-template-columns:1fr 280px; gap:0; overflow:hidden; }
        .exam-questions { padding:32px 40px; overflow-y:auto; max-height:calc(100vh - 60px); }
        .exam-nav-panel { background:rgba(19,19,19,0.95); border-left:1px solid rgba(255,255,255,0.06); padding:24px; overflow-y:auto; }
        .warning-overlay { position:fixed; inset:0; background:rgba(185,28,28,0.95); z-index:9999; display:none; flex-direction:column; justify-content:center; align-items:center; color:#fff; text-align:center; backdrop-filter:blur(8px); }
        .warning-overlay.visible { display:flex; }
        .warning-overlay .warn-icon { font-size:80px; margin-bottom:24px; }
        .warning-overlay .warn-title { font-size:28px; font-weight:700; margin-bottom:12px; }
        .warning-overlay .warn-desc { font-size:16px; opacity:0.8; max-width:500px; margin-bottom:24px; }
        .warning-overlay .warn-count { font-size:48px; font-weight:700; background:rgba(0,0,0,0.3); padding:8px 32px; border-radius:12px; }
        .disqualify-overlay { position:fixed; inset:0; background:rgba(10,10,10,0.98); z-index:99999; display:none; flex-direction:column; justify-content:center; align-items:center; color:#fff; text-align:center; }
        .disqualify-overlay.visible { display:flex; }
        .disqualify-overlay .dq-icon { font-size:100px; margin-bottom:24px; color:#ef4444; }
        .disqualify-overlay .dq-title { font-size:32px; font-weight:700; color:#ef4444; margin-bottom:12px; }
        .q-card { background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.06); border-radius:16px; padding:32px; margin-bottom:24px; }
        .q-number { font-size:12px; letter-spacing:2px; text-transform:uppercase; color:var(--primary); margin-bottom:12px; }
        .q-text { font-size:18px; line-height:1.7; color:#e0e0e0; margin-bottom:24px; }
        .q-marks { font-size:12px; color:var(--on-surface-muted); background:rgba(185,28,28,0.1); padding:4px 12px; border-radius:20px; display:inline-block; margin-bottom:16px; }
        .opt-grid { display:flex; flex-direction:column; gap:10px; }
        .opt-item { display:flex; align-items:center; gap:14px; padding:14px 18px; background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.08); border-radius:12px; cursor:pointer; transition:all 0.2s; }
        .opt-item:hover { background:rgba(185,28,28,0.08); border-color:rgba(185,28,28,0.3); }
        .opt-item.selected { background:rgba(185,28,28,0.15); border-color:var(--primary); }
        .opt-item input[type=radio] { accent-color:var(--primary); width:18px; height:18px; }
        .opt-item label { cursor:pointer; flex:1; color:#ccc; font-size:15px; }
        .sub-textarea { width:100%; min-height:120px; background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.1); border-radius:12px; color:#e0e0e0; padding:16px; font-size:15px; resize:vertical; }
        .sub-textarea:focus { border-color:var(--primary); outline:none; }
        .nav-grid { display:grid; grid-template-columns:repeat(5,1fr); gap:6px; margin-top:16px; }
        .nav-dot { width:40px; height:40px; border-radius:8px; background:rgba(255,255,255,0.05); border:1px solid rgba(255,255,255,0.1); display:flex; align-items:center; justify-content:center; font-size:13px; font-weight:600; color:#888; cursor:pointer; transition:all 0.2s; }
        .nav-dot:hover { background:rgba(185,28,28,0.15); }
        .nav-dot.current { background:var(--primary); color:#fff; border-color:var(--primary); }
        .nav-dot.answered { background:rgba(34,197,94,0.15); border-color:rgba(34,197,94,0.4); color:#22c55e; }
        .nav-legend { margin-top:16px; display:flex; flex-direction:column; gap:6px; font-size:11px; color:var(--on-surface-muted); }
        .nav-legend span { display:flex; align-items:center; gap:8px; }
        .nav-legend .dot { width:12px; height:12px; border-radius:4px; }
        .save-badge { font-size:12px; padding:4px 10px; border-radius:20px; }
        .save-badge.saving { color:#fbbf24; }
        .save-badge.saved { color:#22c55e; }
        .fullscreen-prompt { position:fixed; inset:0; background:rgba(10,10,10,0.98); z-index:99998; display:flex; flex-direction:column; justify-content:center; align-items:center; color:#fff; text-align:center; }
        .fullscreen-prompt .fs-icon { font-size:80px; margin-bottom:20px; }
        .fullscreen-prompt h2 { font-size:28px; margin-bottom:12px; }
        .fullscreen-prompt p { color:#999; max-width:500px; margin-bottom:32px; font-size:15px; line-height:1.6; }
        .tab-indicator { display:flex; align-items:center; gap:8px; font-size:12px; }
        .tab-indicator .dot { width:8px; height:8px; border-radius:50%; }
        .tab-indicator .dot.green { background:#22c55e; }
        .tab-indicator .dot.yellow { background:#fbbf24; }
        .tab-indicator .dot.red { background:#ef4444; }
        /* Submit Confirmation Modal */
        .submit-modal { position:fixed; inset:0; background:rgba(10,10,10,0.92); z-index:99997; display:none; flex-direction:column; justify-content:center; align-items:center; color:#fff; text-align:center; backdrop-filter:blur(8px); }
        .submit-modal.visible { display:flex; }
        .submit-modal .modal-box { background:rgba(32,31,31,0.98); border:1px solid rgba(185,28,28,0.3); border-radius:20px; padding:40px 48px; max-width:440px; box-shadow:0 24px 80px rgba(0,0,0,0.6); }
        .submit-modal .modal-icon { font-size:56px; margin-bottom:16px; }
        .submit-modal .modal-title { font-size:22px; font-weight:700; margin-bottom:10px; color:#e0e0e0; }
        .submit-modal .modal-desc { font-size:14px; color:#999; line-height:1.6; margin-bottom:28px; }
        .submit-modal .modal-actions { display:flex; gap:12px; justify-content:center; }
        .submit-modal .btn-confirm-submit { background:linear-gradient(135deg,#b91c1c,#dc2626); color:#fff; border:none; padding:12px 32px; border-radius:10px; font-size:14px; font-weight:600; cursor:pointer; letter-spacing:0.5px; transition:all 0.2s; }
        .submit-modal .btn-confirm-submit:hover { transform:translateY(-1px); box-shadow:0 6px 20px rgba(185,28,28,0.4); }
        .submit-modal .btn-cancel-submit { background:rgba(255,255,255,0.06); color:#ccc; border:1px solid rgba(255,255,255,0.1); padding:12px 32px; border-radius:10px; font-size:14px; font-weight:600; cursor:pointer; transition:all 0.2s; }
        .submit-modal .btn-cancel-submit:hover { background:rgba(255,255,255,0.1); }
        @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.5} }
    </style>
</head>
<body>
<% Exam exam = (Exam) request.getAttribute("exam");
   ExamAttempt attempt = (ExamAttempt) request.getAttribute("attempt");
   List<Question> questions = (List<Question>) request.getAttribute("questions");
   int totalQ = questions != null ? questions.size() : 0; %>

<!-- Fullscreen Prompt -->
<div class="fullscreen-prompt" id="fsPrompt">
    <div class="fs-icon">&#128274;</div>
    <h2>Exam Security Protocol</h2>
    <p>This exam requires <strong>fullscreen mode</strong>. You will be monitored for tab switches. 
    <br><br><strong>Warning:</strong> After <strong>2 tab switches</strong>, your exam will be automatically terminated and you will receive a score of <strong>0</strong>.</p>
    <button class="btn btn-primary btn-lg" onclick="enterFullscreen()" style="padding:14px 48px;font-size:16px">ENTER FULLSCREEN & START &#8594;</button>
</div>

<!-- Warning Overlay -->
<div class="warning-overlay" id="warnOverlay">
    <div class="warn-icon">&#9888;</div>
    <div class="warn-title">TAB SWITCH DETECTED!</div>
    <div class="warn-desc">You switched away from the exam. This has been logged and reported to the administrator.</div>
    <div class="warn-count">Warning <span id="warnNum">1</span> of 2</div>
    <button class="btn btn-primary" onclick="dismissWarning()" style="margin-top:24px;padding:12px 32px">I UNDERSTAND — CONTINUE EXAM</button>
</div>

<!-- Disqualify Overlay -->
<div class="disqualify-overlay" id="dqOverlay">
    <div class="dq-icon">&#9940;</div>
    <div class="dq-title">EXAM TERMINATED</div>
    <p style="color:#999;max-width:400px;margin-bottom:24px">You have been disqualified for exceeding the maximum number of tab switches. Your score has been recorded as <strong style="color:#ef4444">0</strong>.</p>
    <a href="${pageContext.request.contextPath}/student/exams" class="btn btn-primary" style="padding:12px 32px">RETURN TO EXAMS</a>
</div>

<!-- Submit Confirmation Modal -->
<div class="submit-modal" id="submitModal">
    <div class="modal-box">
        <div class="modal-icon">&#128220;</div>
        <div class="modal-title">Submit Exam?</div>
        <div class="modal-desc">Are you sure you want to submit your exam? This action cannot be undone. All answered questions will be evaluated and unanswered questions will receive 0 marks.</div>
        <div class="modal-actions">
            <button class="btn-cancel-submit" onclick="cancelSubmit()">&#8592; CONTINUE EXAM</button>
            <button class="btn-confirm-submit" onclick="confirmSubmit()">YES, SUBMIT &#10003;</button>
        </div>
    </div>
</div>

<!-- Main Exam Interface -->
<div class="exam-fullscreen" id="examMain" style="display:none">
    <div class="exam-topbar">
        <div class="brand">INTERNSPHERE EXAM</div>
        <div style="display:flex;align-items:center;gap:16px">
            <div class="tab-indicator" id="tabIndicator">
                <span class="dot green" id="statusDot"></span>
                <span id="tabStatus">Secure</span>
            </div>
            <span class="save-badge" id="saveStatus">&#9679; Ready</span>
        </div>
        <div class="timer" id="timer">--:--</div>
    </div>
    <div class="exam-body">
        <div class="exam-questions" id="questionsArea">
            <div style="margin-bottom:20px"><h2 style="font-size:20px;color:#fff"><%= exam.getExamName() %></h2><p style="color:var(--on-surface-muted);font-size:13px"><%= totalQ %> Questions &bull; <%= exam.getTotalMarks() %> Total Marks &bull; <%= exam.getDuration() %> Minutes</p></div>

            <% String currentSection = "";
               if (questions != null) for (int idx = 0; idx < questions.size(); idx++) {
                Question q = questions.get(idx);
                String sec = q.getSection() != null ? q.getSection() : "";
                boolean newSection = !sec.equals(currentSection);
                if (newSection) currentSection = sec; %>
                <div class="q-card" id="q_<%= idx %>" style="<%= idx > 0 ? "display:none" : "" %>">
                    <% if (newSection && !sec.isEmpty()) { %>
                    <div style="background:rgba(185,28,28,0.08);border:1px solid rgba(185,28,28,0.15);border-radius:8px;padding:8px 14px;margin-bottom:14px;font-size:11px;font-weight:600;color:var(--primary);letter-spacing:1px">&#128196; <%= sec.toUpperCase() %></div>
                    <% } %>
                    <div class="q-number">Question <%= (idx + 1) %> of <%= totalQ %></div>
                    <div class="q-marks"><%= q.getMarks() %> marks &bull; <%= q.getType() %></div>
                    <div class="q-text"><%= q.getQuestionText() %></div>

                    <% if ("MCQ".equals(q.getType())) { %>
                        <div class="opt-grid">
                        <% for (Option opt : q.getOptions()) { %>
                            <div class="opt-item" onclick="selectOption(this, <%= attempt.getAttemptId() %>, <%= q.getQuestionId() %>, <%= opt.getOptionId() %>)">
                                <input type="radio" name="q_<%= q.getQuestionId() %>" value="<%= opt.getOptionId() %>" id="opt_<%= opt.getOptionId() %>">
                                <label for="opt_<%= opt.getOptionId() %>"><%= opt.getOptionText() %></label>
                            </div>
                        <% } %>
                        </div>
                    <% } else { %>
                        <textarea class="sub-textarea" id="sub_<%= q.getQuestionId() %>" placeholder="Write your answer here..."
                            onblur="saveSubjective(<%= attempt.getAttemptId() %>, <%= q.getQuestionId() %>)"></textarea>
                    <% } %>

                    <div style="display:flex;justify-content:space-between;margin-top:24px">
                        <button class="btn btn-ghost" onclick="navigate(<%= idx - 1 %>)" <%= idx == 0 ? "disabled style='opacity:0.3'" : "" %>>&#8592; Previous</button>
                        <% if (idx == totalQ - 1) { %>
                            <button class="btn btn-primary" onclick="submitExam()">Submit Exam &#10003;</button>
                        <% } else { %>
                            <button class="btn btn-primary" onclick="navigate(<%= idx + 1 %>)">Next &#8594;</button>
                        <% } %>
                    </div>
                </div>
            <% } %>
        </div>
        <div class="exam-nav-panel">
            <h4 style="font-size:13px;letter-spacing:1px;color:var(--on-surface-muted);margin-bottom:12px">QUESTION MAP</h4>
            <div class="nav-grid">
                <% for (int i = 0; i < totalQ; i++) { %>
                    <div class="nav-dot <%= i == 0 ? "current" : "" %>" onclick="navigate(<%= i %>)" id="dot_<%= i %>"><%= (i + 1) %></div>
                <% } %>
            </div>
            <div class="nav-legend">
                <span><span class="dot" style="background:var(--primary)"></span> Current</span>
                <span><span class="dot" style="background:rgba(34,197,94,0.4)"></span> Answered</span>
                <span><span class="dot" style="background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1)"></span> Not visited</span>
            </div>
            <div style="margin-top:32px;padding-top:20px;border-top:1px solid rgba(255,255,255,0.06)">
                <h4 style="font-size:13px;letter-spacing:1px;color:var(--on-surface-muted);margin-bottom:12px">VIOLATIONS</h4>
                <div style="font-size:24px;font-weight:700;color:#ef4444" id="violationCount">0 / 2</div>
                <div style="font-size:11px;color:var(--on-surface-muted);margin-top:4px">Tab switches detected</div>
            </div>
            <form id="submitForm" action="${pageContext.request.contextPath}/student/exam/submit" method="POST" style="margin-top:24px">
                <input type="hidden" name="attemptId" value="<%= attempt.getAttemptId() %>">
                <input type="hidden" name="examId" value="<%= exam.getExamId() %>">
                <input type="hidden" name="submitType" value="manual" id="submitType">
                <button type="button" class="btn btn-primary" style="width:100%;padding:14px" onclick="submitExam()">SUBMIT EXAM</button>
            </form>
        </div>
    </div>
</div>

<script>
const CTX = '${pageContext.request.contextPath}';
const DURATION = <%= exam.getDuration() %>;
const ATTEMPT_ID = <%= attempt.getAttemptId() %>;
const EXAM_ID = <%= exam.getExamId() %>;
let currentQ = 0;
let tabSwitchCount = 0;
let remaining = DURATION * 60;
let timerInterval;
let isFullscreen = false;
let examStarted = false;

// Enter fullscreen
function enterFullscreen() {
    const el = document.documentElement;
    if (el.requestFullscreen) el.requestFullscreen();
    else if (el.webkitRequestFullscreen) el.webkitRequestFullscreen();
    else if (el.msRequestFullscreen) el.msRequestFullscreen();
    document.getElementById('fsPrompt').style.display = 'none';
    document.getElementById('examMain').style.display = 'flex';
    isFullscreen = true;
    examStarted = true;
    startTimer();
}

// Timer
function startTimer() {
    const timerEl = document.getElementById('timer');
    timerInterval = setInterval(() => {
        remaining--;
        const m = Math.floor(remaining / 60);
        const s = remaining % 60;
        timerEl.textContent = String(m).padStart(2, '0') + ':' + String(s).padStart(2, '0');
        if (remaining <= 300) timerEl.className = 'timer warning';
        if (remaining <= 60) timerEl.className = 'timer danger';
        if (remaining <= 0) { clearInterval(timerInterval); autoSubmit(); }
    }, 1000);
}

// Navigation
function navigate(idx) {
    if (idx < 0 || idx >= <%= totalQ %>) return;
    document.getElementById('q_' + currentQ).style.display = 'none';
    document.getElementById('q_' + idx).style.display = 'block';
    document.querySelectorAll('.nav-dot').forEach(d => d.classList.remove('current'));
    document.getElementById('dot_' + idx).classList.add('current');
    currentQ = idx;
}

// MCQ selection
function selectOption(el, attemptId, questionId, optionId) {
    el.querySelector('input[type=radio]').checked = true;
    el.parentElement.querySelectorAll('.opt-item').forEach(o => o.classList.remove('selected'));
    el.classList.add('selected');
    document.getElementById('dot_' + currentQ).classList.add('answered');
    saveAnswer(attemptId, questionId, optionId, null);
}

// Subjective save
function saveSubjective(attemptId, questionId) {
    const text = document.getElementById('sub_' + questionId).value;
    if (text.trim()) document.getElementById('dot_' + currentQ).classList.add('answered');
    saveAnswer(attemptId, questionId, null, text);
}

// AJAX save
function saveAnswer(attemptId, questionId, selectedOption, descriptiveAnswer) {
    const status = document.getElementById('saveStatus');
    status.innerHTML = '&#9679; Saving...'; status.className = 'save-badge saving';
    const params = new URLSearchParams();
    params.append('attemptId', attemptId);
    params.append('questionId', questionId);
    if (selectedOption) params.append('selectedOption', selectedOption);
    if (descriptiveAnswer) params.append('descriptiveAnswer', descriptiveAnswer);
    fetch(CTX + '/student/exam/save', { method: 'POST', body: params })
        .then(r => r.json())
        .then(() => { status.innerHTML = '&#10003; Saved'; status.className = 'save-badge saved'; })
        .catch(() => { status.innerHTML = '&#9888; Error'; status.className = 'save-badge'; });
}

// Submit — show custom in-page modal (not browser confirm, which breaks fullscreen)
function submitExam() {
    document.getElementById('submitModal').classList.add('visible');
}

function confirmSubmit() {
    document.getElementById('submitModal').classList.remove('visible');
    clearInterval(timerInterval);
    document.getElementById('submitType').value = 'manual';
    document.getElementById('submitForm').submit();
}

function cancelSubmit() {
    document.getElementById('submitModal').classList.remove('visible');
}

function autoSubmit() {
    clearInterval(timerInterval);
    document.getElementById('submitType').value = 'auto';
    document.getElementById('submitForm').submit();
}

// === ANTI-CHEAT: Tab Switch / Fullscreen Exit Detection ===
function handleViolation() {
    if (!examStarted) return;
    tabSwitchCount++;
    document.getElementById('violationCount').textContent = tabSwitchCount + ' / 2';

    // Update status indicator
    const dot = document.getElementById('statusDot');
    const tabStatus = document.getElementById('tabStatus');
    if (tabSwitchCount === 1) { dot.className = 'dot yellow'; tabStatus.textContent = 'Warning 1/2'; }

    // Log to server
    fetch(CTX + '/student/exam/tabswitch', {
        method: 'POST',
        body: new URLSearchParams({ attemptId: ATTEMPT_ID, examId: EXAM_ID })
    });

    if (tabSwitchCount >= 2) {
        // DISQUALIFIED — submit with 0
        dot.className = 'dot red';
        tabStatus.textContent = 'DISQUALIFIED';
        clearInterval(timerInterval);
        document.getElementById('dqOverlay').classList.add('visible');
        // Submit as cheat
        fetch(CTX + '/student/exam/submit', {
            method: 'POST',
            body: new URLSearchParams({ attemptId: ATTEMPT_ID, examId: EXAM_ID, submitType: 'cheat' })
        });
    } else {
        // Show warning
        document.getElementById('warnNum').textContent = tabSwitchCount;
        document.getElementById('warnOverlay').classList.add('visible');
    }
}

function dismissWarning() {
    document.getElementById('warnOverlay').classList.remove('visible');
    // Re-enter fullscreen
    const el = document.documentElement;
    if (el.requestFullscreen) el.requestFullscreen();
    else if (el.webkitRequestFullscreen) el.webkitRequestFullscreen();
}

// Detect tab switch via visibility API
document.addEventListener('visibilitychange', () => {
    if (document.hidden && examStarted) handleViolation();
});

// Detect fullscreen exit
document.addEventListener('fullscreenchange', () => {
    if (!document.fullscreenElement && examStarted) handleViolation();
});
document.addEventListener('webkitfullscreenchange', () => {
    if (!document.webkitFullscreenElement && examStarted) handleViolation();
});

// Prevent keyboard shortcuts
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') { e.preventDefault(); e.stopPropagation(); }
    if ((e.ctrlKey || e.metaKey) && (e.key === 't' || e.key === 'n' || e.key === 'w' || e.key === 'Tab')) {
        e.preventDefault();
    }
});

// Prevent right-click
document.addEventListener('contextmenu', (e) => e.preventDefault());
</script>
</body>
</html>

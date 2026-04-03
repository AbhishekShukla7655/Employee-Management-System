<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>EMS</title>
<link rel="stylesheet" href="css/style.css">
</head>

<body>

<div class="dark-overlay"></div>
<div class="light-overlay"></div>

<div class="container">

    <!-- ===== LEFT ===== -->
    <div class="left">
        <h1>
            <span class="blue">Employee</span><br>
            <strong>Management</strong> System
        </h1>

        <p class="subtitle">Streamline Your Workforce Efficiently.</p>

        <ul class="features">
            <li><span class="check-icon">&#10003;</span> Track Employee Attendance &amp; Performance</li>
            <li><span class="check-icon">&#10003;</span> Manage Payroll &amp; Leave Requests</li>
            <li><span class="check-icon">&#10003;</span> Streamline Team Communication</li>
        </ul>
    </div>

    <!-- ===== RIGHT ===== -->
    <div class="right">

        <!-- TOGGLE — Register (left) | Login (right) -->
        <div class="toggle-wrap">
            <div class="toggle">
                <div class="toggle-btn" id="toggleBtn"></div>
                <span id="registerTab" onclick="showRegister()">Register</span>
                <span id="loginTab" onclick="showLogin()">Login</span>
            </div>
        </div>

        <!-- Title above card -->
        <p class="member-title" id="formTitle">Member Login</p>

        <!-- CARD -->
        <div class="card">

            <!-- LOGIN FORM -->
            <form id="loginForm" action="login" method="post">

                <label class="field-label">Email</label>
                <div class="input-group">
                    <span class="icon">&#9993;</span>
                    <input type="email" name="email" placeholder="Enter your email" required>
                </div>

                <label class="field-label">Password</label>
                <div class="input-group">
                    <span class="icon">&#128274;</span>
                    <input type="password" name="password" placeholder="Enter your password" required>
                </div>

                <div class="form-footer">
                    <a href="#" class="forgot">Forgot Password?</a>
                </div>

                <button type="submit">Login</button>

                <p class="signup-text">Need an account? <a href="#" onclick="showRegister(); return false;">Sign Up</a></p>

            </form>

            <!-- REGISTER FORM -->
            <form id="registerForm" action="register" method="post">

                <label class="field-label">Name</label>
                <div class="input-group">
                    <span class="icon">&#128100;</span>
                    <input type="text" name="name" placeholder="Enter your name" required>
                </div>

                <label class="field-label">Email</label>
                <div class="input-group">
                    <span class="icon">&#9993;</span>
                    <input type="email" name="email" placeholder="Enter your email" required>
                </div>

                <label class="field-label">Password</label>
                <div class="input-group">
                    <span class="icon">&#128274;</span>
                    <input type="password" name="password" placeholder="Enter password" required>
                </div>

                <div class="form-footer" style="justify-content: flex-end; margin-top: 16px;">
                    <a href="#" class="forgot" onclick="showLogin(); return false;">Already have an account? Login</a>
                </div>

                <button type="submit">Register</button>

            </form>

        </div><!-- end .card -->

    </div><!-- end .right -->

</div><!-- end .container -->

<script>
    var loginForm    = document.getElementById("loginForm");
    var registerForm = document.getElementById("registerForm");
    var toggleBtn    = document.getElementById("toggleBtn");
    var loginTab     = document.getElementById("loginTab");
    var registerTab  = document.getElementById("registerTab");
    var formTitle    = document.getElementById("formTitle");

    function showLogin() {
        // Show login, hide register
        loginForm.style.display    = "block";
        registerForm.style.display = "none";

        // Pill slides to RIGHT (Login is the 2nd/right span)
        toggleBtn.style.left = "50%";

        // Active classes
        loginTab.classList.add("active");
        registerTab.classList.remove("active");

        // Update title
        formTitle.textContent = "Member Login";
    }

    function showRegister() {
        // Show register, hide login
        loginForm.style.display    = "none";
        registerForm.style.display = "block";

        // Pill slides to LEFT (Register is the 1st/left span)
        toggleBtn.style.left = "0%";

        // Active classes
        registerTab.classList.add("active");
        loginTab.classList.remove("active");

        // Update title
        formTitle.textContent = "Create Account";
    }

    // Default: show Login on page load
    showLogin();
</script>

</body>
</html>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register</title>

<style>
body{
    font-family: Arial;
    background-color: #f2f2f2;
}

.container{
    width: 300px;
    margin: 100px auto;
    padding: 20px;
    background: white;
    border-radius: 10px;
    box-shadow: 0 0 10px gray;
}

input{
    width: 100%;
    padding: 10px;
    margin: 10px 0;
}

button{
    width: 100%;
    padding: 10px;
    background: green;
    color: white;
    border: none;
}
</style>

</head>
<body>

<div class="container">
    <h2>Register</h2>

    <form action="register" method="post">
        <input type="text" name="name" placeholder="Enter Name" required>
        <input type="email" name="email" placeholder="Enter Email" required>
        <input type="password" name="password" placeholder="Enter Password" required>

        <button type="submit">Register</button>
    </form>

    <br>
    <a href="login.jsp">Already have account? Login</a>
</div>

</body>
</html>
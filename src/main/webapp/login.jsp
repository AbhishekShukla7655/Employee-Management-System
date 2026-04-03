<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>

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
    background: blue;
    color: white;
    border: none;
}
</style>

</head>
<body>

<div class="container">
    <h2>Login</h2>

    <form action="login" method="post" autocomplete="off">
        <input type="email" name="email" placeholder="Enter Email" required autocomplete="username">
        <input type="password" name="password" placeholder="Enter Password" required autocomplete="new-password">

        <button type="submit">Login</button>
    </form>
</div>

</body>
</html>
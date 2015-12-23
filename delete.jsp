<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.text.*" %>

<!DOCTYPE html>

<%
	int param_idx = Integer.parseInt(request.getParameter("idx"));
%>

<html>
	<head>	
		<title>TeamProject</title>	
	
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
    	<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->

		<link rel="stylesheet" type="text/css" href="style.css">

    	<link rel="stylesheet" href="bootstrap-3.3.6-dist/css/bootstrap.min.css">

	</head>

	<body id="target">

		<div class="container">

			<div class="row">
			<!-- 화면을 12개로 나눠 전체적인 크기를 맞추기 위한 div. 2-8-2로 나누었다. -->
				<nav class="col-md-2"></nav>
				<!-- 여기에 광고 -->
				
				<div class="col-md-8">
				<!-- 본문 -->
					<div class="jumbotron text-center">
					<!-- 회색 박스-->
						<img src="image.png" alt="로고" class="img-circle" id="logo">
						<!-- 로고. 어째선지 잘 출력이 안된다. -->
						<h2><a href="index.jsp">TEAM PROJECT</a></h2>
					</div>

					<article>
						<form action=delete_process.jsp?idx=<%=param_idx%> method="post">
							<fieldset>
								<legend>ID & Password 확인</legend>
								<div class="form-group">
									<label for="form-writer">아이디</label>
									<input type="text" name="writer" class="form-control" id="form-writer" required autofocus>
								</div>
								<div class="form-group">
									<label for="form-passowrd">패스워드</label>
									<input type="password" name="password" class="form-control" id="form-password" required>
								</div>
								<br><br>
								<div id="control">
									<div class="btn-group" role="group" aria-label="...">
										<input type="submit" name="submit" class="btn btn-default bnt-lg" value="제출">
										<input type="reset" name="reset" class="btn btn-default bnt-lg" value="리셋">
										<a href="index.jsp" class="btn btn-default bnt-lg">취소</a>
				                    </div>
			                    </div>
							</fieldset>
	                	</form>
					</article>

					<hr>

				</div>

				<div class="col-md-2"></div>
			</div>
		</div>
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	   	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

<!-- Include all compiled plugins (below), or include individual files as needed -->
    	<script src="bootstrap-3.3.6-dist/js/bootstrap.min.js"></script>
	</body>

</html>
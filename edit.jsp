<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.text.*" %>

<%
	Connection conn = null;
	Statement stmt = null;
	String sql = null;
	ResultSet rs = null;

	String dburl = "jdbc:mysql://localhost:3306/teamp";
	// 사용하려는 데이터베이스명을 포함한 URL 기술
	String dbuser = "root";
	// 사용자 계정
	String dbpw = "dlawpgml90";
	// 사용자 계정의 패스워드

	int param_idx = Integer.parseInt(request.getParameter("idx"));
	// 수정하려는 글의 aritcles 테이블에서의 id값.

	String title = null;
	String category = null;
	String writer = null;
	String email = null;
	String content = null;
%>

<!DOCTYPE html>

<html>
	<head>	
		<title>TeamProject</title>	
	
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
    	<meta name="viewport" content="width=device-width, initial-scale=1">
		<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
		<!-- 위의 태그들은 twitter bootstrap를 사용하기위한 필수적인 태그 -->

		<link rel="stylesheet" type="text/css" href="style.css">
		<!-- 내가 만든 css -->
    	<link rel="stylesheet" href="bootstrap-3.3.6-dist/css/bootstrap.min.css">
    	<!-- 부트 스트랩 적용 -->
	</head>

	<body id="target">

		<div class="container">

			<div class="row">
			<!-- 화면을 12개로 나눠 전체적인 크기를 맞추기 위한 div. 2-8-2로 나누었다. -->
				<nav class="col-md-2">	<!-- 여기에 광고 -->

				</nav>

				<div class="col-md-8">		<!-- 본문 -->
					<div class="jumbotron text-center">		<!-- 회색 박스-->
						<img src="image.png" alt="로고" class="img-circle" id="logo">
						<!-- 로고. 어째선지 잘 출력이 안된다. -->
						<h2><a href="index.jsp">TEAM PROJECT</a></h2>
					</div>

					<article>
						<%
							try
							{
								Class.forName("com.mysql.jdbc.Driver");
								// 데이터베이스와 연동하기 위해 DriverManager에 등록한다.

								conn = DriverManager.getConnection(dburl,dbuser,dbpw);
								// DriverManager 객체로부터 Connection 객체를 얻어온다.

								sql = "SELECT articles.id, category, title, user_id, email, content FROM articles LEFT JOIN user ON writer_id = user.id WHERE articles.id = " + param_idx;
								// SELECT articles.id, category, title, user_id, email, content FROM articles LEFT JOIN user ON writer_id = user.id WHERE articles.id = (idx값)
								// articles 테이블의 writer_id값과 user테이블의 id값을 같은 값으로 놓았을 때 articles.id가 param_idx값을 갖는 항목의 id, 카테고리, 제목, 사용자아이디, 이메일, 내용을 컬럼으로 갖는 표를 만든다.
								stmt = conn.createStatement();
								rs = stmt.executeQuery(sql);
								// sql에 저장된 sql문을 실행한다. 그 결과물을 rs에 저장한다.
								
								while(rs.next())
								{
									title = rs.getString("title");
									category = rs.getString("category");
									writer = rs.getString("user_id");
									email = rs.getString("email");
									content = rs.getString("content");
								}
								// rs객체에 저장된 제목의 값을 변수 title에, 카테고리를 category에, user_id를 writer에, 이메일을 email에, 본문을 content에 각각 저장한다.

							}
							catch(Exception e)
							{
								e.printStackTrace();
								out.println("테이블 호출에 실패했습니다." + e.getMessage());
							}
						%>

						<form action=edit_process.jsp?idx=<%=param_idx%> method="post">
						<!-- 비밀번호는 그 사람이 맞는지 확인용으로 따로 보여주지 않는다. 다른 값들은 기본적으로 보여준다. -->
							<div class="form-group">
								<label for="form-title">제목</label>
								<input type="text" name="title" class="form-control" id="form-title" value=<%=title%> required>
							</div>

							<div class="form-group">
								<label for="form-category">카테고리</label>
								<input type="text" name="category" class="form-control" id="form-category" value=<%=category%> required>
		                    </div>

		                    <div class="form-group">
			                    <label for="form-writer">작성자</label>
								<input type="text" name="writer" class="form-control" id="form-writer" value=<%=writer%> required>
		                    </div>

		                    <div class="form-group">
			                    <label for="form-password">비밀번호</label>
								<input type="password" name="password" class="form-control" id="form-password" required>
		                    </div>

		                    <div class="form-group">
			                    <label for="form-email">이메일</label>
								<input type="text" name="category" class="form-control" id="form-writer" value=<%=email%> required>
		                    </div>

		                    <div class="form-group">
			                    <label for="form-description">본문</label>
			                    <textarea rows="10" name="content" class="form-control" id="form-discription" required><%=content%></textarea>
		                    </div>

		                    <div id="control">
			                    <div class="btn-group" role="group" aria-label="...">
				                    <input type="submit" name="submit" class="btn btn-default bnt-lg" value="제출">
				                    <input type="reset" name="reset" class="btn btn-default bnt-lg" value="리셋">
				                    <a href="index.jsp" class="btn btn-default bnt-lg">취소</a>
			                    </div>
		                    </div>
	                	</form>

	                	<%
	                		if(param_idx != 0)
	                		{
								stmt.close();
								conn.close();
							}
						%>

					</article>

					<hr>

				</div>

				<div class="col-md-2"></div>
				<!-- 좌우 전체를 12칸으로 봤을때 끝의 2칸을 비워둔다. -->
			</div>
		</div>
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	   	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

<!-- Include all compiled plugins (below), or include individual files as needed -->
    	<script src="bootstrap-3.3.6-dist/js/bootstrap.min.js"></script>
	</body>

</html>
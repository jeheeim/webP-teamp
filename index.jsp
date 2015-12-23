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

	int param_idx = 0;

	if(request.getParameter("idx") != null)
		param_idx = Integer.parseInt(request.getParameter("idx"));

	String param_category = request.getParameter("category");
	// 카테고리를 클릭했을때 주소창에 뜨는 카테고리값.
	String param_userid = request.getParameter("writerid");
	// 사용자를 클릭했을때 주소창에 뜨는 writerid값.

	int idx = 0;
	String category = null;
	String title = null;
	String user_id = null;
	String email = null;
	Timestamp created = null;
	int view = 0;
	String content = null;
	int skip = 0;
	// 조회된 데이터의 각각의 항목이 저장될 변수.
	// skip은 삭제된 항목이 갖는 값. 기본은 0이며 삭제된 글만 1의 값을 갖는다.

	//idx값이 있는 경우
	if(param_idx != 0)
	{
		try
		{
			Class.forName("com.mysql.jdbc.Driver");
			// 데이터베이스와 연동하기 위해 DriverManager에 등록한다.

			conn = DriverManager.getConnection(dburl,dbuser,dbpw);
			// DriverManager 객체로부터 Connection 객체를 얻어온다.

			sql = "SELECT articles.id, category, title, email, user_id, created, view, content FROM articles LEFT JOIN user ON writer_id = user.id WHERE articles.id = " + param_idx;

			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			// conn에 입력된 db에 sql에 입력된 대로 데이터를 요구한다.
		}
		catch(Exception e)
		{
			e.printStackTrace();
			out.println("테이블 호출에 실패했습니다." + e.getMessage());
		}
	}

	//idx값이 없는 경우
	else
	{
		try
		{
			Class.forName("com.mysql.jdbc.Driver");
			// 데이터베이스와 연동하기 위해 DriverManager에 등록한다.

			conn = DriverManager.getConnection(dburl,dbuser,dbpw);
			// DriverManager 객체로부터 Connection 객체를 얻어온다.

			if(param_category != null)
			{
				sql = "SELECT articles.id, category, title, user_id, created, view, skip FROM articles LEFT JOIN user ON writer_id = user.id WHERE category = '" + param_category + "' ORDER BY id DESC";
			}
			// SELECT articles.id, category, title, user_id, created, view, skip
			// FROM articles LEFT JOIN user ON writer_id = user.id
			// WHERE category = "param_category" ORDER BY id DESC
			// 카테고리 값이 param_category인 항목들만 선발한다.
			// writer_id를 매개로 articles 테이블과 user테이블을 합친다.
			// articles.id, 카테고리, 제목, 사용자아이디, 작성일, 조회수, 삭제여부 이렇게 7개 항목으로 테이블을 만들고 id값을 기준으로 역순으로 배열한다.
			else if(param_userid != null)
			{
				sql = "SELECT articles.id, category, title, user_id, created, view, skip FROM articles LEFT JOIN user ON writer_id = user.id WHERE user_id = '" + param_userid + "' ORDER BY id DESC";
			}
			// SELECT articles.id, category, title, user_id, created, view, skip
			// FROM articles LEFT JOIN user ON writer_id = user.id
			// WHERE user_id = "param_userid" ORDER BY id DESC
			// 사용자아이디 값이 param_userid인 항목들만 선발한다.
			// writer_id를 매개로 articles 테이블과 user테이블을 합친다.
			// articles.id, 카테고리, 제목, 사용자아이디, 작성일, 조회수, 삭제여부 이렇게 7개 항목으로 테이블을 만들고 id값을 기준으로 역순으로 배열한다.
			else
			{
				sql = "SELECT articles.id, category, title, user_id, created, view, skip FROM articles LEFT JOIN user ON writer_id = user.id ORDER BY id DESC";
			}
			// SELECT articles.id, category, title, user_id, created, view, skip
			// FROM articles LEFT JOIN user ON writer_id = user.id
			// WHERE category = "param_category" ORDER BY id DESC
			// writer_id를 매개로 articles 테이블과 user테이블을 합친다.
			// articles.id, 카테고리, 제목, 사용자아이디, 작성일, 조회수, 삭제여부 이렇게 7개 항목으로 테이블을 만들고 id값을 기준으로 역순으로 배열한다.

			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
		}
		catch(Exception e)
		{
			e.printStackTrace();
			out.println("테이블 호출에 실패했습니다." + e.getMessage());
		}
	}
%>

<!-- 공통부분 1 시작 -->
<!DOCTYPE html>

<html>
	<head>
		<title>team project</title>
	
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
    	<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
<!-- twitter bootstrap에서 필수적으로 요구하는 사항.-->

		<link rel="stylesheet" type="text/css" href="style.css">
		<!-- 우리가 만든 css 스타일 파일 -->
    	<link rel="stylesheet" href="bootstrap-3.3.6-dist/css/bootstrap.min.css">
		<!-- 부트스트랩-->
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
						<table class="table">
<!-- 공통부분 1 끝 -->
						<%
							// idx값이 있는 경우
							if(param_idx != 0)
							{
								while(rs.next())
								{
									category	= rs.getString("category");
									title		= rs.getString("title");
									user_id		= rs.getString("user_id");
									email		= rs.getString("email");
									created		= rs.getTimestamp("created");
									view		= rs.getInt("view") + 1;
									content		= rs.getString("content");

									try
									{
										sql = "UPDATE articles SET view = " + view + " WHERE id = " + param_idx;
										stmt = conn.createStatement();
										stmt.executeUpdate(sql);
									}
									catch(Exception e)
									{
										e.printStackTrace();
										out.println("view update 실패했습니다." + e.getMessage());
									}
									// 한번 볼때마다 조회수를 1 씩 늘려준다.
								}
						%>
							<tr><th>제목</th><td colspan="3">[<%=category%>] <%=title%></td></tr>
							<tr><th>작성자</th><td><%=user_id%></td><th>이메일</th><td><%=email%></td></tr>
							<tr><th>작성일</th><td><%=created%></td><th>조회수</th><td><%=view%></td></tr>
							<tr><th>본문</th><td colspan="3"><%=content%></td></tr>

						<!--	|제목		| [카테고리] 제목			|
								|작성자	|(아이디)	| 이메일	|(이메일)	|
								|작성일	|(날자)	| 조회수	|(숫자)	|
								|본문		|()						|-->
						<%
							
							}
							// idx값이 있는 경우 종료

							// idx값이 없는 경우
							else
							{
						%>
							<thead><tr><th>번호</th><th>카테고리</th><th>제목</th><th>작성자</th><th>작성일</th><th>조회수</th></tr></thead>
							<!--| 번호	| 카테고리	 | 제목 | 작성자 | 작성일 | 조회수 | -->
							<tbody>
						<%
								while(rs.next())
								{
									skip = rs.getInt("skip");
									if(skip == 1)
									{
										continue;
									}
									idx = rs.getInt("articles.id");
									category = rs.getString("category");
									title = rs.getString("title");
									user_id = rs.getString("user_id");
									created = rs.getTimestamp("created");
									view = rs.getInt("view");

						%>
							<tr>
								<td><%=idx%></td>
								<td><a href=index.jsp?category=<%=category%>><%=category%></a></td>
								<td><a href=index.jsp?idx=<%=idx%>><%=title%></a></td>
								<td><a href=index.jsp?writerid=<%=user_id%>><%=user_id%></a></td>
								<td><%=created%></td>
								<td><%=view%></td>
							</tr>
						<%
								}
							}
						%>
							</tbody>
						</table>
					</article>

					<hr>
					
					<div id="control"><!-- 이제 마지막으로 다른 부분 -->
					<%
						if(param_idx != 0)
						{
					%>
						<div class="btn-group" role="group" aria-label="...">
							<a href="write.jsp" class="btn btn-success bnt-lg">쓰기</a>
							<a href=write.jsp?idx=<%=param_idx%> class="btn btn-warning bnt-lg">수정</a>
							<a href=delete.jsp?idx=<%=param_idx%> class="btn btn-danger bnt-lg">삭제</a>
							<a href="index.jsp" class="btn btn-default bnt-lg">목록</a>
						</div>
					<%
						}


						else
						{
					%>
						<a href="write.jsp" class="btn btn-success bnt-lg">쓰기</a>
					<%
						}
					%>
					</div>
				</div>

				<div class="col-md-2"></div>
			</div>
		</div>
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	   	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

<!-- Include all compiled plugins (below), or include individual files as needed -->
    	<script src="bootstrap-3.3.6-dist/js/bootstrap.min.js"></script>
	<%
		rs.close();
		stmt.close();
		conn.close();
	%>
	</body>
</html>
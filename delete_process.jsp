<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.text.*" %>

<%
	request.setCharacterEncoding("utf-8");

	String writer = request.getParameter("writer");
	String password = request.getParameter("password");

	String dburl = "jdbc:mysql://localhost:3306/teamp";
	// 사용하려는 데이터베이스명을 포함한 URL 기술
	String dbuser = "root";
	// 사용자 계정
	String dbpw = "dlawpgml90";
	// 사용자 계정의 패스워드

	Connection conn = null;
	Statement stmt = null;	
	ResultSet rs = null;
	String sql = null;

	int param_idx = Integer.parseInt(request.getParameter("idx"));

	String url = null;
	int user_idx = 0;

	try
	{
		Class.forName("com.mysql.jdbc.Driver");
		// 데이터베이스와 연동하기 위해 DriverManager에 등록한다.

		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		// DriverManager 객체로부터 Connection 객체를 얻어온다.

		sql = "SELECT articles.id, user_id, password FROM articles LEFT JOIN user ON writer_id = user.id WHERE articles.id = " + param_idx;
		// param_idx번 글의 글쓴이와 비밀번호를 불러온다.
		stmt = conn.createStatement();
		rs = stmt.executeQuery(sql);
	}
	catch(Exception e)
	{
		e.printStackTrace();
		out.println("기본 데이터 조회 오류입니다." + e.getMessage());
	}

	while(rs.next())
	{
		// 아이디나 비밀번호를 틀린경우. 경고창을 띄운 후 이동했으면 하는데 잘되지않는다.
		if(!writer.equals(rs.getString("user_id")) || !password.equals(rs.getString("password")))
		{
			out.println("<script language=javascript>alert('아이디 혹은 패스워드를 잘못 입력하셨습니다.');</script>");

			url = "delete.jsp?idx = " + param_idx;
		}

		// 아이디와 비밀번호를 정확히 적은 경우
		else
		{
			try
			{
				sql = "UPDATE articles SET skip = 1 WHERE id = " + param_idx;
				stmt.executeUpdate(sql);
			}
			catch(Exception e)
			{
				e.printStackTrace();
				out.println("writer_id 조회 오류입니다." + e.getMessage());
			}
		}

		url = "index.jsp";

		break;
	}

	rs.close();
	stmt.close();
	conn.close();

	response.sendRedirect(url);

%>
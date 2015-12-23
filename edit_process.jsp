<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.text.*" %>

<%
	request.setCharacterEncoding("utf-8");

	String title = request.getParameter("title");
	String category = request.getParameter("category");
	String writer = request.getParameter("writer");
	String password = request.getParameter("password");
	String email = request.getParameter("email");
	String content = request.getParameter("content");
	//edit.jsp가 보낸 값을 저장하는 변수. 각각 제목, 카테고리, 직성자, 비밀번호, 이메일, 본문을 저장한다.


	Connection conn = null;

	String dburl = "jdbc:mysql://localhost:3306/teamp";
	// 사용하려는 데이터베이스명을 포함한 URL 기술
	String dbuser = "root";
	// 사용자 계정
	String dbpw = "dlawpgml90";
	// 사용자 계정의 패스워드

	Statement stmt = null;
	ResultSet rs = null;
	String sql = null;

	int param_idx = Integer.parseInt(request.getParameter("idx"));
	// index.jsp -> edit.jsp -> edit_process.jsp로 넘겨지는, 처음에 읽었던 글의 번호

	try
	{
		Class.forName("com.mysql.jdbc.Driver");
		// 데이터베이스와 연동하기 위해 DriverManager에 등록한다.

		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		// DriverManager 객체로부터 Connection 객체를 얻어온다.

		sql = "SELECT articles.id, category, title, user_id, password, email, content FROM articles LEFT JOIN user ON writer_id = user.id WHERE articles.id = " + param_idx;
		// SELECT articles.id, category, title, user_id, password, email, content
		// FROM articles LEFT user ON writer_id = user.id
		// WHERE articles.id = (idx)
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
		if(!password.equals(rs.getString("password")))
		{
			out.println("<script language=javascript>alert('패스워드를 잘못 입력하셨습니다.');</script>");

			rs.close();
			stmt.close();
			conn.close();

			response.sendRedirect("/edit.jsp?idx=" + param_idx);

			return;
		}
		// response.sendRedirect 메소드는 모든 코드를 읽어들인 뒤에 실행한다. 따라서 코드 중간에 나오게 되면 반드시 return을 해줘야한다.
		// 이 if 문은 edit.jsp에서 넘긴 비밀번호를 db에 저장된 비밀번호와 같은지 비교하고 같지 않은 경우에 실행된다.
		// 같지 않은 경우 alert을 실행해야하는데 response.sendRedirect 메소드가 제어권을 먼저 가지고있어서 싦행되지 않는다.
		else
		{
			try
			{
				sql = "UPDATE articles SET title = '" + title + "', category = '" + category + "', content = '" + content + "' WHERE articles.id = " + param_idx;
				// UPDATE articles SET title = (제목), category = (카테고리), content = (본문) WHERE id = (idx)
				// articles 테이블에서 id값이 idx인 항목에 제목, 카테고리, 본문을 입력받은데로 수정한다.
				stmt.executeUpdate(sql);
			}
			catch(Exception e)
			{
				e.printStackTrace();
				out.println("데이터 업데이트 오류입니다." + e.getMessage());
			}
		}

		break;
	}

	rs.close();
	stmt.close();
	conn.close();

	response.sendRedirect("/index.jsp");
	// 수정이 정상적으로 완료되면 index.jsp로 이동한다
%>
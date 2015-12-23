<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.text.*" %>

<%
	request.setCharacterEncoding("utf-8");

	String title = request.getParameter("title");			// write.jsp에서 넘긴 제목
	String category = request.getParameter("category");		// write.jsp에서 넘긴 카테고리
	String writer = request.getParameter("writer");			// write.jsp에서 넘긴 작성자
	String password = request.getParameter("password");		// write.jsp에서 넘긴 패스워드
	String email = request.getParameter("email");			// write.jsp에서 넘긴 이메일
	String content = request.getParameter("content");		// write.jsp에서 넘긴 본문

	Connection conn = null;

	String dburl = "jdbc:mysql://localhost:3306/teamp";
	// 사용하려는 데이터베이스명을 포함한 URL 기술
	String dbuser = "root";
	// 사용자 계정
	String dbpw = "dlawpgml90";
	// 사용자 계정의 패스워드

	Statement stmt = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String sql = null;

	request.setCharacterEncoding("utf-8");

	int useridx = 0;
	String userid = null;

	int param_idx = 0;

	// idx값이 있는 경우. 즉 수정인 경우
	if(request.getParameter("idx") != null)
		param_idx = Integer.parseInt(request.getParameter("idx"));
	// index.jsp -> write.jsp -> write_process.jsp로 넘겨지는, 처음에 읽었던 글의 번호

	try
	{
		Class.forName("com.mysql.jdbc.Driver");
		// 데이터베이스와 연동하기 위해 DriverManager에 등록한다.

		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		// DriverManager 객체로부터 Connection 객체를 얻어온다.

		// idx값이 없는 경우. 즉 쓰기인 경우
		if(param_idx == 0)
		{
			sql = "SELECT * FROM user WHERE user_id = '" + writer + "'";
			// select * from user where user_id = "작성자"
		}

		// 반대로 idx값이 있는 경우. 즉 수정하기인 경우
		else
		{
			sql = "SELECT articles.id, category, title, user_id, password, email, content FROM articles LEFT JOIN user ON writer_id = user.id WHERE articles.id = " + param_idx;
			// SELECT articles.id, category, title, user_id, password, email, content
			// FROM articles LEFT user ON writer_id = user.id
			// WHERE articles.id = (idx)
		}
		stmt = conn.createStatement();
		rs = stmt.executeQuery(sql);
		// sql에 저장된 sql문을 stmt의 메소드를 이용, db에 요구하고 그 값을 ResultSet 객체 rs에 저장한다.

	}
	catch(Exception e)
	{
		e.printStackTrace();
		out.println("유저 호출에 실패했습니다." + e.getMessage());
	}
	// 위의 try함수의 sql문이 정상적으로 작동하지 않아 오류가 날 경우 오류를 출력한다.

	// idx값이 없는 경우. 즉 쓰기인 경우
	if(param_idx == 0)
	{
		if(rs.next())
		{
			useridx = rs.getInt("id");
			userid = rs.getString("user_id");
		}
		// rs에 저장된 값이 있다면 그 값에서 user 테이블의 id값을 정수 useridx에, user_id값을 문자열 userid에 저장한다.

		if(useridx == 0)
		{
			try
			{
				sql = "INSERT INTO user(user_id, password, email) VALUES(?,?,?)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, writer);
				pstmt.setString(2, password);
				pstmt.setString(3, email);

				pstmt.executeUpdate();
			}
			//useridx가 0인 경우, 즉 기존의 데이터에 없는 아이디 인 경우 user 테이블에 새로운 값을 저장한다. user_id, password, email을 저장한다.
			catch(Exception e)
			{
				e.printStackTrace();
				out.println("유저 입력에 실패했습니다." + e.getMessage());
			}

			try
			{
				sql = "SELECT id, user_id FROM user WHERE user_id = '" + writer + "'";
				rs = stmt.executeQuery(sql);

				while(rs.next())
				{
					useridx = rs.getInt("id");

					break;
				}
			}
			// select id, user_id from user where user_id = "작성자"
			// user 테이블에서 작성자의 아이디와 같은 아이디를 갖는 데이터를 rs에 저장한다.
			// 1회만 출력될 것이므로 바로 break 해준다.
			catch(Exception e)
			{
				e.printStackTrace();
				out.println("유저테이블의 id값을 불러오는데 실패했습니다." + e.getMessage());
			}
		}

		try
		{
			sql = "INSERT INTO articles(title, writer_id, category, content) VALUES(?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, title);
			pstmt.setInt(2, useridx);
			pstmt.setString(3, category);
			pstmt.setString(4, content);

			pstmt.executeUpdate();
		}
		// articles 테이블의 title, writer_id, category, content 컬럼에 write.jsp에서 보내온 값인 제목, 카테고리, 내용과 위에서 구한 useridx값을 넣어준다.
		catch(Exception e)
		{
			e.printStackTrace();
			out.println("articles 테이블에 데이터를 입력하는데 실패했습니다." + e.getMessage());
		}
	}

	//idx값이 있는 경우. 즉 수정인 경우
	else
	{
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
	}

	stmt.close();
	pstmt.close();
	conn.close();
	// preparedStatement 객체인 pstmt, Statement 객체인 stmt, Connection 객체인 conn을 각각 종료해준다.

	response.sendRedirect("index.jsp");
	// 모든 과정을 마치면 index.jsp로 이동한다.
%>
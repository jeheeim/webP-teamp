<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>

<%@ page import="java.sql.*" %>

<%
	Connection conn = null;                                        // null로 초기화 한다.

PreparedStatement pstmt = null;


try{

String url = "jdbc:mysql://localhost:3306/teamp";        // 사용하려는 데이터베이스명을 포함한 URL 기술

String id = "root";                                                    // 사용자 계정

String pw = "dlawpgml90";                                                // 사용자 계정의 패스워드


Class.forName("com.mysql.jdbc.Driver");                       // 데이터베이스와 연동하기 위해 DriverManager에 등록한다.

conn=DriverManager.getConnection(url,id,pw);              // DriverManager 객체로부터 Connection 객체를 얻어온다.


String sql = "insert into member1 values(?,?,?,?)";        // sql 쿼리

pstmt = conn.prepareStatement(sql);                          // prepareStatement에서 해당 sql을 미리 컴파일한다.

pstmt.setString(1,"test");

pstmt.setString(2,"passwd");

pstmt.setString(3,"김철수");

pstmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));    // 현재 날짜와 시간


pstmt.executeUpdate();                                        // 쿼리를 실행한다.


out.println("member 테이블에 새로운 레코드를 추가했습니다.");        // 성공시 메시지 출력


}catch(Exception e){                                                    // 예외가 발생하면 예외 상황을 처리한다.

e.printStackTrace();

out.println("member 테이블에 새로운 레코드 추가에 실패했습니다.");

}finally{                                                            // 쿼리가 성공 또는 실패에 상관없이 사용한 자원을 해제 한다. (순서중요)

if(pstmt != null) try{pstmt.close();}catch(SQLException sqle){}            // PreparedStatement 객체 해제

if(conn != null) try{conn.close();}catch(SQLException sqle){}            // Connection 해제

}
%>
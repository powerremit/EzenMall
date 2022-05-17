package util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class JDBCUtil {

	// 1~2단계 - connection pool 사용
	public static Connection getConnection() throws Exception {
		Context initCtx = new InitialContext();
		Context envCtx = (Context)initCtx.lookup("java:comp/env"); /* 라이브러리 환경을 찾는것  환경을 envCtx가 받은것 */
		DataSource ds = (DataSource)envCtx.lookup("jdbc/db01");
		return ds.getConnection();
	}
	
	// Connection 과 PreparedStatement를 닫는 메소드(insert, update, delete 작업일 떄)
	public static void close(Connection conn, PreparedStatement pstmt) {
		if(pstmt != null) {
			try {
				pstmt.close();
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		if(conn != null ) {
			try {
				conn.close();
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
	}
	// 메소드 오버로딩(Connection, PreparedStatement, ResultSet 객체를 닫는 메소드) - select 작업을 사용할때
	public static void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
		if(rs != null ) {
			try {
				rs.close();
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		if(pstmt != null) {
			try {
				pstmt.close();
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		if(conn != null ) {
			try {
				conn.close();
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	
}

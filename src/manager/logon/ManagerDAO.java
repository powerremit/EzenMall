package manager.logon;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.JDBCUtil;

public class ManagerDAO {
	// 싱글톤 패턴(인스턴스가 한개만 만들어지도록 하는 방법)
	private ManagerDAO() { }
	private static ManagerDAO managerDAO = new ManagerDAO();
	public static ManagerDAO getInstance() {
		return managerDAO;
	}
	
	// DB 연결과 질의를 위한 변수 순언
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	
	// 관리자 확인 메소드 - 아이디와 패스워드로 관리자 확인
	public int checkManager(String managerId, String managerPwd) {
		String sql = "select * from manager where managerId = ? and managerPwd = ?";
		int cnt = 0;
		try {
			conn = JDBCUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, managerId);
			pstmt.setString(2, managerPwd);
			rs = pstmt.executeQuery();
			
			if(rs.next()) cnt = 1; // 아이디와 패스워드 일치할경우 cnt=1리턴 ->로그인성공
			else cnt = 0;  		   // 아이디 또는 비밀번호가 또는 둘다 틀렸을때 ->로그인실패
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.close(conn, pstmt, rs);
		}
		return cnt;
	}
}

package manager.product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import util.JDBCUtil;

public class ProductDAO {
	// 싱글톤 패턴
	// 외부에서 new를 사용하지 못하도록. 
	private ProductDAO() {	}
	
	private static ProductDAO instance = new ProductDAO();
	
	public static ProductDAO getInstance() {
		return instance;
	}
	
	// DB연결과 질의를 위한 객체 변수 선언
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	
	// 여기서부터 메소드 등록
	//#####################################//
	// manager의 product에서 사용하는 메소드
	
	// 상품등록 메소드 (productRegisterPro.jsp)
	public void insertProduct(ProductDTO product) { // 정보를 가져와야하니까 productDTO에서 받아온다(매개변수)
		String sql = "insert into product(product_kind, product_name, product_price, product_count, author,"
				+ "publishing_com, publishing_date, product_image, product_content, discount_rate) "
				+ "values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		
		try {
			conn = JDBCUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, product.getProduct_kind());
			pstmt.setString(2, product.getProduct_name());
			pstmt.setInt(3, product.getProduct_price());
			pstmt.setInt(4, product.getProduct_count());
			pstmt.setString(5, product.getAuthor());
			pstmt.setString(6, product.getPublishing_com());
			pstmt.setString(7, product.getPublishing_date());
			pstmt.setString(8, product.getProduct_image());;
			pstmt.setString(9, product.getProduct_content());
			pstmt.setInt(10, product.getDiscount_rate());
			pstmt.executeUpdate();
			
		} catch(Exception e) {
			//여기서도 디버깅을 하려면 system.out.println 넣어주면 콘솔에서 에러찾을수있음
			System.out.println("insertProduct 메소드: " + e.getMessage()); // 겟메세지는 간단하게 프린트스택은 경로를 다보여줌.
			e.printStackTrace();
		} finally {
			JDBCUtil.close(conn, pstmt);
		}
	}
	
	// 전체 상품 수 조회(productList.jsp) - 검색하지 않았을 때
	public int getProductCount() {
		String sql = "select count(*) from product";
		int cnt = 0;
		try {
			conn = JDBCUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			rs.next();
			cnt = rs.getInt(1); // 첫번째 값. cnt 한개뿐이니깐.
			
		} catch(Exception e) {
			System.out.println("getProductCount() 메소드: " + e.getMessage());
			e.printStackTrace();
		} finally {
			JDBCUtil.close(conn, pstmt, rs);
		}
		return cnt;
	}
	
	// 검색한 전체 상품수 조회 메소드
	public int getProductCount(String s_search, String i_search) {
		String sql = "select count(*) from product where ";
		if(s_search.equals("제목")) {
			sql += "product_name";
		} else if(s_search.equals("저자")) {
			sql += "author";
		} else if(s_search.equals("출판사")) {
			sql += "publishing_com";
		} else if(s_search.contentEquals("내용")) {
			sql += "product_content";
		}	
		sql += " like ?";
		
		int cnt = 0;
		
		try {
			conn = JDBCUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%" + i_search + "%");
			rs = pstmt.executeQuery();
			rs.next();
			cnt = rs.getInt(1);
		
		} catch(Exception e) {
			System.out.println("getProductCount 메소드: " + e.getMessage());
			e.printStackTrace();
		} finally {
			JDBCUtil.close(conn, pstmt, rs);
		}
		return cnt;
	}
	
	
	
	// 전체 상품 조회 메소드(productList.jsp) 리턴타입이 상품 하나가 아니니깐. 어레이리스트 프로덕트 DTO를 담는 어레이 리스트, 페이징처리
	public List<ProductDTO> getProductList(int startRow, int pageSize) { // 페이징처리 파라미터삽입
		List<ProductDTO> productList = new ArrayList<ProductDTO>();
		// 각각 인스턴스를 만들어서 넣어야됨
		ProductDTO product = null; // 반복문 돌려서 만들어야되니까 초기값 null
		String sql = "select * from product order by product_id desc limit ?, ?"; // 페이징처리(리미티는 0번부터 시작)
		
		
		try {
			conn = JDBCUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow-1); // 페이징처리
			pstmt.setInt(2, pageSize); // 페이징처리
			rs = pstmt.executeQuery();
			while(rs.next()) {
				product = new ProductDTO();
				// product_content를 제외한 11개 필드의 정보를 list에 담아서 이동시키게 된다.
				product.setProduct_id(rs.getInt("product_id"));
				product.setProduct_kind(rs.getString("product_kind"));
				product.setProduct_name(rs.getString("product_name"));
				product.setProduct_price(rs.getInt("product_price"));
				product.setProduct_count(rs.getInt("product_count"));
				product.setAuthor(rs.getString("Author"));
				product.setPublishing_com(rs.getString("publishing_com"));
				product.setPublishing_date(rs.getString("publishing_date"));
				product.setProduct_image(rs.getString("product_image"));
				product.setDiscount_rate(rs.getInt("discount_rate"));
				product.setReg_date(rs.getTimestamp("reg_date"));
				productList.add(product);
			}
		} catch(Exception e) {
			System.out.println("getProductList() 메소드: " + e.getMessage());
			e.printStackTrace();
		} finally {
			JDBCUtil.close(conn, pstmt, rs);
		}
		return productList;
	}
	
	// 검색한 전체 상품 조회 메소드 - 페이징 처리, 검색 처리를 함.
		public List<ProductDTO> getProductList(int startRow, int pageSize, String s_search, String i_search) {
			System.out.println("s_search: " + s_search + ", i_search: " + i_search);
			
			List<ProductDTO> productList = new ArrayList<ProductDTO>();
			ProductDTO product = null;
			String sql = "select * from product where ";
			
			if(s_search.equals("제목")) {
				sql += "product_name";
			} else if(s_search.equals("저자")) {
				sql += "author";
			} else if(s_search.equals("출판사")) {
				sql += "publishing_com";
			} else if(s_search.equals("내용")) {
				sql += "product_content";
			}
					
			sql += " like ? order by product_id desc limit ?, ?";
			
			try {
				conn = JDBCUtil.getConnection();
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, "%" + i_search + "%");
				pstmt.setInt(2, startRow-1);
				pstmt.setInt(3, pageSize);
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					product = new ProductDTO();
					// product_content를 제외한 11개 필드의 정보
					product.setProduct_id(rs.getInt("product_id"));
					product.setProduct_kind(rs.getString("product_kind"));
					product.setProduct_name(rs.getString("product_name"));
					product.setProduct_price(rs.getInt("product_price"));
					product.setProduct_count(rs.getInt("product_count"));
					product.setAuthor(rs.getString("author"));
					product.setPublishing_com(rs.getString("publishing_com"));
					product.setPublishing_date(rs.getString("publishing_date"));
					product.setProduct_image(rs.getString("product_image"));
					product.setDiscount_rate(rs.getInt("discount_rate"));
					product.setReg_date(rs.getTimestamp("reg_date"));
					productList.add(product);
				}
				
			} catch(Exception e) {
				System.out.println("getProductList 메소드: " + e.getMessage());
				e.printStackTrace();
			} finally {
				JDBCUtil.close(conn, pstmt, rs);
			}
			return productList;
		}
	
	// 상품 1개 상세보기 메소드(productContent.jsp)
	public ProductDTO getProduct(int product_id) {
		ProductDTO product = new ProductDTO();
		String sql = "select * from product where product_id = ?";
		
		
		// 상품에 대한 12개의 필드정보 담기.
		try {
			conn = JDBCUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, product_id);
			rs = pstmt.executeQuery();
			rs.next();
			product = new ProductDTO();
			product.setProduct_id(rs.getInt("product_id"));
			product.setProduct_kind(rs.getString("product_kind"));
			product.setProduct_name(rs.getString("product_name"));
			product.setProduct_price(rs.getInt("product_price"));
			product.setProduct_count(rs.getInt("product_count"));
			product.setAuthor(rs.getString("Author"));
			product.setPublishing_com(rs.getString("publishing_com"));
			product.setPublishing_date(rs.getString("publishing_date"));
			product.setProduct_image(rs.getString("product_image"));
			product.setProduct_content(rs.getString("product_content"));
			product.setDiscount_rate(rs.getInt("discount_rate"));
			product.setReg_date(rs.getTimestamp("reg_date"));
			
		} catch(Exception e) {
			System.out.println("getProduct 메소드:" + e.getMessage());
			e.printStackTrace();
		} finally {
			JDBCUtil.close(conn, pstmt, rs);
		}
		return product;
	}
	
	// 상품 정보 수정 메소드
	public void updateProduct(ProductDTO product) {
		String sql = "update product set product_kind=?, product_name=?, product_price=?, product_count=?, author=?, "
				+ "publishing_com=?, publishing_date=?, product_image=?, product_content=?, discount_rate=? where product_id = ?";
		
		try {
			conn = JDBCUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, product.getProduct_kind());
			pstmt.setString(2, product.getProduct_name());;
			pstmt.setInt(3, product.getProduct_price());
			pstmt.setInt(4, product.getProduct_count());
			pstmt.setString(5, product.getAuthor());
			pstmt.setString(6, product.getPublishing_com());
			pstmt.setString(7, product.getPublishing_date());
			pstmt.setString(8, product.getProduct_image());
			pstmt.setString(9, product.getProduct_content());
			pstmt.setInt(10, product.getDiscount_rate());
			pstmt.setInt(11, product.getProduct_id());
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("updateProduct 메소드: " + e.getMessage());
			e.printStackTrace();
		} finally {
			JDBCUtil.close(conn, pstmt);
		}
	}
	
	// 상품 정보 삭제 메소드
	public void deleteProduct(int product_id) {
		String sql ="delete from product where product_id = ?";
		
		try {
			conn = JDBCUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, product_id);
			pstmt.executeUpdate();
		} catch(Exception e) {
			System.out.println("deleteProduct 메소드: " + e.getMessage());
			e.printStackTrace();
		} finally {
			JDBCUtil.close(conn, pstmt);
		}
	}
	
	
	//#####################################//
	// mall 에서 사용하는 메소드
	
	// 1. chk가 1일때 - shop 에서 100번대, 200번대 신상품을 3개씩 담아서 리턴
	// shopAll에서 100번 200번대 신상품 3개씩 리스트에 담아서 리턴(110, 120, 220, 230, 240, 250)
	// 신상품의 기준은 publishing_date(출판일) 기준
	// 2. 
	public List<ProductDTO> getProductList(String[] nProducts){
		List<ProductDTO> productList = new ArrayList<ProductDTO>();
		ProductDTO product = null;
		String sql = "select * from product where product_kind = ? order by publishing_date desc limit 3";
		
		try {
			conn = JDBCUtil.getConnection();
			
			for(String s : nProducts) {
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, s);
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					product = new ProductDTO();
					product.setProduct_id(rs.getInt("product_id"));
					product.setProduct_image(rs.getString("product_image"));
					productList.add(product);
					// 반복문이돌면서 sql 바꿔가면서 실행, productList에 18개의 신상품의정보가 담긴다.
				}
			}
		} catch(Exception e) {
			System.out.println("getProductList(String []) mall 메소드: " + e.getMessage());
			e.printStackTrace();
		} finally {
			JDBCUtil.close(conn, pstmt, rs);
		}
		
		return productList;
	}
	public List<ProductDTO> getRcmdProductList(String[] rProducts){
		List<ProductDTO> r_productList = new ArrayList<ProductDTO>();
		ProductDTO r_product = null;
		String sql = "select * from product where product_kind = ? order by publishing_date desc limit 1";
		
		try {
			conn = JDBCUtil.getConnection();
			
			for(String s : rProducts) {
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, s);
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					r_product = new ProductDTO();
					r_product.setProduct_id(rs.getInt("product_id"));
					r_product.setProduct_image(rs.getString("product_image"));
					r_productList.add(r_product);
					// 반복문이돌면서 sql 바꿔가면서 실행, productList에 18개의 신상품의정보가 담긴다.
				}
			}
		} catch(Exception e) {
			System.out.println("getRcmdProductList(String []) mall 메소드: " + e.getMessage());
			e.printStackTrace();
		} finally {
			JDBCUtil.close(conn, pstmt, rs);
		}
		
		return r_productList;
	}

	
	
}

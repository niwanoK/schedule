

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class CallMonthViewPage
 */
public class MonthView extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public MonthView() {
        super();
        // TODO Auto-generated constructor stub
    }

    protected Connection conn = null;

    public void init() throws ServletException{
      String url = "jdbc:mysql://localhost/schedule";
      String user = "scheduleuser";
      String password = "schedulepass";

      try {
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        conn = DriverManager.getConnection(url, user, password);
      }catch (ClassNotFoundException e){
        log("ClassNotFoundException:" + e.getMessage());
      }catch (SQLException e){
        log("SQLException:" + e.getMessage());
      }catch (Exception e){
        log("Exception:" + e.getMessage());
      }
    }

    public void destory(){
      try{
        if (conn != null){
          conn.close();
        }
      }catch (SQLException e){
        log("SQLException:" + e.getMessage());
      }
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 * MonthView.jspの呼び出し及び値の受け渡しを行う。
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
        int year;
        int month;
        int day = 1;

        // 年データを取得
        String param =  request.getParameter("YEAR");
        if (param == null || param.length() == 0){
            year = -999;
        }else{
            try{
                year = Integer.parseInt(param);
            }catch (NumberFormatException e){
                year = -999;
            }
        }

        // 月データを取得
        param =  request.getParameter("MONTH");
        if (param == null || param.length() == 0){
            month = -999;
        }else{
            try{
                month = Integer.parseInt(param);
            }catch (NumberFormatException e){
                month = -999;
            }
        }

        // パラメータが指定されていない場合は本日の日付を設定
        if (year == -999 || month == -999){
            Calendar calendar = Calendar.getInstance();
            year = calendar.get(Calendar.YEAR);
            month = calendar.get(Calendar.MONTH);
            day = calendar.get(Calendar.DATE);
        }else{
            if (month == 12){
                month = 0;
                year++;
            }

            if (month == -1){
                month = 11;
                year--;
            }
        }

        Calendar calendar = Calendar.getInstance();

        // 今月が何日までかを確認する
        calendar.set(year, month + 1, 0);
        int thisMonthlastDay = calendar.get(Calendar.DATE);

        String[] scheduleData = new String[42];

        for (int i = 0; i <= thisMonthlastDay; i++) {
        	scheduleData[i] = "";
        	try {
        		String sql = "SELECT * FROM schedule WHERE userid = ? and scheduledate = ? ORDER BY starttime";
        		PreparedStatement pstmt = conn.prepareStatement(sql);

        		String startDateStr = year + "-" + (month + 1) + "-" + i;
        		pstmt.setInt(1, 1);
        		pstmt.setString(2, startDateStr);

        		ResultSet rs = pstmt.executeQuery();

        		String scheduleQuery = "";
        		while(rs.next()){
        			String starttime = rs.getString("starttime");
        			String endtime = rs.getString("endtime");
        			String schedule = rs.getString("schedule");

        			if (starttime == null || endtime == null || schedule == null){
        				scheduleQuery = scheduleQuery + "";
        			}else if ((starttime == null || endtime == null) && schedule != null){
        				scheduleQuery = scheduleQuery + "* " + schedule + "\n";
        			}else{
        				String startTimeStr = starttime.substring(0, 5);
        				String endTimeStr = endtime.substring(0, 5);
        				scheduleQuery = scheduleQuery + startTimeStr + "-" + endTimeStr + " " + schedule + "\n";
        			}
        		}
        		scheduleData[i] =scheduleQuery;

        		rs.close();
        		pstmt.close();

        	}catch (SQLException e){
        		log("SQLException:" + e.getMessage());
        	}
        }

		// 呼び出し先Jspに渡すデータセット
		request.setAttribute("YEAR", year);
		request.setAttribute("MONTH", month);
		request.setAttribute("DAY", day);
		request.setAttribute("SCHEDULEDATA", scheduleData);

		// result.jsp にページ遷移
		RequestDispatcher dispatch = request.getRequestDispatcher("MonthView.jsp");
		dispatch.forward(request, response);
	}

}

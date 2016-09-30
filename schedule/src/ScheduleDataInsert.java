

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class NewScheduleInsert
 */
public class ScheduleDataInsert extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public ScheduleDataInsert() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	    //request.setCharacterEncoding("Shift-JIS");
		request.setCharacterEncoding("UTF8");
	    //response.setContentType("text/html;charset=Shift_Jis");
	    response.setContentType("text/html;charset=UTF8");
        PrintWriter out = response.getWriter();

        int year;
        int month;
        int day;
        int shour;
        int sminute;
        int ehour;
        int eminute;
        String plan;
        String memo;

        String param = request.getParameter("YEAR");
        if (param == null || param.length() == 0){
            year = -999;
        }else{
            try{
                year = Integer.parseInt(param);
            }catch (NumberFormatException e){
                year = -999;
            }
        }

        param = request.getParameter("MONTH");
        if (param == null || param.length() == 0){
            month = -999;
        }else{
            try{
                month = Integer.parseInt(param);
            }catch (NumberFormatException e){
                month = -999;
            }
        }

        param = request.getParameter("DAY");
        if (param == null || param.length() == 0){
            day = -999;
        }else{
            try{
                day = Integer.parseInt(param);
            }catch (NumberFormatException e){
                day = -999;
            }
        }

        param = request.getParameter("SHOUR");
        if (param == null || param.length() == 0){
            shour = -999;
        }else{
            try{
                shour = Integer.parseInt(param);
            }catch (NumberFormatException e){
                shour = -999;
            }
        }

        param = request.getParameter("SMINUTE");
        if (param == null || param.length() == 0){
            sminute = -999;
        }else{
            try{
                sminute = Integer.parseInt(param);
            }catch (NumberFormatException e){
                sminute = -999;
            }
        }

        param = request.getParameter("EHOUR");
        if (param == null || param.length() == 0){
            ehour = -999;
        }else{
            try{
                ehour = Integer.parseInt(param);
            }catch (NumberFormatException e){
                ehour = -999;
            }
        }

        param = request.getParameter("EMINUTE");
        if (param == null || param.length() == 0){
            eminute = -999;
        }else{
            try{
                eminute = Integer.parseInt(param);
            }catch (NumberFormatException e){
                eminute = -999;
            }
        }

        param = request.getParameter("PLAN");
        if (param == null || param.length() == 0){
            plan = "";
        }else{
            try{
                plan = param;
            }catch (NumberFormatException e){
                plan = "";
            }
        }

        param = request.getParameter("MEMO");
        if (param == null || param.length() == 0){
            memo = "";
        }else{
            try{
                memo = param;
            }catch (NumberFormatException e){
                memo = "";
            }
        }

        /* 日付が不正な値で来た場合はパラメータ無しで「MonthView」へリダイレクトする */
        if (year == -999 || month == -999 || day == -999){
            response.sendRedirect("/schedule/MonthView");
        }
        String dateStr = year + "-" + month + "-" + day;

        String startTimeStr = shour + ":" + sminute + ":00";
        String endTimeStr = ehour + ":" + eminute + ":00";
        /* 日付が指定されていない場合は、開始及び終了時刻をNULLとして登録する */
        if (shour == -999 || sminute == -999 || ehour == -999 || eminute == -999){
            startTimeStr = null;
            endTimeStr = null;
        }

        Connection conn = null;
        String url = "jdbc:mysql://localhost/schedule";
        String user = "scheduleuser";
        String password = "schedulepass";

        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            conn = DriverManager.getConnection(url, user, password);

            String sql = "insert into schedule (userid, scheduledate, starttime, endtime, schedule, schedulememo) values (?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, 1);
            pstmt.setString(2, dateStr);
            pstmt.setString(3, startTimeStr);
            pstmt.setString(4, endTimeStr);
            pstmt.setString(5, plan);
            pstmt.setString(6, memo);
            int num = pstmt.executeUpdate();

            pstmt.close();

        }catch (ClassNotFoundException e){
            out.println("ClassNotFoundException:" + e.getMessage());
        }catch (SQLException e){
            out.println("SQLException:" + e.getMessage());
        }catch (Exception e){
            out.println("Exception:" + e.getMessage());
        }finally{
            try{
                if (conn != null){
                    conn.close();
                }
            }catch (SQLException e){
                out.println("SQLException:" + e.getMessage());
            }
        }

        // 呼び出し先Jspに渡すデータセット
     	request.setAttribute("YEAR", year);
     	request.setAttribute("MONTH", month - 1);
     	request.setAttribute("DAY", day);

     	// result.jsp にページ遷移
     	response.sendRedirect("/schedule/MonthView");
	}

}

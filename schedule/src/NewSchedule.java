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
 * Servlet implementation class callNewSchedulePage
 */
public class NewSchedule extends HttpServlet {
	private static final long serialVersionUID = 1L;

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
     * @see HttpServlet#HttpServlet()
     */
    public NewSchedule() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 * NewSchedule.jspの呼び出し及び値の受け渡しを行う。
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	// TODO Auto-generated method stub
		// 呼び出し元Jspからデータ受け取り
		request.setCharacterEncoding("UTF8");

        int year;
        int month;
        int day = 1;

        // 年データを取得
        String param =  request.getParameter("YEAR");
        if (param == null || param.length() == 0){
            year = -999;
        }else{
            year = Integer.parseInt(param);
        }

        // 月データを取得
        param =  request.getParameter("MONTH");
        if (param == null || param.length() == 0){
            month = -999;
        }else{
            month = Integer.parseInt(param);
        }

        // 日データを取得
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

        String[] scheduleArray = new String[49];
        int[] widthArray = new int[49];

        for (int i = 0 ; i < 49 ; i++){
            scheduleArray[i] = "";
            widthArray[i] = 0;
        }

        try {
            String sql = "SELECT * FROM schedule WHERE userid = ? and scheduledate = ? ORDER BY starttime";
            PreparedStatement pstmt = conn.prepareStatement(sql);

            String startDateStr = year + "-" + (month + 1) + "-" + day;
            pstmt.setInt(1, 1);
            pstmt.setString(2, startDateStr);

            ResultSet rs = pstmt.executeQuery();

            while(rs.next()){
                String starttime = rs.getString("starttime");
                String endtime = rs.getString("endtime");
                String schedule = rs.getString("schedule");

                if (starttime == null || endtime == null){
                    widthArray[0] = 1;
                    scheduleArray[0] = scheduleArray[0] + schedule + "<br>";
                }else{
                    String startTimeStr = starttime.substring(0, 2);
                    String startMinuteStr = starttime.substring(3, 5);

                    int startTimeNum = Integer.parseInt(startTimeStr);
                    int index = startTimeNum * 2 + 1;
                    if (startMinuteStr.equals("30")){
                        index++;
                    }

                    if (widthArray[index] == 0){
                    /* 既にデータが入っていた場合は異常な状態なので無視する */

                        String endTimeStr = endtime.substring(0, 2);
                        String endMinuteStr = endtime.substring(3, 5);

                        int endTimeNum = Integer.parseInt(endTimeStr);
                        int width = (endTimeNum - startTimeNum) * 2;

                        if (startMinuteStr.equals("30")){
                            width--;
                        }

                        if (endMinuteStr.equals("30")){
                            width++;
                        }

                        String totalTime = startTimeStr + ":" + startMinuteStr + "-" + endTimeStr + ":" + endMinuteStr + " ";
                        scheduleArray[index] = totalTime + schedule;
                        widthArray[index] = width;

                        /* 同じスケジュールの先頭以外の箇所には「-1」を設定 */
                        for (int i = 1 ; i < width ; i++){
                            widthArray[index + i] = -1;
                        }
                    }
                }
            }

            rs.close();
            pstmt.close();

        }catch (SQLException e){
            log("SQLException:" + e.getMessage());
        }


		// 呼び出し先Jspに渡すデータセット
		request.setAttribute("YEAR", year);
		request.setAttribute("MONTH", month);
		request.setAttribute("DAY", day);
		request.setAttribute("SCHEDULE", scheduleArray);
		request.setAttribute("WIDTH", widthArray);

		// result.jsp にページ遷移
		RequestDispatcher dispatch = request.getRequestDispatcher("NewSchedule.jsp");
		dispatch.forward(request, response);
	}

}

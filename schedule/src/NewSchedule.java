import java.io.IOException;
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


		// 呼び出し先Jspに渡すデータセット
		request.setAttribute("YEAR", year);
		request.setAttribute("MONTH", month);
		request.setAttribute("DAY", day);

		// result.jsp にページ遷移
		RequestDispatcher dispatch = request.getRequestDispatcher("NewSchedule.jsp");
		dispatch.forward(request, response);
	}

}

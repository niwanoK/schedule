<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.Calendar" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
            <title>スケジュール管理</title>
    </head>
    <body>
        <style>
            table{
                border:1px solid #a9a9a9;
                width:90%;
                padding:0px;
                margin:0px;
                border-collapse:collapse;
            }
            td{
                width:12%;
                border-top:1px solid #a9a9a9;
                border-left:1px solid #a9a9a9;
                vertical-align:top;
                margin:0px;
                padding:2px;
            }
            td.week{
                background-color:#f0f8ff;
                text-align:center;
            }
            td.day{
                background-color:#f5f5f5;
                text-align:right;
                font-size:0.75em;
            }
            td.otherday{
                background-color:#f5f5f5;
                color:#d3d3d3;
                text-align:right;
                font-size:0.75em;
            }
            td.sche{
                background-color:#fffffff;
                text-align:left;
                height:80px;
            }
            img{
                border:0px;
            }
            span.small{
                font-size:0.75em;
            }
        </style>
        <script language="JavaScript">

        </script>
<%
            int[] calendarDay = new int[42]; /* 最大で7日×6週 */
            int count = 0;
            int year;
            int month;
            int day = 1;

            String param =  request.getParameter("YEAR");
            if (param == null || param.length() == 0){
                year = -999;
            }else{
                year = Integer.parseInt(param);
            }

            param =  request.getParameter("MONTH");
            if (param == null || param.length() == 0){
                month = -999;
            }else{
                month = Integer.parseInt(param);
            }

            /* パラメータが指定されていない場合は本日の日付を設定 */
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
            int nowWeekCount = 0;

            /* 今月が何曜日から開始されているか確認する */
            calendar.set(year, month, 1);
            int startWeek = calendar.get(Calendar.DAY_OF_WEEK);
            System.out.println("今月の曜日は" + startWeek + "から");

            /* 先月が何日までだったかを確認する */
            calendar.set(year, month, 0);
            int beforeMonthlastDay = calendar.get(Calendar.DATE);
            System.out.println("先月は" + beforeMonthlastDay + "日まで");

            /* 今月が何日までかを確認する */
            calendar.set(year, month + 1, 0);
            int thisMonthlastDay = calendar.get(Calendar.DATE);
            System.out.println("今月は" + thisMonthlastDay + "日まで\r\n");

            /* 先月分の日付を格納する */
            for (nowWeekCount = startWeek - 2 ; nowWeekCount >= 0 ; nowWeekCount--){
                calendarDay[count++] = beforeMonthlastDay - nowWeekCount + 35;
            }

            /* 今月分の日付を格納する */
            for (nowWeekCount = 1 ; nowWeekCount <= thisMonthlastDay ; nowWeekCount++){
                calendarDay[count++] = nowWeekCount;
            }

            /* 翌月分の日付を格納する */
            int nextMonthDay = 1;
            while (count % 7 != 0){
                calendarDay[count++] = 35 + nextMonthDay++;
            }
%>
        <p>
            <a href="/schedule/MonthView.jsp?YEAR=<%= year %>&MONTH=<%= month - 1 %>"><span class="small">前月</span></a>
                <%= year %>年
                <%= month + 1 %>月
            <a href="/schedule/MonthView.jsp?YEAR=<%= year %>&MONTH=<%= month + 1 %>"><span class="small">翌月</span></a>
        </p>
        <table>
            <tr>
                <td class="week">日</td>
                <td class="week">月</td>
                <td class="week">火</td>
                <td class="week">水</td>
                <td class="week">木</td>
                <td class="week">金</td>
                <td class="week">土</td>
            </tr>
<%
            int weekCount = count / 7;
            StringBuffer sb = new StringBuffer();

            for (int i = 0 ; i < weekCount ; i++){
                /* スケジュールの日付画面を作成する */
                sb.append("<tr>");

                for (int j = i * 7 ; j < i * 7 + 7 ; j++){
                    if (calendarDay[j] > 35){
                        sb.append("<td class=\"otherday\">");
                        sb.append(calendarDay[j] - 35);
                    }else{
                        sb.append("<td class=\"day\">");
                        sb.append(calendarDay[j]);
                    }
                    sb.append("</td>");
                }

                sb.append("</tr>");

                /* カレンダーのスケジュール登録画面を作成する */
                sb.append("<tr>");

                for (int j = (i * 7) ; j < (i * 7) + 7 ; j++){
                    if (calendarDay[j] > 35){
                        /* 前月及び翌月の箇所にはアイコンは表示しない */
                        sb.append("<td class=\"sche\"></td>");
                    }else{
                        sb.append("<td class=\"sche\">");
                        sb.append("<a href=\"/schedule/NewSchedule.jsp");

                        /* パラメータの作成 */
                        sb.append("?YEAR=");
                        sb.append(year);
                        sb.append("&MONTH=");
                        sb.append(month);
                        sb.append("&DAY=");
                        sb.append(calendarDay[j]);

                        sb.append("\">");
                        sb.append("<img src=\"./img/memo.jpg\" width=\"14\" height=\"16\">");
                        sb.append("</a>");
                        sb.append("</td>");
                    }
                    sb.append("</td>");
                }

                sb.append("</tr>");
            }
            out.println(new String(sb));
%>

        </table>
    </body>
</html>
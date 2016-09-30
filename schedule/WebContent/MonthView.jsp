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
    int count = 0; /* カレンダー配列の番号 */
    int year;    /* 年 */
    int month;   /* 月 */
    int day = 1; /* 日 */

    /* ---日付データを取得し、変数へ格納--- */
    /* 年データを取得(値が取得できない場合は無効値を代入) */
    String param =  request.getParameter("YEAR");
    if (param == null || param.length() == 0){
        year = -999;
    }else{
        year = Integer.parseInt(param);
    }

    /* 月データを取得(値が取得できない場合は無効値を代入) */
    param =  request.getParameter("MONTH");
    if (param == null || param.length() == 0){
        month = -999;
    }else{
        month = Integer.parseInt(param);
    }

    /* ---パラメータが指定されていない場合は本日の日付を設定--- */
    if (year == -999 || month == -999){
        Calendar calendar = Calendar.getInstance();
        year = calendar.get(Calendar.YEAR);
        month = calendar.get(Calendar.MONTH);
        day = calendar.get(Calendar.DATE);
    }else{
    	/* 月が次年へ跨いでいる場合、年を次年にする */
        if (month == 12){
            month = 0;
            year++;
        }

        /* 月が前年へ跨いでいる場合、年を前年にする */
        if (month == -1){
            month = 11;
            year--;
        }
    }

    String[] paramArray = new String[31];
    paramArray = (String[])request.getAttribute("SCHEDULEDATA");
    if (paramArray == null) {
    	paramArray = new String[31];
    	for (int i =0; i < paramArray.length; i++) {
    		paramArray[i] = "";
    	}
    }

    /* ---日付データを配列に格納--- */
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
            <!-- 前月/翌月のリンクを作成 -->
            <a href="/schedule/MonthView?YEAR=<%= year %>&MONTH=<%= month - 1 %>"><span class="small">前月</span></a>
                <%= year %>年
                <%= month + 1 %>月
            <a href="/schedule/MonthView?YEAR=<%= year %>&MONTH=<%= month + 1 %>"><span class="small">翌月</span></a>
        </p>
        <!-- スケジュール表(大枠の作成) -->
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
<%int weekCount = count / 7;
  StringBuffer sb = new StringBuffer();
  for (int i = 0 ; i < weekCount ; i++){%>
            <!-- スケジュールの日付画面を作成する -->
            <tr>
<%    for (int j = i * 7 ; j < i * 7 + 7 ; j++){
          if (calendarDay[j] > 35){%>
                <td class="otherday"><%= calendarDay[j] - 35%>
<%        }else{%>
                <td class="day"><%= calendarDay[j]%>
<%        }%>
                </td>
<%    }%>

            </tr>
            <!--  カレンダーのスケジュール登録画面を作成する -->
            <tr>

<%    for (int j = (i * 7) ; j < (i * 7) + 7 ; j++){
          if (calendarDay[j] > 35){%>
                <!-- 前月及び翌月の箇所にはアイコンは表示しない -->
                <td class="sche">
<%        }else{%>
                <!-- 前月及び翌月の箇所にはアイコンを表示する -->
                <td class="sche">
                    <a href="/schedule/NewSchedule?YEAR=<%= year%>&MONTH=<%= month%>&DAY=<%= calendarDay[j]%>">
                        <img src="./img/memo.jpg" width="14" height="16">
                    </a>
                    <span class="small">
<%            if (paramArray[calendarDay[j]] != null && paramArray[calendarDay[j]] != "" && calendarDay[j] <= thisMonthlastDay){%>
                    <%= paramArray[calendarDay[j]]%>
<%            }
          }%>
                    </span>
                </td>
<%    }%>

            </tr>
<%}%>
        </table>
        <p><a href="/schedule/top.jsp">トップヘ戻る</a></p>
    </body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.Calendar" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>スケジュール登録</title>
    </head>
    <body>
        <style>
            table.sche{
                border:1px solid #a9a9a9;
                padding:0px;
                margin:0px;
                border-collapse:collapse;
            }
            td{
                vertical-align:top;
                margin:0px;
                padding:2px;
                font-size:0.75em;
                height:20px;
            }
            td.top{
                border-bottom:1px solid #a9a9a9;
                text-align:center;
            }
            td.time{
                background-color:#f0f8ff;
                text-align:right;
                border-right:1px double #a9a9a9;
                padding-right:5px;
            }
            td.timeb{
                background-color:#f0f8ff;
                border-bottom:1px solid #a9a9a9;
                border-right:1px double #a9a9a9;
            }
            td.contents{
                background-color:#ffffff;
                border-bottom:1px dotted #a9a9a9;
            }
            td.contentsb{
                background-color:#ffffff;
                border-bottom:1px solid #a9a9a9;
            }
            td.ex{
                background-color:#ffebcd;
                border:1px solid #8b0000;
            }
            img{
                border:0px;
            }
            p{
                font-size:0.75em;
            }

            #contents{
                margin:0;
                padding:0;
                width:710px;
            }
            #left{
                margin:0;
                padding:0;
                float:left;
                width:400px;
            }
            #right{
                margin:0;
                padding:0;
                float:right;
                width:300px;
                background-color:#ffffff;
            }
            #contents:after{
                content:\".\";
                display:block;
                height:0;
                clear:both;
                visibility:hidden;
            }
        </style>
        <script language="JavaScript">

        </script>
<%
    int year;    /* 年 */
    int month;   /* 月 */
    int day;     /* 日 */

    /* 年データの取得(値が取得できない場合は無効値を代入) */
    String param = request.getParameter("YEAR");
    if (param == null || param.length() == 0){
        year = -999;
    }else{
        year = Integer.parseInt(param);
    }

    /* 月データの取得(値が取得できない場合は無効値を代入) */
    param = request.getParameter("MONTH");
    if (param == null || param.length() == 0){
        month = -999;
    }else{
        month = Integer.parseInt(param);
    }

    /* 日データの取得(値が取得できない場合は無効値を代入) */
    param = request.getParameter("DAY");
    if (param == null || param.length() == 0){
        day = -999;
    }else{
        day = Integer.parseInt(param);
    }

    /* パラメータが指定されていない場合は本日の日付を設定 */
    if (year == -999 || month == -999 || day == -999){
        Calendar calendar = Calendar.getInstance();
        year = calendar.get(Calendar.YEAR);
        month = calendar.get(Calendar.MONTH);
        day = calendar.get(Calendar.DATE);
    }

    String[] scheduleArray;
    scheduleArray = (String[])request.getAttribute("SCHEDULE");
    if (scheduleArray == null) {
        scheduleArray = new String[49];
        for (int i =0; i < scheduleArray.length; i++) {
            scheduleArray[i] = "";
        }
    }

    int[] widthArray;
    widthArray = (int[])request.getAttribute("WIDTH");
    if (widthArray == null) {
    	widthArray = new int[49];
        for (int i =0; i < widthArray.length; i++) {
        	widthArray[i] = 0;
        }
    }
%>
        <p>
            スケジュール登録
            <!-- カレンダー表示画面へのリンクを作成 -->
            [<a href="/schedule/MonthView?YEAR=<%= year %>&MONTH=<%= month %>">カレンダーへ戻る</a>]
        </p>
        <div id="contents">
            <!-- (左側)時刻毎の予定表を作成 -->
            <div id="left">
                <table class="sche">
                    <tr><td class="top" style="width:80px">時刻</td><td class="top" style="width:300px">予定</td></tr>
                    <tr>
                        <td class="timeb">未定</td>
                        <td class="contentsb">
<%if (widthArray[0] == 1){%>
                        <%= scheduleArray[0]%>
<%}%>
                        </td>
                    </tr>
<%for (int i = 1 ; i < 49 ; i++){
      if (i % 2 == 1){%>
                    <tr>
                        <td class="time"><%= i / 2 %>:00</td>
<%    } else {%>
                    <tr>
                        <td class="timeb"></td>
<%    }
      if (widthArray[i] != 0){
    	  if (widthArray[i] != -1){%>
    	                <td class="ex" rowspan="<%= widthArray[i] %>"><%= scheduleArray[i] %>
<%        }
      }else {
          if (i % 2 == 1){%>
                        <td class="contents"></td>
<%        } else {%>
                        <td class="contentsb"></td>
<%        }
      }%>
                    </tr>
<%}%>
                </table>
            </div>
            <!-- (右側)スケジュール表示/登録欄を作成 -->
            <div id="right">
                <form method="post" action="/schedule/ScheduleDataInsert">
                    <table>
                        <tr>
                            <!-- 日付表示/選択欄を作成 -->
                            <td nowrap>日付</td>
                            <td>
                                <select name="YEAR">
<%for (int i = 2005 ; i <= 2030 ; i++){%>
                                    <option value="<%= i %>"
<%  if (i == year){%>
                                    selected
<%  }%>
                                    ><%= i %>年
<%}%>
                                </select>
                                <select name="MONTH">
<%for (int i = 1 ; i <= 12 ; i++){%>
                                    <option value="<%= i %>"
<%  if (i == (month + 1)){%>
                                    selected
<%  }%>
                                    ><%= i %>月
<%}%>
                                </select>
                                <select name="DAY">
<%
Calendar calendar = Calendar.getInstance();
/* 今月が何日までかを確認する */
calendar.set(year, month + 1, 0);
int monthLastDay = calendar.get(Calendar.DATE);
%>
<%for (int i = 1 ; i <= monthLastDay ; i++){%>
                                    <option value="<%= i %>"
<%  if (i == day){%>
                                    selected
<%  }%>
                                    ><%= i %>日
<%}%>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <!-- 時刻表示/選択欄を作成 -->
                            <td nowrap>時刻</td>
                            <td>
                                <select name="SHOUR">
                                    <option value="" selected>--時
<%for (int i = 0 ; i <= 23 ; i++){%>
                                    <option value="<%= i %>"><%= i %>時
<%}%>
                                </select>
                                <select name="SMINUTE">
                                     <option value="0">00分
                                    <option value="30">30分
                                </select>
                                    --
                                <select name="EHOUR">
                                    <option value="" selected>--時
<%for (int i = 0 ; i <= 23 ; i++){%>
                                    <option value="<%= i %>"><%= i %>時
<%}%>
                                </select>
                                <select name="EMINUTE">
                                    <option value="0">00分
                                    <option value="30">30分
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <!-- 予定表示/記入欄を作成 -->
                            <td nowrap>予定</td>
                            <td><input type="text" name="PLAN" value="" size="30" maxlength="100"></td>
                        </tr>
                        <tr>
                            <!-- メモ表示/記入欄を作成 -->
                            <td valign="top" nowrap>メモ</td>
                            <td><textarea name="MEMO" cols="30" rows="10" wrap="virtual"></textarea></td>
                        </tr>
                    </table>
                    <p>
                        <!-- 登録ボタンを作成 -->
                        <input type="submit" name="Register" value="登録する">
                        <!-- リセットボタンを作成 -->
                        <input type="reset" value="入力し直す">
                    <p>
                </form>
            </div>
        </div>
    </body>
</html>
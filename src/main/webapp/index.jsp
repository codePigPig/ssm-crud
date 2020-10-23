<%--
  Created by IntelliJ IDEA.
  User: codepigpig
  Date: 2020/10/22
  Time: 22:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
    <title>员工列表</title>

    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>

    <%--   web路径：
                不以/开始的相对路径，找资源是以当前资源的路径为基准，经常容易出问题
                而以/开始的相对路径，是以服务器的路径为标注的（http://localhost:3306），需要加上项目名
                        http://localhost:3306/crud
       --%>
    <script src="${APP_PATH}/static/js/jquery-3.1.1.js"></script>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
<%-- 搭建显示页面 --%>
<div class="container">
    <%-- 标题 --%>
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <%-- 按钮 --%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary">新增</button>
            <button class="btn btn-danger">删除</button>
        </div>
    </div>
    <%-- 显示表格数据 --%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>

                </tbody>


            </table>
        </div>
    </div>
    <%-- 显示分页信息 --%>
    <div class="row">
        <%-- 分页文字信息 --%>
        <div class="col-md-6" id="page_info_area">

        </div>


        <%-- 分页条 --%>
        <div class="col-md-6" id="page_nav_area">


        </div>
    </div>
</div>
    <script type="text/javascript">
        //1.页面加载完成以后，直接去发送一个ajax请求，要到分页数据
        $(function (){
            //去首页
            to_page(1);
        });

        //将请求ajax做成一个功能类
        function to_page(pn){
            $.ajax({
                url:"${APP_PATH}/emps",
                data:"pn="+pn,
                type:"GET",
                success:function (result){
                    // console.log(result);
                    //1、解析并显示员工数据
                    build_emps_table(result);
                    //2、解析并显示分页信息
                    build_page_info(result);
                    //3、解析并显示分页条
                    build_page_nav(result);

                }
            })
        }

        //解析查询数据
        function build_emps_table(result){
            //清空表格
            $("#emps_table tbody").empty();
            var emps = result.extendData.pageInfo.list;
            $.each(emps,function (index,item){
                // alert(item.empName);
                var empIdTd = $("<td></td>").append(item.empId);
                var empNameTd = $("<td></td>").append(item.empName);
                var genderTd = $("<td></td>").append(item.gender=='M'?"男":"女");
                var emailTd = $("<td></td>").append(item.email);
                var departmentTd = $("<td></td>").append(item.department.deptName);


                 /*<button class="btn btn-primary btn-sm">
                    <span class="glyphicon glyphicon-pencil " aria-hidden="true"></span>
                编辑</button>*/
                //编辑按钮和删除按钮
                var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm")
                                .append("<span></span>").addClass("glyphicon glyphicon-pencil")
                                .append("编辑");
                var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm")
                                .append("<span></span>").addClass("glyphicon glyphicon-trash")
                                .append("删除");
                var btnId = $("<td></td>").append(editBtn).append(" ").append(delBtn);

                //append方法执行完成以后还是返回原来的元素
                $("<tr></tr>")
                    .append(empIdTd)
                    .append(empNameTd)
                    .append(genderTd)
                    .append(emailTd)
                    .append(departmentTd)
                    .append(btnId)
                    .appendTo("#emps_table tbody");
            })
        }
        //解析显示分页信息
        function build_page_info(result){
            $("#page_info_area").empty();
            /*显示当前页、总页数、总条记录*/
            var page_Num = result.extendData.pageInfo.pageNum;
            var page_Pages = result.extendData.pageInfo.pages;
            var page_Total = result.extendData.pageInfo.total;

            // $("<p></p>").append("当前 "+page_Num+" 页，总 "+page_Pages+" 页，总 "+page_Total+" 条记录")
            //     .appendTo("#page_info_area");

            $("#page_info_area").append("当前 "+page_Num+" 页，总 "+page_Pages+" 页，总 "+page_Total+" 条记录");
        }
        //解析显示分页条
        function build_page_nav(result){
            //先删除分页条信息，再添加
            $("#page_nav_area").empty();
            //page_nav_area
            var ul = $("<ul></ul>").addClass("pagination");

            //构建元素
            var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
            var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));

            //判断首页和前一页是否有数据，如果没有，就无法选择
            if (result.extendData.pageInfo.hasPreviousPage == false){
                firstPageLi.addClass("disabled");
                prePageLi.addClass("disabled");
            }else {
                //为元素添加点击翻页的事件
                firstPageLi.click(function (){
                    to_page(1);
                });
                //上一页的点击事件
                prePageLi.click(function (){
                    to_page(result.extendData.pageInfo.pageNum -1);
                });
            }


            var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
            var lastPageLi = $("<li></li>").append($("<a></a>").append("尾页").attr("href","#"));

            //判断末页和下一页是否有数据，如果没有，就无法选择
            if (result.extendData.pageInfo.hasNextPage == false){
                nextPageLi.addClass("disabled");
                lastPageLi.addClass("disabled");
            }else {
                //为元素添加点击翻页的事件
                lastPageLi.click(function (){
                    to_page(result.extendData.pageInfo.pages);
                });
                //下一页的点击事件
                nextPageLi.click(function (){
                    to_page(result.extendData.pageInfo.pageNum +1);
                });
            }




            //添加首页和前一页的提示
            // ul.append(firstPageLi).append(prePageLi);
            ul.append(firstPageLi).append(prePageLi);
            //1,2,3,4,5便利给ul中添加页码提示
            var page_nums = result.extendData.pageInfo.navigatepageNums;
            $.each(page_nums,function (index,item){
                var numLi = $("<li></li>").append($("<a></a>").append(item));
                if (result.extendData.pageInfo.pageNum == item){
                    numLi.addClass("active");
                }
                numLi.click(function (){
                    to_page(item);
                });
                ul.append(numLi);
            });
            //添加下一页和末页的提示
            ul.append(nextPageLi).append(lastPageLi);

            //将ul加入到nav中
            var navEle = $("<nav></nav>").append(ul);
            navEle.appendTo("#page_nav_area");

            // var navEle = $("<nav></nav>").append(ul).appendTo("#page_nav_area");
        }
    </script>

</body>
</html>

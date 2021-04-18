<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- use EL-Expression-->
<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <!-- 引入CSS -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery-3.4.1.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
    <link href="${pageContext.request.contextPath}/static/layui/css/layui.css" rel="stylesheet">
</head>
<body>


<div id="head_tool">
    <div class="layui-form-item">
        <div class="layui-input-inline">
            <input id="search_admin" type="text" name="name"  placeholder="请输入管理员姓名"  class="layui-input">
        </div>
        <button class="layui-btn" id="search" lay-submit lay-filter="searche_btn">搜索</button>
    </div>
</div>

<!-- 管理员列表信息 -->
<table class="layui-hide" id="adminList" lay-filter="adminList"></table>
<!-- 表格操作按钮集 -->
<script type="text/html" id="toolbar">
    <button type="button" class="layui-btn layui-btn-sm" lay-event="edit"> <i class="layui-icon">&#xe642;</i></button>
    <button type="button" class="layui-btn layui-btn-sm" lay-event="del"><i class="layui-icon">&#xe640;</i>
    </button>
</script>

<script type="text/html" id="head_toolbar">
    <button class="layui-btn layui-btn-normal layui-btn-sm data-add-btn" lay-event="add"> 添加 </button>

    <button class="layui-btn layui-btn-sm layui-btn-danger data-delete-btn" lay-event="batchdelete"> 批量删除 </button>
    <button class="layui-btn layui-btn-normal layui-btn-sm data-add-btn" lay-event="refresh"> 刷新页面 </button>

</script>





<script type="text/javascript">

    function getUserName(){
        var userType="<%=session.getAttribute("userType")%>";
        var name="<%=session.getAttribute("userName")%>";
        return name;
    }

    $(function () {
        //获取到用户的登录名
        var userName = getUserName();

        layui.use(['element','table','form','jquery','layer','upload'], function() {
            var $ = layui.jquery;//jQuery
            var form = layui.form;//表单
            var table = layui.table;//表格
            var element = layui.element;//元素
            var layer = layui.layer;//弹出层
            var upload = layui.upload;//上传

            //加载表格
            var tableIns = table.render({
                elem:"#adminList",
                url:"${pageContext.request.contextPath}/admin/getAllAminList",
                height: '400' ,
                toolbar:'#head_toolbar',
                method:'post',
                cols:[[
                    {type: 'checkbox', fixed: 'left'},
                    {field: 'id', title: 'ID', width: 90, sort: true},
                    {field: 'name', title: '姓名', width: 100},
                    {field: 'gender', title: '性别', width: 70},
                    {field: 'email', title: '邮箱', width: 200},
                    {field: 'telephone', title: '电话', width: 150},
                    {field: 'address', title: '地址', width: 200},
                    {field:'toolbar',title:'操作',width:400,toolbar: '#toolbar'}
                ]],
                id: 'testReload',
                even: true, //隔行背景
                event: true,
                page: true,
                skin:'row',
                limit:10,
                limits:[10,15,20,25]

            });


            //搜索框搜索管理员信息，重载
            form.on('submit(searche_btn)', function (data) {
                var name = $("#search_admin").val();
                console.log(name);
                /**
                 * 数据表格的重载功能
                 */
                table.reload('testReload', {
                    method: 'post',
                    url:"${pageContext.request.contextPath}/admin/getAllAminList?name="+name,
                    page: {
                        curr: 1 // 重载后从第一页开始
                    }
                });
                return false;
            });


            //监听head_toolbar工具条
            table.on('toolbar(adminList)', function(obj){ //注：tool 是工具条事件名，test 是 table 原始容器的属性 lay-filter="对应的值"
                var data = obj.data; //获得当前行数据
                var checkData = table.checkStatus(obj.config.id).data;
                var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
                var tr = obj.tr; //获得当前行 tr 的 DOM 对象（如果有的话）
                console.log("data:"+data);
                //超级管理员admin添加管理员
                    if(layEvent === 'add'){ //添加
                        if (userName=="admin") {
                            layer.open({
                                type: 1,
                                title: '添加管理员信息',
                                content: $("#addDialog"),
                                area: ['1000px', '450px'],
                                maxmin: true,
                                offset: 'lt'

                            });
                        }else {
                            layer.msg("您不是超级管理员admin，无法添加新的管理员！");
                        }
                    }else if(layEvent === 'refresh'){ //刷新
                        table.reload('testReload', {
                            method: 'post',
                            url:"${pageContext.request.contextPath}/admin/getAllAminList?name="+name,
                            page: {
                                curr: 1 // 重载后从第一页开始
                            }
                        });
                        return false;
                    } else if (layEvent == "batchdelete"){
                        if (userName=="admin") {
                        if (checkData.length === 0) {
                            return layer.msg('请选择数据');
                        }
                        layer.confirm('确定删除选中的数据吗？', function(index) {
                            var idList = "";
                            for (var i = 0; i < checkData.length; i++) {
                                idList += "," + checkData[i].id;
                            }
                            $.ajax({
                                url: "${pageContext.request.contextPath}/admin/batchDelete",
                                type: 'POST',
                                data: {"ids": idList.substring(1)},
                                dataType: "json",
                                success: function (result) {
                                    var data = result;
                                    var resultCode = data.code;
                                    var errorMsg = data.msg;
                                    if (resultCode == '200') {
                                        layer.close(index);
                                        tableIns.reload();

                                    } else {
                                        layer.msg(errorMsg);
                                    }
                                },
                                error: function (xhr, erroType, error, msg) {
                                    layer.msg('删除成功！');
                                }
                            });


                        });
                    }
                    }

            });


            //监听工具条
            table.on('tool(adminList)', function(obj){ //注：tool 是工具条事件名，test 是 table 原始容器的属性 lay-filter="对应的值"
                var data = obj.data; //获得当前行数据
                var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
                var tr = obj.tr; //获得当前行 tr 的 DOM 对象（如果有的话）
                console.log("data:"+data);
                //获取到表里的name
                var tab_name = data.name;

                if(layEvent === 'del'){ //删除
                    //获取到点击的行id
                    var id = data.id;
                    //获取到的值和登录名是否相同
                    if (tab_name==userName){
                        layer.msg("您无法删除您自己的信息！");
                    }else if (userName=="admin") {
                        layer.confirm('真的删除第'+id+'行信息么', function(index){
                            obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
                            layer.close(index);
                            //向服务端发送删除指令
                            $.ajax({
                                type:'post',
                                url:"${pageContext.request.contextPath}/admin/delete?id="+id,
                                success:function (data) {
                                    if (data.code==200){
                                        layer.msg(data.msg);
                                        tableIns.reload();
                                    }

                                }
                            });
                        });
                    }else {
                        layer.msg("您没有权限删除他人信息,如果想要，请联系超级管理员admin！");
                    }

                } else if(layEvent === 'edit') { //编辑
                    var data = obj.data;
                    console.log(data.id);
                    //信息相同允许修改,或者是超级管理员
                    if (tab_name==userName||userName=="admin"){
                        layer.open({
                            type:1,
                            title:'修改管理员信息',
                            content:$("#editDialog"),
                            area: ['1000px', '500px'],
                            offset: 'lt',
                            maxmin: true,
                            success : function(layero, index) {
                                $("#EditId").val(data.id);
                                $("#EditName").val(data.name);
                                $("#EditTel").val(data.telephone);
                                $("#EditAddress").val(data.address);
                                $("#EditEmail").val(data.email);
                                $("input[name=gender][value=男]").attr("checked", data.gender == "男" ? true : false);
                                $("input[name=gender][value=女]").attr("checked", data.gender == "女" ? true : false);
                                form.render(); //更新全部
                            },

                        });
                    }else {
                        layer.msg("您没有修改他人信息的权限，如果想要，请联系超级管理员admin！")
                    }

                }



            });

        });


    });


</script>



<!-- 添加信息窗口 -->
<div id="addDialog"  style="display:none;">
    <!-- 管理员信息表单 -->
    <form id="addForm" class="layui-form" action="${pageContext.request.contextPath}/admin/add" method="post">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">管理员姓名</label>
                <div class="layui-input-inline">
                    <input type="text" name="name" lay-verify="required" lay-reqtext="用户名是必填项，岂能为空？" placeholder="请输入用户名" autocomplete="off" class="layui-input">
                </div>
            </div>

            <div class="layui-inline">
                <label class="layui-form-label">密码</label>
                <div class="layui-input-inline">
                    <input type="password" name="password" lay-verify="pass" placeholder="请输入密码" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux">请填写6到12位密码</div>
            </div>

        </div>

        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">电话</label>
                <div class="layui-input-inline">
                    <input type="tel" name="telephone" lay-verify="required|phone" placeholder="请输入电话" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">邮箱</label>
                <div class="layui-input-inline">
                    <input type="text" name="email" lay-verify="email" placeholder="请输入邮箱" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">地址</label>
                <div class="layui-input-inline">
                    <input type="text" name="address"  placeholder="请输入地址" autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>



        <div class="layui-form-item">
            <label class="layui-form-label">性别</label>
            <div class="layui-input-block">
                <input type="radio" name="gender" value="男" title="男" checked="checked">
                <input type="radio" name="gender" value="女" title="女">
            </div>
        </div>


        <div class="layui-form-item">
            <div class="layui-input-block">
                <button type="submit" class="layui-btn" lay-submit="" lay-filter="submit_add">立即提交</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </form>
</div>


<!-- 修改信息窗口 -->
<div id="editDialog"  style="display:none;">
    <!-- 管理员信息表单 -->
    <form id="editForm" class="layui-form" action="${pageContext.request.contextPath}/admin/update" method="post">
        <input id="EditId" type="hidden" name="id">
        <div class="layui-form-item">
            <label class="layui-form-label">管理员姓名</label>
            <div class="layui-input-inline">
                <input type="text" id="EditName" name="name"  autocomplete="off" class="layui-input">
            </div>
        </div>


        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">电话</label>
                <div class="layui-input-inline">
                    <input type="tel" id="EditTel" name="telephone" lay-verify="required|phone" placeholder="请输入电话" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">邮箱</label>
                <div class="layui-input-inline">
                    <input type="text" id="EditEmail" name="email" lay-verify="email" placeholder="请输入邮箱" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">地址</label>
                <div class="layui-input-inline">
                    <input type="text" id="EditAddress" name="address"  placeholder="请输入地址" autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">性别</label>
            <div class="layui-input-block">
                <input type="radio" id="edit_gender_man" name="gender" value="男" title="男">
                <input type="radio" id="edit_gender_woman" name="gender" value="女" title="女">
            </div>
        </div>



        <div class="layui-form-item">
            <div class="layui-input-block">
                <button type="submit" class="layui-btn" lay-submit="" lay-filter="submit_add">立即提交</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </form>
</div>


</body>
</html>
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
            <label class="layui-form-label">班级 :</label>
            <div class="layui-input-block" >
                <select id="clazz" name="clazz" lay-filter="clazz" style="width: 190px;height:37px; border: 1px solid gold">
                    <option value="">请选择:</option>
                </select>
            </div>
        </div>
        <div class="layui-input-inline" style="margin-left: 125px">
            <input id="search_student" type="text" name="name"  placeholder="请输入学生姓名"  class="layui-input">
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
   <%-- <a class="layui-btn layui-btn-mini layui-btn-normal" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-mini layui-btn-danger" lay-event="del">删除</a>--%>
</script>

<script type="text/html" id="head_toolbar">
    <button class="layui-btn layui-btn-normal layui-btn-sm data-add-btn" lay-event="add"> 添加 </button>

    <button class="layui-btn layui-btn-sm layui-btn-danger data-delete-btn" lay-event="batchdelete"> 批量删除 </button>
    <button class="layui-btn layui-btn-normal layui-btn-sm data-add-btn" lay-event="refresh"> 刷新页面 </button>
<%--
    <a class="layui-btn layui-btn-mini layui-btn-normal" lay-event="refresh">刷新页面</a>
--%>
</script>



<style>
    #editIntro{
        min-height: 40px;
    }
</style>



<script type="text/javascript">

    //获取登录名的方法
    function getUserName(){
        var name="<%=session.getAttribute("userName")%>";
        return name;
    }
    //获取用户的类型
    function getUserType(){
        var Type="<%=session.getAttribute("userType")%>";
        return Type;
    }

    $(function () {
        //获取到用户的登录名
        var userName = getUserName();
        //获取到用户的登陆类型
        var uType = getUserType();

        layui.use(['element','table','form','jquery','layer','upload'], function() {
            var $ = layui.jquery;//jQuery
            var form = layui.form;//表单
            var table = layui.table;//表格
            var element = layui.element;//元素
            var layer = layui.layer;//弹出层
            var upload = layui.upload;

            //加载表格
            var tableIns = table.render({
                elem:"#adminList",
                url:"${pageContext.request.contextPath}/student/getStudentList",
                height: '400' ,
                toolbar:'#head_toolbar',
                method:'post',
                cols:[[
                    {type: 'checkbox', fixed: 'left'},
                    {field: 'id', title: 'ID', width: 90, sort: true},
                    {field: 'sno', title: '学号', width: 100},
                    {field: 'name', title: '姓名', width: 100},
                    {field: 'gender', title: '性别', width: 70},
                    {field: 'clazzName', title: '班级', width: 100},
                    {field: 'email', title: '邮箱', width: 200},
                    {field: 'telephone', title: '电话', width: 150},
                    {field: 'address', title: '地址', width: 200},
                    {field: 'introduction', title: '个人简介', width: 200},
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
                var name = $("#search_student").val();
                var clazz = $("#clazz option:selected").val();
                console.log(name+clazz);
                /**
                 * 数据表格的重载功能
                 */
                table.reload('testReload', {
                    method: 'post',
                    url:"${pageContext.request.contextPath}/student/getStudentList?studentName="+name+"&clazzName="+clazz,
                    page: {
                        curr: 1 // 重载后从第一页开始
                    }
                });
                return false;
            });

            //获取所有班级列表
            $.ajax({
                url: '${pageContext.request.contextPath}/clazz/getAll',
                dataType: 'json',
                type: 'post',
                success: function (data) {
                    $.each(data.data, function (index, item) {
                        //value和值
                        $('#clazz').append(new Option(item.name, item.name));// 下拉菜单里添加元素
                        $('#clazz_add').append(new Option(item.name, item.name));
                        $('#clazz_edit').append(new Option(item.name, item.name));
                    });
                    layui.form.render("select");
                }
            })



            //监听head_toolbar工具条
            table.on('toolbar(adminList)', function(obj){ //注：tool 是工具条事件名，test 是 table 原始容器的属性 lay-filter="对应的值"
                var data = obj.data; //获得当前行数据
              /* var checkData = data.checkStatus("ids");*/

                var checkData = table.checkStatus(obj.config.id).data;
                var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
                var tr = obj.tr; //获得当前行 tr 的 DOM 对象（如果有的话）


                /*只有管理员和老师能够添加学生信息*/
                if(layEvent === 'add'){ //添加
                    if (uType==1||uType==2){
                        layer.open({
                            type:1,
                            title:'添加学生信息',
                            content:$("#addDialog"),
                            area: ['1000px', '470px'],
                            offset: 'lt',
                            maxmin: true

                        });
                    }else {
                        layer.msg("你是学生，没有新增学生的权限!")
                    }
                } else if(layEvent === 'refresh'){ //刷新
                    table.reload('testReload', {
                        method: 'post',
                        url:"${pageContext.request.contextPath}/student/getStudentList",
                        page: {
                            curr: 1 // 重载后从第一页开始
                        }
                    });
                    return false;
                } else if (layEvent == "batchdelete"){
                    if (uType==1||uType==2){


                    if (checkData.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    layer.confirm('确定删除选中的数据吗？', function(index) {
                        var idList = "";
                        for (var i = 0; i < checkData.length; i++) {
                            idList += "," + checkData[i].id;
                        }
                        $.ajax({
                            url: "${pageContext.request.contextPath}/student/deleteLists",
                            type: 'POST',
                            data: {"ids": idList.substring(1)},
                            dataType: "json",
                            success: function (result) {
                                var data = result;
                                var resultCode = data.code;
                                var errorMsg = data.msg;
                                if (resultCode == '200') {
                                    layer.close(index);
                                    table.reload('LAY-app-content-list');
                                    form.render();
                                } else {
                                    layer.msg(errorMsg);
                                }
                            },
                            error: function (xhr, erroType, error, msg) {
                                layer.msg('接口暂时不能访问，请联系管理员！');
                            }
                        });
                    });
                } else {
                        layer.msg("你是学生，没有删除学生的权限!")
                    }
            }
                }
            );

            //监听工具条
            table.on('tool(adminList)', function(obj){ //注：tool 是工具条事件名，test 是 table 原始容器的属性 lay-filter="对应的值"
                var data = obj.data; //获得当前行数据
                var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
                var tr = obj.tr; //获得当前行 tr 的 DOM 对象（如果有的话）
                console.log("data:"+data);

                //获取点击的行数信息
                var tab_name = data.name;
                if(layEvent === 'del'){ //删除
                    var id = data.id;
                    console.log("id:"+id);
                    //进行权限判断
                    if (uType==1||uType==2){
                        //管理员、教师有权限修改
                        layer.confirm('真的删除'+id+'行么', function(index){
                            obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
                            layer.close(index);
                            //向服务端发送删除指令
                            $.ajax({
                                type:'post',
                                url:"${pageContext.request.contextPath}/student/delete?id="+id,
                                success:function (data) {
                                    if (data.code==200){
                                        layer.msg(data.msg);
                                        tableIns.reload();
                                    }

                                }
                            });
                        });
                    }else {
                        if (userName==tab_name){
                            layer.msg("你无法删除自己的信息!");
                        }else{
                            layer.msg("您没有权限删除学生信息！");
                        }
                        
                    }

                } else if(layEvent === 'edit') { //编辑
                    var data = obj.data;
                    console.log(data.id);

                    //修改权限,有权修改
                    if (uType==1||uType==2||userName==tab_name){
                        layer.open({
                            type:1,
                            title:'修改管理员信息',
                            content:$("#editDialog"),
                            area: ['1000px', '470px'],
                            offset: 'lt',
                            maxmin: true,
                            success : function(layero, index) {
                                $("input[name=gender][value=男]").attr("checked", data.gender == "男" ? true : false);
                                $("input[name=gender][value=女]").attr("checked", data.gender == "女" ? true : false);
                                $("#EditId").val(data.id);
                                $("#editSno").val(data.sno);
                                $("#editName").val(data.name);
                                $("#editIntro").val(data.introduction);
                                $("#editTelphone").val(data.telephone);
                                $("#editEamil").val(data.email);
                                $("#editAddress").val(data.address);
                                $("#clazz_edit").val(data.clazzName);
                                //设置下拉框选中状态
                                $("#grade_edit").find("option[value="+data.clazzName+"]").prop("selected",true);
                                form.render(); //更新全部
                            },

                        });
                    }else {
                        layer.msg("你无法修改他人信息!")
                    }


                }
            });


    });


    });


</script>



<!-- 添加信息窗口 -->
<div id="addDialog"  style="display:none;">
    <!-- 管理员信息表单 -->
    <form id="addForm" class="layui-form" action="${pageContext.request.contextPath}/student/addStudent" method="post">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">学号</label>
                <div class="layui-input-inline">
                    <input type="text" name="sno" lay-verify="required" lay-reqtext="学号是必填项，岂能为空？" placeholder="请输入学号" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">学生姓名</label>
                <div class="layui-input-inline">
                    <input type="text" name="name" lay-verify="required" lay-reqtext="学生姓名是必填项，岂能为空？" placeholder="请输入学生姓名" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">密码</label>
                <div class="layui-input-inline">
                    <input type="password" name="password" lay-verify="pass" placeholder="请输入密码" autocomplete="off" class="layui-input">
                </div>
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
            <div class="layui-input-inline" style="width: 40%">
                <label class="layui-form-label">性别</label>
                <div class="layui-input-block">
                    <input type="radio" name="gender" value="男" title="男" checked="">
                    <input type="radio" name="gender" value="女" title="女">
                </div>
            </div>
            <div class="layui-input-inline">
                <label class="layui-form-label">班级 :</label>
                <div class="layui-input-block" style="width: 190px;height:37px; border: 1px solid beige">
                    <select id="clazz_add" name="clazzName" lay-filter="clazz">
                        <option value="">请选择:</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="layui-form-item layui-form-text">
            <label class="layui-form-label">个人简介</label>
            <div class="layui-input-block">
                <textarea  name="introduction" placeholder="请输入内容" class="layui-textarea" style="width: 60% ;height: 20%"></textarea>
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
    <form id="editForm" class="layui-form" action="${pageContext.request.contextPath}/student/updateStudent" method="post">
        <input id="EditId" type="hidden" name="id">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">学号</label>
                <div class="layui-input-inline">
                    <input type="text" id="editSno" name="sno" lay-verify="required" lay-reqtext="学号是必填项，岂能为空？" placeholder="请输入学号" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">学生姓名</label>
                <div class="layui-input-inline">
                    <input type="text" id="editName" name="name" lay-verify="required" lay-reqtext="学生姓名是必填项，岂能为空？" placeholder="请输入学生姓名" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">密码</label>
                <div class="layui-input-inline">
                    <input type="password" id="editPwd" name="password" lay-verify="pass" placeholder="请输入密码" autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">电话</label>
                <div class="layui-input-inline">
                    <input type="tel" id="editTelphone" name="telephone" lay-verify="required|phone" placeholder="请输入电话" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">邮箱</label>
                <div class="layui-input-inline">
                    <input type="text" id="editEamil" name="email" lay-verify="email" placeholder="请输入邮箱" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">地址</label>
                <div class="layui-input-inline">
                    <input type="text" id="editAddress" name="address"  placeholder="请输入地址" autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-input-inline" style="width: 30%">
                <label class="layui-form-label">性别</label>
                <div class="layui-input-block" >
                    <input type="radio" id="edit_gender_man" name="gender" value="男" title="男" checked="">
                    <input type="radio" id="edit_gender_woman" name="gender" value="女" title="女">
                </div>
            </div>
            <div class="layui-input-inline">
                <label class="layui-form-label">班级 :</label>
                <div class="layui-input-block" style="width: 190px;height:37px; border: 1px solid beige" >
                    <select id="clazz_edit" name="clazzName" lay-filter="clazz" >
                        <option value="">请选择:</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="layui-form-item layui-form-text">
            <label class="layui-form-label">个人简介</label>
            <div class="layui-input-block">
                <textarea id="editIntro" name="introduction" placeholder="请输入内容" class="layui-textarea" style="width: 60% ;height: 10px"></textarea>
            </div>
        </div>

       <%-- &lt;%&ndash;头像上传&ndash;%&gt;
        <input type="hidden" name="portraitPath" id="image">
        <div class="layui-form-item">
            <label class="layui-form-label">头像</label>
            <div class="layui-upload">
                <button type="button" class="layui-btn" id="test1">上传图片</button>
                <div class="layui-upload-list" style="margin-left: 110px">
                    <img class="layui-upload-img" id="demo1" width="100px" height="100px">
                    <p id="demoText"></p>
                </div>
            </div>
        </div>--%>

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
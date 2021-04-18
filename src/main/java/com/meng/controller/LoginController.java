package com.meng.controller;

import com.meng.model.Admin;
import com.meng.model.LoginForm;
import com.meng.model.Student;
import com.meng.model.Teacher;
import com.meng.service.impl.AdminServiceImpl;
import com.meng.service.impl.StudentServiceImpl;
import com.meng.service.impl.TeacherServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/system/")
public class LoginController {

    @Autowired
    private AdminServiceImpl adminImpl;
    @Autowired
    private StudentServiceImpl studentImpl;
    @Autowired
    private TeacherServiceImpl teacherImpl;
    @RequestMapping("/goLogin")
    public String goLogin(){
        return "system/login";
    }
    @RequestMapping("/goSystemMainView")
    public String goSystemMainView(){
        return "system/main";
    }

    @RequestMapping("login")
    @ResponseBody
    public Map<String,Object> userLogin(@RequestBody LoginForm loginForm, HttpServletRequest servletRequest){
        Map<String,Object> result = new HashMap<>();
        Integer userType = loginForm.getUserType();
        if (userType == 1){
            Admin admin = adminImpl.login(loginForm);
            try {
                if (admin != null){
                    HttpSession session = servletRequest.getSession();
                    session.setAttribute("user",admin);
                    session.setAttribute("userType",loginForm.getUserType());
                    session.setAttribute("userName",loginForm.getName());
                    result.put("success",true);
                    return result;
                }
            } catch (Exception e){
                e.printStackTrace();
                result.put("success",false);
                result.put("msg","登录失败");
                return  result;
            }

        } else if (userType == 3){
            Student student = studentImpl.login(loginForm);
            try {
                if (student != null){

                    HttpSession session = servletRequest.getSession();

                    session.setAttribute("user",student);
                    session.setAttribute("userType",loginForm.getUserType());
                    session.setAttribute("userName",loginForm.getName());

                    result.put("success",true);
                    return result;
                }
            } catch (Exception e){
                e.printStackTrace();

                result.put("success",false);
                result.put("msg","登录失败");
            }
        } else if (userType == 2){
            Teacher teacher = teacherImpl.login(loginForm);
            try {
                if (teacher != null){
                    HttpSession session = servletRequest.getSession();

                    session.setAttribute("user",teacher);
                    session.setAttribute("userName",loginForm.getName());
                    session.setAttribute("userType",loginForm.getUserType());

                    result.put("success",true);
                    return result;
                }
            } catch (Exception e){
                e.printStackTrace();
                result.put("success",false);
                result.put("msg","登录失败");
            }
        }
        result.put("success",false);
        result.put("msg","登录失败");
        return result;
    }
    @RequestMapping("/logout")
    public void loginOut(HttpServletRequest request, HttpServletResponse response) {
        request.getSession().removeAttribute("user");
        request.getSession().removeAttribute("userType");
        request.getSession().removeAttribute("userName");

        //注销后重定向到登录页面
        try {
            response.sendRedirect("../index.jsp");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

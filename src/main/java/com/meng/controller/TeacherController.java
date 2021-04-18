package com.meng.controller;


import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.meng.model.Student;
import com.meng.model.Teacher;
import com.meng.service.impl.TeacherServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/teacher/")
public class TeacherController {

    @Autowired
    private TeacherServiceImpl impl;



    @RequestMapping(value = "updateTeacherPassword", method = {RequestMethod.POST})
    public String updatePassword(Integer id, String password, HttpServletRequest request) {
        Teacher teacher = new Teacher();
        teacher.setId(id);
        teacher.setPassword(password);
        int i = impl.updatePassword(teacher);
        if (i > 0) {
            request.setAttribute("msg", 1);
            return "system/main";
        }
        return "error/404";
    }


    @RequestMapping(value = "goToTeacherPage", method = {RequestMethod.POST, RequestMethod.GET})
    public String goToAdminPage() {
        return "teacher/teacherList";
    }

    @RequestMapping(value = "findAllTeacher", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Map<String,Object> findAllTeacher(Integer page,Integer limit,String name,String clazz){
        HashMap<String, Object> result = new HashMap<>();
        Teacher teacher = new Teacher();
        teacher.setClazzName(clazz);
        teacher.setName(name);
        List<Teacher> allTeacher = impl.findAllTeacher(teacher);
        PageHelper.startPage(page,limit);
        PageInfo<Teacher> pageInfo = new PageInfo<>(allTeacher);
        long total = pageInfo.getTotal();
        List<Teacher> list = pageInfo.getList();
        result.put("data",list);
        result.put("msg","查询成功");
        result.put("code",0);
        result.put("count",total);
        return  result;
    }
    @RequestMapping(value = "add", method = {RequestMethod.POST, RequestMethod.GET})
    public String add(String tno,String name,String gender,String password,String email,String telephone,String address,String clazzName){
        Teacher teacher = new Teacher( tno, name, gender, password, email, telephone, address, clazzName);
        int add = impl.add(teacher);
        if (add > 0){
            return "teacher/teacherList";
        }
        return "error/404";
    }
    @RequestMapping(value = "delete", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Map<String,Object> delete(Integer id){
        HashMap<String, Object> result = new HashMap<>();
        int delete = impl.delete(id);
        if (delete > 0){
            result.put("code",200);
            result.put("msg","删除成功！！");
        }
        return result;
    }
    @RequestMapping(value = "deleteBatch", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Map<String,Object> delete(Integer[] ids){
        HashMap<String, Object> result = new HashMap<>();
        int delete = impl.deleteBatch(ids);
        if (delete > 0){
            result.put("code",200);
            result.put("msg","删除成功！！");
        }
        return result;
    }

    @RequestMapping(value = "update", method = {RequestMethod.POST, RequestMethod.GET})

    public String update(Integer id, String tno,String name,String gender,String password,String email,String telephone,String address,String clazzName) {
        Teacher teacher = new Teacher(id, tno, name, gender, password, email, telephone, address, clazzName);
        int update = impl.update(teacher);
        if (update > 0){
            return "teacher/teacherList";
        }
        return "error/404";
    }
}

package com.meng.controller;


import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.meng.model.Admin;
import com.meng.model.Student;
import com.meng.service.StudentService;
import com.meng.service.impl.StudentServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/student/")
public class StudentController {

    @Autowired
    private StudentServiceImpl impl;


    @RequestMapping(value = "updateStudentPassword", method = {RequestMethod.POST})
    public String updatePassword(Integer id, String password, HttpServletRequest request) {
        Student student = new Student();
        student.setId(id);
        student.setPassword(password);
        int i = impl.updatePassword(student);
        if (i > 0) {
            request.setAttribute("msg", 1);
            return "system/main";
        }
        return "error/404";
    }


    @RequestMapping("studentListPage")
    public String studentListPage(){
        return "/student/studentList";
    }

    /**
     *
     * @param page
     * @param limit
     * @param studentName
     * @param clazzName
     * @return reslut
     * 思路：
     * 1、
     */
   // @PostMapping("getStudentList")
    @RequestMapping(value = "getStudentList",method = {RequestMethod.POST})
    @ResponseBody
    public Map<String, Object> getStudentList(String page, String limit, String studentName,String clazzName){

        HashMap<String, Object> result = new HashMap<>();
        Student student = new Student();

        student.setName(studentName);

        student.setClazzName(clazzName);

        PageHelper.startPage(Integer.valueOf(page),Integer.valueOf(limit));
        List<Student> students = impl.selectStudentList(student);

        PageInfo<Student> pageInfo = new PageInfo<>(students);

        List<Student> studentList = pageInfo.getList();

        long total = pageInfo.getTotal();

        result.put("data",studentList);
        result.put("code",0);
        result.put("msg","查询成功");
        result.put("count",total);

        return result;
    }


    @RequestMapping(value = "addStudent",method = {RequestMethod.POST})
    public String addStudent(Integer id,String sno,String name, String gender, String password,String email,String telephone,String address,String portraitPath,String introduction,String clazzName){

        Student student = new Student(id,sno,name,gender,password,email,telephone,address,introduction,portraitPath,clazzName);
        int i = impl.insertStudent(student);
        if (i > 0){
            return "student/studentList";
        } else {
            return "error/404";
        }
    }


    @RequestMapping(value = "updateStudent",method = {RequestMethod.POST})
    public String updateStudent(Integer id,String sno,String name, String gender, String password,String email,String telephone,String address,String portraitPath,String introduction,String clazzName){
        Student student = new Student(id,sno,name,gender,password,email,telephone,address,introduction,portraitPath,clazzName);
        int update = impl.update(student);
        if (update > 0){
            return "student/studentList";
        } else {
            return "error/404";
        }
    }

    @PostMapping("delete")
    @ResponseBody
    public Map<String,Object> deleteStudent(Integer id){
        HashMap<String, Object> result = new HashMap<>();
        int delete = impl.delete(id);
        if (delete > 0){
           result.put("msg","删除成功");
           result.put("code",200);
        }
            return result;
    }

    @RequestMapping(value = "batchdelete",method = {RequestMethod.POST})
    public Map<String,Object> deleteList(Integer[] ids){
        HashMap<String, Object> result = new HashMap<>();

        int i = impl.deleteList(ids);
        if (i > 0){
            result.put("code",200);
            result.put("msg","删除成功");
        }
        return result;

    }


    @PostMapping("/deleteLists")
    @ResponseBody
    public Map<String, Object>deletebatch(Integer[] ids) {
        Map<String, Object> result = new HashMap<>();
        int i = impl.deletebatch(ids);
        if (i>0){
            //存储对象数据
            result.put("code",200);
            result.put("msg","删除成功!");
        }
        return result;
    }
}

package com.meng.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.meng.model.Grade;
import com.meng.service.impl.GradeServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/grade/")
public class GradeController {

    @Autowired
    private GradeServiceImpl impl;

    @RequestMapping("goGradeListPage")
    public String goGradeListPage(){
        return "grade/gradeList";
    }

    @RequestMapping("getAllGrade")
    @ResponseBody
    public Map<String, Object> getAllGrade(){
        HashMap<String, Object> result = new HashMap<>();
        List<Grade> allGrade = impl.findAllGrade();
        if (allGrade.size() > 0){
            result.put("data",allGrade);
            result.put("code",0);

        }
        return result;
    }
    @RequestMapping("getAllGradeList")
    @ResponseBody
    public Map<String, Object> getAllGradeList(Integer page,Integer limit,String name){
        HashMap<String, Object> result = new HashMap<>();
        Grade grade = new Grade();
        grade.setName(name);
        List<Grade> allGrade = impl.findGradeList(grade);
        PageHelper.startPage(page,limit);
        PageInfo<Grade> info = new PageInfo<>(allGrade);
        List<Grade> gradeList = info.getList();
        long total = info.getTotal();
        result.put("data",gradeList);
        result.put("code",0);
        result.put("msg","查询成功");
        result.put("count",total);
        return result;
    }
    @RequestMapping(value = "add",method = {RequestMethod.POST,RequestMethod.GET})
    public String add(String name,String manager,String email,String telephone,String introduction){
        Grade grade = new Grade(name, manager, email, telephone, introduction);
        int add = impl.add(grade);
        if (add > 0){
            return "grade/gradeList";
        }
        return "error/404";
    }
    @RequestMapping(value = "delete",method = {RequestMethod.POST,RequestMethod.GET})
    @ResponseBody
    public Map<String,String> delete(String  id){
        HashMap<String, String> result = new HashMap<>();
        int delete = impl.delete(Integer.valueOf(id));
        if (delete > 0){
            result.put("code","200");
            result.put("msg","删除成功！！");
        }
        return result;
    }


    @RequestMapping(value = "batchDelete",method = {RequestMethod.POST,RequestMethod.GET})
    @ResponseBody
    public Map<String,String> batchDelete(Integer[]  ids){
        HashMap<String, String> result = new HashMap<>();
        int delete = impl.batchDelete(ids);
        if (delete > 0){
            result.put("code","200");
            result.put("msg","删除成功！！");
        }
        return result;
    }

    @RequestMapping(value = "update",method = {RequestMethod.POST,RequestMethod.GET})
    public String  update(Integer id,String name,String  manager,String email,String telephone,String introduction){
        Grade grade = new Grade(id,name, manager, email, telephone, introduction);
        int update = impl.update(grade);
        if (update > 0){
            return "grade/gradeList";
        }
        return "error/404";
    }
}

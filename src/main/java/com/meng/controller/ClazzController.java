package com.meng.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.meng.model.Clazz;
import com.meng.service.impl.ClazzServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/clazz/")
public class ClazzController {

    @Autowired
    private ClazzServiceImpl impl;

    @RequestMapping("goClazzListpage")
    public String goGradeListPage() {
        return "clazz/clazzList";
    }

    @RequestMapping(value = "getAllClazzList", method = {RequestMethod.POST})
    @ResponseBody
    public Map<String, Object> getAllClazzList(Integer page, Integer limit, String name, String gradeName) {
        Map<String, Object> result = new HashMap<String, Object>();
        Clazz clazz = new Clazz();
        if (name != null || name != "") {
            clazz.setName(name);
        }
        if (gradeName != null || gradeName != "") {
            clazz.setGradeName(gradeName);
        }
        List<Clazz> clazzList = impl.getAllList(clazz);
        PageHelper.startPage(page, limit);
        PageInfo info = new PageInfo(clazzList);
        long total = info.getTotal();
        List infoList = info.getList();
        result.put("data", infoList);
        result.put("code", 0);
        result.put("msg", "查询成功");
        result.put("count", total);
        return result;
    }

    @RequestMapping(value = "getAll", method = {RequestMethod.POST})
    @ResponseBody
    public Map<String, Object> getAll() {
        HashMap<String, Object> result = new HashMap<>();
        List<Clazz> clazzList = impl.getAll();
        result.put("data", clazzList);
        result.put("code", 0);
        return result;
    }

    @RequestMapping(value = "delete", method = {RequestMethod.POST})
    public Map<String, Object> delete(Integer id) {
        HashMap<String, Object> result = new HashMap<>();

        int num = impl.delete(id);
        if (num > 0) {
            result.put("code", 200);
            result.put("msg", "删除成功");
        }
        return result;
    }


    @RequestMapping(value = "add", method = {RequestMethod.POST, RequestMethod.GET})

    public String addClazz(String name, Integer number, String teacherName, String telephone, String email, String introduction, String gradeName) {
        Clazz clazz = new Clazz(name, number, introduction, teacherName, telephone, email, gradeName);
        int count = impl.add(clazz);
        //存储对象数据
        if (count > 0) {
            return "clazz/clazzList";
        }
        return "error/404";
    }

    @RequestMapping(value = "batchdelete", method = {RequestMethod.POST})
    public Map<String, Object> deleteList(Integer[] ids) {
        HashMap<String, Object> result = new HashMap<>();

        int i = impl.deletebatch(ids);
        if (i > 0) {
            result.put("code", 200);
            result.put("msg", "删除成功");
        }
        return result;
    }


    @RequestMapping(value = "update", method = {RequestMethod.POST, RequestMethod.GET})

    public String update(Integer id, String name, Integer number, String teacherName, String telephone, String email, String introduction, String gradeName) {
        Clazz clazz = new Clazz(id, name, number, introduction, teacherName, telephone, email, gradeName);
        int update = impl.update(clazz);
        if (update > 0) {
            return "clazz/clazzList";
        }
        return "clazz/404";

    }
}

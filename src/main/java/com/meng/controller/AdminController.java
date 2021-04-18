package com.meng.controller;


import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.meng.model.Admin;
import com.meng.service.impl.AdminServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {
    @Autowired
    private AdminServiceImpl impl;

    @RequestMapping(value = "updateAdminPassword", method = {RequestMethod.POST})
    public String updatePassword(Integer id, String password, HttpServletRequest request) {
        Admin admin = new Admin();
        admin.setId(id);
        admin.setPassword(password);
        int i = impl.updatePassword(admin);
        if (i > 0) {
            request.setAttribute("msg", 1);
            return "system/main";
        }
        return "error/404";
    }

    @RequestMapping(value = "goToAdminPage", method = {RequestMethod.POST, RequestMethod.GET})
    public String goToAdminPage() {
        return "admin/adminList";
    }

    @RequestMapping(value = "getAllAminList", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Map<String, Object> findAllAdmin(Integer page, Integer limit, String name) {
        HashMap<String, Object> result = new HashMap<>();
        Admin admin = new Admin();
        if (name != null || name != "") {
            admin.setName(name);
        }
        List<Admin> adminList = impl.findAdminList(admin);
        PageHelper.startPage(page, limit);
        PageInfo pageInfo = new PageInfo(adminList);
        List list = pageInfo.getList();
        long total = pageInfo.getTotal();
        result.put("data", list);
        result.put("count", total);
        result.put("msg", "查询成功");
        result.put("code", 0);
        return result;
    }

    @RequestMapping(value = "add", method = {RequestMethod.POST, RequestMethod.GET})

    public String add(String name, String gender, String password, String email, String telephone, String address) {
        Admin admin = new Admin(name, gender, password, email, telephone, address);
        int add = impl.add(admin);
        if (add > 0) {
            return "admin/adminList";
        }
        return "error/404";
    }

    @RequestMapping(value = "update", method = {RequestMethod.POST, RequestMethod.GET})

    public String update(Integer id, String name, String gender, String email, String telephone, String address, String portraitPath) {
        Admin admin = new Admin(id,name, gender,  email, telephone, address);
        int update = impl.update(admin);
        if (update > 0) {
            return "admin/adminList";
        }
        return "error/404";
    }

    @RequestMapping(value = "delete", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public Map<String, Object> delete(Integer id) {
        HashMap<String, Object> result = new HashMap<>();
        int delete = impl.delete(id);
        if (delete > 0) {
            result.put("msg", "删除成功");
            result.put("code", 200);
            return result;
        }
        result.put("msg", "请选择数据");
        result.put("code", 400);
        return result;
    }
    @RequestMapping(value = "batchDelete", method = {RequestMethod.POST, RequestMethod.GET})
    @ResponseBody

    public Map<String, Object> batchDelete(Integer[] ids) {
        HashMap<String, Object> result = new HashMap<>();
        int i = impl.batchDelete(ids);
        if (i > 0) {
            result.put("msg", "删除成功");
            result.put("code", 200);
            return result;
        }
        result.put("msg", "请选择数据");
        result.put("code", 400);
        return result;
    }
}

package com.meng.service.impl;

import com.meng.dao.AdminDao;
import com.meng.model.Admin;
import com.meng.model.LoginForm;
import com.meng.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AdminServiceImpl implements AdminService {
    @Autowired
    private AdminDao adminDao;

    @Override
    public Admin login(LoginForm loginForm) {
        return adminDao.login(loginForm);
    }

    @Override
    public int updatePassword(Admin admin) {
        return adminDao.updatePassword(admin);
    }

    @Override
    public List<Admin> findAdminList(Admin admin) {
        return adminDao.findAdminList(admin);
    }

    @Override
    public int add(Admin admin) {
        return adminDao.add(admin);
    }

    @Override
    public int delete(Integer id) {
        return adminDao.delete(id);
    }

    @Override
    public int batchDelete(Integer[] ids) {
        return adminDao.batchDelete(ids);
    }

    @Override
    public int update(Admin admin) {
        return adminDao.update(admin);
    }
}

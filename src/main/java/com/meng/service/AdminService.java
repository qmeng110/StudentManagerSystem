package com.meng.service;


import com.meng.model.Admin;
import com.meng.model.LoginForm;

import java.util.List;

public interface AdminService {
    Admin login(LoginForm loginForm);

    int updatePassword(Admin admin);

    List<Admin> findAdminList(Admin admin);
    int add(Admin admin);
    int delete(Integer id);
    int batchDelete(Integer[] ids);
    int update(Admin admin);

}

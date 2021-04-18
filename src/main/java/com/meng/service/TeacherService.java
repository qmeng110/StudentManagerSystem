package com.meng.service;

import com.meng.model.Admin;
import com.meng.model.LoginForm;
import com.meng.model.Teacher;

import java.util.List;

public interface TeacherService {

    public Teacher login(LoginForm loginForm);

    List<Teacher> findAllTeacher(Teacher teacher);

    int add(Teacher teacher);

    int update(Teacher teacher);

    int delete(Integer id);

    int deleteBatch(Integer[] ids);

    int updatePassword(Teacher teacher);
}

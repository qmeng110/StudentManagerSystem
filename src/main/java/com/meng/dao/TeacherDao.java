package com.meng.dao;

import com.meng.model.LoginForm;
import com.meng.model.Student;
import com.meng.model.Teacher;

import java.util.List;

public interface TeacherDao {
    public Teacher login(LoginForm loginForm);

    int updatePassword(Teacher teacher);


    List<Teacher> findAllTeacher(Teacher teacher);

    int add(Teacher teacher);

    int update(Teacher teacher);

    int delete(Integer id);

    int deleteBatch(Integer[] ids);
}

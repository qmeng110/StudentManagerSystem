package com.meng.dao;

import com.meng.model.Admin;
import com.meng.model.LoginForm;
import com.meng.model.Student;

import java.util.List;

public interface StudentDao {


    int updatePassword(Student student);

    public Student login(LoginForm loginForm);

    public List<Student> selectStudentList(Student student);


    public int insertStudent(Student student);

    public int update(Student student);



    public int delete(Integer id);

    public int deletebatch(Integer[] ids);
}

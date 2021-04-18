package com.meng.service.impl;

import com.meng.dao.StudentDao;
import com.meng.model.LoginForm;
import com.meng.model.Student;
import com.meng.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StudentServiceImpl implements StudentService {
    @Autowired

    private StudentDao studentDao;
    @Override
    public Student login(LoginForm loginForm) {
        return studentDao.login(loginForm);
    }

    @Override
    public List<Student> selectStudentList(Student student) {
        return studentDao.selectStudentList(student);
    }

    @Override
    public int insertStudent(Student student) {
        return studentDao.insertStudent(student);
    }

    @Override
    public int update(Student student) {
        return studentDao.update(student);
    }

    @Override
    public int delete(Integer id) {
        return studentDao.delete(id);
    }

    @Override
    public int deleteList(Integer[] ids) {
        return 0;
    }

    @Override
    public int deletebatch(Integer[] ids) {
        return studentDao.deletebatch(ids);
    }

    @Override
    public int updatePassword(Student student) {
        return studentDao.updatePassword(student);
    }


}

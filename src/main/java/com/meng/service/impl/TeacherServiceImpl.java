package com.meng.service.impl;

import com.meng.dao.TeacherDao;
import com.meng.model.LoginForm;
import com.meng.model.Teacher;
import com.meng.service.TeacherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TeacherServiceImpl implements TeacherService {

    @Autowired
    private TeacherDao teacherDao;
    @Override
    public Teacher login(LoginForm loginForm) {
        return  teacherDao.login(loginForm);

    }

    @Override
    public List<Teacher> findAllTeacher(Teacher teacher) {
        return teacherDao.findAllTeacher(teacher);
    }

    @Override
    public int add(Teacher teacher) {
        return teacherDao.add(teacher);
    }

    @Override
    public int update(Teacher teacher) {
        return teacherDao.update(teacher);
    }

    @Override
    public int delete(Integer id) {
        return teacherDao.delete(id);
    }

    @Override
    public int deleteBatch(Integer[] ids) {
        return teacherDao.deleteBatch(ids);
    }

    @Override
    public int updatePassword(Teacher teacher) {
        return teacherDao.updatePassword(teacher);
    }
}

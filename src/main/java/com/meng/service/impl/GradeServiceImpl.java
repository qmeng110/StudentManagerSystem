package com.meng.service.impl;

import com.meng.dao.GradeDao;
import com.meng.model.Grade;
import com.meng.service.GradeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class GradeServiceImpl implements GradeService {
    @Autowired
    private GradeDao dao;
    @Override
    public List<Grade> findAllGrade() {
        return dao.findAllGrade();
    }

    @Override
    public List<Grade> findGradeList(Grade grade) {
        return dao.findGradeList(grade);
    }

    @Override
    public int add(Grade grade) {
        return dao.add(grade);
    }

    @Override
    public int delete(Integer id) {
        return dao.delete(id);
    }

    @Override
    public int batchDelete(Integer[] ids) {
        return dao.batchDelete(ids);
    }

    @Override
    public int update(Grade grade) {
        return dao.update(grade);
    }
}

package com.meng.service;

import com.meng.model.Grade;

import java.util.List;

public interface GradeService {
    List<Grade> findAllGrade();
    List<Grade> findGradeList(Grade grade);
    int add(Grade grade);
    int delete(Integer id);
    int batchDelete(Integer[] ids);
    int update(Grade grade);

}

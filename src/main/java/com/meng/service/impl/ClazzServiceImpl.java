package com.meng.service.impl;

import com.meng.dao.ClazzDao;
import com.meng.model.Clazz;
import com.meng.service.ClazzService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class ClazzServiceImpl implements ClazzService {

    @Autowired

    private ClazzDao clazzDao;
    @Override
    public List<Clazz> getAll() {
        return clazzDao.getAll();
    }

    @Override
    public int delete(Integer id) {
        return clazzDao.delete(id);
    }

    @Override
    public int add(Clazz clazz) {
        return clazzDao.add(clazz);
    }

    @Override
    public List<Clazz> getAllList(Clazz clazz) {
        return clazzDao.getAllList(clazz);
    }

    @Override
    public int deletebatch(Integer[] ids) {
        return clazzDao.deletebatch(ids);
    }

    @Override
    public int update(Clazz clazz) {
        return clazzDao.update(clazz);
    }
}

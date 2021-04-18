package com.meng.service;

import com.meng.model.Clazz;

import java.util.List;

public interface ClazzService {

    public List<Clazz> getAll();

    public int delete(Integer id);

    public int add(Clazz clazz);

    public List<Clazz> getAllList(Clazz clazz);

    public int deletebatch(Integer[] ids);

    public int update(Clazz clazz);

}

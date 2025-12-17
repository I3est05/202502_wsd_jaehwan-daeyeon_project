package com.example.donjoogga.service;

import com.example.donjoogga.mapper.MyScholarshipMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MyScholarshipService {

    @Autowired
    private MyScholarshipMapper myScholarshipMapper;

    @Transactional // ✅ 이 어노테이션을 반드시 붙여야 DB에 영구 저장됩니다.
    public boolean toggleScrap(String userId, Long scholarId, int isApi) {
        int count = myScholarshipMapper.checkScrapped(userId, scholarId);

        if (count > 0) {
            myScholarshipMapper.deleteMyScholarship(userId, scholarId);
            return false;
        } else {
            // ✅ 이 메서드가 실행된 후 Commit이 일어나야 DB에 남습니다.
            myScholarshipMapper.insertMyScholarship(userId, scholarId, isApi);
            return true;
        }
    }
}
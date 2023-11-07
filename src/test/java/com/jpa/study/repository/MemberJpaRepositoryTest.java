//package com.jpa.study.repository;
//
//import com.jpa.study.entity.Member;
//import org.junit.jupiter.api.DisplayName;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.context.SpringBootTest;
//import org.springframework.transaction.annotation.Transactional;
//
//import static org.assertj.core.api.Assertions.assertThat;
//
//@SpringBootTest
//@Transactional // spring test에서 사용시 Rollback 처리시킴
////@Rollback(false)
//class MemberJpaRepositoryTest {
//
//    @Autowired MemberJpaRepository memberJpaRepository;
//
//    @DisplayName("Save Test")
//    @Test
//    public void testMember() {
//        Member member = new Member("개발자_한");
//        Member saveMember = memberJpaRepository.save(member);
//
//        Member findMember = memberJpaRepository.find(saveMember.getId());
//
//        assertThat(findMember.getId()).isEqualTo(member.getId());
//        assertThat(findMember.getUsername()).isEqualTo(member.getUsername());
//        assertThat(findMember).isEqualTo(member); // JPA는 같은 트랜잭션내에서는 같은 인스턴스로 다룬다
//    }
//
//}
package com.CPGroupH.domains.chat.entity;

import com.CPGroupH.domains.common.entity.BaseEntity;
import com.CPGroupH.domains.member.entity.Member;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(uniqueConstraints = @UniqueConstraint(columnNames = {"chatroom_id", "member_id"}))
public class Participant extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chatroom_id", nullable = false)
    public ChatRoom chatRoom;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    public Member member;
    
    public static Participant of(ChatRoom chatRoom, Member member) {
        Participant participant = new Participant();
        participant.chatRoom = chatRoom;
        participant.member = member;
        return participant;
    }
}

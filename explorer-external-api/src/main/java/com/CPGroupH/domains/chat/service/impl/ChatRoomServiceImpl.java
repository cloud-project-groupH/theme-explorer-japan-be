package com.CPGroupH.domains.chat.service.impl;

import com.CPGroupH.domains.chat.entity.ChatRoom;
import com.CPGroupH.domains.chat.entity.repository.ChatRoomRepository;
import com.CPGroupH.domains.chat.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
public class ChatRoomServiceImpl implements ChatRoomService {

    private final ChatRoomRepository chatRoomRepository;

    public ChatRoom findChatRoomById(String id) {
        return chatRoomRepository.findChatRoomById(Long.parseLong(id)).orElseThrow(() -> new NoSuchElementException("ChatRoom이 없습니다"));
    }

    public Page<ChatRoom> getChatRoomsByParticipant(Long participantId, Pageable pageable) {

        return chatRoomRepository.findByParticipantId(participantId, pageable);
    }

    public Page<ChatRoom> getAllChatRooms(Pageable pageable) {

        return chatRoomRepository.findAll(pageable);
    }

}

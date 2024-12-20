package com.CPGroupH.domains.chat.service.impl;

import com.CPGroupH.domains.chat.dto.request.MessageReqDTO;
import com.CPGroupH.domains.chat.entity.ChatRoom;
import com.CPGroupH.domains.chat.entity.Message;
import com.CPGroupH.domains.chat.service.ChatRoomService;
import com.CPGroupH.domains.chat.service.ChatWebSocketService;
import com.CPGroupH.domains.chat.service.MessageService;
import com.CPGroupH.domains.member.entity.Member;
import com.CPGroupH.domains.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ChatWebSocketServiceImpl implements ChatWebSocketService {

    private final SimpMessagingTemplate messagingTemplate;
    private final MemberService memberService;
    private final MessageService messageService;
    private final ChatRoomService chatRoomService;

    public void sendMessageToRoom(String chatRoomId, MessageReqDTO chatMessage) {
        Member sender = memberService.findMemberByNickname(chatMessage.sender());
        ChatRoom chatRoom = chatRoomService.findChatRoomById(chatRoomId);
        Message message = chatMessage.toEntity(sender, chatRoom);
        messageService.saveMessage(message);
        messagingTemplate.convertAndSend("/topic/chatroom/" + chatRoomId, chatMessage);
    }

}

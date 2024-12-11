CREATE TABLE IF NOT EXISTS members (
                         id BIGINT AUTO_INCREMENT PRIMARY KEY,
                         nickname VARCHAR(255) NOT NULL UNIQUE,
                         email VARCHAR(255) NOT NULL,
                         profile_image VARCHAR(255),
                         allowance BOOLEAN,
                         role VARCHAR(10) NOT NULL,
                         deleted_at DATETIME,
                         created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                         updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS addresses (
                           id BIGINT AUTO_INCREMENT PRIMARY KEY,
                           city VARCHAR(255) NOT NULL,
                           district VARCHAR(255) NOT NULL,
                           street VARCHAR(255) NOT NULL,
                           created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                           updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS places (
                        id BIGINT AUTO_INCREMENT PRIMARY KEY,
                        address_id BIGINT NOT NULL,
                        title VARCHAR(255) NOT NULL,
                        likes INT NOT NULL DEFAULT 0,
                        visited INT NOT NULL DEFAULT 0,
                        latitude VARCHAR(50) NOT NULL,
                        longitude VARCHAR(50) NOT NULL,
                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                        CONSTRAINT fk_address FOREIGN KEY (address_id) REFERENCES addresses(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS likes (
                       id BIGINT AUTO_INCREMENT PRIMARY KEY,
                       member_id BIGINT NOT NULL,
                       place_id BIGINT NOT NULL,
                       created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                       updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                       CONSTRAINT fk_likes_member FOREIGN KEY (member_id) REFERENCES members (id) ON DELETE CASCADE,
                       CONSTRAINT fk_likes_place FOREIGN KEY (place_id) REFERENCES places (id) ON DELETE CASCADE,
                       CONSTRAINT uc_like UNIQUE (member_id, place_id)
);

CREATE TABLE IF NOT EXISTS visited (
                         id BIGINT AUTO_INCREMENT PRIMARY KEY,
                         member_id BIGINT NOT NULL,
                         place_id BIGINT NOT NULL,
                         created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                         updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         CONSTRAINT fk_visited_member FOREIGN KEY (member_id) REFERENCES members (id) ON DELETE CASCADE,
                         CONSTRAINT fk_visited_place FOREIGN KEY (place_id) REFERENCES places (id) ON DELETE CASCADE,
                         CONSTRAINT uc_visited UNIQUE (member_id, place_id)
);

CREATE TABLE IF NOT EXISTS categories (
                            id BIGINT AUTO_INCREMENT PRIMARY KEY,
                            title VARCHAR(255) NOT NULL,
                            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sub_categories (
                                id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                category_id BIGINT NOT NULL,
                                title VARCHAR(255) NOT NULL,
                                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS preferences (
                             id BIGINT AUTO_INCREMENT PRIMARY KEY,
                             member_id BIGINT NOT NULL,
                             subcategory_id BIGINT NOT NULL,
                             created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                             updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                             CONSTRAINT fk_preferences_member FOREIGN KEY (member_id) REFERENCES members (id) ON DELETE CASCADE,
                             CONSTRAINT fk_preferences_subcategory FOREIGN KEY (subcategory_id) REFERENCES sub_categories (id) ON DELETE CASCADE,
                             CONSTRAINT uc_preference UNIQUE (member_id, subcategory_id)
);

CREATE TABLE IF NOT EXISTS chat_rooms (
                            id BIGINT AUTO_INCREMENT PRIMARY KEY,
                            title VARCHAR(255) NOT NULL,
                            travel_date DATETIME,
                            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS participants (
                              id BIGINT AUTO_INCREMENT PRIMARY KEY,
                              chatroom_id BIGINT NOT NULL,
                              member_id BIGINT NOT NULL,
                              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                              updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                              CONSTRAINT fk_participants_chatroom FOREIGN KEY (chatroom_id) REFERENCES chat_rooms (id) ON DELETE CASCADE,
                              CONSTRAINT fk_participants_member FOREIGN KEY (member_id) REFERENCES members (id) ON DELETE CASCADE,
                              CONSTRAINT uc_chatroom_member UNIQUE (chatroom_id, member_id)
);

CREATE TABLE IF NOT EXISTS recommendations (
                                               id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                               place_id BIGINT NOT NULL,
                                               subcategory_id BIGINT NOT NULL,
                                               created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                                               updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS messages (
                          id BIGINT AUTO_INCREMENT PRIMARY KEY,
                          chatroom_id BIGINT NOT NULL,
                          sender BIGINT NOT NULL,
                          content TEXT NOT NULL,
                          created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                          updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                          CONSTRAINT fk_messages_chatroom FOREIGN KEY (chatroom_id) REFERENCES chat_rooms (id) ON DELETE CASCADE,
                          CONSTRAINT fk_messages_sender FOREIGN KEY (sender) REFERENCES members (id) ON DELETE CASCADE
);


# INSERT INTO members (nickname, email, profile_image, allowance, role, deleted_at) VALUES
#                                                                                       ('User1', 'user1@example.com', 'https://example.com/image1.png', TRUE, 'USER', NULL),
#                                                                                       ('User2', 'user2@example.com', 'https://example.com/image2.png', TRUE, 'ADMIN', NULL),
#                                                                                       ('User3', 'user3@example.com', 'https://example.com/image3.png', FALSE, 'USER', NULL),
#                                                                                       ('User4', 'user4@example.com', 'https://example.com/image4.png', TRUE, 'USER', NULL),
#                                                                                       ('User5', 'user5@example.com', 'https://example.com/image5.png', FALSE, 'USER', NULL),
#                                                                                       ('User6', 'user6@example.com', 'https://example.com/image6.png', TRUE, 'USER', NULL),
#                                                                                       ('User7', 'user7@example.com', 'https://example.com/image7.png', FALSE, 'USER', NULL),
#                                                                                       ('User8', 'user8@example.com', 'https://example.com/image8.png', TRUE, 'USER', NULL),
#                                                                                       ('User9', 'user9@example.com', 'https://example.com/image9.png', TRUE, 'ADMIN', NULL),
#                                                                                       ('User10', 'user10@example.com', 'https://example.com/image10.png', FALSE, 'USER', NULL);


-- 기존 데이터 삭제-- 외래 키 제약 조건 비활성화
SET FOREIGN_KEY_CHECKS = 0;

-- 데이터 삭제
TRUNCATE TABLE sub_categories;
TRUNCATE TABLE categories;

-- 외래 키 제약 조건 다시 활성화
SET FOREIGN_KEY_CHECKS = 1;

-- AUTO_INCREMENT 초기화 (MySQL 기준)
ALTER TABLE sub_categories AUTO_INCREMENT = 1;
ALTER TABLE categories AUTO_INCREMENT = 1;

-- 카테고리 삽입
INSERT INTO categories (title) VALUES
                                   ('역사 문화'),
                                   ('유명 관광지'),
                                   ('맛집 탐방'),
                                   ('자연, 힐링'),
                                   ('이색 관광지');

-- 서브 카테고리 삽입
INSERT INTO sub_categories (category_id, title) VALUES
-- 역사 문화
(1, '신사/사찰'),
(1, '성'),
(1, '전통 건축물'),
(1, '역사 박물관'),
(1, '전통 예술'),
(1, '고서점'),
(1, '전통 마을'),

-- 유명 관광지
(2, '랜드 마크'),
(2, '쇼핑 스트리트'),
(2, '유명 거리'),
(2, '테마 파크'),
(2, '전망대'),
(2, '현대 건축물'),
(2, '야경 스팟'),

-- 맛집 탐방
(3, '전통 음식'),
(3, '길거리 음식'),
(3, '고급 요리'),
(3, '카페 탐방'),
(3, '디저트'),
(3, '테마 음식점'),
(3, '퓨전 양식'),

-- 자연, 힐링
(4, '정원/공원'),
(4, '하천/호수'),
(4, '자연 명소'),
(4, '온천/스파'),
(4, '꽃놀이'),
(4, '명상 체험'),

-- 이색 관광지
(5, '메이드 카페'),
(5, '도깨비 카페'),
(5, '신카이 마코토'),
(5, '최애의 아이'),
(5, '슬램 덩크'),
(5, '스트리트 아트'),
(5, '사무라이'),
(5, '가부키 메이크업');

# INSERT INTO chat_rooms (title, travel_date) VALUES
#                                                 ('Trip to Tokyo', '2024-12-15 09:00:00'),
#                                                 ('Weekend Hiking', '2024-12-22 07:30:00'),
#                                                 ('Beach Getaway', '2024-12-29 10:00:00'),
#                                                 ('Museum Visit', '2024-12-10 14:00:00'),
#                                                 ('Food Tour', '2024-12-18 12:00:00');
#
# INSERT INTO preferences (member_id, subcategory_id) VALUES
#                                                         (1, 1), (1, 3), (1, 5),
#                                                         (2, 2), (2, 6),
#                                                         (3, 4), (3, 9), (3, 10),
#                                                         (4, 7), (4, 12),
#                                                         (5, 8), (5, 13);
#
# INSERT INTO messages (chatroom_id, sender, content) VALUES
#                                                         (1, 1, 'Hello, how are you?'),
#                                                         (1, 2, 'I am fine, thank you! How about you?'),
#                                                         (2, 3, 'Are we still on for the meeting?'),
#                                                         (2, 4, 'Yes, let’s meet at 3 PM.'),
#                                                         (3, 5, 'Don’t forget to bring the files.'),
#                                                         (3, 1, 'Got it, will bring them.');
#
# INSERT INTO addresses (city, district, street) VALUES
#                                                    ('Tokyo', 'Chiyoda', 'Marunouchi'),
#                                                    ('Tokyo', 'Minato', 'Roppongi'),
#                                                    ('Tokyo', 'Shinjuku', 'Kabukicho'),
#                                                    ('Tokyo', 'Shibuya', 'Harajuku'),
#                                                    ('Tokyo', 'Taito', 'Asakusa'),
#                                                    ('Tokyo', 'Sumida', 'Ryogoku'),
#                                                    ('Tokyo', 'Chuo', 'Ginza'),
#                                                    ('Tokyo', 'Ota', 'Kamata'),
#                                                    ('Tokyo', 'Setagaya', 'Shimokitazawa'),
#                                                    ('Tokyo', 'Koto', 'Odaiba');
#
# INSERT INTO places (address_id, title, likes, visited, latitude, longitude) VALUES
#                                                                                 (1, 'Imperial Palace', 100, 500, '35.6852', '139.7528'),
#                                                                                 (2, 'Tokyo Tower', 250, 1200, '35.6586', '139.7454'),
#                                                                                 (3, 'Shinjuku Gyoen', 180, 800, '35.6850', '139.7107'),
#                                                                                 (4, 'Meiji Shrine', 300, 1500, '35.6764', '139.6993'),
#                                                                                 (5, 'Sensoji Temple', 400, 2000, '35.7148', '139.7967');
#
# INSERT INTO likes (member_id, place_id) VALUES
#                                             (1, 1), (1, 3), (1, 5),
#                                             (2, 2), (2, 4),
#                                             (3, 1), (3, 3), (3, 5),
#                                             (4, 2), (4, 4),
#                                             (5, 1), (5, 3), (5, 5);
#
# INSERT INTO visited (member_id, place_id) VALUES
#                                               (1, 1), (1, 2),
#                                               (2, 3), (2, 4),
#                                               (3, 5), (3, 2),
#                                               (4, 1), (4, 3),
#                                               (5, 4), (5, 2);
#
# INSERT INTO participants (chatroom_id, member_id) VALUES
#                                                       (1, 1), (1, 2), (1, 3),
#                                                       (2, 2), (2, 4),
#                                                       (3, 1), (3, 3), (3, 5);
INSERT INTO addresses (city, district, street) VALUES
                                                   ('도쿄', '지요다구', '소토칸다 1-11-4 미츠와 빌딩 3-7F'), -- 홈 카페 본점
                                                   ('도쿄', '지요다구', '소토칸다 3-1-1 오바야시 빌딩 1F'), -- 아키바 절대 영역
                                                   ('도쿄', '지요다구', '소토칸다 3-16-17 스미요시 빌딩 6F'), -- 메이도리밍 아키하바라 본점
                                                   ('도쿄', '지요다구', '소토칸다 3-7-12 이야미사 제8빌딩 4F'), -- 샹그릴라
                                                   ('도쿄', '지요다구', '소토칸다 3-6-1 마루야마 빌딩 3F'), -- 크라운 티아라
                                                   ('도쿄', '지요다구', '소토칸다 1-2-7 오노덴 빌딩 4F'), -- 큐어 메이드 카페
                                                   ('도쿄', '지요다구', '소토칸다 4-6-2 이스즈 빌딩 8F'), -- STARLIGHT NOVEL
                                                   ('도쿄', '지요다구', '소토칸다 3-6-2 Fh 쿄와 스퀘어'), -- 메이드 카페 메이릿슈
                                                   ('도쿄', '지요다구', '소토칸다 3-16-17'), -- 메이드 카페 피유
                                                   ('도쿄', '신주쿠구', '신주쿠'),
                                                   ('도쿄', '신주쿠구', '가부키초 1-24-1'),
                                                   ('도쿄', '스기나미구', '고엔지미나미 4-44-19'),
                                                   ('도쿄', '도시마구', '다카다 2-12-21'),
                                                   ('도쿄', '미나토구', '시바 공원'),
                                                   ('도쿄', '미나토구', '롯폰기 6-10-1 롯폰기 힐즈 모리 타워 52층'),
                                                   ('도쿄', '신주쿠구', '니시신주쿠 6-1-1'),
                                                   ('도쿄', '시부야구', '센다가야 5-24-10'),
                                                   ('도쿄', '신주쿠구', '카스미가오카마치 14-9'),
                                                   ('도쿄', '메구로구', '메구로'),
                                                   ('도쿄', '메구로구', '히모냐 4-16-14'),
                                                   ('도쿄', '분쿄구', '고라쿠 1-3-61'),
                                                   ('도쿄', '지요다구', '나가타초 1-10-1'),
                                                   ('가나가와', '후지사와시', '쿠게누마카이간 1-17-3'),
                                                   ('가나가와', '가마쿠라시', '코시고에 1-1'),
                                                   ('가나가와', '가마쿠라시', '하세 2-14'),
                                                   ('지바', '마쓰도시', '네모토헥이가 스트리트'),
                                                   ('가나가와', '가와사키시', '시보쿠혼초 5-1-14'),
                                                   ('가나가와', '후지사와시', '구게누마이시가미 2-14'),
                                                   ('가나가와', '후지사와시', '구게누마이시가미 1-1-1'),
                                                   ('도쿄', '시부야구', '우다가와초 23'),
                                                   ('도쿄', '신주쿠구', '가부키초 2-25-6 호라이즌 빌딩 1F・2F'),
                                                   ('도쿄', '주오구', '긴자 4-12-15');
INSERT INTO places (address_id, title, description, likes, visited, latitude, longitude, imageKey) VALUES
                                                                                                       (1, '홈 카페 본점', '일본 도쿄의 유명 메이드 카페', 123, 456, '35.701679364652136', '139.77017973475643', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/홈카페본점.jpg'),
                                                                                                       (2, '아키바 절대 영역', '일본 아키하바라의 대표적인 메이드 카페', 234, 567, '35.70001712352321', '139.76935332444336', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/아키바절대영역.jpg'),
                                                                                                       (3, '메이도리밍 아키하바라 본점', '메이드 카페 중에서도 가장 인기 있는 장소', 345, 678, '35.702040971836084', '139.77128478886115', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/메이도리밍아키하바라본점.jpg'),
                                                                                                       (4, '샹그릴라', '조용하고 독특한 테마를 가진 메이드 카페', 456, 789, '35.70292757478382', '139.7707758858055', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/샹그릴라.jpg'),
                                                                                                       (5, '크라운 티아라', '우아한 테마의 메이드 카페', 567, 890, '35.702330009312504', '139.76956235414224', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/크라운티아라.jpg'),
                                                                                                       (6, '큐어 메이드 카페', '도쿄 오타쿠 문화의 중심지에 위치한 메이드 카페', 678, 901, '35.69842707871868', '139.77085442345694', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/큐어메이드카페.jpeg'),
                                                                                                       (7, 'STARLIGHT NOVEL', '독특한 컨셉으로 꾸며진 메이드 카페', 789, 1012, '36.25335192045757', '139.48633180764125', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/STARLIGHTNOVEL.jpg'),
                                                                                                       (8, '메이드 카페 메이릿슈', '아키하바라의 숨은 보석 같은 메이드 카페', 890, 1123, '35.70245577167382', '139.76968941366283', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/메이드카페메이릿슈.jpg'),
                                                                                                       (9, '메이드 카페 피유', '도쿄 메이드 카페의 또 다른 인기 있는 장소', 901, 1234, '35.70594231008136', '139.77058976037586', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/메이드카페피유.jpg');

INSERT INTO recommendations (place_id, subcategory_id) VALUES
                                                           (1, 28), -- 홈 카페 본점
                                                           (2, 28), -- 아키바 절대 영역
                                                           (3, 28), -- 메이도리밍 아키하바라 본점
                                                           (4, 28), -- 샹그릴라
                                                           (5, 28), -- 크라운 티아라
                                                           (6, 28), -- 큐어 메이드 카페
                                                           (7, 28), -- STARLIGHT NOVEL
                                                           (8, 28), -- 메이드 카페 메이릿슈
                                                           (9, 28); -- 메이드 카페 피유



INSERT INTO places (address_id, title, description, likes, visited, latitude, longitude, imageKey) VALUES
                                                                                                       (10, '신주쿠 굴다리', '신카이 마코토 작품의 배경이 된 신주쿠의 유명한 장소', 234, 345, '35.693972', '139.699500', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/신주쿠굴다리.png'),
                                                                                                       (11, '맥도날드 세이부 신쥬쿠역 앞점', '신카이 마코토의 세계관에서 자주 등장하는 장소', 345, 456, '35.69429476583739', '139.70066648297737', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/맥도날드세이부신쥬쿠역앞점.jpg'),
                                                                                                       (12, '코엔지 하카와 신사', '신사와 자연이 어우러진 아름다운 명소', 456, 567, '35.704811894369136', '139.6511790829779', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/코엔지하카와신사.jpg'),
                                                                                                       (13, '조시가야역 비탈길', '작품 속 감성적인 장면의 모티브가 된 장소', 567, 678, '35.71779577719067', '139.71396646948548', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/조시가야역비탈길.jpg'),
                                                                                                       (14, '도쿄타워 시바 공원', '신카이 마코토 작품의 대표적인 배경', 678, 789, '35.655176947562204', '139.74810703608136', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/도쿄타워시바공원.jpg'),
                                                                                                       (15, '롯폰기 힐즈 스카이덱', '탁 트인 도쿄의 전망을 제공하는 장소', 789, 890, '35.660216580524136', '139.72926406400563', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/롯폰기힐즈스카이덱.JPG'),
                                                                                                       (16, '신주쿠 경찰서 교차로', '신카이 마코토 영화에서 익숙한 배경', 890, 901, '35.69344559192993', '139.69458645599133', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/신주쿠경찰서교차로.jpg'),
                                                                                                       (17, 'NTT 도코모 요요기 빌딩', '도쿄의 상징적인 건물 중 하나', 901, 1012, '35.6844883165802', '139.70308509647035', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/NTT도코모요요기빌딩.jpg'),
                                                                                                       (18, '시나노마치역 앞 육교', '감성적인 풍경으로 유명한 장소', 1012, 1123, '35.67971913098705', '139.71967998112754', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/시나노마치역앞육교.jpg');
INSERT INTO recommendations (place_id, subcategory_id) VALUES
                                                           (10, 30), -- 신주쿠 굴다리
                                                           (11, 30), -- 맥도날드 세이부 신쥬쿠역 앞점
                                                           (12, 30), -- 코엔지 하카와 신사
                                                           (13, 30), -- 조시가야역 비탈길
                                                           (14, 30), -- 도쿄타워 시바 공원
                                                           (15, 30), -- 롯폰기 힐즈 스카이덱
                                                           (16, 30), -- 신주쿠 경찰서 교차로
                                                           (17, 30), -- NTT 도코모 요요기 빌딩
                                                           (18, 30); -- 시나노마치역 앞 육교

INSERT INTO places (address_id, title, description, likes, visited, latitude, longitude, imageKey) VALUES
                                                                                                       (19, '메구로', '도쿄의 대표적인 고급 주거 지역', 567, 678, '35.63414490496821', '139.70755495827103', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/메구로.jpg'),
                                                                                                       (20, '아카네 육교', '특별한 경관을 제공하는 육교', 678, 789, '35.62138972807555', '139.6821114253036', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/아카네육교.png'),
                                                                                                       (21, '도쿄 돔', '일본의 대표적인 돔 경기장', 789, 890, '35.705726693368824', '139.7519127541423', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/도쿄돔.jpg'),
                                                                                                       (22, '일본 국회도서관', '일본의 주요 정치 및 행정 중심지', 890, 901, '35.67856246778222', '139.744230406339', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/일본국회도서관.jpg'),
                                                                                                       (23, '쇼난 해안공원', '슬램덩크 작품의 배경이 된 해안 공원', 234, 345, '35.31391662151159', '139.47522495227804', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/쇼난해안공원.jpg'),
                                                                                                       (24, '가마쿠라코코마에 역', '슬램덩크 명장면의 배경이 된 역', 345, 456, '35.30685990980412', '139.50062663743162', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/가마쿠라코코마에역.jpeg'),
                                                                                                       (25, '하세', '슬램덩크와 관련된 아름다운 명소', 456, 567, '35.31138571242361', '139.53591801179877', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/하세.JPG'),
                                                                                                       (26, 'Mad Wall', '스트리트 아트의 대표적인 장소', 123, 234, '36.53411040336798', '139.998048641259', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/MadWall.jpeg'),
                                                                                                       (27, 'Pejac', '세계적으로 유명한 스트리트 아티스트의 작품', 234, 345, '36.25335192045757', '139.48633180764125', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/Pejac.jpg'),
                                                                                                       (28, 'Ishigami train station Enoden', '독특한 분위기를 자랑하는 기차역', 345, 456, '35.9894444371325', '139.43821686749675', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/Ishigami_train_station_Enoden.jpg'),
                                                                                                       (29, 'Fujisawa train station Enoden', '에노덴 전철의 상징적인 역', 456, 567, '36.027155554665576', '139.61461251831378', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/Fujisawa_train_station_Enoden.jpg'),
                                                                                                       (30, 'ABC-MART GRAND STAGE Center Street', '현대적인 스트리트 아트와 패션의 만남', 567, 678, '36.50618797977934', '139.67750767644964', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/ABC-MART-GRANDSTAGE.jpg'),
                                                                                                       (31, '사무라이 박물관', '사무라이 역사와 문화를 체험할 수 있는 곳', 123, 234, '35.695571434119955', '139.70356403517928', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/사무라이박물관.jpg'),
                                                                                                       (32, '가부키자 극장', '전통 가부키 공연이 열리는 일본의 상징적인 극장', 345, 456, '35.669556889744115', '139.76774458112732', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/가부키자극장.jpg');

INSERT INTO addresses (city, district, street) VALUES
                                                   ('도쿄', '지요다구', '소토칸다 1-11-4 미츠와 빌딩 3-7F'),
                                                   ('도쿄', '지요다구', '소토칸다 3-1-1 오바야시 빌딩 1F'),
                                                   ('도쿄', '지요다구', '소토칸다 3-16-17 스미요시 빌딩 6F'),
                                                   ('도쿄', '지요다구', '소토칸다 3-7-12 이야미사 제8빌딩 4F'),
                                                   ('도쿄', '지요다구', '소토칸다 3-6-1 마루야마 빌딩 3F'),
                                                   ('도쿄', '지요다구', '소토칸다 1-2-7 오노덴 빌딩 4F'),
                                                   ('도쿄', '지요다구', '소토칸다 4-6-2 이스즈 빌딩 8F'),
                                                   ('도쿄', '지요다구', '소토칸다 3-6-2 FH 쿄와 스퀘어'),
                                                   ('도쿄', '지요다구', '소토칸다 3-16-17'),
                                                   ('도쿄', '신주쿠구', '신주쿠'),
                                                   ('도쿄', '신주쿠구', '가부키초 1-24-1'),
                                                   ('도쿄', '스기나미구', '고엔지미나미 4-44-19'),
                                                   ('도쿄', '도시마구', '다카다 2-12-21'),
                                                   ('도쿄', '미나토구', '시바 공원'),
                                                   ('도쿄', '미나토구', '롯폰기 6-10-1 롯폰기 힐즈 모리 타워 52층'),
                                                   ('도쿄', '신주쿠구', '니시신주쿠 6-1-1'),
                                                   ('도쿄', '시부야구', '센다가야 5-24-10'),
                                                   ('도쿄', '신주쿠구', '카스미가오카마치 14-9'),
                                                   ('도쿄', '메구로구', '메구로'),
                                                   ('도쿄', '메구로구', '히모냐 4-16-14'),
                                                   ('도쿄', '분쿄구', '고라쿠 1-3-61'),
                                                   ('도쿄', '지요다구', '나가타초 1-10-1'),
                                                   ('가나가와', '후지사와시', '쿠게누마카이간 1-17-3'),
                                                   ('가나가와', '가마쿠라시', '코시고에 1-1'),
                                                   ('가나가와', '가마쿠라시', '하세 2-14'),
                                                   ('지바', '마쓰도시', '네모토헥이가 스트리트'),
                                                   ('가나가와', '가와사키시', '시보쿠혼초 5-1-14'),
                                                   ('가나가와', '후지사와시', '구게누마이시가미 2-14'),
                                                   ('가나가와', '후지사와시', '구게누마이시가미 1-1-1'),
                                                   ('도쿄', '시부야구', '우다가와초 23'),
                                                   ('도쿄', '신주쿠구', '가부키초 2-25-6 호라이즌 빌딩 1F・2F'),
                                                   ('도쿄', '주오구', '긴자 4-12-15');

INSERT INTO recommendations (place_id, subcategory_id) VALUES
                                                           (19, 31), -- 메구로
                                                           (20, 31), -- 아카네 육교
                                                           (21, 31), -- 도쿄 돔
                                                           (22, 31), -- 일본 국회도서관
                                                           (23, 32), -- 쇼난 해안공원
                                                           (24, 32), -- 가마쿠라코코마에 역
                                                           (25, 32), -- 하세
                                                           (26, 33), -- Mad Wall
                                                           (27, 33), -- Pejac
                                                           (28, 33), -- Ishigami train station Enoden
                                                           (29, 33), -- Fujisawa train station Enoden
                                                           (30, 33), -- ABC-MART GRAND STAGE Center Street
                                                           (31, 34), -- 사무라이 박물관
                                                           (32, 35); -- 가부키자 극장

INSERT INTO addresses (city, district, street) VALUES
                                                   ('도쿄', '미나토구', '시바코엔 4-2-8'),
                                                   ('도쿄', '스미다구', '오시아게 1-1-2'),
                                                   ('도쿄', '신주쿠구', '니시신주쿠 2-8-1'),
                                                   ('도쿄', '시부야구', '도겐자카 2-1'),
                                                   ('도쿄', '미나토구', '레인보우 브리지'),
                                                   ('도쿄', '시부야구', '진구마에 1-16-4'),
                                                   ('도쿄', '다이토구', '우에노 6-10'),
                                                   ('도쿄', '다이토구', '아사쿠사 1-36-3'),
                                                   ('도쿄', '나카노구', '나카노 5-52-15'),
                                                   ('도쿄', '지요다구', '소토칸다 1-12'),
                                                   ('도쿄', '시부야구', '하라주쿠'),
                                                   ('도쿄', '시부야구', '시부야'),
                                                   ('도쿄', '신주쿠구', '신주쿠'),
                                                   ('도쿄', '신주쿠구', '카구라자카'),
                                                   ('지바', '우라야스시', '마이하마 1-1'),
                                                   ('도쿄', '분쿄구', '고라쿠 1-3-61'),
                                                   ('도쿄', '다마시', '오치아이 1-31'),
                                                   ('도쿄', '미나토구', '다이바 1-6-1'),
                                                   ('도쿄', '시부야구', '시부야 2-24-12'),
                                                   ('도쿄', '시부야구', '에비스 4-20-3'),
                                                   ('도쿄', '미나토구', '롯폰기 7-22-2'),
                                                   ('도쿄', '지요다구', '기오이초 3'),
                                                   ('도쿄', '주오구', '긴자 7-6-1'),
                                                   ('도쿄', '주오구', '긴자 5-4-1'),
                                                   ('도쿄', '미나토구', '미나미아오야마 3-10-20'),
                                                   ('도쿄', '지요다구', '마루노우치 3-5-1'),
                                                   ('도쿄', '다이토구', '우에노 공원 7-7'),
                                                   ('도쿄', '미나토구', '다이바 2-3'),
                                                   ('도쿄', '미나토구', '롯폰기 6-10-1');

INSERT INTO places (address_id, title, description, likes, visited, latitude, longitude, imageKey) VALUES
                                                                                                       (33, '도쿄 타워', '도쿄의 대표적인 랜드마크', 120, 300, '35.65873738255278', '139.74546508297615', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/도쿄-타워.jpg'),
                                                                                                       (34, '도쿄 스카이트리', '세계에서 가장 높은 타워 중 하나', 200, 500, '35.71011494211926', '139.81074331181375', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/도쿄-스카이트리.jpg'),
                                                                                                       (35, '도쿄 도청사', '도쿄의 주요 관청 건물', 150, 400, '35.689628807961085', '139.69187941551195', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/도쿄-도청사.jpg'),
                                                                                                       (36, '하치코 동상', '시부야의 상징적인 랜드마크', 180, 450, '35.65925836742909', '139.701251568936', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/하치코-동상.jpg'),
                                                                                                       (37, '레인보우 브리지', '아름다운 경관을 자랑하는 다리', 100, 250, '35.63677307321175', '139.7637236346164', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/레인보우-브리지.jpg'),
                                                                                                       (38, '타케시타 스트리트', '젊은이들의 패션 중심지', 130, 340, '35.67137268942989', '139.70492749592276', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/타케시타-스트리트.jpg'),
                                                                                                       (39, '아메요코 상점가', '도쿄의 인기 쇼핑 거리', 140, 360, '35.70911736002326', '139.77482278482756', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/아메요코-상점가.jpg'),
                                                                                                       (40, '나카미세도리', '아사쿠사의 대표적인 쇼핑 거리', 160, 380, '35.711893540952296', '139.79685116338965', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/나카미세도리.jpg'),
                                                                                                       (41, '나카노 브로드웨이', '애니메이션과 서브컬처의 중심지', 120, 300, '35.7094217062846', '139.66606009222545', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/나카노-브로드웨이.jpg'),
                                                                                                       (42, '아키하바라 전자 거리', '전자제품과 애니메이션 문화의 중심지', 180, 450, '35.6998197943384', '139.77198398140186', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/아키하바라-전자거리.jpg'),
                                                                                                       (43, '하라주쿠', '패션과 문화의 중심지', 170, 420, '35.67027587209027', '139.7016761187545', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/하라주쿠.jpg'),
                                                                                                       (44, '시부야', '도쿄의 상징적인 거리', 160, 400, '35.660293494616695', '139.70551744979147', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/시부야.jpg'),
                                                                                                       (45, '신주쿠', '도쿄의 핵심적인 거리', 200, 480, '35.69534495990291', '139.69896158121864', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/신주쿠.jpg'),
                                                                                                       (46, '카구라자카', '전통과 현대가 어우러진 거리', 140, 340, '35.703010713285124', '139.7325548641443', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/카구라자카.jpg'),
                                                                                                       (47, '도쿄 디즈니랜드', '가족과 함께하는 인기 테마파크', 300, 800, '35.63303582267244', '139.88141351687648', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/도쿄-디즈니랜드.jpg'),
                                                                                                       (48, '도쿄 돔 시티', '스포츠와 엔터테인먼트의 중심지', 250, 700, '35.70449456601841', '139.75490547078735', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/도쿄-돔-시티.jpg'),
                                                                                                       (49, '산리오 퓨로랜드', '귀여운 산리오 캐릭터의 테마파크', 200, 600, '35.62464278666835', '139.42992599777054', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/산리오-퓨로랜드.jpg'),
                                                                                                       (50, '도쿄 조이 폴리스', '최신 놀이기구가 가득한 실내 테마파크', 220, 550, '35.628825661813416', '139.77533180996122', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/도쿄-조이-폴리스.jpg'),
                                                                                                       (51, '시부야 스카이', '시부야의 멋진 전망을 감상할 수 있는 곳', 350, 900, '35.65856861388029', '139.70272149592233', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/시부야-스카이.jpg'),
                                                                                                       (52, '에비스 가든 플레이스 타워', '에비스의 멋진 야경을 즐길 수 있는 장소', 200, 500, '35.64251175668386', '139.71424048797675', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/에비스-가든-플레이스-타워.jpg'),
                                                                                                       (53, '국립신미술관', '현대 건축물의 정수', 150, 400, '35.665498168261045', '139.7267065903742', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/국립신미술관.jpg'),
                                                                                                       (54, 'Kioi Seido', '전통과 현대가 만나는 독특한 건축물', 170, 450, '35.682236636685275', '139.73539768305275', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/Kioi-Seido.jpg'),
                                                                                                       (55, '루이비통 긴자나미키거리점', '럭셔리 패션 브랜드의 상징적인 매장', 200, 500, '35.670223891939045', '139.76225664619625', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/루이비통-긴자나미키거리점.jpg'),
                                                                                                       (56, '에르메스 긴자', '고급스러운 건축물로 유명한 매장', 180, 480, '35.672197419164135', '139.76395420941594', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/에르메스-긴자.jpg'),
                                                                                                       (57, '써니 힐 미나미 아오야마 스토어', '독창적인 건축 디자인으로 유명한 카페', 150, 350, '35.66585626856143', '139.71676839592257', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/써니-힐-미나미-아오야마-스토어.jpg'),
                                                                                                       (58, '도쿄 국제 포럼', '현대 건축물의 아이콘', 200, 600, '35.67702176003926', '139.7639463155113', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/도쿄-국제-포럼.jpg'),
                                                                                                       (59, '국립서양미술관', '유럽 고전 미술의 중심지', 180, 480, '35.715578514880015', '139.7765218996232', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/국립서양미술관.jpg'),
                                                                                                       (60, '오다이바', '도쿄만의 야경을 감상할 수 있는 인기 장소', 300, 700, '35.63070609526506', '139.7842216718596', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/오다이바.jpg'),
                                                                                                       (61, '롯폰기 힐스', '도쿄의 대표적인 고급 쇼핑몰과 전망대', 250, 650, '35.661009926505265', '139.72986490092538', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/롯폰기-힐스.jpg');

INSERT INTO recommendations (place_id, subcategory_id) VALUES
                                                           (33, 8), -- 도쿄 타워
                                                           (34, 8), -- 도쿄 스카이트리
                                                           (35, 8), -- 도쿄 도청사
                                                           (36, 8), -- 하치코 동상
                                                           (37, 8), -- 레인보우 브리지
                                                           (38, 9), -- 타케시타 스트리트
                                                           (39, 9), -- 아메요코 상점가
                                                           (40, 9), -- 나카미세도리
                                                           (41, 9), -- 나카노 브로드웨이
                                                           (42, 10), -- 아키하바라 전자 거리
                                                           (43, 10), -- 하라주쿠
                                                           (44, 10), -- 시부야
                                                           (45, 10), -- 신주쿠
                                                           (46, 10), -- 카구라자카
                                                           (47, 11), -- 도쿄 디즈니랜드
                                                           (48, 11), -- 도쿄 돔 시티
                                                           (49, 11), -- 산리오 퓨로랜드
                                                           (50, 11), -- 도쿄 조이 폴리스
                                                           (51, 12), -- 시부야 스카이
                                                           (52, 12), -- 에비스 가든 플레이스 타워
                                                           (53, 13), -- 국립신미술관
                                                           (54, 13), -- Kioi Seido
                                                           (55, 13), -- 루이비통 긴자나미키거리점
                                                           (56, 13), -- 에르메스 긴자
                                                           (57, 13), -- 써니 힐 미나미 아오야마 스토어
                                                           (58, 13), -- 도쿄 국제 포럼
                                                           (59, 13), -- 국립서양미술관
                                                           (60, 14), -- 오다이바
                                                           (61, 14); -- 롯폰기 힐스

INSERT INTO addresses (city, district, street) VALUES
                                                   ('도쿄', '시부야구', '요요기카미조노초 1-1'), -- 메이지 신궁
                                                   ('도쿄', '다이토구', '아사쿠사 2-3-1'), -- 센소지
                                                   ('도쿄', '지요다구', '후지미 2-4-1'), -- 도쿄대신궁
                                                   ('도쿄', '지요다구', '소토칸다 2-16-2'), -- 간다 묘진
                                                   ('도쿄', '신주쿠구', '신주쿠 5-17-3'), -- 하나조노 신사
                                                   ('효고', '히메지시', '혼마치 83'), -- 히메지 신사
                                                   ('도쿄', '미나토구', '시바코엔 4-7-35'), -- 조죠지
                                                   ('도쿄', '지요다구', '치요다 1-1'), -- 에도 성 유적
                                                   ('사이타마', '가와고에시', '가와고에'), -- 가와고에
                                                   ('도쿄', '고가네이시', '사쿠라초 3-7-1'), -- 에도도쿄건축정원
                                                   ('도쿄', '다이토구', '우에노코엔 13-9'), -- 도쿄 국립박물관
                                                   ('도쿄', '지요다구', '기타노마루코엔 3-1'), -- 도쿄국립근대미술관
                                                   ('도쿄', '스미다구', '요코아미 1-4-1'), -- 에도-도쿄 박물관
                                                   ('도쿄', '다이토구', '우에노코엔 2-1'), -- 시타마치 풍속자료관
                                                   ('도쿄', '미나토구', '미나미아오야마 6-5-1'), -- 네즈미술관
                                                   ('도쿄', '주오구', '긴자 4-12-15'), -- 가부키자 극장
                                                   ('도쿄', '주오구', '니혼바시 1-2-6 黒江屋国分ビル 2F'), -- kuroeya
                                                   ('도쿄', '스미다구', '타이헤이 2-10-9'), -- Sumida Edo Kiriko Museum
                                                   ('도쿄', '주오구', '니혼바시혼초 3-6-2'), -- 오즈와시
                                                   ('도쿄', '지요다구', '칸다진보초 1'), -- 칸다 고서점 거리
                                                   ('치바', '가토리시', '사와라 마을'), -- 사와라 마을
                                                   ('도쿄', '주오구', '츠키지 4-14'); -- 츠키지 시장

INSERT INTO places (address_id, title, description, likes, visited, latitude, longitude, imageKey) VALUES
                                                                                                       (62, '메이지 신궁', '도쿄의 대표적인 신사', 300, 900, '35.6766852040239', '139.6995297474999', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/메이지-신궁.jpg'),
                                                                                                       (63, '센소지', '도쿄에서 가장 오래된 사찰', 450, 1200, '35.714921872062966', '139.79668748297817', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/센소지.jpg'),
                                                                                                       (64, '도쿄대신궁', '일본의 주요 신사 중 하나', 250, 700, '35.7001600265304', '139.7471914038686', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/도쿄대신궁.jpg'),
                                                                                                       (65, '간다 묘진', '오랜 역사를 자랑하는 신사', 300, 800, '35.702166614314905', '139.76801229470175', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/간다-묘진.jpg'),
                                                                                                       (66, '하나조노 신사', '도쿄의 중심부에 위치한 신사', 350, 850, '35.69364434682389', '139.7052849811279', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/하나조노-신사.jpg'),
                                                                                                       (67, '히메지 신사', '효고 현의 아름다운 신사', 400, 900, '34.84001238828704', '134.6958570477411', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/히메지-신사.jpg'),
                                                                                                       (68, '조죠지', '도쿄 타워 근처의 아름다운 사찰', 300, 800, '35.65760973270024', '139.7484215424968', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/조죠지.jpg'),
                                                                                                       (69, '에도 성 유적', '일본 역사와 문화를 대표하는 유적', 500, 1500, '35.68845831224233', '139.75485757873153', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/에도성-유적.jpg'),
                                                                                                       (70, '가와고에', '작은 에도 시대를 느낄 수 있는 전통 마을', 350, 1000, '35.9303579979124', '139.50186583026573', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/가와고에.jpg'),
                                                                                                       (71, '에도도쿄건축정원', '도쿄의 전통 건축물과 역사를 보여주는 공원', 300, 800, '35.7157986583788', '139.51274724434847', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/에도도쿄건축정원.jpg'),
                                                                                                       (72, '도쿄 국립박물관', '일본 최대의 역사 박물관', 400, 1200, '35.72152512159313', '139.77768192007377', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/도쿄-국립박물관.jpg'),
                                                                                                       (73, '도쿄국립근대미술관', '일본 현대 미술을 대표하는 박물관', 300, 900, '35.691679964559995', '139.75623166074988', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/도쿄국립근대미술관.jpg'),
                                                                                                       (74, '에도-도쿄 박물관', '에도 시대부터 현대 도쿄까지의 역사를 담은 박물관', 450, 1100, '35.697230651819524', '139.79679378216082', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/에도-도쿄-박물관.jpg'),
                                                                                                       (75, '시타마치 풍속자료관', '에도 시대의 생활 방식을 엿볼 수 있는 자료관', 250, 700, '35.71291528757493', '139.76982665776364', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/시타마치-풍속자료관.jpg'),
                                                                                                       (76, '네즈미술관', '전통과 현대를 아우르는 미술관', 350, 850, '35.66244847226294', '139.71741554256806', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/네즈미술관.jpg'),
                                                                                                       (77, '가부키자 극장', '전통 공연 예술의 중심지', 450, 1100, '35.669556889744115', '139.76774458112732', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/가부키자-극장.jpg'),
                                                                                                       (78, 'kuroeya', '전통 공예품과 문화를 체험할 수 있는 장소', 200, 600, '35.683562277327454', '139.77397968482663', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/kuroeya.jpg'),
                                                                                                       (79, 'Sumida Edo Kiriko Museum', '에도 시대의 유리 공예를 전시하는 박물관', 250, 750, '35.70135324036879', '139.81368883648332', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/Sumida-Edo-Kiriko-Museum.jpg'),
                                                                                                       (80, '오즈와시', '일본 전통 종이를 체험할 수 있는 곳', 200, 600, '35.688981778828925', '139.7767709903751', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/오즈와시.jpg'),
                                                                                                       (81, '칸다 고서점 거리', '책과 역사를 느낄 수 있는 거리', 300, 900, '35.6961455695612', '139.75989167318332', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/칸다-고서점-거리.jpg'),
                                                                                                       (82, '사와라 마을', '에도 시대의 마을을 느낄 수 있는 전통 지역', 350, 1000, '35.89454952645073', '140.4912471316211', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/사와라-마을.jpg'),
                                                                                                       (83, '츠키지 시장', '신선한 해산물을 제공하는 전통 시장', 450, 1100, '35.66515695261638', '139.7713823922236', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/츠키지-시장.jpg');

INSERT INTO recommendations (place_id, subcategory_id) VALUES
                                                           (62, 1), -- 메이지 신궁
                                                           (63, 1), -- 센소지
                                                           (64, 1), -- 도쿄대신궁
                                                           (65, 1), -- 간다 묘진
                                                           (66, 1), -- 하나조노 신사
                                                           (67, 1), -- 히메지 신사
                                                           (68, 1), -- 조죠지
                                                           (69, 2), -- 에도 성 유적
                                                           (70, 3), -- 가와고에
                                                           (71, 3), -- 에도도쿄건축정원
                                                           (72, 4), -- 도쿄 국립박물관
                                                           (73, 4), -- 도쿄국립근대미술관
                                                           (74, 4), -- 에도-도쿄 박물관
                                                           (75, 4), -- 시타마치 풍속자료관
                                                           (76, 5), -- 네즈미술관
                                                           (77, 5), -- 가부키자 극장
                                                           (78, 5), -- kuroeya
                                                           (79, 5), -- Sumida Edo Kiriko Museum
                                                           (80, 5), -- 오즈와시
                                                           (81, 6), -- 칸다 고서점 거리
                                                           (82, 7), -- 사와라 마을
                                                           (83, 7); -- 츠키지 시장
INSERT INTO addresses (city, district, street) VALUES
                                                   ('도쿄', '지요다구', '히비야코엔 1-6'), -- 히비야 공원
                                                   ('도쿄', '시부야구', '요요기카미조노초 2-1'), -- 요요기 공원
                                                   ('도쿄', '신주쿠구', '나이토마치 11'), -- 신주쿠 교엔
                                                   ('도쿄', '주오구', '하마리큐테이엔 1-1'), -- 하마리큐 은사정원
                                                   ('도쿄', '미나토구', '카이간 1-4-1'), -- 구 시바리큐 정원
                                                   ('도쿄', '에도가와구', '린카이초 6-2'), -- 가사이 임해공원
                                                   ('도쿄', '다이토구', '우에노코엔 5-20'), -- 시노바즈노이케
                                                   ('도쿄', '기타구', '이와부치마치 23-45 先'), -- Arakawa Iwabuchi Barbeque Area
                                                   ('도쿄', '니시타마군', ''), -- 오쿠타마 호수
                                                   ('도쿄', '오타구', '미나미센조쿠 2-14-5'), -- 센조쿠이케 공원
                                                   ('도쿄', '무사시노시', '고텐야마 1-18-31'), -- 이노카시라 연못
                                                   ('도쿄', '하치오지시', '타카오마치'), -- 다카오산
                                                   ('도쿄', '분쿄구', '카스가 1-1-1'), -- 스파 라쿠아
                                                   ('도쿄', '네리마구', '고야마 3-25-1'), -- 토시마엔 니와노유
                                                   ('도쿄', '시나가와구', '고야마 3-9-1'), -- 무사시코야마온천 시미즈유
                                                   ('도쿄', '스미다구', '이시와라 3-30-10'), -- Mikokuyu
                                                   ('도쿄', '이타바시구', '마에노초 3-41-1'), -- 사야노유도코로.온천
                                                   ('도쿄', '메구로구', ''), -- 나카메구로
                                                   ('도쿄', '분쿄구', '혼코마고메 6-16-3'), -- 리쿠기엔
                                                   ('도쿄', '스미다구', ''), -- 보쿠테이 거리
                                                   ('도쿄', '고가네이시', '세키노초 1-13-1'), -- 도쿄도립 고가네이 공원
                                                   ('도쿄', '다이토구', ''), -- 우에노 공원
                                                   ('시가', '나가하마시', '가와미치초'); -- 코린 절

INSERT INTO places (address_id, title, description, likes, visited, latitude, longitude, imageKey) VALUES
                                                                                                       (84, '히비야 공원', '도쿄의 대표적인 녹지 공간', 300, 900, '35.67376835300837', '139.7562631345527', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/히비야-공원.jpg'),
                                                                                                       (85, '요요기 공원', '자연과 여가를 즐길 수 있는 도심 공원', 400, 1200, '35.67018689611857', '139.69518017318242', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/요요기-공원.jpg'),
                                                                                                       (86, '신주쿠 교엔', '도쿄의 가장 아름다운 공원 중 하나', 350, 1100, '35.68536791717447', '139.71034135606737', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/신주쿠-교엔.jpg'),
                                                                                                       (87, '하마리큐 은사정원', '전통과 현대가 어우러진 정원', 450, 1300, '35.65974304360922', '139.76374169037388', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/하마리큐-은사정원.jpg'),
                                                                                                       (88, '구 시바리큐 정원', '에도 시대의 정원을 재현한 공원', 300, 800, '35.65510738968623', '139.75937505544292', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/구-시바리큐-정원.jpg'),
                                                                                                       (89, '가사이 임해공원', '도쿄의 자연과 바다를 즐길 수 있는 공원', 350, 1000, '35.64208051163235', '139.86028839098665', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/가사이-임해공원.jpg'),
                                                                                                       (90, '시노바즈노이케', '도쿄의 도심에 위치한 아름다운 연못', 200, 600, '35.71169808149145', '139.77115467503344', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/시노바즈노이케.jpg'),
                                                                                                       (91, 'Arakawa Iwabuchi Barbeque Area', '야외 바베큐를 즐길 수 있는 공간', 150, 500, '35.78772559624818', '139.72924133853633', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/Arakawa-Iwabuchi-Barbeque-Area.jpg'),
                                                                                                       (92, '오쿠타마 호수', '도쿄 외곽의 아름다운 자연 경관', 250, 750, '35.781009738823194', '139.03590158323968', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/오쿠타마-호수.jpg'),
                                                                                                       (93, '센조쿠이케 공원', '조용하고 평화로운 도쿄의 연못 공원', 300, 800, '35.603620369216486', '139.6901830918254', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/센조쿠이케-공원.jpg'),
                                                                                                       (94, '이노카시라 연못', '자연과 예술이 공존하는 공간', 400, 1000, '35.70406900115469', '139.5735301325953', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/이노카시라-연못.jpg'),
                                                                                                       (95, '다카오산', '도쿄의 대표적인 등산 및 자연 명소', 500, 1500, '35.62600467580037', '139.24554088910116', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/다카오산.jpg'),
                                                                                                       (96, '스파 라쿠아', '도쿄에서 편안한 휴식을 제공하는 온천', 350, 900, '35.70729131550758', '139.7533118922252', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/스파-라쿠아.jpg'),
                                                                                                       (97, '토시마엔 니와노유', '자연 속에서 편안함을 즐길 수 있는 온천', 300, 800, '35.743952183230526', '139.64870712476124', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/토시마엔-니와노유.jpg'),
                                                                                                       (98, '무사시코야마온천 시미즈유', '도쿄의 전통적인 온천', 200, 700, '35.620357879364114', '139.70836214194838', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/무사시코야마온천-시미즈유.jpg'),
                                                                                                       (99, 'Mikokuyu', '현대적인 시설을 갖춘 온천', 250, 850, '35.701583631515895', '139.8049655176547', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/Mikokuyu.jpg'),
                                                                                                       (100, '사야노유도코로.온천', '도쿄에서 힐링을 즐길 수 있는 온천', 300, 950, '35.77089367153869', '139.6936143015714', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/사야노유도코로.jpg'),
                                                                                                       (101, '나카메구로', '도쿄의 대표적인 벚꽃 명소', 500, 2000, '35.6388074793667', '139.70284069110153', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/나카메구로.jpg'),
                                                                                                       (102, '리쿠기엔', '도쿄의 아름다운 전통 정원', 400, 1200, '35.73320498150336', '139.74613046339059', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/리쿠기엔.jpg'),
                                                                                                       (103, '보쿠테이 거리', '벚꽃이 만개하는 아름다운 거리', 300, 800, '35.743301665582706', '139.80296653063084', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/보쿠테이-거리.jpg'),
                                                                                                       (104, '도쿄도립 고가네이 공원', '자연 속에서의 평화로운 산책', 300, 900, '35.71663870017067', '139.51841908066567', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/도쿄도립-고가네이-공원.jpg'),
                                                                                                       (105, '우에노 공원', '도쿄의 대표적인 벚꽃 명소', 400, 1100, '35.7148776277495', '139.77394618058193', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/우에노-공원.jpg'),
                                                                                                       (106, '코린 절', '명상의 평화를 느낄 수 있는 곳', 250, 750, '35.397325694648885', '136.23396873084334', 'https://isshoni-s3.s3.ap-northeast-2.amazonaws.com/코린-절.jpg');

INSERT INTO recommendations (place_id, subcategory_id) VALUES
                                                           (84, 22), -- 히비야 공원
                                                           (85, 22), -- 요요기 공원
                                                           (86, 22), -- 신주쿠 교엔
                                                           (87, 22), -- 하마리큐 은사정원
                                                           (88, 22), -- 구 시바리큐 정원
                                                           (89, 22), -- 가사이 임해공원
                                                           (90, 23), -- 시노바즈노이케
                                                           (91, 23), -- Arakawa Iwabuchi Barbeque Area
                                                           (92, 23), -- 오쿠타마 호수
                                                           (93, 23), -- 센조쿠이케 공원
                                                           (94, 24), -- 이노카시라 연못
                                                           (95, 24), -- 다카오산
                                                           (96, 25), -- 스파 라쿠아
                                                           (97, 25), -- 토시마엔 니와노유
                                                           (98, 25), -- 무사시코야마온천 시미즈유
                                                           (99, 25), -- Mikokuyu
                                                           (100, 25), -- 사야노유도코로.온천
                                                           (101, 26), -- 나카메구로
                                                           (102, 26), -- 리쿠기엔
                                                           (103, 26), -- 보쿠테이 거리
                                                           (104, 26), -- 도쿄도립 고가네이 공원
                                                           (105, 26), -- 우에노 공원
                                                           (106, 27); -- 코린 절

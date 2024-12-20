package com.CPGroupH.domains.place.service;

import com.CPGroupH.domains.place.dto.response.PersonalPlaceResDTO;
import com.CPGroupH.domains.place.dto.response.PopularPlaceResDTO;
import com.CPGroupH.domains.place.dto.response.SearchPlaceResDTO;
import java.util.List;

public interface PlaceService {
    void like(Long memberId, Long placeId);
    void visited(Long memberId, Long placeId);
    List<PopularPlaceResDTO> popularPlace();
    List<PersonalPlaceResDTO> personalPlace(Long memberId);
    List<SearchPlaceResDTO> searchPlace(String keyword);
}

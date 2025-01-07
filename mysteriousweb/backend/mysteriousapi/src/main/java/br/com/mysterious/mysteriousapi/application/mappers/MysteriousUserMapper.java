package br.com.mysterious.mysteriousapi.application.mappers;

import br.com.mysterious.mysteriousapi.domain.entities.customer.MysteriousUser;
import br.com.mysterious.mysteriousapi.persistence.entities.MysteriousUserEntity;

public class MysteriousUserMapper {
    public MysteriousUserEntity toEntity(MysteriousUser mysteriousUser) {
        MysteriousUserEntity mysteriousUserEntity = new MysteriousUserEntity();
        mysteriousUserEntity.setUsername(mysteriousUser.getUsername());
        mysteriousUserEntity.setEmail(mysteriousUser.getEmail());
        mysteriousUserEntity.setPassword(mysteriousUser.getPassword());

        return mysteriousUserEntity;
    }

    public MysteriousUser toDomainObject(MysteriousUserEntity mysteriousUserEntity) {
        MysteriousUser mysteriousUser = new MysteriousUser();
        mysteriousUser.setUsername(mysteriousUserEntity.getUsername());
        mysteriousUser.setEmail(mysteriousUserEntity.getEmail());
        mysteriousUser.setPassword(mysteriousUserEntity.getPassword());

        return mysteriousUser;
    }
}

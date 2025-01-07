package br.com.mysterious.mysteriousapi.persistence.repositories;

import br.com.mysterious.mysteriousapi.persistence.entities.MysteriousUserEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface MysteriousUserRepository extends JpaRepository<MysteriousUserEntity, UUID> {
    MysteriousUserEntity findByEmail(String email);
}

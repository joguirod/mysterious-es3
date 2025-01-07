package br.com.mysterious.mysteriousapi.persistence.repositories;

import br.com.mysterious.mysteriousapi.persistence.entities.ProductEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductRepository extends JpaRepository<ProductEntity, Long> {
}

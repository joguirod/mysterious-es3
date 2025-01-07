package br.com.mysterious.mysteriousapi.application.usecases.product;

import br.com.mysterious.mysteriousapi.application.mappers.ProductMapper;
import br.com.mysterious.mysteriousapi.domain.entities.product.Product;
import br.com.mysterious.mysteriousapi.persistence.entities.ProductEntity;
import br.com.mysterious.mysteriousapi.persistence.repositories.ProductRepository;

import java.util.List;

public class ListAllProductsUseCase {
    ProductRepository productRepository;
    ProductMapper productMapper;

    public ListAllProductsUseCase(ProductRepository productRepository, ProductMapper productMapper) {
        this.productRepository = productRepository;
        this.productMapper = productMapper;
    }

    public List<Product> execute() {
        List<ProductEntity> productEntityList = productRepository.findAll();
        return productEntityList.stream()
                .map(productEntity -> productMapper.toDomainObject(productEntity))
                .toList();
    }
}

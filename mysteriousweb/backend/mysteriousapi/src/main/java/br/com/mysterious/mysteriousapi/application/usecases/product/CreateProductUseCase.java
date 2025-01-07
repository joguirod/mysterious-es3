package br.com.mysterious.mysteriousapi.application.usecases.product;

import br.com.mysterious.mysteriousapi.application.exceptions.NonPositiveNumberException;
import br.com.mysterious.mysteriousapi.application.exceptions.RequiredValueException;
import br.com.mysterious.mysteriousapi.application.mappers.ProductMapper;
import br.com.mysterious.mysteriousapi.domain.entities.product.Product;
import br.com.mysterious.mysteriousapi.persistence.entities.ProductEntity;
import br.com.mysterious.mysteriousapi.persistence.repositories.ProductRepository;

public class CreateProductUseCase {
    ProductRepository productRepository;
    ProductMapper productMapper;

    public CreateProductUseCase(ProductRepository productRepository, ProductMapper productMapper) {
        this.productRepository = productRepository;
        this.productMapper = productMapper;
    }

    public Product execute(Product product) throws NonPositiveNumberException, RequiredValueException {
        validateEmptyValues(product);
        ProductEntity productEntity = productMapper.toEntity(product);
        productEntity = productRepository.save(productEntity);

        return productMapper.toDomainObject(productEntity);
    }

    private void validateEmptyValues(Product product) throws NonPositiveNumberException, RequiredValueException {
        if (product.getProductName() == null) throw new RequiredValueException("Product name is required");
        if (product.getPrice() == null) throw new RequiredValueException("Price is required");
        if (product.getQuantity() < 0) throw new NonPositiveNumberException("Quantity cannot be less than 0");
    }
}

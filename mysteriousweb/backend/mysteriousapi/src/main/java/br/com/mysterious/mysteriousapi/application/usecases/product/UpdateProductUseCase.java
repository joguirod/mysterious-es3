package br.com.mysterious.mysteriousapi.application.usecases.product;

import br.com.mysterious.mysteriousapi.application.exceptions.NonPositiveNumberException;
import br.com.mysterious.mysteriousapi.application.exceptions.ProductNotFoundException;
import br.com.mysterious.mysteriousapi.application.exceptions.RequiredValueException;
import br.com.mysterious.mysteriousapi.application.mappers.ProductMapper;
import br.com.mysterious.mysteriousapi.domain.entities.product.Product;
import br.com.mysterious.mysteriousapi.persistence.entities.ProductEntity;
import br.com.mysterious.mysteriousapi.persistence.repositories.ProductRepository;

public class UpdateProductUseCase {
    ProductRepository productRepository;
    ProductMapper productMapper;

    public UpdateProductUseCase(ProductRepository productRepository, ProductMapper productMapper) {
        this.productRepository = productRepository;
        this.productMapper = productMapper;
    }

    public Product execute(Product product) throws ProductNotFoundException, RequiredValueException, NonPositiveNumberException {
        if (productRepository.findById(product.getId()).isEmpty()) {
            throw new ProductNotFoundException("Product with id " + product.getId() + " not found");
        }
        validate(product);

        ProductEntity productEntity = new ProductEntity(product.getId(), product.getProductName(), product.getPrice(), product.getQuantity(), product.getDescription());
        productEntity = productRepository.save(productEntity);

        return productMapper.toDomainObject(productEntity);
    }

    private void validate(Product product) throws ProductNotFoundException, RequiredValueException, NonPositiveNumberException {
        if (product.getPrice() == null) {
            throw new RequiredValueException("Price is required");
        } else if (product.getPrice() < 0) {
            throw new NonPositiveNumberException("Price must be a positive number");
        }
        if (product.getQuantity() < 0) {
            throw new NonPositiveNumberException("Quantity must be a positive number");
        }
    }
}

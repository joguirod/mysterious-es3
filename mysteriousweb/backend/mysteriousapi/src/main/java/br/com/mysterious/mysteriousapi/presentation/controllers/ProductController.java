package br.com.mysterious.mysteriousapi.presentation.controllers;

import br.com.mysterious.mysteriousapi.application.exceptions.NonPositiveNumberException;
import br.com.mysterious.mysteriousapi.application.exceptions.ProductNotFoundException;
import br.com.mysterious.mysteriousapi.application.exceptions.RequiredValueException;
import br.com.mysterious.mysteriousapi.application.usecases.product.CreateProductUseCase;
import br.com.mysterious.mysteriousapi.application.usecases.product.DeleteProductUseCase;
import br.com.mysterious.mysteriousapi.application.usecases.product.ListAllProductsUseCase;
import br.com.mysterious.mysteriousapi.application.usecases.product.UpdateProductUseCase;
import br.com.mysterious.mysteriousapi.domain.entities.product.Product;
import br.com.mysterious.mysteriousapi.presentation.dtos.mappers.ProductDTOMapper;
import br.com.mysterious.mysteriousapi.presentation.dtos.request.ProductRequestDTO;
import br.com.mysterious.mysteriousapi.presentation.dtos.response.ProductResponseDTO;
import br.com.mysterious.mysteriousapi.persistence.repositories.ProductRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/product")
public class ProductController {
    private final CreateProductUseCase createProductUseCase;
    private final ListAllProductsUseCase listAllProductsUseCase;
    private final UpdateProductUseCase updateProductUseCase;
    private final DeleteProductUseCase deleteProductUseCase;
    private final ProductDTOMapper productDTOMapper;

    public ProductController(ProductRepository productRepository, ListAllProductsUseCase listAllProductsUseCase, CreateProductUseCase createProductUseCase, UpdateProductUseCase updateProductUseCase, DeleteProductUseCase deleteProductUseCase) {
        this.listAllProductsUseCase = listAllProductsUseCase;
        this.updateProductUseCase = updateProductUseCase;
        this.deleteProductUseCase = deleteProductUseCase;
        this.productDTOMapper = new ProductDTOMapper();
        this.createProductUseCase = createProductUseCase;
    }

    @GetMapping
    public ResponseEntity<List<ProductResponseDTO>> getAllProducts() {
        List<ProductResponseDTO> productResponseDTOList = listAllProductsUseCase.execute()
                .stream()
                .map(product -> productDTOMapper.toProductResponseDTO(product))
                .toList();

        return new ResponseEntity<>(productResponseDTOList, HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<ProductResponseDTO> createProduct(@RequestBody ProductRequestDTO productRequestDTO) throws NonPositiveNumberException, RequiredValueException {
        Product product = createProductUseCase.execute(productDTOMapper.toProduct(productRequestDTO));
        return new ResponseEntity<>(productDTOMapper.toProductResponseDTO(product), HttpStatus.CREATED);
    }

    @PutMapping("/edit/{productId}")
    public ResponseEntity<ProductResponseDTO> editProduct(@PathVariable Long productId, @RequestBody ProductRequestDTO productRequestDTO) throws NonPositiveNumberException, RequiredValueException, ProductNotFoundException {
        Product product = productDTOMapper.toProduct(productRequestDTO);
        product.setId(productId);
        product = updateProductUseCase.execute(product);
        return new ResponseEntity<>(productDTOMapper.toProductResponseDTO(product), HttpStatus.OK);
    }

    @DeleteMapping("/delete/{productId}")
    public ResponseEntity<ProductResponseDTO> deleteProduct(@PathVariable Long productId) throws ProductNotFoundException {
        deleteProductUseCase.execute(productId);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}

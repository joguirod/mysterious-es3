package br.com.mysterious.mysteriousapi.presentation.exceptions;

import org.apache.coyote.Response;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;

public class HttpExceptionMessage {
   private String message;
   private HttpStatus status;

   public HttpExceptionMessage(String message, HttpStatus status) {
       this.message = message;
       this.status = status;
   }
}

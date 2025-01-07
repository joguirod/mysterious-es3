package br.com.mysterious.mysteriousapi.common.config;

import br.com.mysterious.mysteriousapi.application.mappers.MysteriousUserMapper;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MysteriousUserConfig {
    @Bean
    MysteriousUserMapper mysteriousUserMapper() {
        return new MysteriousUserMapper();
    }
}

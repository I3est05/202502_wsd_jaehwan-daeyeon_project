package com.example.donjoogga.vo;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Scholarship {
    private Long scholarId;
    private String title;
    private String organization;
    private LocalDateTime deadline;
    private String category;
}
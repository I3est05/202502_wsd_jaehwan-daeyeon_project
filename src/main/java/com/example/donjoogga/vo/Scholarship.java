package com.example.donjoogga.vo;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Scholarship {
    private String refId;
    private String title;
    private String organization;
    private String deadline;
    private String category;
    private int support_amount;
    private String sourceType;

    public String getRefId() {
        return refId;
    }

    public void setRefId(String refId) {
        this.refId = refId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getOrganization() {
        return organization;
    }

    public void setOrganization(String organization) {
        this.organization = organization;
    }

    public String getDeadline() {
        return deadline;
    }

    public void setDeadline(String deadline) {
        this.deadline = deadline;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getSupportAmount() {
        return support_amount;
    }

    public void setSupportAmount(int support_amount) {
        this.support_amount = support_amount;
    }

    public String getSourceType() {
        return sourceType;
    }

    public void setSourceType(String sourceType) {
        this.sourceType = sourceType;
    }
}
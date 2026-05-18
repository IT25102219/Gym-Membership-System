package com.gym.model;

import com.gym.interfaces.Displayable;
import com.gym.interfaces.IModerable;

public abstract class Review implements IModerable, Displayable {
    private int reviewId;
    private int memberId;
    private String memberName;
    private int rating;
    private String comment;
    private String category;
    private String reviewDate;
    private String reviewType;
    private String status;


    public Review(int reviewId, int memberId, String memberName, int rating,
                  String comment, String category, String reviewDate,
                  String reviewType, String status) {
        this.reviewId = reviewId;
        this.memberId = memberId;
        this.memberName = memberName;
        this.rating = rating;
        this.comment = comment;
        this.category = category;
        this.reviewDate = reviewDate;
        this.reviewType = reviewType;
        this.status = status;
    }

    public Review() {}

    public abstract String getDisplayBadge();

    public abstract boolean canEdit();

    @Override
    public boolean approve() {
        this.status = "ACTIVE";
        return true;
    }

    @Override
    public boolean remove() {
        this.status = "REMOVED";
        return true;
    }

    @Override
    public String getModerationStatus() {
        return this.status;
    }


    public String getRatingStars() {
        StringBuilder stars = new StringBuilder();

        for (int i = 0; i < rating; i++) {
            stars.append("★");
        }

        for (int i = rating; i < 5; i++) {
            stars.append("☆");
        }

        return stars.toString();
    }

    public int getReviewId() { return reviewId; }
    public int getMemberId() { return memberId; }
    public String getMemberName() { return memberName; }
    public int getRating() { return rating; }
    public String getComment() { return comment; }
    public String getCategory() { return category; }
    public String getReviewDate() { return reviewDate; }
    public String getReviewType() { return reviewType; }
    public String getStatus() { return status; }

    public void setReviewId(int reviewId) { this.reviewId = reviewId; }
    public void setMemberId(int memberId) { this.memberId = memberId; }
    public void setMemberName(String memberName) { this.memberName = memberName; }
    public void setRating(int rating) { this.rating = rating; }
    public void setComment(String comment) { this.comment = comment; }
    public void setCategory(String category) { this.category = category; }
    public void setReviewDate(String reviewDate) { this.reviewDate = reviewDate; }
    public void setReviewType(String reviewType) { this.reviewType = reviewType; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return "Review{id=" + reviewId + ", member='" + memberName +
               "', rating=" + rating + ", type='" + reviewType + "'}";
    }
}
